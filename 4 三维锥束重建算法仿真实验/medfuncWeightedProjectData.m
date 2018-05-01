function RF1 = medfuncWeightedProjectData( RF, N, SOD, dd )
%MEDFUNCWEIGHTEDPROJECTDATA Summary of this function goes here
%   Detailed explanation goes here

RF1 = zeros(N, N);
% weighted projectdata function
% ----------------------------------------------
% 输入参数
% RF：仿真的投影数据
% N ：探测器通道个数
% SOD ：源到旋转中心的距离
% dd ：探测器的像素（通道）大小
% ----------------------------------------------
% 输出参数：
% RF1 ： 加权了的投影数据矩阵 N*N
%================================================%
for k1 = 1:N
    for k2 = 1:N
        RF1(k1, k2) = RF(k1,k2) * SOD / sqrt(SOD^2 + ((k1 - N / 2) * dd) ^ 2 + ((k2 - N / 2) * dd) ^ 2);
    end   
end
end

