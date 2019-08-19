%==========================================================================
%利用加速度计的信息求取 水平姿态角
%    输入：加速度计X Y Z(m/s2); 纬度(弧度) 高程(m) 
%          当地导航坐标系选择 东北天
%    输出：state  1 静止，数据有效； 0 运动，数据无效。
%         俯仰 横滚(弧度)
%==========================================================================
function [state,pitch,roll] = att_from_acc(acc_x,acc_y,acc_z,lat,high)

%% 1. 利用当地经纬度计算 理论重力加速度 数值
%选用 WGS84地球参数计算
TEarth_G_0 = 9.7803267714;
TEarth_G_n = TEarth_G_0*(1+5.27094e-3*sin(lat)^2+2.32718e-5*sin(lat)^4)-3.086e-6*high; % grs80
TAcc_Mean = sqrt(acc_x^2+acc_y^2+acc_z^2);
if abs(TAcc_Mean - TEarth_G_n) > 0.1
    %从加速度判断处于运动状态
    state = 0;  pitch = 0;  roll = 0;
else
    state = 1;
    %以三轴加速度计输出的矢量和作为 重力理论值进行水平姿态求解
    TG_n = TAcc_Mean;
    % !!! 后面改进，增加错误判断机制
    pitch = asin(acc_y/TG_n);
    roll = -atan(acc_x/acc_z);
end