function fh_RL = medfuncFanBeamRLFilter2( N_d, delta_dd )
%MEDFUNCFANBEAMFILTER Fan beam R - L filter for equal distance
%   Detailed explanation goes here
%-----------------------------------------------
% 输入参数：
% N_d: 探测器通道个数
% delta_dd:探测器距离间距
%-----------------------------------------------
% 输出参数：
% fh_RL:滤波向量（N_d×1）
%================================================%
fh_RL = zeros(N_d, 1);
for k1 = 1:N_d
    fh_RL(k1) = -1 / (2 * pi * pi * ((k1 - N_d / 2 - 1) * delta_dd) ^ 2);
    if mod(k1 - N_d / 2 - 1, 2) == 0
        fh_RL(k1) = 0;
    end
end
fh_RL(N_d / 2 + 1) = 1 / (8 * delta_dd ^ 2);
end

