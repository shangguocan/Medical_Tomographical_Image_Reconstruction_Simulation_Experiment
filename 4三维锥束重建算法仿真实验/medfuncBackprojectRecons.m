function temprec = medfuncBackprojectRecons( dd, D, beta, angle_num, N, Q )
%MEDFUNCBACKPROJECTRECONS Summary of this function goes here
%   Detailed explanation goes here

temprec = zeros(N, N, N);
% 对加权滤波后的数据进行反投影滤波
% -------------------------------------
% 输入参数：
% dd ： 探测器通道大小
% D ： 源到探测器的距离
% beta ： 旋转角度
% angle_num ： 总的投影角度数目
% N ：重建图像大小
% Q ：滤波后的theta角度的投影数据， 矩阵大小为N * N
% -------------------------------------

% 输出参数：
% temprec ： 临时重建结果 矩阵大小 N * N
%=================================================%
for k1 = 1 : N
    x = dd * (k1 - N / 2);
    for k2  = 1 : N
        y = dd * (k2 - N / 2);
        U = (D + x * sin(beta) - y * cos(beta)) / D;
        a = (x * cos(beta) + y * sin(beta)) / U;
        xx = round(a / dd + N / 2);
        u1 = a / dd + N / 2 - xx;
        for k3 = 1 : N
            z = dd * (k3 - N / 2);
            b = z / U;
            yy = round(b / dd + N / 2);
            u2 = b / dd + N / 2 - yy;
            % 双线性插值
            if(xx >= 1) && (xx < N) && (yy >= 1) && (yy < N)
                temp = (1 - u1) * (1 - u2) * Q(xx, yy) + (1 - u1) * u2 * Q(xx, yy + 1) + u1 *(1 - u2) * Q(xx + 1, yy) + u1 * u2 * Q(xx + 1, yy + 1);
                temprec(k1, k2, k3) = temprec(k1, k2, k3) + temp / U^2 * 2 * pi / angle_num;
            else
                temprec(k1, k2, k3) = temprec(k1, k2, k3);
            end
        end
    end
end


end

