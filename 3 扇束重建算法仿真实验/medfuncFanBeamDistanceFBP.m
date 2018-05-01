function rec_RL = medfuncFanBeamDistanceFBP( P, fh_RL, beta, SOD, N, N_d, delta_dd )
%MEDFUNCFANBEAMDISTANCEFBP Summary of this function goes here
%   Fan beam FBP function for equal distance
% -----------------------------------------------------------
% 输入参数
% P:投影数据重建
% fh_RL;滤波向量
% beta;旋转角度矢量 in degrees
% SOD:焦距（射线源到旋转中心的距离）
% N_d:探测器通道个数
% delta_dd:探测器通道间距
% ------------------------------------------------------------
% 输出参数
% rec_RL:重建数据矩阵(N * N)
% =========================================================== %
%%===================定义变量========================%%
dd = delta_dd  * (-N / 2 + 0.5 : N /2  - 0.5 );  % 探测器距离坐标
% dd = delta_dd  * (-N / 2 + 0.25 : N /2  - 0.25 );  % 探测器距离坐标
beta = beta * pi / 180;
beta_num = length(beta);  % 旋转角度个数
MX = N;
MY = N;   % 重建图像大小
% 以下设置感兴趣区域，其中：
% roi(1)、roi(2)分别为x坐标轴最小最大值
% roi(3)、roi(4)分别为y坐标轴最小最大值

%%% roi为 完整图像 和 中心部分区域  二选一
% roi = N * [-0.5 0.5 -0.5 0.5]; % 感兴趣区域为完整图像
roi =  N * [-0.25 0.25 -0.25 0.25];  % 感兴趣区域为中心部分区域


hx = (roi(2) - roi(1)) / (MX - 1);  % 计算x 坐标轴间距
xrange = roi(1) + hx * [0:MX-1];    % x坐标向量
hy = (roi(4) - roi(3)) / (MY - 1);  % 计算y坐标轴间距
yrange = flipud((roi(3) + hy * [0 : MY - 1])');  % y坐标向量
x1 = ones(MY, 1) * xrange;  % x坐标矩阵
x2 = yrange * ones(1, MX);  % y坐标矩阵
rec_RL = zeros(MY, MX);     % 存放重建图像数据


%% ==============滤波反投影重建================ %%
for m = 1: beta_num
    alphaj = beta(m); % 旋转角度
    RF1 = P(:, m) .* (SOD ./ sqrt(SOD .^ 2 + dd .^ 2))';   %投影函数修正
    C_RL  = conv(RF1, fh_RL, 'same');  % 卷积计算
    aj = [cos(alphaj);  sin(alphaj)];
    U = (SOD + x1 .* aj(2) - x2 .* aj(1)) / SOD;
    t = real((x1.*aj(1) + x2.*aj(2)) ./ U) / delta_dd;  %射束计算
    k = floor(t);  % 射束编号（整数部分）
    u = t - k;      % 小数部分
    k = max(1, k + N_d / 2 + 1);  
    k = min(k, N_d - 1);     %限定k范围为1~N_d - 1
    P_RL = ((1 - u).* C_RL(k) + u.* C_RL(k+1));  % 线性内插
    rec_RL = rec_RL + P_RL ./ U ^ 2 * 2 * pi /beta_num;  % 反投影累加
end



end

