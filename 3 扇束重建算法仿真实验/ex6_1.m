%% 等角扇束滤波反投影重建的参考程序

clc;
clear all;
close all;
%% ================定义变量=================%
N = 256;        % 图像大小
I = phantom(N);    % Shepp-Logan头模型
SOD = 250;
delta_gamma1 = 2;
delta_gamma2 = 1;
delta_gamma3 = 0.25;

%% ==============生成扇束投影===============%
R1 = fanbeam(I, SOD, 'FanSensorSpacing', delta_gamma1);
R2 = fanbeam(I, SOD, 'FanSensorSpacing', delta_gamma2);
R3 = fanbeam(I, SOD, 'FanSensorSpacing', delta_gamma3);

%% ==============等角度FBP算法重建==========%
rec1 = ifanbeam(R1, SOD, 'FanSensorSpacing',delta_gamma1);
rec2 = ifanbeam(R2, SOD, 'FanSensorSpacing',delta_gamma2);
rec3 = ifanbeam(R3, SOD, 'FanSensorSpacing',delta_gamma3);

%% ===============显示结果=================%%
figure;   % 显示图像
subplot(221);imshow(I, [0,1]),xlabel('(a)256x256头模型（原始图像）');
subplot(222);imshow(rec1, [0,1]),xlabel('(b)扇束重建图像（等角间隔为2）');
subplot(223);imshow(rec2, [0,1]),xlabel('(c)扇束重建图像（等角间隔为1）');
subplot(224);imshow(rec3, [0,1]),xlabel('(d)扇束重建图像（等角间隔为0.25）');