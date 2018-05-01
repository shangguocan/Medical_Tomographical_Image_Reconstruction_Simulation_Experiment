function [ W_ind, W_dat ] = medfuncSystemMatrix( theta, N, P_num, delta )
%MEDFUNCSYSTEMMATRIX Summary of this function goes here
%   Detailed explanation goes here

% W_fun 计算投影矩阵
% -----------------------------------------
% 输入参数
% theta : 投影角度，适用于0<=theta<180
% N : 矩阵的大小
% P_num : 每个投影角度下的射线条数（探测器通道个数）
% delta : 网格大小
%------------------------------------------
% 输出参数
% 输出以W_ind和W_dat表示的投影矩阵
% W_ind : 存储投影射线所穿过的网格的编号的矩阵，M行，2*N列
% W_dat : 存储投影射线所穿过的网格的长度的矩阵，M行，2*N列
%%========================================%%
% 用于验证的一小段程序
% theta = 45;
% N = 10;
% P_num = 15;
% delta = 1;
% ---------------------------------------------------------------
N2 = N^2;
M = length(theta) * P_num;  % 投影射线的总条数
W_ind = zeros(M, 2 * N);  % 存放射线穿过的网格的编号
W_dat = zeros(M, 2 * N);  % 存放射线穿过的网格的长度
% t_max = sqrt(2) * N * delta;
% t = linspace(-t_max / 2， t_max / 2, P_num);
t = (-(P_num - 1) / 2 : (P_num - 1) / 2) * delta; % 探测器坐标
%% 当图像较小、射线条数较小时，可以画出扫描结构图，这是网格图 %%
if N <= 10 && length(theta) <= 5
    x = (-N/2 : 1 : N/2) * delta;
    y = (-N/2 : 1 : N/2) * delta;
    plot(x, meshgrid(y,x), 'k');
    hold on;
    plot(meshgrid(x,y), y, 'k');
    axis([-N / 2 - 5, N / 2 + 5, -N / 2 - 5, N / 2 + 5]);
    text(0, -0.4 * delta, '0');
end

%==================投影矩阵的计算========================%
for jj = 1 : length(theta)
    for ii = 1 : 1 : P_num
        % 完成一条射线权因子向量的计算 
        u = zeros(1, 2 * N); 
        v = zeros(1, 2 * N);
        th = theta(jj); % 投影角度
        if th >= 180 || th < 0
            error('输入角度必须在0~180之间');
        %%===============投影角度等于90°时====================%%
        elseif th == 90
            % 画出对应的射线图
            if N <= 10 && length(theta) <= 5
                xx = (-N / 2 - 2 : 0.01 : N / 2 + 2) * delta;
                yy = t(ii);
                plot(xx, yy, 'b');
                hold on;
            end
            % 如果超出网格范围，直接计算下一条
            if t(ii) >= N / 2 * delta || t(ii) <= - N / 2 * delta
                continue;
            end
            kout = N * ceil(N / 2 - t(ii) / delta);
            kk = (kout - (N - 1)) : 1 : kout;
            u(1 : N) = kk;
            v(1 : N) = ones(1, N) * delta;
        %%==========投影角度等于0时=================%%
        elseif th == 0
            % 画出对应的射线图
            if N <= 10 && length(theta) <= 5
                yy = (-N / 2 - 2 :0.01 : N / 2 + 2) * delta;
                xx = t(ii);
                plot(xx, yy, 'b');
                hold on;
            end
            % 如果超出网格范围，直接计算下一条
            if t(ii) >= N / 2 * delta || t(ii) <= -N / 2 * delta
                continue;
            end
            kin = ceil(N / 2 + t(ii) / delta);
            kk = kin : N :(kin + N * (N -1));
            u(1:N) = kk;
            v(1:N) = ones(1, N) * delta;
        %%==当90<th<180时，投影射线的角度(以x正半轴为起点)为th-90==%%
        %%==当0<th<90时，与投影射线关于y轴对称的射线的角度为90-th==%%
        else 
            if th > 90
                th_temp = th - 90;
            elseif th < 90
                th_temp = 90 - th;
            end
            th_temp = th_temp * pi / 180;  % 角度转化为弧度
            % 确定射线y = mx + b的m和b 
            b = t / cos(th_temp);
            m = tan(th_temp);
            y1d = -N / 2 * delta * m + b(ii);
            y2d = N / 2 * delta * m + b(ii);
            % 画出射线图
            if N <10 && length(theta) <= 5
                xx = (-N / 2 - 2 : 0.01 : N / 2 + 2) * delta;
                if th < 90
                    yy = -m * xx + b(ii);
                elseif th > 90
                    yy = m * xx + b(ii);
                end
                plot(xx, yy, 'b');
                hold on;
            end
            %如果超出网格范围， 直接计算下一条
            if(y1d < - N / 2 * delta && y2d < -N / 2 * delta) || (y1d > N / 2 * delta && y2d > -N / 2 * delta)
                continue;
            end
            %%====确定入射点（xin, yin）,出射点（xout,yout）及参数d1===%%
            if(y1d <= N / 2 * delta && y1d >= -N/2 * delta && y2d > N / 2 * delta)
                yin = y1d;
                d1 = yin - floor(yin / delta) * delta;
                kin = N * floor(N / 2 - yin / delta) + 1;
                yout = N / 2 * delta;
                xout = (yout - b(ii)) / m;
                kout = ceil(xout / delta) + N / 2;
            elseif y1d <= N / 2 * delta && y1d >= -N / 2 * delta && y2d >= -N / 2 * delta && y2d < N / 2 * delta
                yin = y1d;
                d1 = yin - floor(yin / delta) * delta;
                kin = N * floor(N / 2 - yin / delta) + 1;
                yout = y2d ;
                kout = N * floor(N / 2 - yout / delta) + N;
            elseif y1d < -N / 2 * delta && y2d > N / 2 * delta
                yin = -N / 2 * delta;
                xin = (yin - b(ii)) / m;
                d1 = N / 2 * delta + floor(xin / delta) * delta * m + b(ii);
                kin = N * (N - 1) + N / 2 + ceil(xin / delta);
                yout = N / 2 * delta;
                xout = (yout - b(ii)) / m;
                kout = ceil(xout / delta) + N / 2;
            elseif y1d < -N / 2 * delta && y2d >= -N / 2 * delta && y2d < N / 2 * delta
                yin = -N / 2 * delta;
                xin = (yin - b(ii))/m;
                d1 = N/2 * delta + (floor(xin / delta) * delta * m + b(ii));
                kin = N * (N - 1) + N / 2 + ceil(xin / delta);
                yout = y2d;
                kout = N * floor(N / 2 - yout / delta) + N;
            else
                continue;   %直接计算下一条
            end
            %%==计算射线i穿过像素的编号和长度==%%
            k = kin;
            c = 0;
            d2 = d1 + m * delta;
            while k >= 1 && k <= N2
                c = c + 1;
                if d1 >= 0 && d2 > delta
                    u(c) = k;
                    v(c) = (delta - d1) * sqrt(m ^ 2 + 1) / m;
                    if k > N && k~= kout
                        k = k - N;
                        d1 = d1 - delta;
                        d2 = d1 + m * delta;
                    else
                        break;
                    end
                elseif d1 >= 0 && d2 == delta
                    u(c) = k;
                    v(c) = delta * sqrt(m ^ 2 + 1);
                    if k > N && k ~= kout
                        k = k - N + 1;
                        d1 = 0;
                        d2 = d1 + m * delta;
                    else 
                        break;
                    end
                elseif d1 >= 0 && d2 < delta
                    u(c) = k;
                    v(c) = delta * sqrt(m ^ 2 + 1);
                    if k ~= kout
                        k = k + 1;
                        d1 = d2;
                        d2 = d1 + m * delta;
                    else 
                        break;
                    end
                elseif d1 <= 0 && d2 >= 0 && d2 <= delta
                    u(c) = k;
                    v(c) = d2 * sqrt(m ^ 2 + 1) / m;
                    if k ~= kout
                        k = k + 1;
                        d1 = d2;
                        d2 = d1 + m * delta;
                    else
                        break;
                    end
                elseif d1 <= 0 && d2 > delta
                    u(c) = k;
                    v(c) = delta * sqrt(m ^ 2 + 1) / m;
                    if k > N && k ~= kout
                        k = k - N;
                        d1 = -delta + d1;
                        d2 = d1 + m * delta;
                    else
                        break;
                    end
                end
            end
            %% 如果投影角度小于90，还需要利用投影射线关于y轴的对称性计算出权因子向量
            if th < 90
                u_temp = zeros(1, 2 * N);
                if any(u) == 0  % 如果不经过任何网格，直接计算下一条
                    continue;
                end
                ind = u > 0;
                for k = 1 : length(u(ind))
                    r = rem(u(k), N);
                    if r == 0
                        u_temp(k) = u(k) - N + 1;
                    else
                        u_temp(k) = u(k) - 2 * r + N + 1;
                    end
                end
                u = u_temp;
            end
        end
        W_ind((jj - 1) * P_num + ii, :) = u;
        W_dat((jj - 1) * P_num + ii, :) = v;
    end
end
end


















