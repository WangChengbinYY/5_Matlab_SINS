function Plot_bias_compare(bias0,bias1)
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
t0 = bias0(:,7);
t1 = bias1(:,7);

%% 陀螺零偏估计数据
    %X轴陀螺零偏 
    figure;
    plot(t0,bias0(:,1) /(pi / 180.0 / 3600.0),'r');
    hold on;
    plot(t1,bias1(:,1)/(pi / 180.0 / 3600.0));    
    xlabel('\it t \rm / s');
    ylabel('\it GyroBias_X \rm / \circ/h');
    title('KF滤波-X轴陀螺零偏估计');
    
    figure;
    plot(t0,bias0(:,2) /(pi / 180.0 / 3600.0),'r');
    hold on;
    plot(t1,bias1(:,2)/(pi / 180.0 / 3600.0));    
    xlabel('\it t \rm / s');
    ylabel('\it GyroBias_Y \rm / \circ/h');
    title('KF滤波-Y轴陀螺零偏估计');   
    
    figure;
    plot(t0,bias0(:,3) /(pi / 180.0 / 3600.0),'r');
    hold on;
    plot(t1,bias1(:,3)/(pi / 180.0 / 3600.0));    
    xlabel('\it t \rm / s');
    ylabel('\it GyroBias_Z \rm / \circ/h');
    title('KF滤波-Z轴陀螺零偏估计');
    
 %% 加计零偏估计数据
    %X轴加计零偏    
    figure;
    plot(t0,bias0(:,4)*1e5,'r');
    hold on;
    plot(t1,bias1(:,4)*1e5);    
    xlabel('\it t \rm / s');
    ylabel('\it AccBias_X \rm / mGal');
    title('KF滤波-X轴加计零偏估计');
    
    figure;
    plot(t0,bias0(:,5)*1e5,'r');
    hold on;
    plot(t1,bias1(:,5)*1e5);    
    xlabel('\it t \rm / s');
    ylabel('\it AccBias_Y \rm / mGal');
    title('KF滤波-Y轴加计零偏估计');   
    
    figure;
    plot(t0,bias0(:,6)*1e5,'r');
    hold on;
    plot(t1,bias1(:,6)*1e5);    
    xlabel('\it t \rm / s');
    ylabel('\it AccBias_Z \rm / mGal');
    title('KF滤波-Z轴加计零偏估计');
    
    
    
    