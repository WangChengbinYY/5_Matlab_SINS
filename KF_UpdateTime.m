function KF = KF_UpdateTime(KF,INSData)
% 依据新的INS信息 进行KF的 时间更新
% Inputs:   KF INSData 
% Output:   KF
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 1/1/2019

KF = KF_UpdateFt(KF,INSData);
KF.Fk = KF.Ft * INSData.ts;
KF.Phikk_1 = eye(size(KF.Ft)) + KF.Fk;

KF.Xkk_1 = KF.Phikk_1 * KF.Xk;
KF.Pkk_1 = KF.Phikk_1 * KF.Pk * KF.Phikk_1' + KF.Qk;

%当仅做时间更新时，仅执行一步预测，也不反馈
KF.Xk = KF.Xkk_1;
KF.Pk = KF.Pkk_1;

