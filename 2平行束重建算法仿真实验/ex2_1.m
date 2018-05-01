% 利用Radon变换计算平行束投影数据的参考程序
clc;
clear all;
close all;
I = phantom(256);     %生成２５６＊２５６的Shepp-Logan头模型
figure;               %显示原始图像
imshow(I,[]),title('256*256头模型图像');xlabel('(a)256x256头模型图像')


theta = 0:1:179;        %投影角度
sprintf('theta = %d', theta);
P = radon(I,theta);   %生成投影数据
%     pause(2)
%显示投影数
figure;
 imagesc(P), colormap(gray), colorbar,title('180度平行束投影图像')
 xlabel('(b)利用Radon变换得到的平行束投影')



% figure;               %显示原始图像
% imshow(I,[]),title('256*256头模型图像');xlabel('(a)256x256头模型图像')
% figure;               %显示投影数据
% imagesc(P), colormap(gray), colorbar,title('180度平行束投影图像')
% xlabel('(b)利用Radon变换得到的平行束投影')
 