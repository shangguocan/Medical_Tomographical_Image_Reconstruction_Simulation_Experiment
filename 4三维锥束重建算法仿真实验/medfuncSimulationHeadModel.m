function I = medfuncSimulationHeadModel( shep, N )
%Function of Simulating S_L Head Model

%------------------------------------------
% 输入参数：
% shep : 仿真头模型参数矩阵
% N : 头模型大小
%------------------------------------------
% 输出参数：
% I : 头部模型三维矩阵
%%================================================%%
I = zeros(N, N, N);     % 存放头模型数据

xe = shep(: , 1)'  ;       % 椭球中心x坐标
ye = shep(: , 2)' ;       % 椭球中心y坐标
ze = shep(: , 3)' ;       % 椭球中心z坐标

ae = shep(: , 4)' ;       % 椭球x方向上半轴长
be = shep(: , 5)' ;       % 椭球y方向上半轴长
ce = shep(: , 6)' ;       % 椭球z方向上半轴长

phi = shep(: , 7)' ;      % 椭球绕x方向逆时针旋转的角度
gamma = shep(: , 8)' ;    % 椭球绕y方向逆时针旋转的角度
theta = shep(: , 9)' ;    % 椭球绕z方向逆时针旋转的角度
rho = shep(: , 10)' ;     % 椭球密度

for k1 = 1 : N
    for k2 = 1 : N
        for k3 = 1 : N
%             k1 = 1 : N;
%             k2 = 1 : N;
%             k3 = 1 : N;
            phi_rad = phi * pi / 180;  % 角度换算成弧度
            gamma_rad = gamma * pi / 180; % 角度换算成弧度
            theta_rad = theta * pi / 180; % 角度换算成弧度
            
            x0 = (k1 - N / 2) / (N / 2);  % 归一化x坐标
            y0 = (k2 - N / 2) / (N / 2);  % 归一化y坐标
            z0 = (k3 - N / 2) / (N / 2);  % 归一化z坐标
            
            cos_phi = cos(phi_rad);
            sin_phi = sin(phi_rad);
            
            cos_gamma = cos(gamma_rad);
            sin_gamma = sin(gamma_rad);
            
            cos_theta = cos(theta_rad);
            sin_theta = sin(theta_rad);
            
            %%=====================计算旋转矩阵T=========================%%
            %            T = [ T11  T12  T13;
            %                  T21  T22  T23;
            %                  T31  T32  T33];
            
            T11 = cos_theta .* cos_phi - cos_gamma .* sin_phi .* sin_theta;
            T12 = cos_theta .* sin_phi + cos_gamma .* cos_phi .* sin_theta;
            T13 = sin_theta .* sin_gamma;
            
            T21 = -sin_theta .* cos_phi - cos_gamma  .*  sin_phi .*  cos_theta;
            T22 = -sin_theta .* sin_phi + cos_gamma  .*  cos_phi .*  cos_theta;
            T23 = cos_theta .* sin_gamma;
            
            T31 = sin_gamma .* sin_phi;
            T32 = -sin_gamma .* cos_phi;
            T33 = cos_gamma;
            
            %%===================对原始坐标点（x0,y0,z0）作旋转平移变换=====%%
            XX = T11 * x0 + T12 * y0 + T13 * z0;
            YY = T21 * x0 + T22 * y0 + T23 * z0;
            ZZ = T31 * x0 + T32 * y0 + T33 * z0;
            x = XX - xe;
            y = YY - ye;
            z = ZZ - ze;
            ellipsoid = x.^2 ./ ae.^2  +  y.^2 ./ be.^2  +  z.^2 / ce.^2;  % 椭球方程
            ind = ellipsoid <= 1;  % 判断改点是否处于椭球内
            grayval = sum(rho .* ind);    % 计算改点灰度值
            I ( k1, k2, k3 ) =  I ( k1, k2, k3 ) + grayval;
        end
    end
end

end

