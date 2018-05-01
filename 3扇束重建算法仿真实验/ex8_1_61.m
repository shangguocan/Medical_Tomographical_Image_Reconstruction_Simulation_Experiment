% 等距扇束FBP算法的参考程序

clc;
clear all;
close all;
%%==========定义变量============%%
N = 256;  % 重建图像大小
N_d = 256;  % 探测器通道个数
beta = 0 : 1 : 359;  % 旋转角度
SOD = 250; % 焦距
t_max = sqrt(2) * 0.5 * N;   % t轴最大范围
delta_dd = SOD * t_max / sqrt(SOD ^ 2 - t_max ^ 2 ) / (N / 2);  % 探测器距离间距
dd = delta_dd * (-N_d / 2 + 0.5 : N_d / 2 - 0.5);  % 探测器距离坐标
I = phantom(N);  % 建立Shepp-Logan头模型
%%===========投影数据仿真==============%%
P = medfuncFanBeamDistanceForwardProjection(N, beta, SOD, N_d, dd);
%%===============生成滤波核=================%%
fh_RL = medfuncFanBeamRLFilter2(N_d, delta_dd);
%%==============滤波反投影==============%%
rec_RL = medfuncFanBeamDistanceFBP(P, fh_RL, beta, SOD, N, N_d, delta_dd);
%%================结果显示=================%%
figure;
subplot(121);
imshow(I, []);
title('250×250头模型（原始图像）');
subplot(122);
imshow(rec_RL, []);
title('等距扇束FBP算法重建图像（RL函数）');
