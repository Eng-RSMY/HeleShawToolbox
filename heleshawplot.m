function [ ] = heleshawplot( H, varargin )
% heleshawplot: Plot a single step of a heleshawflow object
%
% REQUIRED PARAMETERS
%
%       H       a heleshaw object
%
% OPTIONAL PARAMETERS
%
%       step    the step to plot.  can be a single number of a vector of
%               steps to plot on the same graph (default last step in H)
%
%       visible:  'on' 'off'   make the figure visible on or off
%
%       showdensity:  'on' 'off'   display the density in grayscale
%                                  (default 'on')
%
%       axis: [xmin,xmax,ymin,ymax]  vector of length 4 for the axis of the plot
%                                     (defaults taken from last step in H)
%
%       showcenter: 'on' 'off'      mark the center point of the flow
%
% EXAMPLES
%
% heleshawplot(H)        plots the last frame of the heleshawflow H
%
% heleshawplot(H,'steps',4): plots the 4th frame of the heleshawflow H
%
% heleshawplot(H,'steps',[1,4,8]): plots the 1st, 4th and 8th frame of H



% parse inputs
  p = inputParser;

  %Get the last column of M and make this the default step
  s= size(H.vertices);

  defaultsteps = [s(2)];
  defaultvisible = 'on';
  expectedvisible =  {'on','off'};
  defaultshowdensity = 'on';
  expectedshowdensity =  {'on','off'};
  
  defaultshowcenter = 'on';
  expectedshowcenter =  {'on','off'};
  
  % parse optional inputs
  addRequired(p,'H');
  addOptional(p,'steps',defaultsteps);
  addOptional(p,'visible',defaultvisible, @(x) any(validatestring(x,expectedvisible)));
  addOptional(p,'showdensity',defaultshowdensity, @(x) any(validatestring(x,expectedshowdensity)));
  addOptional(p,'showcenter',defaultshowcenter, @(x) any(validatestring(x,expectedshowcenter)));
  addOptional(p,'axis',1);

  parse(p,H,varargin{:});
  
  % if needed set the axis automatically from the final frame
    axis=zeros(4:1);
  if ismember('axis',p.UsingDefaults)  
    %s = size(H.vertices);
    n = s(2);  % this would better be the last element in steps **fixme**
    w=H.vertices(1:s(1),n);
    a(1) = min(real(w)) - 0.1*(max(real(w))-min(real(w)));
    a(2) = max(real(w)) + 0.1*(max(real(w))-min(real(w)));
    a(3) = min(imag(w)) - 0.1*(max(imag(w))-min(imag(w)));
    a(4) = max(imag(w)) + 0.1*(max(imag(w))-min(imag(w)));
  else
    a=p.Results.axis;
  end
 
  
 v=p.Results.steps;
 l=length(v);
 
    
  %Plotting
%  fig1 = figure('visible', p.Results.visible);
  fig1 = figure;

%  sets the axes 
  set(gca,'Xlim', [a(1) a(2)])
  set(gca,'Ylim', [a(3) a(4)])

 
  
  %Put in the density
  if strcmp(p.Results.showdensity,'on')==1 
    X = linspace(a(1),a(2),100);
    Y = linspace(a(3),a(4),100);
    [X,Y] = meshgrid(X,Y);
    density2=@(x,y) H.density(x+i.*y);
    
    
    cmap = colormap(gray(128));
    cmap = cmap(32:128,1:3);
    colormap(cmap);  
    Z = -log(density2(X,Y));
    if (min(min(Z)) ~= max(max(Z)))       %only plot contour if non-trivial to avoid warnings
        [hC hC] = contourf(X,Y,Z,100);
         set(hC,'LineStyle','none');
    end
  end
  
  hold on;
  
  %plot([0],[0], 'r*');
  
  %Plot the polygon using sctools
  %p=polygon(w);
  %plot(p);
  %for k=1:8
  %plot([0 M.regularpoints(k,1:v(l))]);
  %end
  
  for k=1:l-1
   % get the relevant column
  w=H.vertices(1:s(1),v(k));
  a = max(abs(w))*1.1;
  plot([w ; w(1)]);   
  end
  
 
  
   w=H.vertices(1:s(1),v(l));
   plot([w ; w(1)], 'r');
   
   if (strcmp(p.Results.showcenter,'on')==1)
       plot(real(p.Results.H.center), imag(p.Results.H.center),'*')
   end
end


