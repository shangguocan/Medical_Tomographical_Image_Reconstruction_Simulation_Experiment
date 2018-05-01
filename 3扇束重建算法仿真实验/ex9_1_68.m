% 实验九扇束等角重排算法的参考程序
%%=============主程序==================%%
clc;
clear all;
close all;
%%==============定义变量================%%
delta_beta = 1;  % 旋转角度变量
beta = 0 : delta_beta : 359;  % 旋转角度
N = 256;   % 图像大小
N_d = 257;  % 探测器通道个数
SOD = 250; % 焦距
delta_gamma = 0.25;  % 扇束张角增量 
I = phantom(N);   % 建立Shepp-Logan头模型
%%============投影数据仿真===============%%
P = medfuncFanBeamAngleForwardProjection(N, beta, SOD, N_d, delta_gamma);
%%=================调用等角扇束重建函数进行重建==================%%
rec_RL = medfuncFanBeamAngleResorting(P, N, SOD, delta_beta, delta_gamma);
%%======================仿真结果显示==========================%%
figure
subplot(121);
imshow(I, []);
title('(a)256×256头模型（原始图像）');
subplot(122);
imshow(rec_RL, []);
title('(b)重排算法重建后的图像')