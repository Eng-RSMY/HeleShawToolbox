function [ vertices ] = bigbox( numberofvertices)
%bigbox: column of points that lie along the four edges of a square
n = numberofvertices;

vertices=zeros(4*n,1);

for k = 1:n
    vertices(k) = 1 - (2*k/n)+i;
    vertices(k+n) = -1 +i - (2*k/n)*i;
    vertices(k+2*n) = -1 - i + 2*k/n;
    vertices(k+3*n) = 1-i + (2*k/n)*i;
end


