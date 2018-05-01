% 利用解析法，等距扇束投影仿真的参考程序

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
%%===========仿真结果显示==============%%
figure(1);
imshow(I, [0 1]);
title('(a)256×256头模型图像');
figure(2);
imagesc(P), colormap(gray), colorbar;
title('(b)360°等角扇束投影数据');