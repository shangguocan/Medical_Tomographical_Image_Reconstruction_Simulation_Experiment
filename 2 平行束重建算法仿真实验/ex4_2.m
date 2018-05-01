%% 利用解析法使用不同滤波函数进行滤波反投影重建的参考程序%%

%% ======主程序==========%%
clc;
clear all;
close all;
%% =======仿真参数设置================%%
N = 256;                        % 重建图像大小，探测器采样点数也设为N
I = phantom(N);                 % Shepp-Logan头模型
delta = pi/180;                 % 角度增量（弧度）
theta = 0:1:179;                % 投影角度
theta_num = length(theta);
d = 1;                          % 平移步长
%% ========产生投影数据===============%%
P = radon(I, theta);                 % radon变换
[mm, nn] = size(P);                  % 计算投影数据矩阵的行、列长度
e = floor((mm - N -1)/2 + 1) + 1;    % 投影数据的默认投影中心为floor((size(I) + 1)/2)
P = P(e: N + e - 1, :);              % 截取中心N点数据，因投影数据较多，含无用数据
P1 = reshape(P, N, theta_num);
%% ========产生滤波函数===============%%
fh_RL = medfuncRlfilterfunction(N,d);     % R-L滤波函数
fh_SL = medfuncSlfilterfunction(N,d);     % S-L滤波函数
%% =======滤波反投影重建（利用卷积）===========%%
rec = medfuncBackprojection(theta_num, N, P1, delta);
% 直接反投影重建（利用上一实验编写的函数）
rec_RL = medfuncRLfilteredbackprojection(theta_num, N, P1, delta, fh_RL);
% R-L函数滤波反投影重建
rec_SL = medfuncSLfilteredbackprojection(theta_num, N, P1, delta, fh_SL);
% S-L函数滤波反投影重建
%% =============函数滤波反投影重建===============%%
figure;
subplot(221),imshow(I), xlabel('(a)256x256头模型（原始图像）');
subplot(222),imshow(rec,[]),xlabel('(b)直接反投影重建图像');
subplot(223),imshow(rec_RL, []);xlabel('(c)R-L函数滤波反投影重建图像')
subplot(224),imshow(rec_SL, []);xlabel('(d)S-L函数滤波反投影重建图像');
% xlabel('图2.25 利用解析法进行滤波反投影重建图像')