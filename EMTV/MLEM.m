function [X,info] = MLEM(A,b,K,l)


% Input:
%   A        m times n matrix.
%   b        m times 1 vector.
%   K        Number of iterations. If K is a scalar, then K is the maximum
%            number of iterations and only the last iterate is saved.
%            If K is a vector, then the largest value in K is the maximum
%            number of iterations and only iterates corresponding to the
%            values in K are saved, together with the last iterate.
%            If K is empty then a stopping criterion must be specified.

% Output:
%   X      Matrix containing the saved iterations.
%   info   Information vector with 2 elements.
%          info(1) = 0 : stopped by maximum number of iterations
%          info(2) = no. of iterations.
%
% See also: randkaczmarz, symkaczmarz

% Maria Saxild-Hansen and Per Chr. Hansen, July 5, 2015, DTU Compute.

% Reference: G. T. Herman, Fundamentals of Computerized Tomography,
% Image Reconstruction from Projections, Springer, New York, 2009. 

[m,n] = size(A);
% A = A';  % Faster to perform sparse column operations.

% Check the number of inputs.
if nargin < 3
    error('Too few input arguments')
end

% Default value of starting vector x0.
x0 = ones(n,1);

% The sizes of A, b and x must match.
if size(b,1) ~= m || size(b,2) ~= 1
    error('The sizes of A and b do not match')
elseif size(x0,1) ~= n || size(x0,2) ~= 1
    error('The size of x0 does not match the problem')
end

% Initialization.
    if isempty(K)
        error('No stopping rule specified')
    end
    
    kmax=K;
    
% Initialization before iterations.
xk = x0;
% normAi = full(abs(sum(A.*A,1)));  % Remember that A is transposed.
% I = find(normAi>0);

stop = 0;
k = 0;
xk1 =x0;

Lcon = ones(m,1);

while ~stop
    disp(k);
    
    k = k + 1;
    % The EM algorithm
    t1 = A'*(b./(A*xk));
    t2 = (A'*Lcon);
    xk1 = xk.*t1./t2;
    
    xkTV = xk1;

    % TV method
%     for i=1:l
%         dxk = EMImgTV(xkTV);
%         vst = dxk/norm(dxk);
%         xkTV = xkTV+a*vst.*xkTV./(A'*Lcon);       
%     end
   
    % Stopping rules.
    if k >= kmax
        stop = 1;
        info = [0 k];
    else
        xk = xkTV;
    end
       
end

X = xk;


