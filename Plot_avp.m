function Plot_avp(avp)
% 绘制结果数据图形 姿态 速度 位置
% Inputs:    
% Output:   
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 2/1/2019
global G_CONST  

    % 获取时间 x轴
    t = avp(:,10);

%% 绘制姿态信息    
    %绘制单个图形——姿态
    figure;
    plot(t,avp(:,1)*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('姿态-俯仰');
    
    figure;
    plot(t,avp(:,2)*G_CONST.R2D);
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('姿态-横滚');

    figure;
    Yaw = avp(:,3)*G_CONST.R2D;
    L = size(Yaw);
    for i=1:L
        if Yaw(i,1) < 0.0
            Yaw(i,1) = Yaw(i,1) + 360.0;
        end
    end
    plot(t,Yaw);
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('姿态-航向');

%% 绘制速度信息     
    figure;
    plot(t,avp(:,4));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('速度-东向');

    figure;
    plot(t,avp(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('速度-北向');

    figure;
    plot(t,avp(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('速度-天向');
    
    figure;
    plot(t,(sqrt(avp(:,4).^2+avp(:,5).^2+avp(:,6).^2)));
    xlabel('\it t \rm / s');
    ylabel('\it V \rm / m/s');
    title('绝对速度');

%% 绘制位置信息  
    figure;
    plot(0, 0, 'rp');     %在起始位置画一个 五角星
    legend(sprintf('%.6f, %.6f / 度', avp(1,8)*G_CONST.R2D,avp(1,7)*G_CONST.R2D));
    hold on;
    plot((avp(:,8)-avp(1,8))*G_CONST.earth_Re*cos(avp(1,7)), (avp(:,7)-avp(1,7))*G_CONST.earth_Re);
    xlabel('\it East \rm / m');
    ylabel('\it North \rm / m');

    
    
    
