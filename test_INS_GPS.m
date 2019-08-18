%==========================================================================
% INS-GPS��ϵ�������
%       The navigation coordinate system is n coordinate����E N U
%       the body coordinate system is b coordinate����R F U
% �������ݸ�ʽ��
%       IMUData: ��ŵ���ԭʼIMU���ݣ����ݸ�ʽΪ��������������ʽ��
%               ʱ��(s,��ȷ��ms) ����(���ٶ� rd/s) �Ӽ�(���ٶ� m/s2)
%       GPSData�����ԭʼGPS���ݣ����ݸ�ʽΪ:
%               ʱ��(s,��ȷ��ms) γ�ȡ����ȡ��߳�(rd m) 
%
%�������ݸ�ʽ��
%       avp0����ʼ��Ϣ��Ŀǰ�������Զ�׼��ֱ���趨��ʼ��Ϣ�����ݸ�ʽΪ��(ʵ�ʶ�����άʸ��)
%               ��̬ pitch roll yaw(rd),�ٶ� V_E,V_N,V_U(m/s2),λ�� Lat,Lon,H(rd m)
%      
%       INSData_now: ��ǰʱ�̵Ĺߵ���Ϣ���ݣ�����.....�� INS_DataIinitial
%       INSData_pre:
%
%       KF: Kalman�˲���������в�������ÿ���������ڸ��µ�����
%
%��������
%       avp�� ��������ţ���ʽͬavp0
%       XkPk��KF�˲����м����� 15ά״̬ �Ͷ�Ӧ�ķ�����Ϣ �� ʱ��
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 1/1/2019
%==========================================================================

%% ========================== һ������Ԥ���� ========================
clear variables;
global G_CONST                                          %macro definition
    G_CONST = Initial_CONST();

load('E:\n_WorkSpace\Matlab\0_Data\INSGPS���ʹ������\INS_GPS');
IMUData = imudata(:,:);                         %ѡȡ��GPS����ʼ��
GPSData(:,1) = GNSS(:,1);
GPSData(:,2:3) = GNSS(:,2:3)*G_CONST.D2R;       %��GPSγ�Ⱦ��� ת��Ϊ����
GPSData(:,4) = GNSS(:,4);

GPS_Error(:,1:3) = GNSS(:,5:7);                 %GPS��λ����׼�����:m

%% ========================== ���������趨 ==========================
%1��ϵͳ�����趨
    T = 1/200.0;                                %�������ʱ�䣬IMU����Ƶ��    
%2��IMU�������趨 
    %����������
    %IMU_ErrorInitial(gbias,gbias_std,gbias_CorTime,garw,fbias,fbias_std,fbias_CorTime,fvrw)
    %��λ deg/h	deg/h	h  deg/sqrt(h)	mGal   mGal  h   m/s/sqrt(h)	
    IMU_Error = IMU_ErrorInitial(0.01,0.005,4,0.0022,10,25,4,0.00075);    
%3��IMU��������λ��׼�� 
    IMU_Error = IMU_ChangeErrorUnit(IMU_Error);    
%4���趨���㲽��
    NUM_IMU = size(IMUData,1);
    NUM_GPS = fix(NUM_IMU * T);    
%5����ֵ�趨��Ŀǰ�����ǳ�ʼ��׼��ֱ���趨��ֵ
    att0 = [0.5*G_CONST.D2R;0.5*G_CONST.D2R;-3.1259987];
    att0_Erro = [0.5*G_CONST.D2R;0.5*G_CONST.D2R;1*G_CONST.D2R];
    vel0 = [0.1;0.1;0.1];
    vel0_Erro = [0.1;0.1;0.1];
    pos0 = [0.530699173342059;1.994351183398699;15.359326045134754];
    pos0_Erro = [5/6378137;5/6378137/cos(0.530699173342059);5];
    avp0 = [att0;vel0;pos0];
    avp0_Error = [att0_Erro;vel0_Erro;pos0_Erro];  
%6����ʼ��ǰһʱ�̺͵�ǰʱ�̵�INS��Ϣ���ݽṹ��
    INSData_now = INS_DataIinitial(pos0,vel0,att0,0); 
    INSData_now.w_ib_b = IMUData(1,2:4)';             
    INSData_now.f_ib_b = IMUData(1,5:7)';            
    INSData_now.time = IMUData(1,1);
    INSData_now.ts = T;               %��е���Ž�������
    INSData_now.IMUError = IMU_Error;
    INSData_pre = INSData_now;
%7����ʼ��Kalman�˲���Ϣ�ṹ��        
    KF = KF_Initial(15,3);    
    KF.Xk = zeros(15,1);            %X0 = 0;
    KF.Pk = diag([avp0_Error;IMU_Error.gyr_bias;IMU_Error.acc_bias]*10)^2;     %X0 ��Ӧ�� P0    
%     KF.Qt = diag([zeros(9,1);IMU_Error.gyr_noise_arw;IMU_Error.acc_noise_vrw])^2;       %������������ �Ӽ� ������߲���
    KF.Qt = diag([IMU_Error.gyr_noise_arw;IMU_Error.acc_noise_vrw;zeros(9,1)])^2;
    KF.Qk = T.* KF.Qt; 
    KF.Hk = [zeros(3,6), eye(3), zeros(3,6)];   %����λ�÷���
    KF.Rk = diag(pos0_Erro)^2;
    KF    = KF_UpdateFt(KF,INSData_pre);
%8�������������    
    avp_Leo = zeros(NUM_IMU,10);    % a v p �� time
    xkpk_Leo = zeros(NUM_GPS,31);   %Xk Pk �� time      
    bias_Leo = zeros(NUM_GPS,7);   %������ƫ �Ӽ���ƫ �� time  
    
%% =========================== ����ѭ������ =========================    
profile on
%1��ѭ������
    NUM_GNSS = 1;       %��ʱ����������GPS����ѭ��
    for i=1:NUM_IMU
        %��ȡ����������
        INSData_now.time = IMUData(i,1);
        INSData_now.w_ib_b = IMUData(i,2:4)';
        INSData_now.f_ib_b = IMUData(i,5:7)';
        
        %�ߵ������ȡ���
        INSData_now = INS_Update(INSData_pre,INSData_now,T);
        
        %�ж��Ƿ���� ����˲�
        tmp_time = abs(IMUData(i,1)-GPSData(NUM_GNSS,1));
        if( tmp_time > 0.004)
            %����ʱ����� ������״̬ת�ƾ����һ��Ԥ�ⷽ�����
            KF  = KF_UpdateTime(KF,INSData_now);
            
        else
            %����ʱ����º�������� 
            KF.Zk = INSData_now.pos - GPSData(NUM_GNSS,2:4)';  
            %����ʹ��GNSS�����Դ���λ�þ�����Ϣ
            PosError = [GNSS(NUM_GNSS,5)/6378137;GNSS(NUM_GNSS,6)/6378137/cos(0.530699173342059);GNSS(NUM_GNSS,7)];
            KF.Rk = diag(PosError)^2;            
            KF  = KF_UpdateMeasure(KF,INSData_now);
            %���˲��Ľ�� ���з���������
            xkpk_Leo(NUM_GNSS,1:15) = KF.Xk';
            xkpk_Leo(NUM_GNSS,16:30) = diag(KF.Pk)';
            xkpk_Leo(NUM_GNSS,31) = GPSData(NUM_GNSS,1);   
            [KF,INSData_now] = KF_FeedBack(KF,INSData_now,1.0);   
            bias_Leo(NUM_GNSS,1:3) = INSData_now.IMUError.gyr_bias';
            bias_Leo(NUM_GNSS,4:6) = INSData_now.IMUError.acc_bias';
            bias_Leo(NUM_GNSS,7) = GPSData(NUM_GNSS,1); 
            NUM_GNSS = NUM_GNSS +1;
        end       
        
        %�����ս������
        avp_Leo(i,1:3) = INSData_now.att';
        avp_Leo(i,4:6) = INSData_now.vel';
        avp_Leo(i,7:9) = INSData_now.pos';
        avp_Leo(i,10) = INSData_now.time;
        %������ǰ����������Ϣ��������һ������ѭ��
        INSData_pre =  INSData_now;  
    end
profile viewer    
    

Plot_avp(avp_Leo);
%  Plot_avp_Compare(avp,avp_Leo);
% Plot_xkpk_compare(xkpk,xkpk_Leo);
% Plot_bias_compare(bias,bias_Leo);

    