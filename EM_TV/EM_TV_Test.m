close all
fprintf(1,'\nStarting EMTVdemo:\n\n');
 
% Set the parameters for the test problem.
theta = 0:3:180;  % No. of used angles.
eta = 0.05;       % Relative noise level.
 
% No. of iterations.
k = 200; % for Main loop
l = 60;   % for TV mehotde
t= clock;
% image load
Img = imread('lena.jpg');
[t1 t2 t3]=size(Img);
if t3==3
    Img = rgb2gray(Img);
end
 
% Img = imresize(Img,[256 256]);
Img = im2double(Img);
 
[sz1 sz2] = size(Img);
 
N = sz1;    % The discretization points
p=2*N;  % No. of parallel rays.
 
% Create the test problem.
[A,b_ex,x_ex] = EMparalleltomo(N,theta,p);
% b = b_ex;
x_ex = Img(:);
b_ex = A*x_ex;
b = b_ex;
 
fprintf(1,'Creating a parallel-bema tomography test problem\n');
fprintf(1,'with N = %2.0f, theta = %1.0f:%1.0f:%3.0f, and p = %2.0f.',...
    [N,theta(1),theta(2)-theta(1),theta(end),p]);
 
% Noise level.
e = poissrnd(eta,size(b_ex));
e = e/norm(e);  % normalization
b = b_ex + e;
 
% Show the exact solution.
figure
imagesc(reshape(x_ex,N,N)), colormap gray,
axis image off
c = caxis;
title('Exact phantom')
 
fprintf(1,'\n\n');
fprintf(1,'Perform k = %2.0f iterations with EMTV''s method.',k);
fprintf(1,'\nThis takes a moment ...');
 
% Perform the kaczmarz iterations.
Xkacz = EM_TV(A,b,k,l);
 
% Show the kaczmarz solution.
figure
imagesc(reshape(Xkacz,N,N)), colormap gray,
axis image off
caxis(c);
title('EM_TV reconstruction')
t4 = clock;
etime(t4,t);
