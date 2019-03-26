%avp        YGM calculate      四子样
%avp_Leo    MySelf calculate    二子样
RD2DEG = 180.0/pi;
avp_t = avp(:,10);
avp_Leo_t = avp_Leo(:,10);
% avp_WD_t = NavData(:,1);


for i=1:length(avp_Leo)
    avp_Leo(i,3) = avp_Leo(i,3)*(-1);
    if avp_Leo(i,3) < 0.0
        avp_Leo(i,3) = avp_Leo(i,3)+2*pi;
    end
end
for i=1:length(avp)
    avp(i,3) = avp(i,3)*(-1);
    if avp(i,3) < 0.0
        avp(i,3) = avp(i,3)+2*pi;
    end
end

%% att compare
%pitch
    figure; 
    plot(avp_t,avp(:,1)*RD2DEG,'r');               
    hold on;
%     plot(avp_WD_t,NavData(:,9)*RD2DEG,'g');
%     hold on;
    plot(avp_Leo_t,avp_Leo(:,1)*RD2DEG);       
    xlabel('/s'),ylabel('pitch/deg');
    title("atitude");

%roll
    figure; 
    plot(avp_t,avp(:,2)*RD2DEG,'r');               
    hold on;
%     plot(avp_WD_t,NavData(:,8)*RD2DEG,'g');
%     hold on;
    plot(avp_Leo_t,avp_Leo(:,2)*RD2DEG);       
    xlabel('/s'),ylabel('Roll/deg');
    title("atitude");
%yaw
    figure; 
    plot(avp_t,avp(:,3)*RD2DEG,'r');               
    hold on;
%     plot(avp_WD_t,NavData(:,10)*RD2DEG,'g');
%     hold on;
    plot(avp_Leo_t,avp_Leo(:,3)*RD2DEG);       
    xlabel('/s'),ylabel('Yaw/deg');
    title("atitude");
    
%% vel compare
%Vel_E
    figure; 
    plot(avp_t,avp(:,4),'r');               
    hold on;
    plot(avp_Leo_t,avp_Leo(:,4));       
    xlabel('/s'),ylabel('Vel_E/ m/s');
    title("Velocity");
%Vel_N
    figure; 
    plot(avp_t,avp(:,5),'r');               
    hold on;
    plot(avp_Leo_t,avp_Leo(:,5));       
    xlabel('/s'),ylabel('Vel_N/ m/s');
    title("Velocity");
%Vel_U
    figure; 
    plot(avp_t,avp(:,6),'r');               
    hold on;
    plot(avp_Leo_t,avp_Leo(:,6));       
    xlabel('/s'),ylabel('Vel_U/ m/s');
    title("Velocity");    

%% pos compare
%lat 
    figure; 
    plot(avp_t,avp(:,7),'r');               
    hold on;
    plot(avp_Leo_t,avp_Leo(:,7));       
    xlabel('/s'),ylabel('lat/ deg');
    title("Positon");
%lon
    figure; 
    plot(avp_t,avp(:,8),'r');               
    hold on;
    plot(avp_Leo_t,avp_Leo(:,8));       
    xlabel('/s'),ylabel('lon/ deg');
    title("Positon");
%high
    figure; 
    plot(avp_t,avp(:,9),'r');               
    hold on;
    plot(avp_Leo_t,avp_Leo(:,9));       
    xlabel('/s'),ylabel('H/ m/s');
    title("Positon");       
    
    figure;
    plot(NavData(1:73500,3),NavData(1:73500,2));
    
    
    plot(avp_Leo(:,9) -avp(:,9) )