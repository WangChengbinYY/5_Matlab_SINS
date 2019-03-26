function Euler = change_DCM2euler(C_b_n)
% 将输入的旋转矩阵 转为 欧拉姿态角
%       n系 东北天；b系 右前上
% Inputs:   C_b_n DCM from body-frame to navigation-frame
% Output:   Euler - Euler=[pitch; roll; yaw] in radians
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 23/12/2018

    Euler = [ asin(C_b_n(3,2)); 
            atan2(-C_b_n(3,1),C_b_n(3,3)); 
            atan2(-C_b_n(1,2),C_b_n(2,2)) ];