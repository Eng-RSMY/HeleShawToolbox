function [ vertices ] = bigregularpolygon( n )
%bigregularpolygon: Column of coordinates of a regular polygon with n-vertices

theta = linspace(0,2*pi,n+1);
theta = theta(1:n);

vertices = exp(i*theta).';


end

