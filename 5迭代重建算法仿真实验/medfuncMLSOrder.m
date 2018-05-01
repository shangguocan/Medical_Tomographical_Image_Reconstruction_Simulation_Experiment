function Order_MLS = medfuncMLSOrder( Np )
%MEDFUNCMLSORDER Summary of this function goes here
%   Detailed explanation goes here
%   MLS 投影访问方式，计算ART的迭代顺序
%   —————————————————————————————————————
%   说明：程序是针对180扫描设计的，当使用360度扫描时，2、3象限顺序互换
%   输入参数：
%   Np:投影角度个数（projection number） 即length(theta)
%   ---------------------------------------------------------------------
%   输出参数：
%   Order_MLS : 按LMS访问方式的迭代投影顺序
%   ======================================================================

L = fix(log2(Np));
if Np > 2 ^ L
    L = L + 1;
end
Order_MLS = zeros(1, Np);
Flag_MLS = zeros(1, Np);
k = 0;
for ii = 1 : L-1
    NL = 2 ^ ii;
    A = bitrevorder(0 : NL - 1);
    B = A(k+1 : end);
    for jj = 1 : length(B)
        k = k + 1;
        M = round((Np / NL) * B(jj));
        Flag_MLS(M + 1) = 1;
        Order_MLS(k) = M;
    end
end

%---------------对L层处理-----------------%
NL = 2 ^ L;
A = bitrevorder(0 : NL - 1);
B = A(k + 1 : end);
M = round((Np / NL) * B);
for jj = 1 : length(B)
    M = round((Np / NL) * B(jj));
    if(M < Np) && (M >= 0) && (Flag_MLS(M + 1) == 0)    %% 注意Flag_MLS访问越界问题
        k = k + 1;
        Flag_MLS(M + 1) = 1;
        Order_MLS(k) = M;
    elseif(M - 1 < Np) && (M - 1 >= 0) && (Flag_MLS(M) == 0)
        k = k + 1;
        Flag_MLS(M) = 1;
        Order_MLS(k) = M - 1;
    elseif(M + 1 < Np) && (M + 1 >= 0) && (Flag_MLS(M + 2) == 0)
        k = k + 1;
        Flag_MLS(M + 2) = 1;
        Order_MLS(k) = M + 1;
    end
end

