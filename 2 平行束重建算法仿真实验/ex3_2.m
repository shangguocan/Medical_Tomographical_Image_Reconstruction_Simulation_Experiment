% P26 利用解析法直接反投影重建的参考程序

%% =====主程序====%%
clc;
clear all;
close all;

%% ========投影参数设置=============%%
N = 256;
I = phantom(N);     
delta = pi / 180;
theta = 0:1:179;
theta_num = length(theta);

%% ===========生成投影数据============%%
P = radon(I,theta);    % radon变换
[mm, nn] = size(P);    % 计算投影矩阵的行，列长度
e = floor((mm - N - 1)/2 + 1)+1; 
P = P(e : N+e-1 ,: );
P1 = reshape(P, N, theta_num);

%% ===========反投影重建===============%%
rec = medfuncBackprojection(theta_num, N, P1, delta);

%% ===========投影结果显示======================%%
figure;
imshow(I, []); title('原始图像');xlabel('(a)256x256头模型图像')
figure;
imshow(rec,[]);title('直接反投影重建图像');
xlabel('(b)利用解析法得到的直接反投影重建图像')