%==========================================================================
%  足部导航 ADIS16475
%   左脚放置  东北天
%==========================================================================
clear variables;

%% 数据准备
load('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\1_第一组预处理\20190421-2_第一组');
% IMU数据  加计(m/s2) 陀螺(弧度/s)
% 预分配数据存放空间
    %左脚数据
    Num_IMUData = length(Data_IMU_R);
    avp_L = zeros(Num_IMUData,10);

% 器件参数，目前没用    
    IMU_Error_L = IMU_ErrorInitial(0.0,0.0,0,0.0,0,0,0,0.0);    
    IMU_Error_L = IMU_ChangeErrorUnit(IMU_Error_L);  
    
% 全局变量及常数设置
global G_CONST                                          %macro definition
    G_CONST = Initial_CONST();
    T = 1.0/200;                                        %200Hz sampling
  
%% 数据处理
%1. 设置起始位置  选用GPS数据的 
    %Latitude, longitude, and elevation ，unit is rd m
    pos0(1,1) = mean(Origion_GPS_L(50:70,4))*pi/180.0;
    pos0(2,1) = mean(Origion_GPS_L(50:70,3))*pi/180.0;
    pos0(3,1) = mean(Origion_GPS_L(50:70,5));
    vel0   = [0.0;0.0;0.0];          %unit：m/s2    
%     att0   = [0.0;0.0;-3.126];       %unit：rd
    att0   = [0.0;0.0;0.0]; 
    time0  = Data_IMU_R(1,1);
    
%2. 计算数据结构体声明
    INSData_now = INS_DataIinitial(pos0,vel0,att0,0); 
    INSData_now.w_ib_b = Data_IMU_R(1,5:7)';    
    
%     INSData_now.w_ib_b(1,1)=0; INSData_now.w_ib_b(2,1)=0;
    INSData_now.w_ib_b(3,1)=INSData_now.w_ib_b(3,1)+0.002512385095784;
    INSData_now.f_ib_b = Data_IMU_R(1,2:4)';            
    INSData_now.time = Data_IMU_R(1,1);
    INSData_now.ts = T;               %机械编排解算周期
    INSData_now.IMUError = IMU_Error_L;
    INSData_pre = INSData_now;    
    
%3. %Circulation processing   Receiving new sensor data   
%     avp_Leo = zeros(Num_IMUData,10);
%     DeltaV_n_Leo = zeros(Num_IMUData,4);
    for i=1:Num_IMUData
    %IMUData =                                                      %new sensor data   
%     imudata_new = imu_compensation(IMUData,CONFIG_IMUerror);        %Error compensation
    INSData_now.w_ib_b = Data_IMU_R(i,5:7)';           
%     INSData_now.w_ib_b(1,1)=0; INSData_now.w_ib_b(2,1)=0;
%     INSData_now.w_ib_b(3,1)=INSData_now.w_ib_b(3,1)+0.002512385095784;
    INSData_now.f_ib_b = Data_IMU_R(i,2:4)';            
    INSData_now.time = Data_IMU_R(i,1);
    
	%Calculate the inertial navigation solution at the current moment
    INSData_now = ins_update(INSData_pre,INSData_now,T);
    %Calculate the inertial navigation solution at the current moment
    %without compansation
    %INSData_now = ins_update_nocompansation(INSData_pre,INSData_now,T);
     
    %Save the calculation results
    avp_L(i,1:3) = INSData_now.att';
    avp_L(i,4:6) = INSData_now.vel';
    avp_L(i,7:9) = INSData_now.pos';
    avp_L(i,10) = INSData_now.time;
%     DeltaV_n_Leo(i,1:3) = INSData_now.DeltaV_n';
%     DeltaV_n_Leo(i,4) = INSData_now.time;
    %save the result to predata
    INSData_pre =  INSData_now;
    end


