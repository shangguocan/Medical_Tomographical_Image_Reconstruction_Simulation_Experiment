% MART算法的参考程序

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
M = P_num * length(theta);
P = reshape(P, M, 1);  % 排列成列向量


%%===========获取投影矩阵============%%
delta = 1;  % 网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);


%%============设置参数============%%
F = ones(N2, 1);  % 初始图像向量
var = 0.3;  % 松弛因子
c = 0; % 迭代计数器
irt_num = 5; % 总迭代次数
tic 
while(c < irt_num)
    for i = 1:M
        % 如果射线不经过任何像素，不作计算
        if any(W_ind(i, :)) == 0
            continue;
        end
        % 计算权因子向量w
        w = zeros(1, N2);
        ind = W_ind(i, :) > 0;
        w(W_ind(i, ind)) = W_dat(i, ind);
        % 图像进行一次迭代更新
        PP = w * F;   %前向投影
        if PP ~= 0
            ind1 = w > 0;
            F(ind1) = (P(i) / PP).^(var * w(ind1)') .* F(ind1);
        end
    end
    c = c + 1;
end
toc
F = reshape(F, N, N)';  % 转换成N×N的图像矩阵
%%==================仿真结果显示======================%%
figure(1);
imshow(I), xlabel('(a)180×180头模型图像');
figure(2);
imshow(F), xlabel('(b)MART算法重建的图像');