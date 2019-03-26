function KF = KF_UpdateFt(KF,INSData)
% 依据新的INS信息 更新KF滤波器中的Ft等参数，并计算离散化的状态转移矩阵kf.Phikk_1
% Inputs:   KF INSData 
% Output:   KF
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 1/1/2019
    L=INSData.pos(1,1);
    cL = cos(L);
    sL = sin(L);
    sL2 = sin(L)*sin(L);
	tL = tan(L);
    secL = 1/cos(L);
    f_RMh = 1/INSData.Rmh; 
    f_RNh = 1/INSData.Rnh; 
    f_clRNh = f_RNh/cL;
    f_RMh2 = f_RMh*f_RMh;  
    f_RNh2 = f_RNh*f_RNh;
    vn = INSData.vel;
    vE_clRNh = vn(1)*f_clRNh; 
    vE_RNh2 = vn(1)*f_RNh2; 
    vN_RMh2 = vn(2)*f_RMh2;
    O33 = zeros(3);    
    
%     Mp1 = [ 0,               0, 0;
%            -ins.eth.wnie(3), 0, 0;
%             ins.eth.wnie(2), 0, 0 ];
    wnie = INSData.w_ie_n;
    Mp1=O33; Mp1(2)=-wnie(3); Mp1(3)=wnie(2);
%     Mp2 = [ 0,             0,  vN_RMh2;
%             0,             0, -vE_RNh2;
%             vE_clRNh*secl, 0, -vE_RNh2*tl];
    Mp2=O33; Mp2(3)=vE_clRNh*secL; Mp2(7)=vN_RMh2; Mp2(8)=-vE_RNh2; Mp2(9)=-vE_RNh2*tL;
%     Avn = [ 0,    -vn(3), vn(2);                               % Avn = askew(vn);
%             vn(3), 0,    -vn(1);
%            -vn(2), vn(1), 0 ];
    Avn=O33; Avn(2)=vn(3); Avn(3)=-vn(2); Avn(4)=-vn(3); Avn(6)=vn(1); Avn(7)=vn(2); Avn(8)=-vn(1); 
%     Awn = [ 0,               -wnien(3), wnien(2); % Awn = askew(wnien);
%             wnien(3), 0,               -wnien(1); 
%            -wnien(2), wnien(1), 0 ];
    wnien = INSData.w_ie_n + INSData.w_in_n;

    Awn=O33; Awn(2)=wnien(3); Awn(3)=-wnien(2); Awn(4)=-wnien(3); Awn(6)=wnien(1); Awn(7)=wnien(2); Awn(8)=-wnien(1); 
    %%
%     Maa = [ 0,               wnin(3),-wnin(2);  % Maa = -askew(wnin);
%            -wnin(3), 0,               wnin(1); 
%             wnin(2),-wnin(1), 0 ];
    wnin = INSData.w_in_n;
    Maa=O33; Maa(2)=-wnin(3); Maa(3)=wnin(2); Maa(4)=wnin(3); Maa(6)=-wnin(1); Maa(7)=-wnin(2); Maa(8)=wnin(1); 
%     Mav = [ 0,       -f_RMh, 0;
%             f_RNh,    0,     0;
%             f_RNh*tl, 0,     0 ];
    Mav=O33; Mav(2)=f_RNh; Mav(3)=f_RNh*tL; Mav(4)=-f_RMh;
    Map = Mp1+Mp2;
%     Mva = [ 0,        -ins.fn(3), ins.fn(2);                    % Mva = askew(ins.fn);
%             ins.fn(3), 0,        -ins.fn(1);
%            -ins.fn(2), ins.fn(1), 0 ];
    fn = INSData.fn;
%% 这里的fn是补偿以后的
    Mva=O33; Mva(2)=fn(3); Mva(3)=-fn(2); Mva(4)=-fn(3); Mva(6)=fn(1); Mva(7)=fn(2); Mva(8)=-fn(1); 
    Mvv = Avn*Mav - Awn;
    Mvp = Avn*(Mp1+Map);
    % g = g0*(1+5.27094e-3*eth.sl2+2.32718e-5*sl4)-3.086e-6*pos(3);
    g0 = 9.7803267714;  scL = sL*cL;
    Mvp(3) = Mvp(3)-g0*(5.27094e-3*2*scL+2.32718e-5*4*sL2*scL); Mvp(9) = Mvp(9)+3.086e-6;  % 26/05/2014, good!!!
%     Mpv = [ 0,       f_RMh, 0;
%             f_clRNh, 0,     0;
%             0,       0,     1 ];
    Mpv = O33; Mpv(1,2) = f_RMh; Mpv(2,1) = f_clRNh;Mpv(3,3) = 1;
%     Mpp = [ 0,           0, -vN_RMh2;
%             vE_clRNh*tl, 0, -vE_RNh2*secl;
%             0,           0,  0 ];
    Mpp = O33; Mpp(2)=vE_clRNh*tL; Mpp(7)=-vN_RMh2; Mpp(8)=-vE_RNh2*secL;
	%%     fi     dvn    dpos    eb       db
	KF.Ft = [ Maa    Mav    Map    -INSData.C_b_n  O33 
           Mva    Mvv    Mvp     O33      INSData.C_b_n 
           O33    Mpv    Mpp     O33      O33
           zeros(6,9)  diag(-1./[INSData.IMUError.gyr_bias_CorTime;INSData.IMUError.acc_bias_CorTime]) ];



