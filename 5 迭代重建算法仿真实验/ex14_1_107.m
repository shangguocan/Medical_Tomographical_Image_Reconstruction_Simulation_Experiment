% ART算法的参考程序
clc;
% clear all;
close all;
N = 180; % 图像大小
N2= N ^2;
I = phantom(N);  % 产生头模型图像
theta = linspace(0, 180, 61);
theta = theta(1:60);  % 投影角度
%%=============产生投影数据===============%%
P_num = 260;   % 探测器通道个数
P = medfuncParallelBeamForwardProjection(theta, N, P_num);  % 产生投影数据
% P = radon(I, theta);
%%================获取投影矩阵=====================%%
delta = 1;  % 网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);
%%===============进行ART迭代=============================%%%
F = zeros(N2, 1);    % 初始图像向量
lambda = 0.25;    % 松弛因子
c = 0;  % 迭代计数器
irt_num = 5;  % 总迭代次数
while(c < irt_num)
    for j = 1:length(theta)
        for i = 1:1:P_num
            % 取得一条射线所穿过的网格编号和长度
            u = W_ind((j - 1) * P_num + i, :);   % 编号
            v = W_dat((j - 1) * P_num + i, :);   % 长度
            % 如果射线不经过任何像素，不作计算
            if any(u) == 0
                continue;
            end
            % 恢复投影矩阵中这一条射线对应的行向量w
            w = zeros(1, N2);
            ind = u > 0;
            w(u(ind)) = v(ind);
            % 图像进行一次ART迭代
            PP= w * F;  % 前向投影
            C = (P(i,j) - PP) / sum(w.^2)* w';  % 修正项
            F = F +  lambda *C;
        end
    end
    F(F < 0) = 0; % 小于0的像素置0
    c = c + 1;
end

F = reshape(F, N, N)';   % 转换成N×N的图像矩阵
figure(1);
imshow(I);
xlabel('(a)180×180头模型图像');
figure(2);
imshow(F);
xlabel('(b)ART算法重建的图像');

