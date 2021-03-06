function Q = calculate_QmulQ(Q1, Q2)
% 实现四元数相乘计算  Q = Q1*Q2.
% 
% Inputs: Q1, Q2 - input quaternion
% Output: Q - output quaternion ,such that q = Q1*Q2
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 24/12/2018
    Q = [ Q1(1) * Q2(1) - Q1(2) * Q2(2) - Q1(3) * Q2(3) - Q1(4) * Q2(4);
          Q1(1) * Q2(2) + Q1(2) * Q2(1) + Q1(3) * Q2(4) - Q1(4) * Q2(3);
          Q1(1) * Q2(3) + Q1(3) * Q2(1) + Q1(4) * Q2(2) - Q1(2) * Q2(4);
          Q1(1) * Q2(4) + Q1(4) * Q2(1) + Q1(2) * Q2(3) - Q1(3) * Q2(2) ];
