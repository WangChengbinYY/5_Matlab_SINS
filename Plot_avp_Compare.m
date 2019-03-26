function Plot_avp_Compare(avp0,avp1)
% 比较绘制 结果数据图形 姿态 速度 位置
% Inputs:    
% Output:   
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 2/1/2019
global G_CONST  

    % 获取时间 x轴
    t0 = avp0(:,10);
    t1 = avp1(:,10);
    

%% 绘制姿态信息    
    %绘制单个图形——姿态
    figure;
    plot(t0,avp0(:,1)*G_CONST.R2D,'r');
    hold on;
    plot(t1,avp1(:,1)*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('姿态-俯仰');
    
    figure;
    plot(t0,avp0(:,2)*G_CONST.R2D,'r');
    hold on;
    plot(t1,avp1(:,2)*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('姿态-横滚');

    figure;
    Yaw0 = avp0(:,3)*G_CONST.R2D;
    L0 = size(Yaw0);
    for i=1:L0
        if Yaw0(i,1) < 0.0
            Yaw0(i,1) = Yaw0(i,1) + 360.0;
        end
    end
    Yaw1 = avp1(:,3)*G_CONST.R2D;
    L1 = size(Yaw1);
    for i=1:L1
        if Yaw1(i,1) < 0.0
            Yaw1(i,1) = Yaw1(i,1) + 360.0;
        end
    end
    
    plot(t0,Yaw0,'r');
    hold on;
    plot(t1,Yaw1); 
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('姿态-航向');

%% 绘制速度信息     
    figure;
    plot(t0,avp0(:,4),'r');
    hold on;
    plot(t1,avp1(:,4));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('速度-东向');

    figure;
    plot(t0,avp0(:,5),'r');
    hold on;
    plot(t1,avp1(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('速度-北向');

    figure;
    plot(t0,avp0(:,6),'r');
    hold on;
    plot(t1,avp1(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('速度-天向');
    
    figure;
    plot(t0,(sqrt(avp0(:,4).^2+avp0(:,5).^2+avp0(:,6).^2)),'r*');
    hold on;
    plot(t1,(sqrt(avp1(:,4).^2+avp1(:,5).^2+avp1(:,6).^2)));
    xlabel('\it t \rm / s');
    ylabel('\it V \rm / m/s');
    title('绝对速度');

%% 绘制位置信息  
    %行驶路线图
    figure;
    plot(0, 0, 'rp');     %在起始位置画一个 五角星
    legend(sprintf('%.6f, %.6f / 度', avp0(1,8)*G_CONST.R2D,avp0(1,7)*G_CONST.R2D));
    hold on;    
    plot((avp0(:,8)-avp0(1,8))*G_CONST.earth_Re*cos(avp0(1,7)), (avp0(:,7)-avp0(1,7))*G_CONST.earth_Re,'r');
    hold on;    
    plot((avp1(:,8)-avp1(1,8))*G_CONST.earth_Re*cos(avp1(1,7)), (avp1(:,7)-avp1(1,7))*G_CONST.earth_Re);  
    xlabel('\it East \rm / m');
    ylabel('\it North \rm / m');
    title('行驶路线');
    %东向位置信息
    figure;  
    plot(t0,(avp0(:,8)-avp0(1,8))*G_CONST.earth_Re*cos(avp0(1,7)),'r');
    hold on;    
    plot(t1,(avp1(:,8)-avp1(1,8))*G_CONST.earth_Re*cos(avp1(1,7)));
    xlabel('\it t \rm / s');
    ylabel('\it 东向行驶距离 \rm / m');
    title('行驶路线');
    %北向位置信息
    figure;
    plot(t0,(avp0(:,7)-avp0(1,7))*G_CONST.earth_Re,'r');
    hold on;    
    plot(t1,(avp1(:,7)-avp1(1,7))*G_CONST.earth_Re);
    xlabel('\it East \rm / m');
    ylabel('\it 北向行驶距离 \rm / m');       
    %位置比较
    figure;
    plot(t0,avp0(:,9),'r');
    hold on;
    plot(t1,avp1(:,9));
    xlabel('\it t \rm / s');
    ylabel('\it 高程 \rm / m');
    title('高程信息');
    
    