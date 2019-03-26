clear all;

%% 测试二进制数据读取及转化
% fid = fopen("E:\pos80_GNSS_OUT.bin",'r');
% NavData = zeros(569575,10);
% i = 1
% while feof(fid) == 0
%     [Nav,count] = fread(fid,10,'double'); 
%     NavData(i,:) = Nav';
%     i = i+1;
% end

%% 实验读取二进制文件
%     fid = fopen("E:\2_WorkSpace_Leo\Matlab\Matlab_SINS\data\pos80.bin",'r');
%     imudata = zeros(1153372,7);
%     i = 1;
%     while feof(fid) == 0
%     [imu,count] = fread(fid,7,'double');
%     imudata(i,:) = imu';
%     i = i+1;
%     end
% %    load('E:\2_WorkSpace_Leo\Matlab\Matlab_SINS\data\imudata_pos80');

%% 测试全局变量
% global G_CONST
% G_CONST = const_initial();
% POS = vector_initial(30*pi/180,150*pi/180,100);
% vn = vector_initial(15,30,5);

%% 地球参数测试

% Rmh = earth_get_Rmh(POS);
% Rnh = earth_get_Rnh(POS);
% w_ie_n = earth_get_w_ie_n(POS);
% w_en_n = earth_get_w_en_n(POS,vn,Rmh,Rnh);
% w_in_n = earth_get_w_in_n(POS,vn,Rmh,Rnh);
% g_ = earth_get_g_n(POS);

%% IMU误差参数测试

%     INPUT_CONFIG_IMU.gyr_bias     = 0.01;      %陀螺零偏                    标准输入单位：deg/h
%     INPUT_CONFIG_IMU.gyr_arw      = 0.001;      %陀螺角度随机游走             标准输入单位：deg/sqrt(h)
%     INPUT_CONFIG_IMU.gyr_sqrtROG  = 0.001;      %陀螺一阶马尔科夫噪声         标准输入单位：deg/h/sqrt(h)
%     INPUT_CONFIG_IMU.gyr_TauG     = 1000;      %陀螺一阶马尔科夫噪声相关时间 标准输入单位：s
%     INPUT_CONFIG_IMU.gyr_dKG.xx   = 1.0e5*10;      %陀螺x的非线性刻度因子        标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.xy   = 0.0;      %陀螺x轴到y轴的非正交参数     标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.xz   = 0.0;      %陀螺x轴到z轴的非正交参数     标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.yx   = 0.0;      %陀螺y轴到x轴的非正交参数     标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.yy   = 1.0e5*10;      %陀螺y的非线性刻度因子        标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.yz   = 0.0;      %陀螺y轴到z轴的非正交参数     标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.zx   = 0.0;      %陀螺z轴到x轴的非正交参数     标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.zy   = 0.0;      %陀螺z轴到y轴的非正交参数     标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.gyr_dKG.zz   = 1.0e5*10;      %陀螺z的非线性刻度因子        标准输入单位：无，直接转化为标校结果
%     INPUT_CONFIG_IMU.acc_bias     = 50.0;      %加计零偏                    标准输入单位：ug
%     INPUT_CONFIG_IMU.acc_arw      = 10.0;      %加计速度随机游走             标准输入单位：ug/sqrt(Hz)
%     INPUT_CONFIG_IMU.acc_sqrtROG  = 10.0;      %加计一阶马尔科夫噪声         标准输入单位：ug
%     INPUT_CONFIG_IMU.acc_TauG     = 1000.0;      %加计一阶马尔科夫噪声相关时间 标准输入单位：s
%     INPUT_CONFIG_IMU.acc_dKG.xx   = 1.0e5*10;
%     INPUT_CONFIG_IMU.acc_dKG.xy   = 0.0;
%     INPUT_CONFIG_IMU.acc_dKG.xz   = 0.0;
%     INPUT_CONFIG_IMU.acc_dKG.yx   = 0.0;
%     INPUT_CONFIG_IMU.acc_dKG.yy   = 1.0e5*10;
%     INPUT_CONFIG_IMU.acc_dKG.yz   = 0.0;
%     INPUT_CONFIG_IMU.acc_dKG.zx   = 0.0;
%     INPUT_CONFIG_IMU.acc_dKG.zy   = 0.0;
%     INPUT_CONFIG_IMU.acc_dKG.zz   = 1.0e5*10;    
% CONFIG_IMU = config_imu_set(INPUT_CONFIG_IMU);


%}

%% 绘图测试
global G_CONST                                          %macro definition
    G_CONST = Initial_CONST();
    Plot_avp(navresultFirst);
    Plot_avp_Compare(navresultFirst,navresultSecond);


    