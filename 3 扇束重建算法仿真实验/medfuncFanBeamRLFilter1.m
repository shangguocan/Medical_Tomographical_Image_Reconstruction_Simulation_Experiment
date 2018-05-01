function fh_RL = medfuncFanBeamRLFilter1( N_d, delta_gamma )
%MEDFUNCFANBEAMRLFILTER1 Summary of this function goes here
%   Fan beam R - L filter function for equal angle
%-----------------------------------------------
% 输入参数：
% N_d: 探测器通道个数
% delta_gamma:等角间隔程序中为等角扇束角度间隔（in degrees）
%-----------------------------------------------
% 输出参数：
% fh_RL:滤波向量（N_d×1）
%================================================%

delta_gamma = delta_gamma * pi / 180;  % 角度化为弧度
fh_RL = zeros(N_d, 1);
for k1 = 1 : N_d
    fh_RL(k1) = -1 / (2 * pi * pi * sin((k1 - N_d / 2 - 1) * delta_gamma)^2);
    if mod(k1 - N_d / 2 - 1, 2) == 0
        fh_RL(k1) = 0;
    end
end
fh_RL(N_d / 2 + 1) = 1 / (8 * delta_gamma ^ 2);


end

