function [KF,INSData] = KF_FeedBack(KF,INSData,coef_fb)
% 针对KF滤波的信息，按照系数coef_fb进行反馈
% Inputs:   KF INSData coef_fb
% Output:   KF
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 2/1/2019

xfb_tmp = coef_fb.*KF.Xk;
%姿态补偿
INSData.Q_b_n = qmul(rv2q(xfb_tmp(1:3)), INSData.Q_b_n);
KF.Xk(1:3) = KF.Xk(1:3) - xfb_tmp(1:3);    
INSData.C_b_n = change_Q2DCM(INSData.Q_b_n);
INSData.att = change_DCM2euler(INSData.C_b_n);
%速度补偿
INSData.vel = INSData.vel - xfb_tmp(4:6);
KF.Xk(4:6) = KF.Xk(4:6) - xfb_tmp(4:6);    
%位置补偿
INSData.pos = INSData.pos - xfb_tmp(7:9);
KF.Xk(7:9) = KF.Xk(7:9) - xfb_tmp(7:9);    
%陀螺零偏补偿
INSData.IMUError.gyr_bias = INSData.IMUError.gyr_bias + xfb_tmp(10:12);
KF.Xk(10:12) = KF.Xk(10:12) - xfb_tmp(10:12);    
%加计零偏补偿
INSData.IMUError.acc_bias = INSData.IMUError.acc_bias + xfb_tmp(13:15);
KF.Xk(13:15) = KF.Xk(13:15) - xfb_tmp(13:15);    

