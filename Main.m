%==========================================================================
% Implement inertial navigation and combined navigation algorithm - the main program
%       The navigation coordinate system is n coordinate¡ª¡ªE N U
%       the body coordinate system is b coordinate¡ª¡ªR F U
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 20/12/2018
%==========================================================================
clear all;

%% ===========================Data preload============================
% load gpsdata
%     GPSData = Initial_GPSData();
% load imudata ,imuerror coefficient and unit changeed
    [IMUData,IMUError] = Initial_IMUData();
% Calculate the length of the data
    Num_IMUData = length(IMUData);
%     Num_GPSData = length(GPSData);
    
%% ===========================Global variable definition area========
%------------------------Constant definition area
global G_CONST                                          %macro definition
    G_CONST = const_initial();
%------------------------System setting parameter    
    T = 1.0/200;                                        %200Hz sampling
  
%% ===========================the main processing====================
%1. Set the initial value
    %Latitude, longitude, and elevation £¬unit is rd m
    pos0   = [30.4068572011000*pi/180.0;114.267934323500*pi/180.0;20.3593264287000];
    vel0   = [0.0;0.0;0.0];       %unit£ºm/s2    
    att0   = [0.0;0.0;-3.126];       %unit£ºrd
    time0  = 0.0;
    
%2. Variable declarations
    INSData_pre = INS_DataIinitial(pos0,vel0,att0,time0); 
    INSData_pre.w_ib_b = IMUData(1,2:4)';             
    INSData_pre.f_ib_b = IMUData(1,5:7)';            
    INSData_pre.time = IMUData(1,1);
    INSData_now = INS_DataIinitial(pos0,vel0,att0,time0);

%3. %Circulation processing   Receiving new sensor data   
    avp_Leo = zeros(Num_IMUData,10);
    DeltaV_n_Leo = zeros(Num_IMUData,4);
    for i=1:Num_IMUData
    %IMUData =                                                      %new sensor data   
%     imudata_new = imu_compensation(IMUData,CONFIG_IMUerror);        %Error compensation
    INSData_now.w_ib_b = IMUData(i,2:4)';             
    INSData_now.f_ib_b = IMUData(i,5:7)';            
    INSData_now.time = IMUData(i,1);
    
	%Calculate the inertial navigation solution at the current moment
    INSData_now = INS_Update(INSData_pre,INSData_now,T);
    %Calculate the inertial navigation solution at the current moment
    %without compansation
    %INSData_now = ins_update_nocompansation(INSData_pre,INSData_now,T);
     
    %Save the calculation results
    avp_Leo(i,1:3) = INSData_now.att';
    avp_Leo(i,4:6) = INSData_now.vel';
    avp_Leo(i,7:9) = INSData_now.pos';
    avp_Leo(i,10) = INSData_now.time;
%     DeltaV_n_Leo(i,1:3) = INSData_now.DeltaV_n';
%     DeltaV_n_Leo(i,4) = INSData_now.time;
    %save the result to predata
    INSData_pre =  INSData_now;
    end


