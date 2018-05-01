% 利用解析法计算平行束投影数据的参考程序
clc;
clear all;
close all;
%%==========仿真参数设置======================================%%
N = 256;%重建图像大小，探测器通道个数
theta = 0:1:179;
%%=======产生仿真数据====================================%%
I = phantom(N);%产生shepp-Logan头模型
N_d = 2*ceil(norm(size(I) - floor((size(I)-1)/2)-1))+3;    % 设定平板探测器通道个数
P = medfuncParallelBeamForwardProjection(theta,N,N_d);    % 产生投影数据
%%=================仿真结果显示=====================%
figure;  %显示原始图像
imshow(I,[]),title('256*256头模型图像');xlabel('(a)256x256头模型图像')
figure; % 显示投影数据
imagesc(P),colormap(gray),colorbar,title('180度平行束投影')
 xlabel('(b)利用解析法得到的平行束投影像')

