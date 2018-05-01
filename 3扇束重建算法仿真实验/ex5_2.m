%% 利用解析法

%% ======主程序===========%%
clc;
clear all;
close all;
%% ======定义变量==========%%
beta = 0:1:359;      % 旋转角度
N = 256;             % 图像大小
N_d = 379;           % 探测器通道个数
SOD = 250;           % 焦距
delta_gamma = 0.25;
I = phantom(N);      % 建立Shepp-Logan头模型
%% =========投影数据仿真=============%%
P = medfuncFanBeamAngleForwardProjection(N, beta, SOD, N_d, delta_gamma);
%% =========结果显示================%%
figure;             % 显示原始图像
imshow(I,[0, 1]);
xlabel('(a)256x256头模型图像');
figure;             % 显示投影数据
imagesc(P),colormap(gray),colorbar;
xlabel('(b)360°等角扇束投影数据');
xlabel('图3.7 利用解析法对等角扇束投影的数据仿真')