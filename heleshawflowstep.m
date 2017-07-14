function [wnew, deltaw, wregular, norm] = heleshawflowstep(w,density,cent)
%heleshawflowstep
%  Generates a single step of the flow (unlikely to be called directly)
%  INPUTS
%    w          a vector of complex points
%    density    the density of the flow
%    cent       complex number for the center of the flow
%  OUTPUTS
%    wnew       the new vector of complex points
%    deltaw     ??
%    wregular   ??
%    norm       ??

p = polygon(w);
n = length(w);
g= density;



% compute the schwarz map and get the prevertices
% First crate the tption to turn of waitbar
opt = scmapopt('TraceSolution','off');


%get the diskmap, center it and get its prevertices
f= diskmap(p,opt);


f = center(f,cent);
z = prevertex(f);
wnew=f(z);

% computing the norm of f
eta=evaldiff(f,cent);
norm=abs(eta);

% computing wregular
phi=linspace(0,2*pi,9);
phi=phi(1:8);
phi=phi-angle(eta);
wregular=f(exp(i*phi));

% compute v, the vector of normals
w2 = wnew - circshift(wnew,-1);
v = i.*(w2)./abs(w2);



theta = unwrap(angle(z));


zplus2 = exp((i/2).*(theta + unwrap(circshift(theta,-1))));
zplus1 = exp((i/4).*(3*theta + unwrap(circshift(theta,-1))));
zminus1 = exp((i/4).*(3*theta + unwrap(circshift(theta,1))-2*pi));
zminus2 = exp((i/2).*(theta + unwrap(circshift(theta,1))-2*pi));


A1=((ones(n,1)./(g(f(zplus1)).*abs(evaldiff(f,zplus1)))) + ones(n,1)./(g(f(zplus2)) .* abs(evaldiff(f,zplus2)))).*v;
A2=((ones(n,1)./(g(f(zminus1)) .* abs(evaldiff(f,zminus1)))) + ones(n,1)./(g(f(zminus2)) .* abs(evaldiff(f,zminus2)))).*circshift(v,1);


deltaw = (1/4).*(A1+A2);

end

