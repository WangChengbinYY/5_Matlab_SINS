function insdata_now = INS_Update(insdata_pre,insdata_now,T)
% �����Խ��㣬ʱ�����
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 22/12/2018

%% һ��������Ҫ������ֵ
    %����(m-1/2)ʱ�̵��ٶ�Vn
    temp_Vn_half = insdata_pre.vel+ 0.5*insdata_pre.DeltaV_n;
    %����(m-1/2)ʱ�̵�λ��pos
    temp_DeltaS = (insdata_pre.vel+temp_Vn_half)*T/4.0;
    temp = [temp_DeltaS(2,1)/insdata_pre.Rmh;temp_DeltaS(1,1)/insdata_pre.Rnh/cos(insdata_pre.pos(1,1));temp_DeltaS(3,1)];
    temp_pos_half = insdata_pre.pos+temp;
    %��(m-1/2)ʱ�̵�λ�� �� Rmh��Rnh
    temp_Rmh = earth_get_Rmh(temp_pos_half);
    temp_Rnh = earth_get_Rnh(temp_pos_half);
    %��(m-1/2)ʱ�̵��ٶ�λ�ã���w_ie_n,w_en_n,w_in_n
    temp_w_ie_n = earth_get_w_ie_n(temp_pos_half);
    temp_w_en_n = earth_get_w_en_n(temp_pos_half,temp_Vn_half,temp_Rmh,temp_Rnh);
    temp_w_in_n = temp_w_ie_n+temp_w_en_n;
    %��(m-1/2)ʱ�̵�λ�� �� gn
    temp_gn = earth_get_g_n(temp_pos_half);
    
%% �����������ݺͼӼƵ�����
    %������� ������
    insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T/2;
    %�Ӽ���� �ٶ�����
    insdata_now.DeltaV_ib_b = (insdata_now.f_ib_b+insdata_pre.f_ib_b)*T/2;
%% �����ٶȸ���
    %����(m-1/2)�����ݣ����� DeltaV_cor_n
    temp = 2*temp_w_ie_n;
    temp = temp+temp_w_en_n;
    temp = cross(temp,temp_Vn_half);
    temp = temp_gn-temp;     %����ط�ǣ��gn���������⣡��Ĭ��Ϊ ����������ϵ
    temp_DeltaV_cor_n = T*temp;
    %���� DeltaV_rot_b
    temp_DeltaV_rot_b = 0.5*cross(insdata_now.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
    %���� DeltaV_scul_b
    temp = cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
    temp1 = cross(insdata_pre.DeltaV_ib_b,insdata_now.DeltaTheta_ib_b);
    temp_DeltaV_roll_b = (temp+temp1)/12.0;
    %���� DeltaV_sf_n  �൱��YGM�е� dvbm
    dvbm = insdata_now.DeltaV_ib_b+temp_DeltaV_rot_b+temp_DeltaV_roll_b;
    
        % ��ƫ�������������� 
        %�Լ��ٶȼƽ�����ƫ����    ���⣺Ϊɶ�����ﲹ�������������ʼʹ�ü��ٶȼ����ݵ�ʱ�򲹳���
%         dvbm = dvbm-insdata_now.IMUError.acc_bias*T;
        insdata_now.fb = dvbm/T;
        insdata_now.fn = insdata_pre.C_b_n*insdata_now.fb;
    
    tempM = askew_v2m(temp_w_in_n)*T/2.0;
    tempM = eye(3) - tempM;
    temp_DeltaV_sf_n = tempM*insdata_pre.C_b_n*(dvbm);    
    %���� ��ǰʱ�̵��ٶ�����INSData.DeltaV_n
    insdata_now.DeltaV_n = temp_DeltaV_sf_n + temp_DeltaV_cor_n;
    %���� ��ǰʱ�̵��ٶ�
    insdata_now.vel = insdata_pre.vel + insdata_now.DeltaV_n;
    
    
    insdata_now.DeltaV_n = [0;0;0];    
    insdata_now.vel = [0;0;0];    
    
%% �ġ�λ�ø���
    temp_DeltaS = (insdata_pre.vel+insdata_now.vel)*T/2.0;
    temp = [temp_DeltaS(2,1)/temp_Rmh;temp_DeltaS(1,1)/temp_Rnh/cos(temp_pos_half(1,1));temp_DeltaS(3,1)];
    insdata_now.pos = insdata_pre.pos+temp;
    
%% �塢��̬����    
    %1. ��ȡ ��Ԫ��Q_nm_1_nm
    %�����µ� �ٶ� λ�ã����¼��� w_in_n �������㵱ǰʱ�̵�DeltaTheta_in_n
    temp_pos = [0.698294524225869;2.030216593994910;42.9];
 
    insdata_now.w_ie_n = earth_get_w_ie_n(temp_pos);
    insdata_now.Rmh = earth_get_Rmh(temp_pos);
    insdata_now.Rnh = earth_get_Rnh(temp_pos);
    insdata_now.w_en_n = earth_get_w_en_n(temp_pos,[0;0;0],insdata_now.Rmh,insdata_now.Rnh);  
    
%     insdata_now.w_ie_n = earth_get_w_ie_n(insdata_now.pos);
%     insdata_now.Rmh = earth_get_Rmh(insdata_now.pos);
%     insdata_now.Rnh = earth_get_Rnh(insdata_now.pos);
%     insdata_now.w_en_n = earth_get_w_en_n(insdata_now.pos,insdata_now.vel,insdata_now.Rmh,insdata_now.Rnh);
  
    insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
    insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T/2.0;
    %��DeltaTheta_in_n ���� ��Ӧ����Ԫ��temp_Q_nm_nm_1
    %�����Ӧ����תʸ�� temp_fi_in_n
    temp_fi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
    %�� ��תʸ�� temp_fi_nm_nm_1 ���Ӧ����Ԫ�� temp_Q_nm_nm_1
    temp_Q_nm_nm_1 = change_rv2Q(temp_fi_in_n);
    temp_Q_nm_1_nm = change_Q2conj(temp_Q_nm_nm_1);
    %2. ��ȡ ��Ԫ�� Q_bm_bm_1
    %�����Ӧ����תʸ�� temp_fi_ib_b
    temp_fi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
        
        %����������
        %��������ƫ���в������Ȳ����Ƿ����Ա����������
%         temp_fi_ib_b = temp_fi_ib_b - insdata_now.IMUError.gyr_bias*T;
        
    %�� ��תʸ�� temp_fi_ib_b ���Ӧ����Ԫ�� temp_Q_bm_bm_1
    temp_Q_bm_bm_1 = change_rv2Q(temp_fi_ib_b);
    insdata_now.Q_b_n = calculate_QmulQ(calculate_QmulQ(temp_Q_nm_1_nm,insdata_pre.Q_b_n),temp_Q_bm_bm_1);
    %�� ��Ԫ�� ����Ӧ�� DCM
    insdata_now.C_b_n = change_Q2DCM(insdata_now.Q_b_n);
    %�� DCM ���� ��ǰʱ�̵���̬
    insdata_now.att = change_DCM2euler(insdata_now.C_b_n);


   
    

    
