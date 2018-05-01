function rec_RL = medfuncFanBeamAngleResorting( P, N, SOD, delta_beta, delta_gamma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



% 扇束等角重排算法（两步内插）
% ---------------------------
% 输入参数
% P:等角扇束投影，N_d×beta_num
% N:输出图像的大小
% SOD:焦距（射线源到旋转中心的距离）
% delta_beta:旋转角度增量（in degrees）
% delta_gamma:等角扇束角度间隔
%------------------------------------
% 输出参数
% rec_RL:重建出的图像（大小N * N）
% ============================================%

[N_d, beta_num] = size(P);  % 旋转角度个数
delta_theta = 0.5;  % 角度
theta = 0 : delta_theta :359;
Np = 257;
Mp = length(theta);  % Np,Mp分别为重排后平行束投影的角度个数和探测器通道个数
delta_gamma = delta_gamma * pi / 180;
delta_theta = delta_theta * pi / 180;
delta_beta = delta_beta * pi / 180;   % 角度化为弧度
d = SOD * sin((N_d - 1) / 2 * delta_gamma) / ((Np - 1) / 2);  % 平行光束间隔
pp = zeros(N_d, Mp);
PP = zeros(Np, Mp);  % 存放插值后的数据
% ============第一步插值======================
m1 = zeros(N_d, Mp);
for k1 = 1:N_d
    for k2 = 1:Mp
        t = k2 * (delta_theta / delta_beta) - (k1 - (N_d - 1) / 2 - 1) * (delta_gamma / delta_beta);
        n = floor(t);  % 整数部分
        m1(k1, k2) = n;
        u = t - n;   % 小数部分
        if n >= 1 && n < beta_num
            pp(k1, k2) = (1 - u) * P(k1, n) + u * P(k1, n + 1);  %线性插值
        end
    end 
end

%==============第二步插值===================%
for k1 = 1:Mp
    for k2 = 1:Np
        tt = 1 / delta_gamma * asin((k2 - (Np - 1) / 2 - 1) * d / SOD) + (Np - 1) / 2 + 1;
        m = floor(tt);   % 整数部分
        uu = tt - m;     % 小数部分
        if m >= 1 && m < N_d
            PP(k2, k1) = (1 - uu) * pp(m, k1) + uu * pp(m + 1, k1);   % 线性插值
        end
    end
end

%================平行束的滤波反投影重建===========================%
rec_RL  = iradon(PP, theta, 'linear', 'Ram-Lak', N);

end

