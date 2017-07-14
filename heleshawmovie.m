function [] = heleshawmovie( H ,varargin)
%heleshawmovie: Creates an avi movie of a heleshawflow object that is saved
%in the current directory

% REQUIRED PARAMETERS: 
%   H a heleshawflow object
%
% OPTIONAL PARAMETERS
%       step    the step to plot.  can be a single number of a vector of
%               steps to plot on the same graph (default to all steps in H)
%
%       showdensity:  'on' 'off'   display the density in grayscale
%                                  (default 'on')
%
%       axis: [xmin,xmax,ymin,ymax]  vector of length 4 for the axis of the plot
%                                     (defaults taken from last step in H)
%
%       showcenter: 'on' 'off'      mark the center point of the flow
%
%       avifile:    name of the avifile to create.  Default is heleshaw.avi
%       

% EXAMPLES
%
% heleshawmovie(H)        creates a movie of the Heleshaw object H called
% heleshaw.avi
%
% implay('heleshaw.avi');                 show the movie
%
% heleshawmovie(H,'steps',[2 5]): plots frames 2 through 5 of the object H
%
% heleshawmovie(H,'filename','test.avi') as above but output to test.avi     

p = inputParser;

  addRequired(p,'H');
  s= size(H.vertices);
  defaultsteps = [1 s(2)];
  defaultshowdensity = 'on';
  expectedshowdensity =  {'on','off'}; 
  defaultshowcenter = 'on';
  expectedshowcenter =  {'on','off'};
  defaultfilename = 'heleshaw.avi';
  addOptional(p,'showdensity',defaultshowdensity, @(x) any(validatestring(x,expectedshowdensity)));
  addOptional(p,'axis',1);
  addOptional(p,'showcenter',defaultshowcenter, @(x) any(validatestring(x,expectedshowcenter)));
  addOptional(p,'steps',defaultsteps);
  addOptional(p,'filename',defaultfilename);

 
  parse(p,H,varargin{:});
  
% Code  

  
    n = s(2);

 
    % if needed set the axis automatically from the final frame
    axis=zeros(4:1);
  if ismember('axis',p.UsingDefaults)  
    w=H.vertices(1:s(1),n);
    
    a(1) = min(real(w)) - 0.1*(max(real(w))-min(real(w)));
    a(2) = max(real(w)) + 0.1*(max(real(w))-min(real(w)));
    a(3) = min(imag(w)) - 0.1*(max(imag(w))-min(imag(w)));
    a(4) = max(imag(w)) + 0.1*(max(imag(w))-min(imag(w)));
  else
    a=p.Results.axis;
  end
    
     
  fig1 = figure;

  set(gca,'Xlim', [a(1) a(2)])
  set(gca,'Ylim', [a(3) a(4)])
  hold on;

%close all;

writerObj = VideoWriter(p.Results.filename);
open(writerObj);

    for k = p.Results.steps(1):p.Results.steps(2)
            heleshawplot(H,'steps',[k],'visible','off','axis',a,'showdensity',p.Results.showdensity,'showcenter',p.Results.showcenter);
    frame = getframe;
    %frame = im2frame(fig1);
   writeVideo(writerObj,frame);
   close all;
    end
close(writerObj);
   close all;
end

