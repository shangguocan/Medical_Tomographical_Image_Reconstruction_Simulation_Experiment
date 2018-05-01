%  三维锥束FDK算法的参考程序（说明，为减小重建时间，实验时建议选取N = 128或者64来进行重建）

clc;
% clear all;
close all;

sprintf('导入数据，定义变量运行时间：')
tic
N = 256;  %重建图像大小，探测器采样点数
load '3Dprojection_256.mat';   %导入投影矩阵
angle_range = 360;    % 旋转角度0-2pi间的采样点数
SOD = 44;   % 源到探测器中心的距离
SDD = 2 * SOD;   % 源到探测器中心的距离
virtual_detector_length = 2;   % 虚拟探测器长度
detector_length = virtual_detector_length * SDD / SOD;   % 探测器长度
detector_channel_size = detector_length/N;      % 探测器的单位长度
rampfilter = zeros(1, N);   % 存放斜坡滤波函数

%% ---------------------------
project_beta = zeros(N, N);  % 存放beta角度的投影数据
weighted_project_beta = zeros(N ,N); % 存放预加权的投影数据
filtered_project = zeros(N, N);  % 存放滤波后的投影数据
rec = zeros(N, N, N);     % 存放重建结果
toc

%% 滤波器设计  %%
sprintf('滤波器设计运行时间：')
tic
Nfft = 2 ^ nextpow2(2 * N - 1);
rampfilter = zeros(1, Nfft);     % 存放斜坡滤波函数
for k1 = 1 : Nfft
    rampfilter(k1) = -1 / (pi * pi * ((k1 - Nfft / 2 - 1)^2));
    if mod(k1 - Nfft/2 - 1, 2) == 0
        rampfilter(k1) = 0;
    end
end

rampfilter(Nfft / 2 + 1) = 1 / 4;
H = fft(rampfilter);
H0 = abs(H)';
toc

%%=================FDK重建算法====================%%
sprintf('FDK重建算法的运行时间是：')
tic
for m = 1 : angle_range
    beta = (m - 1) * pi / 180;    % 旋转角度（弧度）
    project_beta = P(:, :, m);
    %%%==============加权==================%
    weighted_project_beta = medfuncWeightedProjectData(project_beta, N, SOD, detector_channel_size);
    %%============滤波============%%
    filtered_project = medfuncFFtRampFilter(weighted_project_beta, H0, N);
    %%============反投影=============%%
    rec = rec + medfuncBackprojectRecons(detector_channel_size, SOD, beta, angle_range, N, filtered_project);
end
toc

%%%============重建结果保存与显示================%

sprintf('重建结果保存与显示运行时间：')
tic
rec = rec * pi / 180 / detector_channel_size;
filename = strcat('zhuishu_recconstruction', '_', num2str(N), '.mat');
save(filename, 'rec');
figure;
subplot(131), imshow(reshape(rec(N / 2, :, :), N, N), []), xlabel('x = 0处的断面');
subplot(132), imshow(reshape(rec(:, N / 2, :), N, N), []), xlabel('y = 0处的断面');
subplot(133), imshow(reshape(rec(:, :, N / 2), N, N), []), xlabel('z = 0处的断面');

