% POCS_TVM算法的参考程序

clc;
clear all; 
close all;
N = 180;  % 图像大小
N2 = N ^ 2;
I = phantom(N);  % 产生头模型图像
theta = linspace(0, 180, 61);
theta = theta(1:60);  % 投影角度
%%========产生投影数据=========%%
P_num = 260;  % 探测器通道个数
P= medfuncParallelBeamForwardProjection(theta, N, P_num);  % 产生投影数据
% P = radon(I, theta);
%%=========获取投影矩阵=========%%
delta = 1;  % 网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);
%%==========POCS - TVM算法===========%%
irt_num = 5;   % 算法总迭代次数
F0 = zeros(N2, 1); % 初始图像向量
num_TVM = 4;   % 全变分最小化过程的迭代次数
lambda = 0.25;  % 松弛因子
alpha = 0.2;    % 调节因子
F = medfuncPOCS_TVM(N, W_ind, W_dat, P, irt_num, F0, num_TVM, lambda, alpha);
F = reshape(F, N, N)';  % 转换成N×N的矩阵图像
%%==============仿真结果显示=================%%
figure(1);
imshow(I);
xlabel('(a)180×180头模型图像');
figure(2);
imshow(F);
xlabel('(b)POCS - TVM算法重建的图像')