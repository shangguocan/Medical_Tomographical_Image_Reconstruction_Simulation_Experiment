clc;
clear all;
close all;
N = 180; % 图像大小
N2 = 256;
N3 = 512;
N4 = 1024;
I = phantom(N);   % 产生头模型图像,大小为180x180
I2 = phantom(N2); % 产生头模型图像,大小为256x256
I3 = phantom(N3); % 产生头模型图像,大小为512x512
I4 = phantom(N4); % 产生头模型图像,大小为256x256
subplot(221);
%figure
imshow(I);title('(a)Shepp-Logan头模型180x180')
subplot(222);
%figure
imshow(I2);title('(b)Shepp-Logan头模型256x256')
subplot(223);
%figure
imshow(I3);title('(b)Shepp-Logan头模型512x512')
subplot(224);
%figure
imshow(I4);title('(b)Shepp-Logan头模型1024x1024')
