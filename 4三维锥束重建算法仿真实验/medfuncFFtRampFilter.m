function Q = medfuncFFtRampFilter( RF1, H0, N )
%MEDFUNCFFTRAMPFILTER Summary of this function goes here
%   Detailed explanation goes here

Q = zeros(N, N);
% To filter the projection data
% --------------------------------------
% 输入参数：
% RF1 ： 加权后的投影数据
% H0 ： 谐波滤波函数
% N ： 探测器通道个数
% -------------------------------------
% 输出参数：
% Q:对加权了的投影数据进行斜坡滤波后的结果N*N
%%
Nfft = 2^nextpow2(2*N - 1);
for k2 = 1:N
    RF2 = RF1(:, k2);
    g = [RF2; zeros(Nfft - N, 1)];
    G = fft(g);
    G = G .* H0;
    g = real(ifft(G));
    RF2 = g(1:N);
    Q(:, k2) = RF2;
end


end

