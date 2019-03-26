function Plot_xkpk_compare(xkpk0,xkpk1)
% KF滤波信息 进行对比
% Inputs:    
% Output:   
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 2/1/2019
global G_CONST  


%获取时间x轴
t0 = xkpk0(:,31);
t1 = xkpk1(:,31);

%% 姿态误差信息绘制
    %俯仰误差
    figure;
    subplot(211);
    plot(t0,xkpk0(:,1)*G_CONST.R2D,'r');
    hold on;
    plot(t1,xkpk1(:,1)*G_CONST.R2D);    
    xlabel('\it t \rm / s');
    ylabel('\it \phi_E \rm / \circ');
    title('KF滤波-俯仰误差');
    subplot(212);
    plot(t0,sqrt(xkpk0(:,16)).*G_CONST.R2D,'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,16)).*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \sigma \phi _E \rm / \circ');
    title('KF滤波Pk：俯仰角均方差');  
 
    %横滚误差
    figure;
    subplot(211);
    plot(t0,xkpk0(:,2)*G_CONST.R2D,'r');
    hold on;
    plot(t1,xkpk1(:,2)*G_CONST.R2D);    
    xlabel('\it t \rm / s');
    ylabel('\it \phi_N \rm / \circ');
    title('KF滤波-横滚误差');    
    subplot(212);
    plot(t0,sqrt(xkpk0(:,17)).*G_CONST.R2D,'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,17)).*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \sigma \phi _N \rm / \circ');
    title('KF滤波Pk：横滚角均方差');  

    %航向误差
    figure;
    subplot(211);
    plot(t0,xkpk0(:,3)*G_CONST.R2D,'r');
    hold on;
    plot(t1,xkpk1(:,3)*G_CONST.R2D);    
    xlabel('\it t \rm / s');
    ylabel('\it \phi_U \rm / \circ');
    title('KF滤波-航向误差');   
    subplot(212);
    plot(t0,sqrt(xkpk0(:,18)).*G_CONST.R2D,'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,18)).*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \sigma \phi _U \rm / \circ');
    title('KF滤波Pk：航向角均方差');  
     
%% 速度误差信息绘制   
    figure;
    subplot(211);
    plot(t0,xkpk0(:,4),'r');
    hold on;
    plot(t1,xkpk1(:,4));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('KF滤波-东向速度误差');
    subplot(212);
    plot(t0,sqrt(xkpk0(:,19)),'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,19)));
    xlabel('\it t \rm / s');
    ylabel('\it \sigma V_E \rm / m/s');
    title('KF滤波Pk：东向速度均方差');  
   
    figure;
    subplot(211);
    plot(t0,xkpk0(:,5),'r');
    hold on;
    plot(t1,xkpk1(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('KF滤波-北向速度误差');    
    subplot(212);
    plot(t0,sqrt(xkpk0(:,20)),'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,20)));
    xlabel('\it t \rm / s');
    ylabel('\it \sigma V_N \rm / m/s');
    title('KF滤波Pk：北向速度均方差');    
     
    figure;
    subplot(211);
    plot(t0,xkpk0(:,6),'r');
    hold on;
    plot(t1,xkpk1(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('KF滤波-天向速度误差');  
    subplot(212);
    plot(t0,sqrt(xkpk0(:,21)),'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,21)));
    xlabel('\it t \rm / s');
    ylabel('\it \sigma V_U \rm / m/s');
    title('KF滤波Pk：天向速度均方差');      
    
%% 位置误差信息绘制   
    figure;
    subplot(211);
    plot(t0,xkpk0(:,7)*G_CONST.earth_Re,'r');
    hold on;
    plot(t1,xkpk1(:,7)*G_CONST.earth_Re);
    xlabel('\it t \rm / s');
    ylabel('\it North \rm / m');
    title('KF滤波-北向位置误差');    
    subplot(212);
    plot(t0,sqrt(xkpk0(:,22))*G_CONST.earth_Re,'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,22))*G_CONST.earth_Re);
    xlabel('\it t \rm / s');
    ylabel('\it \sigma North \rm / m');
    title('KF滤波Pk：北向位置均方差');  
    

    figure;
    subplot(211);
    plot(t0,xkpk0(:,8)*G_CONST.earth_Re*cos(0.530699173342059),'r');
    hold on;
    plot(t1,xkpk1(:,8)*G_CONST.earth_Re*cos(0.530699173342059));
    xlabel('\it t \rm / s');
    ylabel('\it East \rm / m');
    title('KF滤波-东向位置误差');      
    subplot(212);
    plot(t0,sqrt(xkpk0(:,23))*G_CONST.earth_Re*cos(0.530699173342059),'r');
    hold on;
    plot(t1,sqrt(xkpk1(:,23))*G_CONST.earth_Re*cos(0.530699173342059));
    xlabel('\it t \rm / s');
    ylabel('\it \sigma East \rm / m');
    title('KF滤波Pk：东向位置均方差');  
    
    figure;
    subplot(211);
    plot(t0,xkpk0(:,9),'r');
    hold on;
    plot(t1,xkpk1(:,9));
    xlabel('\it t \rm / s');
    ylabel('\it Up \rm / m');
    title('KF滤波-天向位置误差');        
    subplot(212);
    plot(t0,xkpk0(:,24),'r');
    hold on;
    plot(t1,xkpk1(:,24));
    xlabel('\it t \rm / s');
    ylabel('\it \sigma North \rm / m');
    title('KF滤波Pk：天向位置均方差');  


    
    
    
    
    
    
    
    
    