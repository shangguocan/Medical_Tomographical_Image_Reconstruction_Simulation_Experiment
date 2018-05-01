function X = EMImgTV(img)
 
m = length(img);
N = sqrt(m);
e = 1e-8;
 

 for col=2:N-1
    for row=2:N-1
        x1 = (img((row)*N+col) - img((row-1)*N+col))/ ...
            sqrt(e+(img(row*N+col) - img((row-1)*N+col)).^2+(img((row-1)*N+col+1) - img((row-1)*N+col)).^2);
        x2 = (img((row-1)*N+col) - img((row-2)*N+col))/ ...
            sqrt(e+(img((row-1)*N+col) - img((row-2)*N+col)).^2+(img((row-2)*N+col+1) - img((row-2)*N+col)).^2);
        x3 = (img((row-1)*N+col+1) - img((row-1)*N+col))/ ...
            sqrt(e+(img((row)*N+col) - img((row-1)*N+col)).^2+(img((row-1)*N+col+1) - img((row-1)*N+col)).^2);
        x4 = (img((row-1)*N+col) - img((row-1)*N+col-1))/ ...
            sqrt(e+(img((row)*N+col-1) - img((row-1)*N+col-1)).^2+(img((row-1)*N+col) - img((row-1)*N+col-1)).^2);
        X((row-1)*N+col) = x1-x2+x3-x4;
    end
end
 
% X=X(:);

