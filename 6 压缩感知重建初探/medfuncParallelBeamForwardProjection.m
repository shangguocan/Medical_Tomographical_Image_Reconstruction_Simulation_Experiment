function P = medfuncParallelBeamForwardProjection(theta,N,N_d)
%EX2_2_F Summary of this function goes here
%   Detailed explanation goes here

% Parallel beam forward projection function
% ------------------------
% 输入参数：
% theta:投影角度矢量 in degrees
% N：图像大小
% N_d ：探测器通道个数
% --------------------------

% 输出参数
% P ：投影数据矩阵（N_d * theta_num）
% ===============================================================%
%       A   a     b     x0    y0      phi
shep = [1   .69   .92   0     0       0
        -.8 .6624 .8740 0     -.0184  0
        -.2 .1100 .3100 .22   0       -18
        -.2 .1600 .4100 -.22  0       18
        .1  .2100 .2500 0     .35     0
        .1  .0460 .0460 0     .1      0
        .1  .0460 .0460 0     -.1     0
        .1  .0460 .0230 -.08  -.605   0
        .1  .0230 .0230 0     -.606   0
        .1  .0230 .0460 .06   -.605   0];
theta_num = length(theta);
P = zeros(N_d, theta_num);            % 存放投影数据
rho = shep(:,1).';                    % 椭圆对应密度
ae = 0.5 * N * shep(:,2).';           % 椭圆短半轴
be = 0.5 * N * shep(:,3).';           % 椭圆长半轴
xe = 0.5 * N * shep(:,4).';           % 椭圆中心x坐标
ye = 0.5 * N * shep(:,5).';           % 椭圆中心y坐标
alpha = shep(:,6).';                  % 椭圆旋转角度
alpha = alpha * pi/180;
theta = theta*pi/180;                 % 角度换算成弧度
TT = -(N_d - 1)/2 : (N_d - 1)/2;      % 探测器坐标
for k1 = 1:theta_num
    P_theta = zeros(1,N_d);           % 存放每一角度投影数据
    for k2 = 1:max(size(xe))
        a = (ae(k2)*cos(theta(k1)- alpha(k2)))^2 + (be(k2) * sin(theta(k1) - alpha(k2)))^2;
        temp = a - (TT - xe(k2) * cos(theta(k1)) - ye(k2) * sin(theta(k1))).^2;
        ind = temp > 0;   %根号内值需为非负
        P_theta(ind) = P_theta(ind) + rho(k2) * (2 * ae(k2) * be(k2) * sqrt(temp(ind)))./a;
    end
    P(:,k1) = P_theta.';


end

