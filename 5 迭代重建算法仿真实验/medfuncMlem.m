% 系数矩阵A能够被完全存储时，MLEM算法的参考程序

function F = medfuncMlem( W, F0, P, irt_num)
%MEDFUNCMLEM Summary of this function goes here
%   Detailed explanation goes here

%   MLEM(maximum likelihood expectation maximization) algorithm
%   --------------------------------------------
%   输入参数：
%   W ：系数矩阵（或概率矩阵）
%   F0 : 初始图像向量
%   P ：投影数据，列向量
%   irt_num ：迭代次数
%   ---------------------------------------------
%   输出参数：
%   F ： 输出图像向量
%   ===========================================================%
sumCol = sum(W).';   % 求系统矩阵的列和向量
Wt = W.';
F = F0;
for k = 1 : irt_num
    R = zeros(numel(P), 1);
    proj = W * F;   % 投影运算
    ind1 = proj > 0;
    R(ind1) = p(ind1) ./ proj(ind1);    % 实际投影与估计投影的比值
    back_proj = Wt * R;  % 反投影运算
    ind2 = sumCol > 0;
    F(ind2) = F(ind2) .* (back_proj(ind2) ./ sumCol(ind2));   % 图像迭代更新一次
end
end

