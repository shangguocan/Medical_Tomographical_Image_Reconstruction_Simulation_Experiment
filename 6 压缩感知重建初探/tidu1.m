clc;
clear all;
close all;


Img = imread('lena.jpg');
[m,n t3]=size(Img);
if t3==3
    Img = rgb2gray(Img);
end
Img = im2double(Img);

figure
imshow(Img);title(' Original image');
impixelregion;

tic
% %% ”–œﬁ≤˚”÷À„∑®
F = zeros(m,n);
g = zeros(m,n);
count_zero1 =0;
count_zero2 =0
ratio1 =0;
ratio2 =0;


%F(1, :) = Img (1, :);
%F(:, 1) = Img (:, 1);
for i = 2:m
    for  j=2:n
        % ”–œﬁ≤˚”÷Õºœ?
            F(i, j) = ( sqrt(  (Img (i, j) - Img (i-1, j) ) ^ 2) + sqrt( (Img (i, j) - Img (i, j-1) ) ^ 2 ) ) ^ 0.5;
           
          g(i, j)  = F(i, j) -0.3;
            
          
            
              
    end
end

for i = 1 : m
    for j = 1 : n
        if( F(i, j) == 0 )
            count_zero1 = count_zero1 + 1;
        end
    end
end
sprintf('count_zero1 = ');
count_zero1;
ratio1 = count_zero1 / (m*n)
for i = 1 : m
    for j = 1 : n
        if( g(i, j) <= 0 )
            count_zero2 = count_zero2 + 1;
            g(i, j)=0;
        end
    end
end
sprintf('count_zero2 = ')
count_zero2 
ratio2 = count_zero2 / (m*n)  

%%
toc
 
% F = FiniteDifference(I, N);
figure
imshow(F);
impixelregion;
title(' Latitude degree') ;
figure
imshow(g);
impixelregion;
title(' Latitude degree') ;
