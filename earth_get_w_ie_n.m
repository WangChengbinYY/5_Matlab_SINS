function w_ie_n = earth_get_w_ie_n(pos)
% 计算地球自转角速度在n系下的投影w_ie_n
%       导航坐标n系采用 东北天
% Inputs:   pos = [lat;lon;h] 纬度、经度、高程，单位弧度 m
% Output:   w_ie_n = [x;y;z]      单位 弧度/s 
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018
global G_CONST

w_ie_n = [0; G_CONST.earth_wie*cos(pos(1,1)); G_CONST.earth_wie*sin(pos(1,1))];

