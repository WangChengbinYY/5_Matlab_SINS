clear all;
%原始数据预处理
Number = '1';   %处理第 x 套数据
%------------------------------------------------------------------------
% 1. 读取txt文件
%------------------------------------------------------------------------
Filename_L_GPS = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\L_IMUGPS',Number,'_GPS.txt');
Origion_GPS_L = importdata(Filename_L_GPS);
clear Filename_L_GPS;

Filename_L_Foot = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\L_IMUGPS',Number,'_FootPressure.txt');
Origion_Foot_L = importdata(Filename_L_Foot);
clear Filename_L_Foot;

Filename_L_IMUB = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\L_IMUGPS',Number,'_IMU_B.txt');
Origion_IMUB_L = importdata(Filename_L_IMUB);
clear Filename_L_IMUB;

Filename_L_UWB = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\L_IMUGPS',Number,'_UWB.txt');
Origion_UWB_L = importdata(Filename_L_UWB);
clear Filename_L_UWB;

Filename_R_GPS = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\R_IMUGPS',Number,'_GPS.txt');
Origion_GPS_R = importdata(Filename_R_GPS);
clear Filename_R_GPS;

Filename_R_Foot = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\R_IMUGPS',Number,'_FootPressure.txt');
Origion_Foot_R = importdata(Filename_R_Foot);
clear Filename_R_Foot;

Filename_R_IMB = strcat('E:\2_博士课题_JG\2_实验记录\20190421_2_紫荆操场第二次一圈带压力\原始数据\R_IMUGPS',Number,'_IMU_B.txt');
Origion_IMUB_R = importdata(Filename_R_IMB);
clear Filename_R_IMB;

%-------------------------------------------------------------------------
% 2. 对ADIS数据进行预处理 
%    其中包含Foot的数据，因为Foot和IMUB是同时采集的，时间一样
%-------------------------------------------------------------------------
% 查看ADIS采集是否漏包，如果ADIS漏包，意味着 Foot也漏包！
[m,n] = size(Origion_IMUB_L);
Temp_ADIS_L = zeros(m-1,1);
for i=1:m-1
    Temp_ADIS_L(i,1) = Origion_IMUB_L(i+1,10)-Origion_IMUB_L(i,10);
    if Temp_ADIS_L(i,1) < 0
        Temp_ADIS_L(i,1) = Temp_ADIS_L(i,1) + 65536;
    end
end
figure;plot(Temp_ADIS_L);title('L-ADIS-IMU-数据漏包(>1为漏包)');
clear Temp_ADIS_L m n i;

[m,n] = size(Origion_IMUB_R);
Temp_ADIS_R = zeros(m-1,1);
for i=1:m-1
    Temp_ADIS_R(i,1) = Origion_IMUB_R(i+1,10)-Origion_IMUB_R(i,10);
    if Temp_ADIS_R(i,1) < 0
        Temp_ADIS_R(i,1) = Temp_ADIS_R(i,1) + 65536;
    end
end
figure;plot(Temp_ADIS_R);title('R-ADIS-IMU-数据漏包(>1为漏包)');
clear Temp_ADIS_R m n i;

%------------------------------------------
% 2.1 若是有漏包的 先进行插值补充数据(Foot也需要补包)
%------------------------------------------


%------------------------------------------
% 2.2 按照设定的时间段，对左足 IMU数据进行截取 整理
%------------------------------------------
GPS_Time_Start = 9107;      GPS_Time_End = 9475; 
L_IMUB_StartNum = 21070;     L_IMUB_EndNum = 94916; 
DTime = 5;     %采样间隔 ms 200Hz
%建立临时变量
[m1,n] = size(Origion_IMUB_L);
m1 = L_IMUB_EndNum - L_IMUB_StartNum + 1;
Temp_L_IMUB = zeros(m1,n+3);
Temp_L_IMUB(:,1:2) = Origion_IMUB_L(L_IMUB_StartNum:L_IMUB_EndNum,1:2);
Temp_L_IMUB(:,6:n+3) = Origion_IMUB_L(L_IMUB_StartNum:L_IMUB_EndNum,3:n);
[m1,n] = size(Origion_Foot_L);
m1 = L_IMUB_EndNum - L_IMUB_StartNum + 1;
Temp_L_Foot = zeros(m1,n+3);
Temp_L_Foot(:,1:2) = Origion_Foot_L(L_IMUB_StartNum:L_IMUB_EndNum,1:2);
Temp_L_Foot(:,6:n+3) = Origion_Foot_L(L_IMUB_StartNum:L_IMUB_EndNum,3:n);
%原始数据 整秒内 Hz 对齐
TNumber = 1; TSecond = 0;
Temp_L_IMUB(1,3:4) = Temp_L_IMUB(1,1:2);
Temp_L_IMUB(1,5) = Temp_L_IMUB(1,3) + Temp_L_IMUB(1,4)/1000.0;
Temp_L_Foot(1,3:4) = Temp_L_Foot(1,1:2);
Temp_L_Foot(1,5) = Temp_L_Foot(1,3) + Temp_L_Foot(1,4)/1000.0;
TMSFirst = Temp_L_IMUB(1,2);
TTimeStart = Temp_L_IMUB(1,1);
for i=2:m1
    if((Temp_L_IMUB(i,2)-Temp_L_IMUB(i-1,2)) < -500) && (TNumber > 190)
        % 新 秒 的开始
        TSecond = TSecond + 1;
        TNumber = 0;
        TMSFirst = Temp_L_IMUB(i,2);
    end
    Temp_L_IMUB(i,3) = TTimeStart + TSecond;
    Temp_L_IMUB(i,4) = TMSFirst + TNumber*DTime;
    Temp_L_IMUB(i,5) = Temp_L_IMUB(i,3) + Temp_L_IMUB(i,4)/1000.0;
    
    Temp_L_Foot(i,3) = TTimeStart + TSecond;
    Temp_L_Foot(i,4) = TMSFirst + TNumber*DTime;
    Temp_L_Foot(i,5) = Temp_L_Foot(i,3) + Temp_L_Foot(i,4)/1000.0;
    
    TNumber = TNumber + 1;
end
%按照 采样频率对齐 获取插值整理后的新数据
m2 = (GPS_Time_End-GPS_Time_Start+1)*(1000/DTime);
Data_IMU_L = zeros(m2,8);    %ADIS 整理后的数据 时间1 加计3 陀螺3 温度1
Data_Foot_L = zeros(m2,5);   %压力传感器数据 时间1 压力4
TempJ = 1;  Fj = 1; Sj = 1;
for i=1:m2
    %设定时间
    Data_IMU_L(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    Data_Foot_L(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    %按照时间进行插值 找寻前后最近的时间点
    for j = TempJ:m1
        if(Temp_L_IMUB(j,5) == Data_IMU_L(i,1))
            Data_IMU_L(i,2:8) = Temp_L_IMUB(j,6:12);
            Data_Foot_L(i,2:5) = Temp_L_Foot(j,6:9);
            TempJ = j;
            break;
        end
        if(Temp_L_IMUB(j,5) < Data_IMU_L(i,1))
            Fj = j;
        end
        if(Temp_L_IMUB(j,5) > Data_IMU_L(i,1))
            Sj = j;
            X1 = Temp_L_IMUB(Fj,5);
            X2 = Temp_L_IMUB(Sj,5);
            Data_IMU_L(i,2) = Leo_InsertData(X1,Temp_L_IMUB(Fj,6),X2,Temp_L_IMUB(Sj,6),Data_IMU_L(i,1));
            Data_IMU_L(i,3) = Leo_InsertData(X1,Temp_L_IMUB(Fj,7),X2,Temp_L_IMUB(Sj,7),Data_IMU_L(i,1));
            Data_IMU_L(i,4) = Leo_InsertData(X1,Temp_L_IMUB(Fj,8),X2,Temp_L_IMUB(Sj,8),Data_IMU_L(i,1));
            Data_IMU_L(i,5) = Leo_InsertData(X1,Temp_L_IMUB(Fj,9),X2,Temp_L_IMUB(Sj,9),Data_IMU_L(i,1));
            Data_IMU_L(i,6) = Leo_InsertData(X1,Temp_L_IMUB(Fj,10),X2,Temp_L_IMUB(Sj,10),Data_IMU_L(i,1));
            Data_IMU_L(i,7) = Leo_InsertData(X1,Temp_L_IMUB(Fj,11),X2,Temp_L_IMUB(Sj,11),Data_IMU_L(i,1));
            Data_IMU_L(i,8) = Leo_InsertData(X1,Temp_L_IMUB(Fj,12),X2,Temp_L_IMUB(Sj,12),Data_IMU_L(i,1));
            
            Data_Foot_L(i,2) = Leo_InsertData(X1,Temp_L_Foot(Fj,6),X2,Temp_L_Foot(Sj,6),Data_IMU_L(i,1));
            Data_Foot_L(i,3) = Leo_InsertData(X1,Temp_L_Foot(Fj,7),X2,Temp_L_Foot(Sj,7),Data_IMU_L(i,1));
            Data_Foot_L(i,4) = Leo_InsertData(X1,Temp_L_Foot(Fj,8),X2,Temp_L_Foot(Sj,8),Data_IMU_L(i,1));
            Data_Foot_L(i,5) = Leo_InsertData(X1,Temp_L_Foot(Fj,9),X2,Temp_L_Foot(Sj,9),Data_IMU_L(i,1));         
            
            TempJ = j;
            break;
        end
    end
end
%绘制插值后的L-IMUB数据
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,6));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,2),'r');
title('L-IMUB加速度计X轴 插值后 红色');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,7));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,3),'r');
title('L-IMUB加速度计Y轴 插值后 红色');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,8));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,4),'r');
title('L-IMUB加速度计Z轴 插值后 红色');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,9));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,5),'r');
title('L-IMUB陀螺X轴 插值后 红色');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,10));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,6),'r');
title('L-IMUB陀螺Y轴 插值后 红色');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,11));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,7),'r');
title('L-IMUB陀螺Z轴 插值后 红色');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,12));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,8),'r');
title('L-IMUB温度 插值后 红色');

%绘制插值后的L-Foot数据
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,6));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,2),'r');
title('L-Foot点1 插值后 红色');
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,7));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,3),'r');
title('L-Foot点2 插值后 红色');
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,8));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,4),'r');
title('L-Foot点3 插值后 红色');
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,9));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,5),'r');
title('L-Foot点4 插值后 红色');

clear L_IMUB_StartNum L_IMUB_EndNum m1 m2 n TNumber TSecond i j Temp_L_IMUB;
clear Fj Sj X1 X2 TempJ TMSFirst Temp_L_Foot;

%------------------------------------------
% 2.3 按照设定的时间段，对右足 IMU数据进行截取 整理
%     右足传感器 的晶振有点问题，计时不准 预处理和 左足不一样
%------------------------------------------
R_IMUB_StartNum = 19940;     R_IMUB_EndNum = 93709;
%建立临时变量
[m1,n] = size(Origion_IMUB_R);
m1 = R_IMUB_EndNum - R_IMUB_StartNum + 1;
Temp_R_IMUB = zeros(m1,n+3);
Temp_R_IMUB(:,1:2) = Origion_IMUB_R(R_IMUB_StartNum:R_IMUB_EndNum,1:2);
Temp_R_IMUB(:,6:n+3) = Origion_IMUB_R(R_IMUB_StartNum:R_IMUB_EndNum,3:n);
[m1,n] = size(Origion_Foot_R);
m1 = R_IMUB_EndNum - R_IMUB_StartNum + 1;
Temp_R_Foot = zeros(m1,n+3);
Temp_R_Foot(:,1:2) = Origion_Foot_R(R_IMUB_StartNum:R_IMUB_EndNum,1:2);
Temp_R_Foot(:,6:n+3) = Origion_Foot_R(R_IMUB_StartNum:R_IMUB_EndNum,3:n);
%原始数据 整秒内 Hz 对齐
TNumber = 1; TSecond = 0;
Temp_R_IMUB(1,3:4) = Temp_R_IMUB(1,1:2);
Temp_R_IMUB(1,5) = Temp_R_IMUB(1,3) + Temp_R_IMUB(1,4)/1000.0;
Temp_R_Foot(1,3:4) = Temp_R_Foot(1,1:2);
Temp_R_Foot(1,5) = Temp_R_Foot(1,3) + Temp_R_Foot(1,4)/1000.0;
TMSFirst = Temp_R_IMUB(1,2);
TTimeStart = Temp_R_IMUB(1,1);
for i=2:m1
    if (((Temp_R_IMUB(i,2)-Temp_R_IMUB(i-1,2)) < 0) && ((Temp_R_IMUB(i,2)-Temp_R_IMUB(i-1,2)) > -500) )
        % 新 秒 的开始
        TSecond = TSecond + 1;
        TNumber = 0;
        TMSFirst = Temp_R_IMUB(i,2);
    end
    Temp_R_IMUB(i,3) = TTimeStart + TSecond;
    Temp_R_IMUB(i,4) = TMSFirst + TNumber*DTime;
    Temp_R_IMUB(i,5) = Temp_R_IMUB(i,3) + Temp_R_IMUB(i,4)/1000.0;
    
    Temp_R_Foot(i,3) = TTimeStart + TSecond;
    Temp_R_Foot(i,4) = TMSFirst + TNumber*DTime;
    Temp_R_Foot(i,5) = Temp_R_Foot(i,3) + Temp_R_Foot(i,4)/1000.0;
    
    TNumber = TNumber + 1;
end

%按照 采样频率对齐 获取插值整理后的新数据
m2 = (GPS_Time_End-GPS_Time_Start+1)*(1000/DTime);
Data_IMU_R = zeros(m2,8);    %ADIS 整理后的数据 时间1 加计3 陀螺3 温度1
Data_Foot_R = zeros(m2,5);   %压力传感器数据 时间1 压力4
TempJ = 1;  Fj = 1; Sj = 1;
for i=1:m2
    %设定时间
    Data_IMU_R(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    Data_Foot_R(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    %按照时间进行插值 找寻前后最近的时间点
    for j = TempJ:m1
        if(Temp_R_IMUB(j,5) == Data_IMU_R(i,1))
            Data_IMU_R(i,2:8) = Temp_R_IMUB(j,6:12);
            Data_Foot_R(i,2:5) = Temp_R_Foot(j,6:9);
            TempJ = j;
            break;
        end
        if(Temp_R_IMUB(j,5) < Data_IMU_R(i,1))
            Fj = j;
        end
        if(Temp_R_IMUB(j,5) > Data_IMU_R(i,1))
            Sj = j;
            X1 = Temp_R_IMUB(Fj,5);
            X2 = Temp_R_IMUB(Sj,5);
            Data_IMU_R(i,2) = Leo_InsertData(X1,Temp_R_IMUB(Fj,6),X2,Temp_R_IMUB(Sj,6),Data_IMU_R(i,1));
            Data_IMU_R(i,3) = Leo_InsertData(X1,Temp_R_IMUB(Fj,7),X2,Temp_R_IMUB(Sj,7),Data_IMU_R(i,1));
            Data_IMU_R(i,4) = Leo_InsertData(X1,Temp_R_IMUB(Fj,8),X2,Temp_R_IMUB(Sj,8),Data_IMU_R(i,1));
            Data_IMU_R(i,5) = Leo_InsertData(X1,Temp_R_IMUB(Fj,9),X2,Temp_R_IMUB(Sj,9),Data_IMU_R(i,1));
            Data_IMU_R(i,6) = Leo_InsertData(X1,Temp_R_IMUB(Fj,10),X2,Temp_R_IMUB(Sj,10),Data_IMU_R(i,1));
            Data_IMU_R(i,7) = Leo_InsertData(X1,Temp_R_IMUB(Fj,11),X2,Temp_R_IMUB(Sj,11),Data_IMU_R(i,1));
            Data_IMU_R(i,8) = Leo_InsertData(X1,Temp_R_IMUB(Fj,12),X2,Temp_R_IMUB(Sj,12),Data_IMU_R(i,1));
                        
            Data_Foot_R(i,2) = Leo_InsertData(X1,Temp_R_Foot(Fj,6),X2,Temp_R_Foot(Sj,6),Data_IMU_R(i,1));
            Data_Foot_R(i,3) = Leo_InsertData(X1,Temp_R_Foot(Fj,7),X2,Temp_R_Foot(Sj,7),Data_IMU_R(i,1));
            Data_Foot_R(i,4) = Leo_InsertData(X1,Temp_R_Foot(Fj,8),X2,Temp_R_Foot(Sj,8),Data_IMU_R(i,1));
            Data_Foot_R(i,5) = Leo_InsertData(X1,Temp_R_Foot(Fj,9),X2,Temp_R_Foot(Sj,9),Data_IMU_R(i,1));   
            
            TempJ = j;
            break;
        end
    end
end
%绘制插值后的L-IMUB数据
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,6));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,2),'r');
title('R-IMUB加速度计X轴 插值后 红色');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,7));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,3),'r');
title('R-IMUB加速度计Y轴 插值后 红色');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,8));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,4),'r');
title('R-IMUB加速度计Z轴 插值后 红色');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,9));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,5),'r');
title('R-IMUB陀螺X轴 插值后 红色');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,10));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,6),'r');
title('R-IMUB陀螺Y轴 插值后 红色');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,11));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,7),'r');
title('R-IMUB陀螺Z轴 插值后 红色');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,12));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,8),'r');
title('R-IMUB温度 插值后 红色');

%绘制插值后的R-Foot数据
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,6));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,2),'r');
title('R-Foot点1 插值后 红色');
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,7));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,3),'r');
title('R-Foot点2 插值后 红色');
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,8));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,4),'r');
title('R-Foot点3 插值后 红色');
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,9));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,5),'r');
title('R-Foot点4 插值后 红色');

clear R_IMUB_StartNum R_IMUB_EndNum m1 m2 n TNumber TSecond i j Temp_R_IMUB;
clear Fj Sj X1 X2 TempJ TMSFirst Temp_R_Foot TTimeStart;

%-------------------------------------------------------------------------
% 3. 对 UWB 数据进行预处理
%-------------------------------------------------------------------------
%------------------------------------------
% 3.1 检查是否有漏包的 
%------------------------------------------
[m,n] = size(Origion_UWB_L);
Temp_UWB_L = zeros(m-1,1);
for i=1:m-1
    Temp_UWB_L(i,1) = Origion_UWB_L(i+1,3)-Origion_UWB_L(i,3);
    if Temp_UWB_L(i,1) < 0
        Temp_UWB_L(i,1) = Temp_UWB_L(i,1) + 256;
    end
end
figure;plot(Temp_UWB_L);title('L-UWB-数据漏包(>1为漏包)');
clear Temp_UWB_L m n i;

%------------------------------------------
% 3.2 UWB数据进行补包 
%------------------------------------------
[m,n] = size(Origion_UWB_L);
j = 1;
Origion_UWB_L_Insert(1,:) = Origion_UWB_L(1,:);
for i = 2:m
    j = j+1;
    Number = Origion_UWB_L(i,3)-Origion_UWB_L(i-1,3);
    if ((Number==2) || (Number+256) == 2)
        Origion_UWB_L_Insert(j,1) = Origion_UWB_L(i-1,1);
        Origion_UWB_L_Insert(j,2) = Origion_UWB_L(i-1,2)+10;
        Origion_UWB_L_Insert(j,3) = Origion_UWB_L(i-1,3)+1;
        if Origion_UWB_L_Insert(j,3) == 256
            Origion_UWB_L_Insert(j,3) = 0;
        end
        Origion_UWB_L_Insert(j,4) = (Origion_UWB_L(i-1,4)+Origion_UWB_L(i,4))/2;
        j = j+1;
        Origion_UWB_L_Insert(j,:) =  Origion_UWB_L(i,:);
    else
        Origion_UWB_L_Insert(j,:) =  Origion_UWB_L(i,:);
    end    
end

% 查看 新补齐的UWB数据包是否漏包
[m,n] = size(Origion_UWB_L_Insert);
Temp_UWB_L = zeros(m-1,1);
for i=1:m-1
    Temp_UWB_L(i,1) = Origion_UWB_L_Insert(i+1,3)-Origion_UWB_L_Insert(i,3);
    if Temp_UWB_L(i,1) < 0
        Temp_UWB_L(i,1) = Temp_UWB_L(i,1) + 256;
    end
end
plot(Temp_UWB_L);
clear Temp_UWB_L m n i j Number;

%------------------------------------------
% 3.3 补包后的UWB数据 进行时间对准插值 
%------------------------------------------
L_UWB_StartNum = 9873;     L_UWB_EndNum = 46900;
%建立临时变量
DTime = 10;     %采样间隔 10ms  100Hz
[m1,n] = size(Origion_UWB_L_Insert);
m1 = L_UWB_EndNum - L_UWB_StartNum + 1;
Temp_UWB_L = zeros(m1,n+3);
Temp_UWB_L(:,1:2) = Origion_UWB_L_Insert(L_UWB_StartNum:L_UWB_EndNum,1:2);
Temp_UWB_L(:,6:n+3) = Origion_UWB_L_Insert(L_UWB_StartNum:L_UWB_EndNum,3:n);

%原始数据 整秒内 Hz 对齐
TNumber = 1; TSecond = 0;
Temp_UWB_L(1,3:4) = Temp_UWB_L(1,1:2);
Temp_UWB_L(1,5) = Temp_UWB_L(1,3) + Temp_UWB_L(1,4)/1000.0;
TTimeStart = Temp_UWB_L(1,1);
TMSFirst = Temp_UWB_L(1,2);
for i=2:m1
    if((Temp_UWB_L(i,2)-Temp_UWB_L(i-1,2)) < -500) && (TNumber > 90)
        % 新 秒 的开始
        TSecond = TSecond + 1;
        TNumber = 0;
        TMSFirst = Temp_UWB_L(i,2);
    end
    Temp_UWB_L(i,3) = TTimeStart + TSecond;
    Temp_UWB_L(i,4) = TMSFirst + TNumber*DTime;
    Temp_UWB_L(i,5) = Temp_UWB_L(i,3) + Temp_UWB_L(i,4)/1000.0;    
    TNumber = TNumber + 1;
end

%按照 采样频率对齐 获取插值整理后的新数据
m2 = (GPS_Time_End-GPS_Time_Start+1)*(1000/DTime);
Data_UWB_L = zeros(m2,2);    %UWB测距 整理后的数据 时间1 距离1
TempJ = 1;  Fj = 1; Sj = 1;
for i=1:m2
    %设定时间
    Data_UWB_L(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    %按照时间进行插值 找寻前后最近的时间点
    for j = TempJ:m1
        if(Temp_UWB_L(j,5) == Data_UWB_L(i,1))
            Data_UWB_L(i,2) = Temp_UWB_L(j,7);
            TempJ = j;
            break;
        end
        if(Temp_UWB_L(j,5) < Data_UWB_L(i,1))
            Fj = j;
        end
        if(Temp_UWB_L(j,5) > Data_UWB_L(i,1))
            Sj = j;
            X1 = Temp_UWB_L(Fj,5);
            X2 = Temp_UWB_L(Sj,5);
            Data_UWB_L(i,2) = Leo_InsertData(X1,Temp_UWB_L(Fj,7),X2,Temp_UWB_L(Sj,7),Data_UWB_L(i,1));
            TempJ = j;
            break;
        end
    end
end
%绘制插值后的L-UWB数据
figure;plot(Temp_UWB_L(:,5),Temp_UWB_L(:,7));
hold on;plot(Data_UWB_L(:,1),Data_UWB_L(:,2),'r');
title('L-UWB测距 插值后 红色');
clear L_UWB_StartNum L_UWB_EndNum m1 m2 n TNumber TSecond i j Temp_UWB_L;
clear Fj Sj X1 X2 TempJ TMSFirst  TTimeStart;



