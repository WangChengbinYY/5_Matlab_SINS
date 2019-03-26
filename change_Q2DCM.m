function C_b_n = change_Q2DCM(Q_b_n)
% 将输入的四元数 变换成 DCM 
%       n系 东北天；b系 右前上
% Inputs:   Q_b_n - attitude quaternion
% Output:   C_b_n DCM from body-frame to navigation-frame
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 24/12/2018

    q11 = Q_b_n(1)*Q_b_n(1); q12 = Q_b_n(1)*Q_b_n(2); q13 = Q_b_n(1)*Q_b_n(3); q14 = Q_b_n(1)*Q_b_n(4); 
    q22 = Q_b_n(2)*Q_b_n(2); q23 = Q_b_n(2)*Q_b_n(3); q24 = Q_b_n(2)*Q_b_n(4);     
    q33 = Q_b_n(3)*Q_b_n(3); q34 = Q_b_n(3)*Q_b_n(4);  
    q44 = Q_b_n(4)*Q_b_n(4);
    C_b_n = [ q11+q22-q33-q44,  2*(q23-q14),     2*(q24+q13);
            2*(q23+q14),      q11-q22+q33-q44, 2*(q34-q12);
            2*(q24-q13),      2*(q34+q12),     q11-q22-q33+q44 ];