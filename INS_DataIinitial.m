function INSData = INS_DataIinitial(pos,vn,att,time)
% 计算补偿过的g在n系下的投影
% Inputs:   pos = [lat;lon;h] 纬度、经度、高程，单位弧度 m
% Output:   g_n     单位 m/s2
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018

%% 主要数据区
    INSData.pos = pos;
    INSData.att = att;
    INSData.vel = vn;
    INSData.time = time;                          

%% 传感器数据
    INSData.w_ib_b = [0.0;0.0;0.0];           %陀螺输出 角速率
    INSData.DeltaTheta_ib_b = [0.0;0.0;0.0];  %陀螺输出 角增量
    INSData.f_ib_b = [0.0;0.0;0.0];           %加计输出 加速度
    INSData.DeltaV_ib_b = [0.0;0.0;0.0];      %加计输出 速度增量
    
%% 姿态变换参数
    INSData.C_b_n = change_euler2DCM(INSData.att);
    INSData.Q_b_n = change_DCM2Q(INSData.C_b_n);
    
%% 中间计算数据
    INSData.DeltaTheta_in_n = [0.0;0.0;0.0];   %n系旋转的累积
    INSData.DeltaV_n        = [0.0;0.0;0.0];          %vn速度增量 v(m)=v(m-1)+DeltaV_n
    INSData.Rmh             = earth_get_Rmh(INSData.pos);
    INSData.Rnh             = earth_get_Rnh(INSData.pos);
    INSData.w_ie_n          = earth_get_w_ie_n(INSData.pos);
    INSData.w_en_n          = earth_get_w_en_n(INSData.pos,INSData.vel,INSData.Rmh,INSData.Rnh);
    INSData.w_in_n          = INSData.w_ie_n+INSData.w_en_n;

    INSData.phi             = [0.0;0.0;0.0];
    INSData.DeltaV_n_sf     = [0.0;0.0;0.0];
    
    INSData.fn              = [0.0;0.0;0.0];
    INSData.fb              = [0.0;0.0;0.0];    %补偿以后的
    
%% 器件误差参数
    INSData.IMUError        = IMU_ErrorInitial(0.0,0.0,0,0.0,0.0,0.0,0,0.0);
    
    
    