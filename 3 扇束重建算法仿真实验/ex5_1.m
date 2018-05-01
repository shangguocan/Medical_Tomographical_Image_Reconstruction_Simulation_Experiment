%%　等角扇束投影数据仿真的参考程序

clc;
clear all;
close all;
%% =======设置参数==============%%
N = 256;              % 图像大小
SOD = 250;            % 焦距（射线源到旋转中心的距离）
delta_gamma = 0.25;   % 等角扇束角度间隔
%% =======生成仿真数据===========%%
I = phantom(N);       % 建立Shepp-Logan头模型
P = fanbeam(I, SOD, 'FanSensorSpacing', delta_gamma);   %生成投影数据
%% =======仿真结果显示===========%%
figure;               % 显示原始图像
imshow(I,[0, 1]);
xlabel('(a)256x256头模型图像');
figure;               % 显示投影数据
imagesc(P),colormap(gray),colorbar;
xlabel('(b)360°等角扇束投影数据');
%xlable('图3.6 利用"fanbeam"函数对等角扇束投影的方针结果')