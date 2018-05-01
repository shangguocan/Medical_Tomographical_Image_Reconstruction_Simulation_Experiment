function P = medfunc3DProjectHeadModel( shep, N, SOD, detector_channel_size, theta_num )
% Function of Projecting Of S_L Head Model
%------------------------------------------
% 输入参数
% shep : 仿真头模型参数矩阵
% N : 探测器通道个数
% SOD : 源到旋转中心的距离
% detector_channel_size : 探测器的像素（通道）大小
% theta_num : 总的不同角度的投影次数
%------------------------------------------
% 输出参数:
% P : 投影数据矩阵 N * N * 总的投影角度数
%%=============================================%%
P = zeros(N, N, theta_num);

xe = shep(:, 1)';       % 椭球中心x坐标
ye = shep(:, 2)';       % 椭球中心y坐标
ze = shep(:, 3)';       % 椭球中心z坐标

ae = shep(:, 4)';       % 椭球x方向上半轴长
be = shep(:, 5)';       % 椭球y方向上半轴长
ce = shep(:, 6)';       % 椭球z方向上半轴长

phi = shep(:, 7)';      % 椭球绕x方向逆时针旋转的角度
gamma = shep(:, 8)';    % 椭球绕y方向逆时针旋转的角度
theta = shep(:, 9)';    % 椭球绕z方向逆时针旋转的角度
rho = shep(:, 10)';     % 椭球密度

for m = 1 : theta_num
    rotation_theta = (m - 1)  * pi / 180; % 旋转角度（弧度）
    for k1 = 1:N
        for k2 = 1 : N
            Ax = (k1 - N/2) * detector_channel_size * cos(rotation_theta) + SOD * sin(rotation_theta);
            Ay = (k1 - N/2) * detector_channel_size * sin(rotation_theta) - SOD * cos(rotation_theta);
            Az = (k2 - N/2) * detector_channel_size;
            Bx = -(SOD * sin(rotation_theta));
            By = (SOD * cos(rotation_theta));
            Bz = 0;
            asq = ae.^2;     % a^2
            bsq = be.^2;     % b^2
            csq = ce.^2;     % c^2;
            phi_rad = phi * pi / 180;  % 角度换算成弧度
            gamma_rad = gamma * pi / 180; % 角度换算成弧度
            theta_rad = theta * pi / 180; % 角度换算成弧度
            
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
            
            T21 = -sin_theta .* cos_phi - cos_gamma .* sin_phi .* cos_theta;
            T22 = -sin_theta .* sin_phi + cos_gamma .* cos_phi .* cos_theta;
            T23 = cos_theta .* sin_gamma;
            
            T31 = sin_gamma .* sin_phi;
            T32 = -sin_gamma .* cos_phi;
            T33 = cos_gamma;
            
            A1 = Ax * T11 + Ay * T12 + Az * T13;
            A2 = Ax * T21 + Ay * T22 + Az * T23;
            A3 = Ax * T31 + Ay * T32 + Az * T33;
            
            B1 = Bx * T11 + By * T12 + Bz * T13 - xe;
            B2 = Bx * T21 + By * T22 + Bz * T23 - ye;
            B3 = Bx * T31 + By * T32 + Bz * T33 - ze;
            
            A = bsq .* csq .* A1.^2 + asq .* csq .* A2.^2 + asq .* bsq .* A3 .^ 2;
            B = 2 * (bsq .* csq .* A1 .* B1 + asq .* csq .* A2 .* B2 + asq .* bsq .* A3 .* B3);
            C = bsq .* csq.* B1 .^ 2 + asq .* csq .* B2 .^ 2 + asq .* bsq .* B3 .^ 2 - asq  .*  bsq .* csq;
            delta = B.^2 - 4 * A .* C;
            ind  = delta >= 0;
            temp = sqrt ( delta .* ind * ( Ax ^ 2 + Ay ^ 2 + Az ^ 2 ) )  ./  A;
            tmp = sum(rho .* temp);  % 计算该点灰度值
            P(k1, k2, m) = P(k1, k2, m) + tmp;
        end
    end
end

end

