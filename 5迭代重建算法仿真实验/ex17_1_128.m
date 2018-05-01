clc;
clear all;
close all;
N = 128;  % 图像大小
N2 = N ^ 2;
I = phantom(N);  % 产生头模型图像
theta = linspace(0, 180, 61);
theta = theta(1 : 60); % 投影角度
%%============产生投影数据=============%%
P_num = 185;   % 探测器通道个数
P = medfuncParallelBeamForwardProjection(theta, N, P_num); % 产生投影数据
M = P_num * length(theta);   % 投影射线的总条数
P = reshape(P, M, 1);
%%====获取系统矩阵====%%
delta = 1;  %　网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);
%==============利用MLEM算法进行重建==============%
F0 = ones(N2, 1);    % 初始图像向量
irt_num = 20;    % 迭代次数
F = medfuncMlem1(W_ind, W_dat, N, F0, P, irt_num);
F = reshape(F, N, N)';
%% ==================仿真结果显示=================%%
figure(1);
imshow(I), xlabel('(a)128 x 128头模型图像');
figure(2);
imshow(F), xlabel('(b)MLEM算法重建的图像')