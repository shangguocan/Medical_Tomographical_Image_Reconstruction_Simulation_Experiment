function F = medfuncOsem( W_ind, W_dat, W_index, N, F0, P, irt_num, L )
%MEDFUNCOSEM Summary of this function goes here
%   Detailed explanation goes here

% OSEM(Ordered Subsets Expectation Maximization) algorithm
% -----------------------------------------------------------------------
% 输入参数：
% W_ind:射线穿过网格的编号， M × 2 * N
% W_dat:射线穿过网格的长度， M × 2 * N
% W_index:矩阵，L行，T * P_num列，存放L个子集中每条射线所属的行号
% F0:初始图像向量
% P:投影数据，列向量
% irt_num:迭代次数
% L:子集个数
% -----------------------------------------------------------------------
% 输出参数：
% F:输出图像向量
%========================================================================%
N2 = N^2;
M = length(P); % 所有的射线条数
F = F0;
for k = 1:irt_num
    for kk = 1 : L  % 子迭代
        w_ind = W_ind(W_index(kk, :), :);
        w_dat = W_dat(W_index(kk, :), :);
        %%============求实际投影与估计投影的比值向量=======================%%
        R = zeros(M/L, 1);
        p = P(W_index(kk, :));   % 取得某一子集对应的投影数据
        for ii = 1:M/L
            %如果射线不通过任何像素，不作计算
            if any(w_ind(ii, :)) == 0
                continue;
            end
            w = zeros(1, N2);
            for jj = 1:2*N
                m = w_ind(ii, jj);
                if m > 0 && m <= N2
                    w(m) = w_dat(ii, jj);
                end
            end
            proj = w * F;  %前向投影
            R(ii) = p(ii)./proj;   % 比值向量
        end
        %%====求比值向量与全1向量的反投影back_proj,back_proj0====%%
        back_proj = zeros(N2, 1); 
        back_proj0 = zeros(N2, 1);
        for ii = 1:M/L   % 以行（射线）的遍历来进行反投影运算
            label = w_ind(ii, :);
            data = w_dat(ii, :); % 循环体内以向量进行运算
            if any(label) ~= 0  % 如果射线不通过任何像素，不作计算
                ind = label > 0;
                index = label(ind);  % 非零元素对应的网络编号
                back_proj(index) = back_proj(index) + R(ii) * data(ind).';  %比值向量的反投影
                back_proj0(index) = back_proj0(index) + data(ind).';  % 全1向量的反投影
            end
        end
        %%=====图像迭代更新一次=====%%
        ind = back_proj0 > 0;
        F(ind) = F(ind) .* (back_proj(ind) ./ back_proj0(ind));
    end
end
end

