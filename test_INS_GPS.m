%==========================================================================
% INS-GPS组合导航测试
%       The navigation coordinate system is n coordinate——E N U
%       the body coordinate system is b coordinate——R F U
% 输入数据格式：
%       IMUData: 存放的是原始IMU数据，数据格式为：（采用速率形式）
%               时间(s,精确到ms) 陀螺(角速度 rd/s) 加计(加速度 m/s2)
%       GPSData：存放原始GPS数据，数据格式为:
%               时间(s,精确到ms) 纬度、经度、高程(rd m) 
%
%计算数据格式：
%       avp0：起始信息，目前不采用自对准，直接设定起始信息，数据格式为：(实际都是三维矢量)
%               姿态 pitch roll yaw(rd),速度 V_E,V_N,V_U(m/s2),位置 Lat,Lon,H(rd m)
%      
%       INSData_now: 当前时刻的惯导信息数据，包括.....见 INS_DataIinitial
%       INSData_pre:
%
%       KF: Kalman滤波所需的所有参数，及每个计算周期更新的数据
%
%结果输出：
%       avp： 计算结果存放，格式同avp0
%       XkPk：KF滤波的中间数据 15维状态 和对应的方差信息 及 时间
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 1/1/2019
%==========================================================================

%% ========================== 一、数据预加载 ========================
clear variables;
global G_CONST                                          %macro definition
    G_CONST = Initial_CONST();

load('E:\n_WorkSpace\Matlab\0_Data\INSGPS组合使用数据\INS_GPS');
IMUData = imudata(:,:);                         %选取有GPS的起始点
GPSData(:,1) = GNSS(:,1);
GPSData(:,2:3) = GNSS(:,2:3)*G_CONST.D2R;       %将GPS纬度经度 转化为弧度
GPSData(:,4) = GNSS(:,4);

GPS_Error(:,1:3) = GNSS(:,5:7);                 %GPS定位误差，标准差，经度:m

%% ========================== 二、参数设定 ==========================
%1、系统参数设定
    T = 1/200.0;                                %解算计算时间，IMU采样频率    
%2、IMU误差参数设定 
    %陀螺误差参数
    %IMU_ErrorInitial(gbias,gbias_std,gbias_CorTime,garw,fbias,fbias_std,fbias_CorTime,fvrw)
    %单位 deg/h	deg/h	h  deg/sqrt(h)	mGal   mGal  h   m/s/sqrt(h)	
    IMU_Error = IMU_ErrorInitial(0.01,0.005,4,0.0022,10,25,4,0.00075);    
%3、IMU误差参数单位标准化 
    IMU_Error = IMU_ChangeErrorUnit(IMU_Error);    
%4、设定解算步长
    NUM_IMU = size(IMUData,1);
    NUM_GPS = fix(NUM_IMU * T);    
%5、初值设定，目前不考虑初始对准，直接设定初值
    att0 = [0.5*G_CONST.D2R;0.5*G_CONST.D2R;-3.1259987];
    att0_Erro = [0.5*G_CONST.D2R;0.5*G_CONST.D2R;1*G_CONST.D2R];
    vel0 = [0.1;0.1;0.1];
    vel0_Erro = [0.1;0.1;0.1];
    pos0 = [0.530699173342059;1.994351183398699;15.359326045134754];
    pos0_Erro = [5/6378137;5/6378137/cos(0.530699173342059);5];
    avp0 = [att0;vel0;pos0];
    avp0_Error = [att0_Erro;vel0_Erro;pos0_Erro];  
%6、初始化前一时刻和当前时刻的INS信息数据结构体
    INSData_now = INS_DataIinitial(pos0,vel0,att0,0); 
    INSData_now.w_ib_b = IMUData(1,2:4)';             
    INSData_now.f_ib_b = IMUData(1,5:7)';            
    INSData_now.time = IMUData(1,1);
    INSData_now.ts = T;               %机械编排解算周期
    INSData_now.IMUError = IMU_Error;
    INSData_pre = INSData_now;
%7、初始化Kalman滤波信息结构体        
    KF = KF_Initial(15,3);    
    KF.Xk = zeros(15,1);            %X0 = 0;
    KF.Pk = diag([avp0_Error;IMU_Error.gyr_bias;IMU_Error.acc_bias]*10)^2;     %X0 对应的 P0    
%     KF.Qt = diag([zeros(9,1);IMU_Error.gyr_noise_arw;IMU_Error.acc_noise_vrw])^2;       %这里输入陀螺 加计 随机游走参数
    KF.Qt = diag([IMU_Error.gyr_noise_arw;IMU_Error.acc_noise_vrw;zeros(9,1)])^2;
    KF.Qk = T.* KF.Qt; 
    KF.Hk = [zeros(3,6), eye(3), zeros(3,6)];   %仅有位置反馈
    KF.Rk = diag(pos0_Erro)^2;
    KF    = KF_UpdateFt(KF,INSData_pre);
%8、声明输出变量    
    avp_Leo = zeros(NUM_IMU,10);    % a v p 及 time
    xkpk_Leo = zeros(NUM_GPS,31);   %Xk Pk 及 time      
    bias_Leo = zeros(NUM_GPS,7);   %陀螺零偏 加计零偏 及 time  
    
%% =========================== 三、循环解算 =========================    
profile on
%1、循环解算
    NUM_GNSS = 1;       %临时变量，用于GPS数据循环
    for i=1:NUM_IMU
        %获取传感器数据
        INSData_now.time = IMUData(i,1);
        INSData_now.w_ib_b = IMUData(i,2:4)';
        INSData_now.f_ib_b = IMUData(i,5:7)';
        
        %惯导解算获取结果
        INSData_now = INS_Update(INSData_pre,INSData_now,T);
        
        %判断是否进入 组合滤波
        tmp_time = abs(IMUData(i,1)-GPSData(NUM_GNSS,1));
        if( tmp_time > 0.004)
            %进入时间更新 仅更新状态转移矩阵和一步预测方差阵等
            KF  = KF_UpdateTime(KF,INSData_now);
            
        else
            %进入时间更新和量测更新 
            KF.Zk = INSData_now.pos - GPSData(NUM_GNSS,2:4)';  
            %尝试使用GNSS数据自带的位置经度信息
            PosError = [GNSS(NUM_GNSS,5)/6378137;GNSS(NUM_GNSS,6)/6378137/cos(0.530699173342059);GNSS(NUM_GNSS,7)];
            KF.Rk = diag(PosError)^2;            
            KF  = KF_UpdateMeasure(KF,INSData_now);
            %将滤波的结果 进行反馈并保存
            xkpk_Leo(NUM_GNSS,1:15) = KF.Xk';
            xkpk_Leo(NUM_GNSS,16:30) = diag(KF.Pk)';
            xkpk_Leo(NUM_GNSS,31) = GPSData(NUM_GNSS,1);   
            [KF,INSData_now] = KF_FeedBack(KF,INSData_now,1.0);   
            bias_Leo(NUM_GNSS,1:3) = INSData_now.IMUError.gyr_bias';
            bias_Leo(NUM_GNSS,4:6) = INSData_now.IMUError.acc_bias';
            bias_Leo(NUM_GNSS,7) = GPSData(NUM_GNSS,1); 
            NUM_GNSS = NUM_GNSS +1;
        end       
        
        %将最终结果保存
        avp_Leo(i,1:3) = INSData_now.att';
        avp_Leo(i,4:6) = INSData_now.vel';
        avp_Leo(i,7:9) = INSData_now.pos';
        avp_Leo(i,10) = INSData_now.time;
        %保留当前周期数据信息，进入下一个周期循环
        INSData_pre =  INSData_now;  
    end
profile viewer    
    

Plot_avp(avp_Leo);
%  Plot_avp_Compare(avp,avp_Leo);
% Plot_xkpk_compare(xkpk,xkpk_Leo);
% Plot_bias_compare(bias,bias_Leo);

    