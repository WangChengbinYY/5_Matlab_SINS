function insdata_now = INS_Update(insdata_pre,insdata_now,T)
% 计算补偿过的g在n系下的投影
% Inputs:   pos = [lat;lon;h] 纬度、经度、高程，单位弧度 m
% Output:   g_n     单位 m/s2
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018

%% 一、计算需要的外推值
    %计算(m-1/2)时刻的速度Vn
    temp_Vn_half = insdata_pre.vel+ 0.5*insdata_pre.DeltaV_n;
    %计算(m-1/2)时刻的位置pos
    temp_DeltaS = (insdata_pre.vel+temp_Vn_half)*T/4.0;
    temp = [temp_DeltaS(2,1)/insdata_pre.Rmh;temp_DeltaS(1,1)/insdata_pre.Rnh/cos(insdata_pre.pos(1,1));temp_DeltaS(3,1)];
    temp_pos_half = insdata_pre.pos+temp;
    %由(m-1/2)时刻的位置 求 Rmh，Rnh
    temp_Rmh = earth_get_Rmh(temp_pos_half);
    temp_Rnh = earth_get_Rnh(temp_pos_half);
    %由(m-1/2)时刻的速度位置，求w_ie_n,w_en_n,w_in_n
    temp_w_ie_n = earth_get_w_ie_n(temp_pos_half);
    temp_w_en_n = earth_get_w_en_n(temp_pos_half,temp_Vn_half,temp_Rmh,temp_Rnh);
    temp_w_in_n = temp_w_ie_n+temp_w_en_n;
    %由(m-1/2)时刻的位置 求 gn
    temp_gn = earth_get_g_n(temp_pos_half);
    
%% 二、计算陀螺和加计的增量
    %陀螺输出 角增量
    insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T/2;
    %加计输出 速度增量
    insdata_now.DeltaV_ib_b = (insdata_now.f_ib_b+insdata_pre.f_ib_b)*T/2;
%% 三、速度更新
    %基于(m-1/2)的数据，计算 DeltaV_cor_n
    temp = 2*temp_w_ie_n;
    temp = temp+temp_w_en_n;
    temp = cross(temp,temp_Vn_half);
    temp = temp_gn-temp;
    temp_DeltaV_cor_n = T*temp;
    %计算 DeltaV_rot_b
    temp_DeltaV_rot_b = 0.5*cross(insdata_now.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
    %计算 DeltaV_roll_b
    temp = cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
    temp1 = cross(insdata_pre.DeltaV_ib_b,insdata_now.DeltaTheta_ib_b);
    temp_DeltaV_roll_b = (temp+temp1)/12.0;
    %计算 DeltaV_sf_n  相当于YGM中的 dvbm
    dvbm = insdata_now.DeltaV_ib_b+temp_DeltaV_rot_b+temp_DeltaV_roll_b;
    %对加速度计进行零偏补偿
    dvbm = dvbm-insdata_now.IMUError.acc_bias*T;
    insdata_now.fb = dvbm/T;
    insdata_now.fn = insdata_pre.C_b_n*insdata_now.fb;
    tempM = askew_v2m(temp_w_in_n)*T/2.0;
    tempM = eye(3) - tempM;
    temp_DeltaV_sf_n = tempM*insdata_pre.C_b_n*(dvbm);    
    %计算 当前时刻的速度增量INSData.DeltaV_n
    insdata_now.DeltaV_n = temp_DeltaV_sf_n + temp_DeltaV_cor_n;
    %计算 当前时刻的速度
    insdata_now.vel = insdata_pre.vel + insdata_now.DeltaV_n;
    
%% 四、位置更新
    temp_DeltaS = (insdata_pre.vel+insdata_now.vel)*T/2.0;
    temp = [temp_DeltaS(2,1)/temp_Rmh;temp_DeltaS(1,1)/temp_Rnh/cos(temp_pos_half(1,1));temp_DeltaS(3,1)];
    insdata_now.pos = insdata_pre.pos+temp;
    
%% 五、姿态更新    
    %1. 求取 四元数Q_nm_1_nm
    %利用新的 速度 位置，重新计算 w_in_n ，并计算当前时刻的DeltaTheta_in_n
    insdata_now.w_ie_n = earth_get_w_ie_n(insdata_now.pos);
    insdata_now.Rmh = earth_get_Rmh(insdata_now.pos);
    insdata_now.Rnh = earth_get_Rnh(insdata_now.pos);
    insdata_now.w_en_n = earth_get_w_en_n(insdata_now.pos,insdata_now.vel,insdata_now.Rmh,insdata_now.Rnh);
    insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
    insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T/2.0;
    %由DeltaTheta_in_n 计算 对应的四元数temp_Q_nm_nm_1
    %计算对应的旋转矢量 temp_fi_in_n
    temp_fi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
    %由 旋转矢量 temp_fi_nm_nm_1 求对应的四元数 temp_Q_nm_nm_1
    temp_Q_nm_nm_1 = change_rv2Q(temp_fi_in_n);
    temp_Q_nm_1_nm = change_Q2conj(temp_Q_nm_nm_1);
    %2. 求取 四元数 Q_bm_bm_1
    %计算对应的旋转矢量 temp_fi_ib_b
    temp_fi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
    %对陀螺零偏进行补偿，先不考虑非线性比例因子误差
    temp_fi_ib_b = temp_fi_ib_b - insdata_now.IMUError.gyr_bias*T;
    %由 旋转矢量 temp_fi_ib_b 求对应的四元数 temp_Q_bm_bm_1
    temp_Q_bm_bm_1 = change_rv2Q(temp_fi_ib_b);
    insdata_now.Q_b_n = calculate_QmulQ(calculate_QmulQ(temp_Q_nm_1_nm,insdata_pre.Q_b_n),temp_Q_bm_bm_1);
    %由 四元数 求解对应的 DCM
    insdata_now.C_b_n = change_Q2DCM(insdata_now.Q_b_n);
    %由 DCM 更新 当前时刻的姿态
    insdata_now.att = change_DCM2euler(insdata_now.C_b_n);


   
    

    
