function IMUData = Initial_IMUData()
% IMU数据及误差参数初始化
% Inputs:   
% Output:   imu数据 和 误差参数
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 25/12/2018

%% 武大POS80 的数据
load('E:\n_WorkSpace\Matlab\0_Data\INSGPS组合使用数据\imudata_pos80');
IMUData = imudata(586800:1153371,:);
%     IMUData = imudata;



%% 考虑 非正交误差
%{
global G_CONST

    imuerror.gyr_bias     = input_imuerror.gyr_bias*G_CONST.D2R/3600.0;                  %陀螺零偏 deg/h —> rd/s
    imuerror.gyr_arw      = input_imuerror.gyr_arw*G_CONST.D2R/sqrt(3600.0);             %陀螺角度随机游走 单位：deg/sqrt(h)->rd/sqrt(s)
    imuerror.gyr_sqrtROG  = input_imuerror.gyr_sqrtROG*G_CONST.D2R/3600.0/sqrt(3600.0);    %陀螺一阶马尔科夫噪声 单位：deg/h/sqrt(h)-> ?自己也搞不清楚了
    imuerror.gyr_TauG     = input_imuerror.gyr_TauG;                                %陀螺一阶马尔科夫噪声相关时间 单位：s
    if input_imuerror.gyr_TauG>0 
        imuerror.gyr_sqrtROG = input_imuerror.gyr_sqrtROG*G_CONST.D2R/3600.0*sqrt(2/input_imuerror.gyr_TauG);                    % Markov process
    end
    imuerror.gyr_dKG.xx   = input_imuerror.gyr_dKG.xx;
    imuerror.gyr_dKG.xy   = input_imuerror.gyr_dKG.xy;
    imuerror.gyr_dKG.xz   = input_imuerror.gyr_dKG.xz;
    imuerror.gyr_dKG.yx   = input_imuerror.gyr_dKG.yx;
    imuerror.gyr_dKG.yy   = input_imuerror.gyr_dKG.yy;
    imuerror.gyr_dKG.yz   = input_imuerror.gyr_dKG.yz;
    imuerror.gyr_dKG.zx   = input_imuerror.gyr_dKG.zx;
    imuerror.gyr_dKG.zy   = input_imuerror.gyr_dKG.zy;
    imuerror.gyr_dKG.zz   = input_imuerror.gyr_dKG.zz;
    imuerror.acc_bias     = input_imuerror.acc_bias*G_CONST.ug;                %加计零偏 ug -> m/s2
    imuerror.acc_arw      = input_imuerror.acc_arw*G_CONST.ug/sqrt(1);         %加计速度随机游走 单位：ug/sqrt(Hz)->m/s2/sqrt(1),这里为啥取1Hz？？？
    imuerror.acc_sqrtROG  = input_imuerror.acc_sqrtROG*G_CONST.ug/sqrt(3600.0);  %加计一阶马尔科夫噪声 单位：ug/sqrt(h) -> m/s2
    imuerror.acc_TauG     = input_imuerror.acc_TauG;                        %加计一阶马尔科夫噪声相关时间 单位：s
    if input_imuerror.acc_TauG>0 
        imuerror.acc_sqrtROG = input_imuerror.acc_sqrtROG*G_CONST.ug*sqrt(2/input_imuerror.acc_TauG);                    % Markov process
    end
    imuerror.acc_dKG.xx   = input_imuerror.acc_dKG.xx;                      %定义 同 陀螺
    imuerror.acc_dKG.xy   = input_imuerror.acc_dKG.xy;
    imuerror.acc_dKG.xz   = input_imuerror.acc_dKG.xz;
    imuerror.acc_dKG.yx   = input_imuerror.acc_dKG.yx;
    imuerror.acc_dKG.yy   = input_imuerror.acc_dKG.yy;
    imuerror.acc_dKG.yz   = input_imuerror.acc_dKG.yz;
    imuerror.acc_dKG.zx   = input_imuerror.acc_dKG.zx;
    imuerror.acc_dKG.zy   = input_imuerror.acc_dKG.zy;
    imuerror.acc_dKG.zz   = input_imuerror.acc_dKG.zz;
%}





