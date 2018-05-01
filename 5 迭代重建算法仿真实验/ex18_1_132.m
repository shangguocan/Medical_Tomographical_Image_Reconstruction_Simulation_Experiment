% 利用OSEM算法进行图像重建的参考程序

clc;
clear all;
close all;
N = 128;  % 图像大小
N2 = N ^ 2;
I = phantom(N);  % 产生头模型图像
theta = linspace(0, 180, 61);
theta = theta(1:60); % 投影角度

%%===========产生投影数据============%%
P_num = 185;  % 探测器通道个数
P = medfuncParallelBeamForwardProjection(theta, N, P_num);   % 产生投影数据
M = P_num * length(theta);  % 投影射线的总条数
P = reshape(P, M, 1);
%%===========获取系统矩阵============%%
delta = 1;  % 网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);
%%============划分子集============%%

L = 10;  % 子集个数
T = length(theta) / L;   % 每个子集包含的角度数
theta_seq = reshape(1:length(theta), L, T);  % 产生角度编号矩阵
W_index = zeros(L, T * P_num);   % 包含L个子集的射线的行号
for i = 1:L
    temp = P_num * theta_seq(i, :);
    for j = 1:T
        W_index(i, (j - 1) * P_num + 1 : j * P_num) = temp(j) - P_num + 1 : temp(j);
    end
end

%===============利用OSEM算法进行重建==================%
F0 = ones(N2, 1);  % 初始图像向量
irt_num = 5; % 迭代次数
F = medfuncOsem(W_ind, W_dat, W_index, N, F0, P, irt_num, L);
F = reshape(F, N, N)';
%%=====仿真结果显示=====%%
figure(1);
imshow(I), xlabel('(a)128×128头模型图像');
figure(2);
imshow(F), xlabel('(b)OSEM算法重建的图像');