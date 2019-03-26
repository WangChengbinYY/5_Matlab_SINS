function C_b_n = change_euler2DCM(att)
% 将输入的欧拉角 变换成 DCM 
%       n系 东北天；b系 右前上
% Inputs:   att - att=[pitch; roll; yaw] in radians
% Output:   C_b_n DCM from body-frame to navigation-frame
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 23/12/2018

    s = sin(att); c = cos(att);
    si = s(1); sj = s(2); sk = s(3); 
    ci = c(1); cj = c(2); ck = c(3);
    C_b_n = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
            cj*sk+si*sj*ck,  ci*ck,  sj*sk-si*cj*ck;
           -ci*sj,           si,     ci*cj           ];