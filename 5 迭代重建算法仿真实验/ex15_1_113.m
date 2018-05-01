% 比较不同的投影访问方式的ART重建程序
% 比较不同的投影访问方式对迭代重建的影响
% 1、顺序访问方式
% 2、MLS访问方式

clf;
clc;
clear all;
close all;
N = 180; % 图像大小
N2 = N ^ 2;
I = phantom(N);  % 产生头模型图像
Image = reshape(I', N2, 1);
theta = linspace(0, 180, 91);
theta = theta(1 : 90);  % 投影角度

%%================产生投影数据====================%%
P_num = 200;  % 探测器通道个数
p = medfuncParallelBeamForwardProjection(theta, N, P_num);  % 产生投影数据
%%================获取系统矩阵=========================%%
delta = 1;  % 网格大小
[W_ind, W_dat] = medfuncSystemMatrix(theta, N, P_num, delta);
%%=================ART迭代参数设置=========================%%
lambda = 0.5;  % 松弛因子
c = 0;  % 迭代计数器
irt_num = 5;    % 总迭代次数
theta_num = length(theta);   % 投影角度个数
err1 = zeros(irt_num + 1, 1);  %存放图像误差
err2 = zeros(irt_num + 1, 1);
E1_art = zeros(N2, 1); % 初始图像向量
E1_art_mls = zeros(N2, 1); 

%%==================逐条射线进行ART迭代======================%%
%%------------------art顺序---------------------%%
sq_error = sum( ( Image - mean(Image) ) .^ 2);
err1(c + 1) = sqrt( sum ( ( Image - E1_art ) .^ 2 )  /  sq_error );  % 归一化均方距离d
tic
while(c < irt_num)
    for j = 1 : theta_num
        for i = 1 : 1 : P_num
            % 完成一条射线权因子向量的计算
            u = W_ind( ( j - 1 ) * P_num + i,  :);
            v = W_dat( ( j - 1 ) * P_num + i,  :);
            % 利用所得的某一投影系数行向量进行迭代
            if any(u) == 0
                continue;
            end
            w = zeros(1, N2);
            ind = u > 0;
            w( u ( ind ) ) = v( ind );
            PP = w * E1_art;
            C = ( p ( i,  j ) - PP) / sum( w .^ 2 ) *  w';
            E1_art = E1_art + lambda * C;
        end
    end
    E1_art ( E1_art < 0 ) = 0;
    c = c + 1;
    err1( c + 1 ) = sqrt( sum ( ( Image - E1_art )  .^  2 )  / sq_error);
end
toc
plot( 0 : irt_num, err1, 'r-- *' );
c = 0; clear C; clear w; clear u; clear v; clear err; clear cc;
%%-----------------art-mls--------------------%%
err2( c + 1 ) = sqrt( sum ( ( Image - E1_art_mls ) .^ 2)  /  sq_error );
Order_MLS = medfuncMLSOrder( theta_num ) + 1;
tic
while(c < irt_num)
    for j = Order_MLS
        for i = 1 : 1 : P_num
            % 完成一条射线权因子向量的计算
            u = W_ind((j - 1)  *  P_num + i,  :);
            v = W_dat((j - 1)  *  P_num + i,  :);
            % 利用所得的某一投影系数行向量进行迭代
            if any(u) == 0
                continue;
            end
            w = zeros(1, N2);
            ind = u > 0;
            w( u( ind ) ) = v( ind );
            PP = w * E1_art_mls;
            C = ( p(i,  j) - PP )  / sum( w .^ 2 )  *  w';
            E1_art_mls = E1_art_mls + lambda * C;
        end
    end
    E1_art_mls(E1_art_mls < 0) = 0;
    c = c + 1;
    err2(c + 1) = sqrt( sum ( ( Image - E1_art_mls ) .^ 2 )  / sq_error );
end
toc

hold on;  plot(0 : irt_num, err2, 'g-*');
title('error between original and reconstruction');
legend('sequence', 'MLS'); xlabel('迭代次数'); ylabel('归一化均方距离itd');
%%-------------------------转换成NxN的图像矩阵---------------------------%%
E1_art = reshape(E1_art, N, N)';
E1_art_mls = reshape(E1_art_mls, N, N)';
%%=========================show images===========================%%
figure
subplot(131);imshow(I),title('Original image')
subplot(132);imshow(E1_art), title('sequence access');
subplot(133);imshow(E1_art_mls),title('MLS access');