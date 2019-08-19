%==========================================================================
%�㲿���� ADIS16475
%   ���ݾ���Ԥ����󣬽��йߵ�����
%       ��������nϵ��������
%       ��������bϵ��ǰ����(���û���⣬�ҽŵ�x y������ ȡ��)
%==========================================================================
clear variables;

%% 0.����׼��
load('F:\2_��ʿ����_JG\2_ʵ���¼\20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��\1_��һ��Ԥ����\20190421-2_��һ��');

% IMU����  �Ӽ�(m/s2) ����(����/s)
    % ������������������Ŀǰû�ã����濼�����    
    IMU_Error_L = IMU_ErrorInitial(0.0,0.0,0,0.0,0,0,0,0.0);    
    IMU_Error_L = IMU_ChangeErrorUnit(IMU_Error_L);  
    IMU_Error_R = IMU_Error_L;
    
% ȫ�ֱ�������������
global G_CONST                                          %ȫ�ֱ�������
    G_CONST = Initial_CONST();
    T = 1.0/200;                                        %����Ƶ��200Hz

% ��ʼ��λ��[���� γ�� �߳�](����)����̬(����)���ٶ�(m/s2)
    %������ע�⣬Ϊ�˺ͺ������һֱ�������γ����ǰ�棬��һ��� ���� γ��д����һ��
    Pos_L_Start = [40.009340775*pi/180;116.322858775*pi/180;39.09];
    %��̬��˳���� ���� ��� ����
    Att_L_Start = [-11.973*pi/180;-9.828*pi/180;89*pi/180];
    Att_R_Start = [-16.861*pi/180;6.459*pi/180;89*pi/180];
    %�ٶȳ�ʼֵ
    Vel_L_Start = [0;0;0];
    Vel_R_Start = [0;0;0];
    
%% 1.���ߵ��������ݴ���
% 1.1 Ԥ�������ݴ�ſռ�
    %�������
    Num_IMUData = length(Data_IMU_R);       %���ݸ���
    Result_L_Pure = zeros(Num_IMUData,10);  %������ ʱ�� ��̬ �ٶ� λ��
    Result_R_Pure = zeros(Num_IMUData,10);

%1.2 ������ʼλ��  ѡ��GPS���ݵ� 
    %Latitude, longitude, and elevation ��unit is rd m
    pos0(1,1) = mean(Origion_GPS_L(50:70,4))*pi/180.0;
    pos0(2,1) = mean(Origion_GPS_L(50:70,3))*pi/180.0;
    pos0(3,1) = mean(Origion_GPS_L(50:70,5));
    vel0   = [0.0;0.0;0.0];          %unit��m/s2    
%     att0   = [0.0;0.0;-3.126];       %unit��rd
    att0   = [0.0;0.0;0.0]; 
    time0  = Data_IMU_R(1,1);
    
%2. �������ݽṹ������
    INSData_now = INS_DataIinitial(pos0,vel0,att0,0); 
    INSData_now.w_ib_b = Data_IMU_R(1,5:7)';    
    
%     INSData_now.w_ib_b(1,1)=0; INSData_now.w_ib_b(2,1)=0;
    INSData_now.w_ib_b(3,1)=INSData_now.w_ib_b(3,1)+0.002512385095784;
    INSData_now.f_ib_b = Data_IMU_R(1,2:4)';            
    INSData_now.time = Data_IMU_R(1,1);
    INSData_now.ts = T;               %��е���Ž�������
    INSData_now.IMUError = IMU_Error_L;
    INSData_pre = INSData_now;    
    
%3. %Circulation processing   Receiving new sensor data   
%     avp_Leo = zeros(Num_IMUData,10);
%     DeltaV_n_Leo = zeros(Num_IMUData,4);
    for i=1:Num_IMUData
    %IMUData =                                                      %new sensor data   
%     imudata_new = imu_compensation(IMUData,CONFIG_IMUerror);        %Error compensation
    INSData_now.w_ib_b = Data_IMU_R(i,5:7)';           
%     INSData_now.w_ib_b(1,1)=0; INSData_now.w_ib_b(2,1)=0;
%     INSData_now.w_ib_b(3,1)=INSData_now.w_ib_b(3,1)+0.002512385095784;
    INSData_now.f_ib_b = Data_IMU_R(i,2:4)';            
    INSData_now.time = Data_IMU_R(i,1);
    
	%Calculate the inertial navigation solution at the current moment
    INSData_now = ins_update(INSData_pre,INSData_now,T);
    %Calculate the inertial navigation solution at the current moment
    %without compansation
    %INSData_now = ins_update_nocompansation(INSData_pre,INSData_now,T);
     
    %Save the calculation results
    avp_L(i,1:3) = INSData_now.att';
    avp_L(i,4:6) = INSData_now.vel';
    avp_L(i,7:9) = INSData_now.pos';
    avp_L(i,10) = INSData_now.time;
%     DeltaV_n_Leo(i,1:3) = INSData_now.DeltaV_n';
%     DeltaV_n_Leo(i,4) = INSData_now.time;
    %save the result to predata
    INSData_pre =  INSData_now;
    end


