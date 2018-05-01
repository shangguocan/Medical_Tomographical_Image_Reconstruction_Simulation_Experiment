function rec = medfuncBackprojection(theta_num, N, P1, delta)
%MEDFUNCBACKPROJECTION Summary of this function goes here
%   Detailed explanation goes here

% Backprojection reconstruction function
% --------------------------
% 输入参数：
% theta_num ：投影角度个数
% N ： 图像大小、探测器通道个数
% P1 ：投影数据矩阵
% delta ：角度增量（弧度）
% ---------------------------

% 输出参数：
% rec ： 反投影重建图像矩阵
% =============================================================%
rec = zeros(N);    % 存储重建后的像素值
for m = 1:theta_num
    pm = P1(:, m); %取某一角度的投影数据
    Cm = (N/2) * (1 - cos((m - 1) * delta) - sin((m - 1) * delta));
    for k1 = 1:N
        for k2 = 1:N
            % 以下是射束计算，需要注意的是射束编号n取值范围为1——N-1
            Xrm = Cm + (k2 - 1) * cos((m - 1) * delta) + (k1 - 1) * sin((m - 1)* delta);
            n = floor(Xrm);  % 射束编号（整数部分）
            t = Xrm - floor(Xrm);  % 小数部分
            n = max(1,n); 
            n = min(n,N-1);    % 限定n范围为1——N-1
            p = (1 - t) * pm(n) + t * pm(n + 1); % 线性内插
            rec(N + 1 - k1, k2) = rec(N + 1 - k1, k2) + p; %反投影，图像需要翻转90°
        end
    end
   
end

