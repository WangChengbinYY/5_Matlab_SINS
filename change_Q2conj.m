function Qo = change_Q2conj(Qi)
% 求输入四元数的共轭四元数.
% 
% Input:    Qi - input quaternion
% Output:   Qo - output quaternion ,if Qi = [Qi(1); Qi(2:4)]
%              then Qi = [Qi(1); -Qi(2:4)]
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 23/12/2018

    Qo = [Qi(1); -Qi(2:4)];