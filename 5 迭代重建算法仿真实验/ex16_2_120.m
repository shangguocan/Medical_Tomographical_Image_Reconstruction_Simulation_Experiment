% SART算法的参考程序

clc;
clear all;
close all;
N = 180;
N2 = N ^ 2;
I = phantom(N);
theta = linspace(0, 180, 61);
theta = theta(1:60); % 投影角度

%%===========产生投影数据============%%
P_num = 260;  % 探测器通道个数
P = medfuncParallelBeamForwardProjection(theta, N, P_num);   % 产生投影数据
% P = radon(I, theta);
%%===========获取投影矩阵============%%
delta = 1;  % 网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);
%%============设置参数============%%
F = ones(N2, 1);  % 初始图像向量
lambda = 0.5;  % 松弛因子
c = 0; % 迭代计数器
irt_num = 5; % 总迭代次数
while( c < irt_num)
    for j = 1:length(theta)
        W1_ind = W_ind((j - 1) * P_num + 1:j * P_num, :);
        W1_dat = W_dat((j - 1) * P_num + 1:j * P_num, :);
        W = zeros(P_num, N2);
        for jj = 1: P_num
            % 如果射线不经过任何像素，不作计算
            if ~any(W1_ind(jj, :))
                continue;
            end
            for ii = 1:2*N
                m = W1_ind(jj, ii);
                if m > 0 && m <= N2
                    W(jj, m) = W1_dat(jj, ii);
                end
            end
        end
        sumCol = sum(W)'; % 列和向量
        sumRow = sum(W, 2); % 行和向量
        ind1 = sumRow > 0;
        corr = zeros(P_num, 1);
        err = P(:, j) - W * F;
        corr(ind1) = err(ind1) ./ sumRow(ind1);   % 修正误差
        backproj = W' * corr;   % 修正误差反投影
        ind2 = sumCol > 0;
        delta = zeros(N2, 1);
        delta(ind2) = backproj(ind2) ./ sumCol(ind2);
        F = F + lambda * delta;
        F(F < 0) = 0;
    end
    c = c + 1;
end
F = reshape(F, N, N)';
figure(1);
imshow(I), xlabel('(a)180×180头模型图像');
figure(2);
imshow(F), xlabel('(b)SART算法重建的图像');

