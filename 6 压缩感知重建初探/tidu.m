clc;
clear all;
close all;
%N = 512; % 图像大小

Img = imread('lena9.jpg');
[t1 t2 t3]=size(Img);
if t3==3
    Img = rgb2gray(Img);
end
Img = im2double(Img);
[m,n] = size(Img);
figure
imshow(Img);imhist(Img);title(' Original image');
%impixelregion;

sum_original = 0;
for i = 1:m
    for j = 1:n
        sum_orginal = sum_original + Img(i, j);
    end
end
sum_original
tic
% %% 有限阐又算法
F = zeros(m, n);
count_zero =0;
ratio =0;
%r = 10 ;
%Img=zeros(m+2*r+1,n+2*r+1);
%Img(r+1:m+r,r+1:n+r)=Img;
%Img(1:r,r+1:n+r)=img(1:r,1:n);                
%Img(1:m+r,n+r+1:n+2*r+1)=Img(1:m+r,n:n+r);    Img(m+r+1:m+2*r+1,r+1:n+2*r+1)=Img(m:m+r,r+1:n+2*r+1);   
%Img(1:m+2*r+1,1:r)=Img(1:m+2*r+1,r+1:2*r); 


%F(1, :) = Img (1, :);
%F(:, 1) = Img (:, 1);
sum = 0;
for i = 2:m
    for  j=2:n
        % 有限阐又图?
        F(i, j) = ( sqrt(  (Img (i, j) - Img (i-1, j) ) ^ 2) + sqrt( (Img (i, j) - Img (i, j-1) ) ^ 2 ) ) ^ 0.5;
        if (F(i, j) ==0)
            count_zero = count_zero+1;
            sum = F(i,j) + sum;
        end      
    end
end
sprintf(' count_zero =') ;count_zero;


ratio = ( count_zero /(m * n));
sprintf(' ratio =') ;
ratio;

  

%%
toc
 
% F = FiniteDifference(I, N);
figure
imshow(F);
imhist(F)
save imagematrix F;
impixelinfo;
title(' Latitude degree') ;


%% 不同偏移的软阈值滤波
for i = 0.1 : 0.05 : 0.5
    F1 = F - i;
    figure;
    imhist(F1)
    imshow(F1);
end


% F1 = F - 0.3;
% % subplot(121);
% figure
% imshow(F1);
% impixelregion
% title('(c)软阈值滤波图像')
% 
% F2 = F - sum / (m * n);
% % subplot(122);
% figure
% imshow(F2)
% impixelregion
% title('(d)去均值后图像')
% 
