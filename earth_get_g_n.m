function g_n = earth_get_g_n(pos)
% 计算补偿过的g在n系下的投影
% Inputs:   pos = [lat;lon;h] 纬度、经度、高程，单位弧度 m
% Output:   g_n     单位 m/s2
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018
global G_CONST
temp_g = G_CONST.earth_g0*(1+5.27094e-3*sin(pos(1,1))^2+2.32718e-5*sin(pos(1,1))^4)-3.086e-6*pos(3,1); % grs80
g_n = [0;0;-temp_g];