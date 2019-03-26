function w_in_n = earth_get_w_in_n(pos,vn,Rmh,Rnh)
% 计算n系相对i系旋转速度在n系下的投影w_in_n 顺带会更新w_ie_n w_en_n
%       导航坐标n系采用 东北天
% Inputs:   pos = [lat;lon;h] 纬度、经度、高程，单位弧度 m
%           vn = [x;y;z] 载体相对地球速度在n系下的投影，单位弧度 m
% Output:   w_in_n = [x;y;z]      单位 弧度/s 
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018

w_ie_n = earth_get_w_ie_n(pos);
w_en_n = earth_get_w_en_n(pos,vn,Rmh,Rnh);
w_in_n = w_ie_n+w_en_n;



