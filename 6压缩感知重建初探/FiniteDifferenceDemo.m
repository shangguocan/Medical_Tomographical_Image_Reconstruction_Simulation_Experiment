clc;
clear all;
close all;

% %% 读入图像
% N = 256; % 图像大小
% I = phantom(N);   % 产生头模型图像,大小为180x180
% subplot(121)
% imshow(I);impixelregion;
% title('(a)Shepp-Logan头模型180x180')


% %% 读入图像
I = imread('lena.jpg');
figure;
subplot(121);imshow(I);%impixelregion
title('(a)Origin Image')
length(I)

tic
%%% 有限差分算法
F = zeros(size(I));
F(1, :) = I(1, :);
F(:, 1) = I(:, 1);
for i = 2 : length(I)
    for j = 2 : length(I)
        % 有限差分图像
            F(i, j) = ( sqrt(  ( double(I(i, j)) - double(I(i-1, j)) ) ^ 2) + sqrt( ( double(I(i, j)) - double(I(i, j-1)) ) ^ 2 ) ) ^ 0.5;
    end
end
toc

% F = FiniteDifference(I, N);
subplot(122)
imshow(F);
title('(b)有限差分图像');
impixelregion

%% 稀疏化后的图像，灰度值等于0的个数计数
%  以及占比
count_zero = 0;
for i = 1 : length(F)
    for j = 1 : length(F)
        if( F(i, j) == 0 )
            count_zero = count_zero + 1;
        end
    end
end
sprintf('count_zero = ')
count_zero
ratio = count_zero / (512^2)