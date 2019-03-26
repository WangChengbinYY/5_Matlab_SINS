function M_v = askew_v2m(v)
% Convert 3x1 vector to 3x3 askew matrix.
%
% Prototype: M_v = askew(v)
% Input:     v - 3x1 vector
% Output: v - corresponding 3x3 askew matrix, such that
%                 |  0   -v(3)  v(2) |
%           M_v = | v(3)  0    -v(1) |
%                 |-v(2)  v(1)  0    |
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018

    M_v = [ 0,     -v(3),   v(2); 
          v(3),   0,     -v(1); 
         -v(2),   v(1),   0     ];