function F = medfuncPOCS_TVM( N, W_ind, W_dat, P, irt_num, F0, num_TVM, lambda, alpha )
%MEDFUNCPOCS_TVM algorithm
%   ---------------------------------------------------
% 输入参数
% N:图像大小
% W_ind:射线所穿过网格的编号，M×2*N
% W_dat:射线所穿过网格的长度，M×2*N
% P:投影数据
% irt_num:算法的总迭代次数
% F0:初始图像向量
% num_TVM:全变分最小化（TVM）过程的迭代次数，默认值为6
% lambda:松弛银子，默认值为0.25
% alpha: 调节因子，默认值为0.2
% ------------------------------------------------------
% 输出参数：
% F：重建的图像
% =====================================================%
if nargin < 6, F0 = zeros(N^2, 1);end
if nargin < 7, num_TVM = 6; end
if nargin < 8, lambda = 0.25; end
if nargin < 9, alpha = 0.2; end
F = F0;  % 初始化图像
N2 = N^2;
% 得到每个投影的射线条数P_num和投影的个数theta_num
[P_num, theta_num] = size(P);
e = 0.00000001;
k1 = 0;  % 循环控制变量
while(k1 < irt_num)
    TEMP1 = F;
    %%==================POCS过程======================%%
    for j = 1 : theta_num
        for i = 1 : 1 : P_num
            % 取得一条射线所穿过的网格编号和长度
            u = W_ind((j - 1) * P_num + i, :); %编号
            v = W_dat((j - 1) * P_num + i, :); %长度
            % 如果射线不经过任何像素，不作计算
            if(any(u) == 0)
                continue;
            end
            % 恢复投影矩阵中与这一条射线对应的行向量w
            w = zeros(1, N2);
            ind = u > 0;
            w(u(ind)) = v(ind);
            % 图像进行一次ART迭代
            PP = w * F;  % 前向投影
            C = (P(i, j) - PP) / sum(w.^2) *w';  % 修正项
            F = F + lambda * C;
        end
    end
    F(F < 0) = 0;   % 非负约束
    %%============TVM过程====================%%
    d = sqrt((TEMP1 - F)' * (TEMP1 - F));    % 增量因子
    k2 = 0;
    while(k2 < num_TVM)
        G = zeros(N2, 1);
        for i = 2:N-1
            for j = 2:N-1
                G((j - 1) * N + i) = (2 * F((j - 1) * N + i) - F((j - 1) * N + i - 1) - F((j - 2) * N + i)) / sqrt(e + ...
                    (F((j - 1) * N + i) - F((j - 1) * N + i - 1))^2 + (F((j - 1) * N + i) - F((j - 2) * N + i))^2) -...
                    (F(j * N + i) - F((j - 1) * N + i)) / sqrt(e + (F(j * N + i) - F((j - 1) * N + i))^2 + (F(j * N + i)-...
                    F(j * N + i - 1))^2) -...
                    (F((j - 1) * N + i + 1) - F((j - 1) * N + i) / sqrt(e + (F((j - 1) * N + i + 1) - F((j - 1) * N + i))...
                    ^2 + F((j - 1) * N + i + 1) - F((j - 2) * N + i + 1))^2);
            end
        end
        G = G / sqrt(G' * G);
        F = F - alpha * d * G;
        k2 = k2 + 1;
    end
    k1 = k1 + 1;
end


end

