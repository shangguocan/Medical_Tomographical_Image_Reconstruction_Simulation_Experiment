%  P26, 利用“iradon”函数，直接反投影重建的参考程序

% clc;
% clear all;
% close all;
% I = phantom(256);                         % 生成256*256的Shepp_Logan头部模型
% theta = 0:179;                            % 投影角度180度
% P = radon(I,theta);                       % 生成投影数据
% rec = iradon(P, theta, 'None');           % 直接反投影重建（不采用滤波器即为直接反投影重建）
% figure;                                   % 显示原始图像
% imshow(I,[]),title('原始图像');
% xlabel('(a)256x256头模型图像')
% figure;                                   % 显示重建后图像
% imshow(rec,[]);title('直接反投影重建图像');impixelregion
% xlabel('(b)利用"radon"函数得到的直接反投影重建图像')
% 
% 



clc;
clear all;
close all;


I = phantom(256);                         % 生成256*256的Shepp_Logan头部模型
figure;                                   % 显示原始图像
imshow(I,[]),title('原始图像');
xlabel('(a)256x256头模型图像')



for theta = 0:1:179;                            % 投影角度180度
    P = radon(I,theta);                       % 生成投影数据
    rec = iradon(P, theta, 'None');           % 直接反投影重建（不采用滤波器即为直接反投影重建）
    figure;                                   % 显示重建后图像
    pause(2);
    imshow(rec,[]);title('直接反投影重建图像');
    % impixelregion
    xlabel('(b)利用"radon"函数得到的直接反投影重建图像')
end



