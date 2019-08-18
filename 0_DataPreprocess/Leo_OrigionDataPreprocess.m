clear all;
%ԭʼ����Ԥ����
Number = '1';   %����� x ������
%------------------------------------------------------------------------
% 1. ��ȡtxt�ļ�
%------------------------------------------------------------------------
Filename_L_GPS = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\L_IMUGPS',Number,'_GPS.txt');
Origion_GPS_L = importdata(Filename_L_GPS);
clear Filename_L_GPS;

Filename_L_Foot = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\L_IMUGPS',Number,'_FootPressure.txt');
Origion_Foot_L = importdata(Filename_L_Foot);
clear Filename_L_Foot;

Filename_L_IMUB = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\L_IMUGPS',Number,'_IMU_B.txt');
Origion_IMUB_L = importdata(Filename_L_IMUB);
clear Filename_L_IMUB;

Filename_L_UWB = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\L_IMUGPS',Number,'_UWB.txt');
Origion_UWB_L = importdata(Filename_L_UWB);
clear Filename_L_UWB;

Filename_R_GPS = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\R_IMUGPS',Number,'_GPS.txt');
Origion_GPS_R = importdata(Filename_R_GPS);
clear Filename_R_GPS;

Filename_R_Foot = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\R_IMUGPS',Number,'_FootPressure.txt');
Origion_Foot_R = importdata(Filename_R_Foot);
clear Filename_R_Foot;

Filename_R_IMB = strcat('E:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\ԭʼ����\R_IMUGPS',Number,'_IMU_B.txt');
Origion_IMUB_R = importdata(Filename_R_IMB);
clear Filename_R_IMB;

%-------------------------------------------------------------------------
% 2. ��ADIS���ݽ���Ԥ���� 
%    ���а���Foot�����ݣ���ΪFoot��IMUB��ͬʱ�ɼ��ģ�ʱ��һ��
%-------------------------------------------------------------------------
% �鿴ADIS�ɼ��Ƿ�©�������ADIS©������ζ�� FootҲ©����
[m,n] = size(Origion_IMUB_L);
Temp_ADIS_L = zeros(m-1,1);
for i=1:m-1
    Temp_ADIS_L(i,1) = Origion_IMUB_L(i+1,10)-Origion_IMUB_L(i,10);
    if Temp_ADIS_L(i,1) < 0
        Temp_ADIS_L(i,1) = Temp_ADIS_L(i,1) + 65536;
    end
end
figure;plot(Temp_ADIS_L);title('L-ADIS-IMU-����©��(>1Ϊ©��)');
clear Temp_ADIS_L m n i;

[m,n] = size(Origion_IMUB_R);
Temp_ADIS_R = zeros(m-1,1);
for i=1:m-1
    Temp_ADIS_R(i,1) = Origion_IMUB_R(i+1,10)-Origion_IMUB_R(i,10);
    if Temp_ADIS_R(i,1) < 0
        Temp_ADIS_R(i,1) = Temp_ADIS_R(i,1) + 65536;
    end
end
figure;plot(Temp_ADIS_R);title('R-ADIS-IMU-����©��(>1Ϊ©��)');
clear Temp_ADIS_R m n i;

%------------------------------------------
% 2.1 ������©���� �Ƚ��в�ֵ��������(FootҲ��Ҫ����)
%------------------------------------------


%------------------------------------------
% 2.2 �����趨��ʱ��Σ������� IMU���ݽ��н�ȡ ����
%------------------------------------------
GPS_Time_Start = 9107;      GPS_Time_End = 9475; 
L_IMUB_StartNum = 21070;     L_IMUB_EndNum = 94916; 
DTime = 5;     %������� ms 200Hz
%������ʱ����
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
%ԭʼ���� ������ Hz ����
TNumber = 1; TSecond = 0;
Temp_L_IMUB(1,3:4) = Temp_L_IMUB(1,1:2);
Temp_L_IMUB(1,5) = Temp_L_IMUB(1,3) + Temp_L_IMUB(1,4)/1000.0;
Temp_L_Foot(1,3:4) = Temp_L_Foot(1,1:2);
Temp_L_Foot(1,5) = Temp_L_Foot(1,3) + Temp_L_Foot(1,4)/1000.0;
TMSFirst = Temp_L_IMUB(1,2);
TTimeStart = Temp_L_IMUB(1,1);
for i=2:m1
    if((Temp_L_IMUB(i,2)-Temp_L_IMUB(i-1,2)) < -500) && (TNumber > 190)
        % �� �� �Ŀ�ʼ
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
%���� ����Ƶ�ʶ��� ��ȡ��ֵ������������
m2 = (GPS_Time_End-GPS_Time_Start+1)*(1000/DTime);
Data_IMU_L = zeros(m2,8);    %ADIS ���������� ʱ��1 �Ӽ�3 ����3 �¶�1
Data_Foot_L = zeros(m2,5);   %ѹ������������ ʱ��1 ѹ��4
TempJ = 1;  Fj = 1; Sj = 1;
for i=1:m2
    %�趨ʱ��
    Data_IMU_L(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    Data_Foot_L(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    %����ʱ����в�ֵ ��Ѱǰ�������ʱ���
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
%���Ʋ�ֵ���L-IMUB����
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,6));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,2),'r');
title('L-IMUB���ٶȼ�X�� ��ֵ�� ��ɫ');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,7));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,3),'r');
title('L-IMUB���ٶȼ�Y�� ��ֵ�� ��ɫ');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,8));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,4),'r');
title('L-IMUB���ٶȼ�Z�� ��ֵ�� ��ɫ');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,9));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,5),'r');
title('L-IMUB����X�� ��ֵ�� ��ɫ');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,10));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,6),'r');
title('L-IMUB����Y�� ��ֵ�� ��ɫ');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,11));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,7),'r');
title('L-IMUB����Z�� ��ֵ�� ��ɫ');
figure;plot(Temp_L_IMUB(:,5),Temp_L_IMUB(:,12));
hold on;plot(Data_IMU_L(:,1),Data_IMU_L(:,8),'r');
title('L-IMUB�¶� ��ֵ�� ��ɫ');

%���Ʋ�ֵ���L-Foot����
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,6));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,2),'r');
title('L-Foot��1 ��ֵ�� ��ɫ');
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,7));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,3),'r');
title('L-Foot��2 ��ֵ�� ��ɫ');
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,8));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,4),'r');
title('L-Foot��3 ��ֵ�� ��ɫ');
figure;plot(Temp_L_Foot(:,5),Temp_L_Foot(:,9));
hold on;plot(Data_Foot_L(:,1),Data_Foot_L(:,5),'r');
title('L-Foot��4 ��ֵ�� ��ɫ');

clear L_IMUB_StartNum L_IMUB_EndNum m1 m2 n TNumber TSecond i j Temp_L_IMUB;
clear Fj Sj X1 X2 TempJ TMSFirst Temp_L_Foot;

%------------------------------------------
% 2.3 �����趨��ʱ��Σ������� IMU���ݽ��н�ȡ ����
%     ���㴫���� �ľ����е����⣬��ʱ��׼ Ԥ����� ���㲻һ��
%------------------------------------------
R_IMUB_StartNum = 19940;     R_IMUB_EndNum = 93709;
%������ʱ����
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
%ԭʼ���� ������ Hz ����
TNumber = 1; TSecond = 0;
Temp_R_IMUB(1,3:4) = Temp_R_IMUB(1,1:2);
Temp_R_IMUB(1,5) = Temp_R_IMUB(1,3) + Temp_R_IMUB(1,4)/1000.0;
Temp_R_Foot(1,3:4) = Temp_R_Foot(1,1:2);
Temp_R_Foot(1,5) = Temp_R_Foot(1,3) + Temp_R_Foot(1,4)/1000.0;
TMSFirst = Temp_R_IMUB(1,2);
TTimeStart = Temp_R_IMUB(1,1);
for i=2:m1
    if (((Temp_R_IMUB(i,2)-Temp_R_IMUB(i-1,2)) < 0) && ((Temp_R_IMUB(i,2)-Temp_R_IMUB(i-1,2)) > -500) )
        % �� �� �Ŀ�ʼ
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

%���� ����Ƶ�ʶ��� ��ȡ��ֵ������������
m2 = (GPS_Time_End-GPS_Time_Start+1)*(1000/DTime);
Data_IMU_R = zeros(m2,8);    %ADIS ���������� ʱ��1 �Ӽ�3 ����3 �¶�1
Data_Foot_R = zeros(m2,5);   %ѹ������������ ʱ��1 ѹ��4
TempJ = 1;  Fj = 1; Sj = 1;
for i=1:m2
    %�趨ʱ��
    Data_IMU_R(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    Data_Foot_R(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    %����ʱ����в�ֵ ��Ѱǰ�������ʱ���
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
%���Ʋ�ֵ���L-IMUB����
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,6));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,2),'r');
title('R-IMUB���ٶȼ�X�� ��ֵ�� ��ɫ');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,7));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,3),'r');
title('R-IMUB���ٶȼ�Y�� ��ֵ�� ��ɫ');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,8));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,4),'r');
title('R-IMUB���ٶȼ�Z�� ��ֵ�� ��ɫ');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,9));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,5),'r');
title('R-IMUB����X�� ��ֵ�� ��ɫ');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,10));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,6),'r');
title('R-IMUB����Y�� ��ֵ�� ��ɫ');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,11));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,7),'r');
title('R-IMUB����Z�� ��ֵ�� ��ɫ');
figure;plot(Temp_R_IMUB(:,5),Temp_R_IMUB(:,12));
hold on;plot(Data_IMU_R(:,1),Data_IMU_R(:,8),'r');
title('R-IMUB�¶� ��ֵ�� ��ɫ');

%���Ʋ�ֵ���R-Foot����
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,6));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,2),'r');
title('R-Foot��1 ��ֵ�� ��ɫ');
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,7));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,3),'r');
title('R-Foot��2 ��ֵ�� ��ɫ');
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,8));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,4),'r');
title('R-Foot��3 ��ֵ�� ��ɫ');
figure;plot(Temp_R_Foot(:,5),Temp_R_Foot(:,9));
hold on;plot(Data_Foot_R(:,1),Data_Foot_R(:,5),'r');
title('R-Foot��4 ��ֵ�� ��ɫ');

clear R_IMUB_StartNum R_IMUB_EndNum m1 m2 n TNumber TSecond i j Temp_R_IMUB;
clear Fj Sj X1 X2 TempJ TMSFirst Temp_R_Foot TTimeStart;

%-------------------------------------------------------------------------
% 3. �� UWB ���ݽ���Ԥ����
%-------------------------------------------------------------------------
%------------------------------------------
% 3.1 ����Ƿ���©���� 
%------------------------------------------
[m,n] = size(Origion_UWB_L);
Temp_UWB_L = zeros(m-1,1);
for i=1:m-1
    Temp_UWB_L(i,1) = Origion_UWB_L(i+1,3)-Origion_UWB_L(i,3);
    if Temp_UWB_L(i,1) < 0
        Temp_UWB_L(i,1) = Temp_UWB_L(i,1) + 256;
    end
end
figure;plot(Temp_UWB_L);title('L-UWB-����©��(>1Ϊ©��)');
clear Temp_UWB_L m n i;

%------------------------------------------
% 3.2 UWB���ݽ��в��� 
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

% �鿴 �²����UWB���ݰ��Ƿ�©��
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
% 3.3 �������UWB���� ����ʱ���׼��ֵ 
%------------------------------------------
L_UWB_StartNum = 9873;     L_UWB_EndNum = 46900;
%������ʱ����
DTime = 10;     %������� 10ms  100Hz
[m1,n] = size(Origion_UWB_L_Insert);
m1 = L_UWB_EndNum - L_UWB_StartNum + 1;
Temp_UWB_L = zeros(m1,n+3);
Temp_UWB_L(:,1:2) = Origion_UWB_L_Insert(L_UWB_StartNum:L_UWB_EndNum,1:2);
Temp_UWB_L(:,6:n+3) = Origion_UWB_L_Insert(L_UWB_StartNum:L_UWB_EndNum,3:n);

%ԭʼ���� ������ Hz ����
TNumber = 1; TSecond = 0;
Temp_UWB_L(1,3:4) = Temp_UWB_L(1,1:2);
Temp_UWB_L(1,5) = Temp_UWB_L(1,3) + Temp_UWB_L(1,4)/1000.0;
TTimeStart = Temp_UWB_L(1,1);
TMSFirst = Temp_UWB_L(1,2);
for i=2:m1
    if((Temp_UWB_L(i,2)-Temp_UWB_L(i-1,2)) < -500) && (TNumber > 90)
        % �� �� �Ŀ�ʼ
        TSecond = TSecond + 1;
        TNumber = 0;
        TMSFirst = Temp_UWB_L(i,2);
    end
    Temp_UWB_L(i,3) = TTimeStart + TSecond;
    Temp_UWB_L(i,4) = TMSFirst + TNumber*DTime;
    Temp_UWB_L(i,5) = Temp_UWB_L(i,3) + Temp_UWB_L(i,4)/1000.0;    
    TNumber = TNumber + 1;
end

%���� ����Ƶ�ʶ��� ��ȡ��ֵ������������
m2 = (GPS_Time_End-GPS_Time_Start+1)*(1000/DTime);
Data_UWB_L = zeros(m2,2);    %UWB��� ���������� ʱ��1 ����1
TempJ = 1;  Fj = 1; Sj = 1;
for i=1:m2
    %�趨ʱ��
    Data_UWB_L(i,1) = GPS_Time_Start + (i-1)*DTime/1000.0;
    %����ʱ����в�ֵ ��Ѱǰ�������ʱ���
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
%���Ʋ�ֵ���L-UWB����
figure;plot(Temp_UWB_L(:,5),Temp_UWB_L(:,7));
hold on;plot(Data_UWB_L(:,1),Data_UWB_L(:,2),'r');
title('L-UWB��� ��ֵ�� ��ɫ');
clear L_UWB_StartNum L_UWB_EndNum m1 m2 n TNumber TSecond i j Temp_UWB_L;
clear Fj Sj X1 X2 TempJ TMSFirst  TTimeStart;



