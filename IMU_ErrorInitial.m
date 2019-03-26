% function IMU_Error = IMU_ErrorInitial(gbias,gbias_std,gbias_CorTime,gscal,gscal_std,gscal_CorTime,garw,fbias,fbias_std,fbias_CorTime,fscal,fscal_std,fscal_CorTime,fvrw)
function IMU_Error = IMU_ErrorInitial(gbias,gbias_std,gbias_CorTime,garw,fbias,fbias_std,fbias_CorTime,fvrw)
%声明 IMU_Error 的信息结构体  
%   注意： 1）暂时不考虑 非线性因素的影响！！！！！！！！！
%          2）目前考虑假设所有xyz的器件性能一样！
% Inputs:   
%         % deg/h	Gyro initial bias 
%         % deg/h	the std of gyro biase with the first order markoff process
%         % h       The relevant time
%         % deg/sqrt(h)	random walk  I didn't quite understand the final unit definition

%         % mGal    acc initial bias   
%         % mGal    the std of acc biase with the first order markoff process
%         % h       The relevant time
%         % m/s/sqrt(h)	velocity random walk  I didn't quite understand the final unit definition
  
% Output:   IMU_Error         
%
% Copyright(c) 2018, by Chengbin Wang, All rights reserved.
% Department of Precision Instrument Engineering Research Center for 
% Navigation Technology,Tsinghua University,Bei Jing, P.R.China
% 2/1/2019

%% 简单认为三轴器件性能一样
    IMU_Error.gyr_bias = [gbias;gbias;gbias];
    IMU_Error.gyr_bias_std = [gbias_std;gbias_std;gbias_std];
    IMU_Error.gyr_bias_CorTime = [gbias_CorTime;gbias_CorTime;gbias_CorTime];
    IMU_Error.gyr_noise_arw = [garw;garw;garw];       

    IMU_Error.acc_bias = [fbias;fbias;fbias];
    IMU_Error.acc_bias_std = [fbias_std;fbias_std;fbias_std];
    IMU_Error.acc_bias_CorTime = [fbias_CorTime;fbias_CorTime;fbias_CorTime];
    IMU_Error.acc_noise_vrw = [fvrw;fvrw;fvrw];  

%% 考虑三轴器件性能不一样
%{
    % deg/h	Gyro initial bias      
    IMU_Error.gyr_bias = [0.0;0.0;0.0];
    %deg/h	the std of gyro biase with the first order markoff process
    IMU_Error.gyr_bias_std = [gbias_std;gbias_std;gbias_std];
    % h	The relevant time
    IMU_Error.gyr_bias_CorTime = [4.0;4.0;4.0];
    % ppm	Gyro scale factor error
    IMU_Error.gyr_scal = [0.0;0.0;0.0];
    % ppm	the std of gyro scale factor error with the first order markoff process
    IMU_Error.gyr_scal_std = [0.0;0.0;0.0];
    % h	The relevant time
    IMU_Error.gyr_scale_CorTime = [4.0;4.0;4.0];
    % deg/sqrt(h)	random walk  I didn't quite understand the final unit definition
    IMU_Error.gyr_noise_arw = [0.0;0.0;0.0];       
    %加计误差参数
    % mGal	acc initial bias   
    IMU_Error.acc_bias = [0.0;0.0;0.0];
    % mGal = [0.0;0.0;0.0];the std of acc biase with the first order markoff process
    IMU_Error.acc_bias_std = [0.0;0.0;0.0];
    % h	The relevant time
    IMU_Error.acc_bias_CorTime = [4.0;4.0;4.0];
    % ppm	acc scale factor error
    IMU_Error.acc_scal = [0.0;0.0;0.0];
    % ppm	the std of acc scale factor error with the first order markoff process
    IMU_Error.acc_scal_std = [0.0;0.0;0.0];
    % h	The relevant time
    IMU_Error.acc_scale_CorTime = [4.0;4.0;4.0];
    % m/s/sqrt(h)	velocity random walk  I didn't quite understand the final unit definition
    IMU_Error.acc_noise_vrw = [0.0;0.0;0.0];   
%}





