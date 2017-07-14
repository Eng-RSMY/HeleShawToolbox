function [ deltatheta ] = flowtheta( theta, alpha, deltaalpha, deltaL )
%   INPUT
%   theta: row vector of length n giving angles of the points on unit disc that are mapped
%   to the vertices of a polygon by a conformal map of the
%   Schwarz-Christoffel form
%   alpha: row vector of length n giving the internal angles (in multiples of pi) of the polygon
%   deltaalpha: row vector of length n giving an infinitesimal change in
%   the internal angles
%   deltaL: row vector of length n giving the infinitesimal change in the
%   ratio (w_j+1 - w_j) / | w_2- w_1| where w_j are the complex numbers of
%   the vertices of the polygon

% OUTPUT
% row vector of length n giving the infinitesimal change of the angles of the points on
% the unit disc

n = length(theta);

if (n==0)
    error( ' Input vector of zero length ')
end
    
if (length(alpha) ~= n) | (length(deltaalpha) ~=n) | (length(deltaL) ~=n)
error(' Input vectors need to be of the same length')
end 

A =@(x) 1+0.*x;
for k=1: n
A=@(x) A(x).*  (( 1 - exp(1i.*(x-theta(k)))).^(alpha(k)-1));    
end
A=@(x) A(x).*i.*exp(i.*x);

B=@(k,x) A(x).*(alpha(k)-1).*i.* exp(1i.*(x-theta(k)))./(1-exp(1i.*(x-theta(k))));

C=@(k,x) A(x).*log(1-exp(1i.*(x-theta(k))));

E=zeros(1,n);
F=zeros(n,n);
H=zeros(n,n);
G=zeros(1,n);

 % This epsilon is used to evaluate integrals with singularities at the
 % endpoints.  It should be possible to use instead quadgk
 epsilon = 0.0001;

for j=1:n-1
    E(j) = quad(A,theta(j)+epsilon,theta(j+1)-epsilon);
end

 E(n) = quad(A,theta(n)+epsilon,theta(1)+2*pi-epsilon);
 
 for j = 1:n
     G(j) = A(theta(j)+epsilon);
 end
 

 
 for k = 1:n
     for j=1 :n-1
         F(j,k) = quad(@(x) B(k,x),theta(j)+epsilon,theta(j+1)-epsilon);
         H(j,k) = quad(@(x) C(k,x),theta(j)+epsilon,theta(j+1)-epsilon);
     end
     
     F(n,k) = quad(@(x) B(k,x),theta(n)+epsilon,theta(1)+2*pi-epsilon);
     H(n,k) = quad(@(x) C(k,x),theta(n)+epsilon,theta(1)+2*pi-epsilon);
 end


M =F;
N = zeros(n,n);
P = zeros(n,n);

for j =1:n
    M(j,j) = M(j,j) - A(theta(j)+epsilon);
end

for j=1:n-1
    M(j,j+1) = M(j,j+1) + A(theta(j+1)-epsilon);
end
M(n,1) = M(n,1) + A(theta(1)+2*pi-epsilon);

for j = 1 :n
    for k=1 :n
N(k,j) = ( M(k,j) - E(k).* real( M(1,j)./E(1) )); 
    end
end

for j = 1 :n
    for k=1 :n
P(k,j) =  ( H(k,j) - E(k).* real( H(1,j)./E(1) )); 
    end
end

Y=abs(E(1)).*(deltaL.')-P*(deltaalpha.');
deltatheta=real(transpose(linsolve(N,Y)));

end