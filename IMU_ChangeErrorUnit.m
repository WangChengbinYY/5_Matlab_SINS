function ImuError = IMU_ChangeErrorUnit(ImuError)
% The unit conversion of IMU gyro and adding parameters is carried out
% Inputs:   ImuError    Input various parameters
% Output:   imuerror    The parameter after converting the units
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 25/12/2018

%% Unit conversion
% deg/h__rd/s    Gyro initial bias           
ImuError.gyr_bias           = ImuError.gyr_bias * (pi / 180.0 / 3600.0);    
% deg/h__rd/s    the std of gyro biase with the first order markoff process
ImuError.gyr_bias_std       = ImuError.gyr_bias_std * (pi / 180.0 / 3600.0);
% h         The relevant time
ImuError.gyr_bias_CorTime   = ImuError.gyr_bias_CorTime * 3600;     
% ppm       Gyro scale factor error
% ImuError.gyr_scal           = ImuError.gyr_scal * 1.0e-6;    
% % ppm       the std of gyro scale factor error with the first order markoff process
% ImuError.gyr_scal_std       = ImuError.gyr_scal_std * 1.0e-6;   
% % h         The relevant time
% ImuError.gyr_scale_CorTime  = ImuError.gyr_scale_CorTime * 3600;
% deg/s/sqrt(h)__rd/s angle random walk  I didn't quite understand the final unit definition
ImuError.gyr_noise_arw      = ImuError.gyr_noise_arw * (pi / 180.0 / 60.0);               

% mGal__m/s2      acc initial bias   
ImuError.acc_bias           = ImuError.acc_bias * 1.0e-5; 
% mGal__m/s2      the std of acc biase with the first order markoff process
ImuError.acc_bias_std       = ImuError.acc_bias_std * 1.0e-5 ;  
% h         The relevant time
ImuError.acc_bias_CorTime   = ImuError.acc_bias_CorTime * 3600;
% % ppm       acc scale factor error
% ImuError.acc_scal           = ImuError.acc_scal * 1.0e-6;    
% % ppm       the std of acc scale factor error with the first order markoff process
% ImuError.acc_scal_std       = ImuError.acc_scal_std  * 1.0e-6;   
% % h         The relevant time
% ImuError.acc_scale_CorTime  = ImuError.acc_scale_CorTime * 3600;
% m/s/sqrt(h)__m/s2    velocity random walk  I didn't quite understand the final unit definition
ImuError.acc_noise_vrw      = ImuError.acc_noise_vrw / 60.0;            





