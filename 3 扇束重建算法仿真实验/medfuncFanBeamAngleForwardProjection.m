function P = medfuncFanBeamAngleForwardProjection(N, beta, SOD, N_d, delta_gamma)
%MEDFUNCFANBEAMANGLEFORWARDPROJECTION Summary of this function goes here
%   Detailed explanation goes here

% Fanbeam equal angle forward projection function
% -----------------------------------------------
% 输入参数：
% N：图像大小
% beta：旋转角度矢量in radians
% SOD：焦距（射线源到旋转中心的距离）
% N_d：探测器通道个数
% delta_gamma：等角扇束角度间隔in degrees
% -----------------------------------------------
% 输出参数：
% P：投影数据矩阵(N_d * beta_num)
% ============================================================ %
%% ============定义头模型=============%%
%       A   a     b     x0    y0      phi
% --------------------------------------------
shepp = [1   .69   .92   0     0       0
        -.8 .6624 .8740 0     -.0184  0
        -.2 .1100 .3100 .22   0       -18
        -.2 .1600 .4100 -.22  0       18
        .1  .2100 .2500 0     .35     0
        .1  .0460 .0460 0     .1      0
        .1  .0460 .0460 0     -.1     0
        .1  .0460 .0230 -.08  -.605   0
        .1  .0230 .0230 0     -.606   0
        .1  .0230 .0460 .06   -.605   0];
gamma = delta_gamma * (-N_d/2 + 0.5 : N_d/2 - 0.5);    %扇束角度
rho = shepp(:, 1).';            % rho椭圆对应密度
ae = 0.5 * N * shepp(:,2).';    % ae椭圆短半轴
be = 0.5 * N * shepp(:,3).' ;    % be椭圆长半轴
xe = 0.5 * N * shepp(:,4).';   % xe椭圆中心x坐标
ye = 0.5 * N * shepp(:,5).';     % ye椭圆中心y坐标
alpha = shepp(:,6).';           % alpha椭圆旋转角度
%% =================投影数据生成=============%%
beta = beta * pi/180;
alpha = alpha * pi/180;
gamma = gamma * pi / 180;    % 角度换算成弧度
beta_num = length(beta);
P = zeros(N_d, beta_num);    % 存放投影数据
for k1 = 1:beta_num
    theta = beta(k1) + gamma;
    P_beta = zeros(1, N_d);% 存放每一旋转角度下的投影数据
    for k2 = 1:length(xe)
        rsq = (ae(k2) * cos(theta - alpha(k2))).^2 + (be(k2) * sin(theta - alpha(k2))).^2;
        dsq = (SOD * sin(gamma) - xe(k2) * cos(theta) - ye(k2) * sin(theta)).^2;
        temp = rsq - dsq;    % r^2 - d^2
        ind = temp > 0;      % 根号内值需为非负
        P_beta(ind) = P_beta(ind) + rho(k2) * (2 * ae(k2) * be(k2) * sqrt(temp(ind)))./rsq(ind);
    end
    P(:,k1) = P_beta.';

end

