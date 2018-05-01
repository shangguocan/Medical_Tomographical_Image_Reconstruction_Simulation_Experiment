clc
clear all;

tic

close all
fprintf(1,'\nStarting EMTVdemo:\n\n');

% Set the parameters for the test problem.
theta = [0:3:180]; % No. of used angles.
eta = 0.05;       % Relative noise level.

% No. of iterations.
k = 100; % for Main loop
l = 60;   % for TV mehotd
t= clock;
% image load
Img = imread('lena.jpg');
[t1 t2 t3]=size(Img);
if t3==3
    Img = rgb2gray(Img);
end

[Length, Width] = size(Img);
Img(256,256)

%% 2 选定像素圆心，原始图是512*512，选择圆心为(u, v) = （256,256）
     % 提取指定半径平方的圆的区域 
u = 256;
v = 256; % 圆心坐标

imgF = zeros(Length);
C = 10000; % 圆的半径的平方
for i = 1:Length;
    for j = 1:Width
        if((i - u)^2 + (j - v)^2 <= C)
            imgF(i, j) = Img(i, j);
        end
    end
end

%% 3 显示圆提取后的图像
sprintf('提取指定半径平方的圆形区域')
figure
imshow(imgF, [0 255])
impixelregion
title('提取半径平方为100的圆形区域')


% ImgF = imresize(ImgF,[256 256]);
imgF = im2double(imgF);

[sz1 sz2] = size(imgF);

N = sz1;    % The discretization points
p=2*N;  % No. of parallel rays.

% Create the test problem.
[A,b_ex,x_ex] = EMparalleltomo(N,theta,p);
% b = b_ex;
x_ex = imgF(:);
b_ex = A*x_ex;
b = b_ex;

fprintf(1,'Creating a parallel-bema tomography test problem\n');
fprintf(1,'with N = %2.0f, theta = %1.0f:%1.0f:%3.0f, and p = %2.0f.',...
    [N,theta(1),theta(2)-theta(1),theta(end),p]);

% Noise level.
% e = poissrnd(eta,size(b_ex));
% e = e/norm(e);  % normalization
% b = b_ex + e;

% Show the exact solution.
figure
Image = reshape(x_ex,N,N);
imagesc(Image), colormap gray,
impixelregion
% figure
% imhist(reshape(x_ex, N, N))
axis image off
c = caxis;
title('Exact phantom')

fprintf(1,'\n\n');
fprintf(1,'Perform k = %2.0f iterations with EMTV''s method.',k);
fprintf(1,'\nThis takes a moment ...');

% Perform the kaczmarz(ART算法) iterations. 
Xkacz =EM_TV(A,b,k,l);

% Show the kaczmarz solution.
figure
ImageJ = reshape(Xkacz,N,N);
imagesc(ImageJ), colormap gray,
impixelregion
axis image off
caxis(c);
title('EMTV reconstruction')

t4 = clock;
etime(t4,t);
toc

figure
imhist(Image)
title('原图灰度直方图')
figure
imhist(ImageJ)
title('EMTV后直方图')

%% 截尾滤波 阈值为0.2
sprintf('截尾滤波消耗时间为：')
tic
ImageJ1 = ImageJ - 0.2;
figure
imshow(ImageJ1)
title('截尾阈值为0.2的图像')
impixelregion
figure
imhist(ImageJ1)
title('截尾阈值为0.2之后的灰度直方图')
toc

%% 计算原始图像、EMTV、截尾后EMTV的稀疏率
tic
zero_count_yuantu = 0;
zero_count_EMTV = 0;
zero_count_EMTV_Cutoff = 0;

for i = 1 : 512
    for j = 1 : 512
        if Image(i, j) == 0
            zero_count_yuantu = zero_count_yuantu + 1;
        end
        
        if ImageJ(i, j) == 0
            zero_count_EMTV = zero_count_EMTV + 1;
        end
        
        if ImageJ1(i, j) == 0
            zero_count_EMTV_Cutoff = zero_count_EMTV_Cutoff + 1;
        end
    end
end

sprintf('原始图像的稀疏率为：')
ratio_yuantu = zero_count_yuantu / (512 * 512)

sprintf('EMTV图像的稀疏率为：')
ratio_EMTV = zero_count_EMTV / (512 * 512)

sprintf('EMTV截尾阈值为0.2的图像的稀疏率为：')
ratio_EMTV_Cutoff = zero_count_EMTV / (512 * 512)

toc