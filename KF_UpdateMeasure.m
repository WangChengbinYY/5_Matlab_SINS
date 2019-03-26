function KF = KF_UpdateMeasure(KF,INSData)
% 依据新的INS信息 和 GPS数据 进行KF的 时间更新 和 量测更新
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

KF.Kk = KF.Pkk_1*KF.Hk'*invbc(KF.Hk*KF.Pkk_1*KF.Hk'+KF.Rk);
KF.Xk = KF.Xkk_1 + KF.Kk * (KF.Zk - KF.Hk*KF.Xkk_1);
KF.Pk = (eye(15)-KF.Kk*KF.Hk)*KF.Pkk_1*(eye(15)-KF.Kk*KF.Hk)' + KF.Kk*KF.Rk*KF.Kk';






