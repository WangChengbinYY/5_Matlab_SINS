function g_const = Initial_CONST()
% 一些常值 和 单位换算 对应C程序里面的宏定义
% Inputs:   input_config_imu    输入的各类参数
% Output:   config_imu          转换完单位后的参数
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018
global G_CONST
%% 单位换算
    G_CONST.PI         = 3.141592653589793;               %后面使用为pi，C语言中宏定义    
    G_CONST.D2R        = G_CONST.PI/180.0;                   %度转弧度
    G_CONST.R2D        = 180.0/G_CONST.PI;                   %弧度转度
    G_CONST.mil        = 2*G_CONST.PI/6000.0;                %一个密位 转成 弧度
    G_CONST.nm         = 1853.0;                          %一海里  单位:m
    G_CONST.g0         = 9.7803267714;                    %单位：m/s2
    G_CONST.mg         = 1.0e-3*G_CONST.g0;                  %单位：m/s2
    G_CONST.ug         = 1.0e-6*G_CONST.g0;                  %单位：m/s2
    G_CONST.mGal       = 1.0e-3*0.01;                     %单位：m/s2
%% 地球常值参数    
    G_CONST.earth_wie   = 7.2921151467e-5;              %地球自转角速度 标量 单位：弧度/s
    G_CONST.earth_f     = 0.003352813177897;
    G_CONST.earth_Re    = 6378137;                      %单位：m
    G_CONST.earth_e     = 0.081819221455524;    
    G_CONST.earth_g0    = 9.7803267714;                 %单位：m/s2

%%     
    g_const = G_CONST;