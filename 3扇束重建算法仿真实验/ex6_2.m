%% 利用本章的等角扇束FBP算法
%% ===========主程序=============%%
clc;
clear all;
close all;
%% ===========定义变量===========%%
N = 256;    % 图像大小
N_d = 380;  % 探测器通道个数
beta = 0 : 1 : 359; % 旋转角度
SOD = 250;     % 焦距（射线源到旋转中心的距离）
delta_gamma = 0.25; % 等角扇束角度间隔
% delat_gamma = asin(sqrt(2) * 0.5 * N / SOD) / (N_d / 2) * 180 / pi
I = phantom(N);  % 建立Shepp_Logan头模型
%%===================投影数据仿真==========================%%
P = medfuncFanBeamAngleForwardProjection(N, beta, SOD, N_d, delta_gamma);
%%======================生成滤波核=========================%%
fh_RL = medfuncFanBeamRLFilter1(N_d, delta_gamma);
%%======================滤波反投影=========================%%
rec_RL = medfuncFanBeamAngleFBP(P, fh_RL, beta, SOD, N, N_d, delta_gamma);
%%======================显示结果===========================%%
figure;
subplot(121);
imshow(I,[]);  
title('(a)256×256头模型（原始图像）');
subplot(122);
imshow(rec_RL, []);
title('(b)等角扇束FBP算法重建图像（RL函数）');