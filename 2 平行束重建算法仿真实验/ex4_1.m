%% 利用“iradon”函数使用不同滤波函数进行滤波反投影的参考程序%%

clc;
clear all;
close all;
N = 256;
I = phantom(N);
theta = 0:1:179;
P = radon(I,theta);
rec = iradon(P, theta, 'linear', 'None');
rec_RL = iradon(P, theta);
rec_SL = iradon(P, theta, 'linear', 'Shepp-Logan');
figure;
subplot(221);imshow(I),title('原始图像');
subplot(222);imshow(rec, []), title('直接反投影重建图像');
subplot(223);imshow(rec_RL, []),title('R-L函数滤波反投影重建图像');
subplot(224);imshow(rec_SL, []),title('S-L函数滤波反投影重建图像');