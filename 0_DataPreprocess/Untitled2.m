TFoot = zeros(109595,5);
TFoot(:,1) = Origion_Foot_L(:,1) + Origion_Foot_L(:,2)./1000;
TFoot(:,2:5) = Origion_Foot_L(:,2:5);

TIMUX = zeros(109595,2);
TIMUX(:,1) = Origion_IMUB_L(:,1) + Origion_IMUB_L(:,2)./1000;
TIMUX(:,2) = Origion_IMUB_L(:,6);

figure;
plot(TIMUX(40000:60000,1)-0.5,TIMUX(40000:60000,2));
hold on;
plot(TFoot(40000:60000,1),TFoot(40000:60000,4)-700,'r');
hold on;
plot(TFoot(40000:60000,1),TFoot(40000:60000,2)-700,'g');

figure;
plot(Data_IMU_L(:,1),Data_IMU_L(:,5));
hold on;
plot(Data_Foot_L(:,1),Data_Foot_L(:,5)-700,'r');
hold on;
plot(Data_Foot_L(:,1),Data_Foot_L(:,3)-700,'g');

figure;
plot(Data_Foot_L(:,1),Data_Foot_L(:,5)-700);
hold on;
plot(Data_Foot_L(:,1),Data_Foot_L(:,4)-670);
hold on;

figure;
plot(Data_Foot_L(:,1),Data_Foot_L(:,3)-700);
hold on;
plot(Data_Foot_L(:,1),Data_Foot_L(:,2)-670,'r');
hold on;


figure;
plot(Data_Foot_R(:,1),Data_Foot_R(:,5)-700);
hold on;
plot(Data_Foot_R(:,1),Data_Foot_R(:,4)-670);
hold on;

figure;
plot(Data_Foot_R(:,1),Data_Foot_R(:,3)-700);
hold on;
plot(Data_Foot_R(:,1),Data_Foot_R(:,2)-670,'r');
hold on;


figure;
% plot(Data_Foot_L(:,1),Data_Foot_L(:,2)-940,'y');
% hold on;
% plot(Data_Foot_L(:,1),Data_Foot_L(:,3)-940);
% hold on;
plot(Data_Foot_L(:,1),Data_Foot_L(:,4)-940,'g');
hold on;
plot(Data_Foot_L(:,1),Data_Foot_L(:,5)-940,'b');
hold on;
plot(Data_IMU_L(:,1),Data_IMU_L(:,5),'r');
hold on;
plot(Data_UWB_L(:,1),Data_UWB_L(:,2)*400,'r-.');






figure;
plot(Data_Foot_R(:,1),Data_Foot_R(:,2)-940,'y');
hold on;
plot(Data_Foot_R(:,1),Data_Foot_R(:,3)-940);
hold on;
plot(Data_Foot_R(:,1),Data_Foot_R(:,4)-940,'g');
hold on;
plot(Data_Foot_R(:,1),Data_Foot_R(:,5)-940,'b');
hold on;
plot(Data_IMU_R(:,1)+0.05,Data_IMU_R(:,5),'r');



figure;
plot(Origion_Foot_L(:,2)); hold on; plot(Origion_IMUB_L(:,2),'r');


figure;
plot(Origion_Foot_L(:,3)-940,'y');
hold on;
plot(Origion_Foot_L(:,4)-940);
hold on;
plot(Origion_Foot_L(:,5)-940,'g');
hold on;
plot(Origion_Foot_L(:,6)-940,'b');
hold on;
plot(Origion_IMUB_L(:,6),'r');



figure;
plot(Origion_Foot_L(:,3),'y');
hold on;
plot(Origion_Foot_L(:,4));
hold on;
plot(Origion_Foot_L(:,5),'g');
hold on;
plot(Origion_Foot_L(:,6),'b');
hold on;
plot(Origion_IMUB_L(:,5)*100,'r');

