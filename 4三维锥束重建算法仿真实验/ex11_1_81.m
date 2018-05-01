% 锥束投影数据仿真的参考程序

% clc;
% clear all;
% close all;
tic
N = 256;  % 重建图像大小，探测器采样点数也设为N
SOD = 44; % 源到旋转中心的距离
SDD = 2 * SOD;  % 源到探测器中心的距离
vitual_detector_length = 2;  % 虚拟探测器长度
detector_length = vitual_detector_length * SDD / SOD;  % 探测器长度
theta_num = 360;  % 旋转角度数
detector_channel_size = detector_length / N; % 探测器的单位长度
P = zeros(N,  N,  theta_num);  % 存放投影数据

%%===============定义头模型参数================%%
%          xe            ye              ze             ae            be           ce              phi           gamma      theta            rho
shep = [0              0               0               0.6900    0.9200    0.8100      0              0                 0                  1.0000
              0              -0.0184    0              0.6624    0.8740     0.7800     0               0                 0                 -0.8000
              0.2200    0               0              0.1100    0.3100     0.2200    -18.0000   0                10.0000    -0.2000
             -0.2200    0               0              0.1600    0.4100     0.2800    18.0000    0                10.0000    -0.2000
             0               0.3500     -0.1500   0.2100    0.2500     0.4100     0               0                0                  0.1000
             0               0.1000     0.2500    0.0460    0.0460     0.0500     0               0                0                  0.1000
             0              -0.1000     0.2500    0.0460    0.0460     0.0500     0               0                0                  0.1000
             -0.0800   -0.6050     0              0.0460    0.0230     0.0500     0               0                0                  0.1000
             0              -0.6060     0              0.0230    0.0230     0.0200     0               0                0                  0.1000
             0.0600    -0.6050     0              0.0230    0.0460     0.0200     0               0                0                  0.1000];

%%======================产生仿真投影数据=============%%
toc
sprintf('生成3D头模型数据的函数，运行时间为：')
tic
P = medfunc3DProjectHeadModel(shep, N, SOD, detector_channel_size, theta_num);
toc

%%================仿真结果保存与显示=====================%%
tic
filename = strcat('3DProjection',   '_',   num2str(N),   '.mat');
save( filename,  'P' );
toc

% 保存为文件
tic
figure;   % 显示投影图像
subplot(1, 3, 1);  imshow(reshape(P(:,  :,  1),  N, N), [0  0.6]);  xlabel('在0°下的投影图');
subplot(1, 3, 2);  imshow(reshape(P(:,  :,  46), N, N), [0  0.6]);  xlabel('在45°下的投影图');
subplot(1, 3, 3);  imshow(reshape(P(:,  :,  91), N, N), [0  0.6]); xlabel('在90°下的投影图');
toc

