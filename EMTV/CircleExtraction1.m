clc;
clear all;
close all;

%% 1 读取原始图像
I = imread('lena.jpg');
imshow(I);
[Length, Width] = size(I);
I(256,256)

%% 2 选定像素圆心，原始图是512*512，选择圆心为(u, v) = （256,256）
     % 提取指定半径平方的圆的区域 
u = 256;
v = 256; % 圆心坐标

F = zeros(Length);
C = 25600; % 圆的半径的平方
for i = 1:Length;
    for j = 1:Width
        if((i - u)^2 + (j - v)^2 <= C)
            F(i, j) = I(i, j);
        end
    end
end

%% 3 显示圆提取后的图像
sprintf('提取指定半径平方的圆形区域')
figure
imshow(F, [0 255])
impixelregion
title('提取半径平方为100的圆形区域')
