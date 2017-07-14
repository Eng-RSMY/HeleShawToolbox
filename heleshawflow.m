function [H] = heleshawflow(W,varargin)
%heleshawflow:  Performs of a number of steps of the hele Shaw flow either
%               from an initial polygon, or continuing an existing
%               heleshawflow

% REQUIRED PARAMETERS
%       W               either a heleshaw object, or a column of complex numbers forming the initial polygon
%
% OPTIONAL PARAMETERS 
%       showtimes       {'on,'off'} display text after each step with the time taken
%                       for that computation (default 'on')
%       numberofsteps   the number of steps of the heleshaw flow to perform
%                       (default 1)
%
% OPTIONAL PARAMETERS (if W is of type double)
%       density         an anonymous function describing the density of the
%                       flow;
%                       should be real valued and strictly positive else expect errors
%                       (default the constant density identically equal to 1)
%
%       timestep        the size of the discretization of the time variable
%                       (default 0.1))
%
%       center          complex number giving the center of the flow (i.e.  point of injection)
%                       needs to be within the polygon
%                       (default 0)
%

% OUTPUTS
%       H            A heleshaw object (see heleshaw.m classdef)
% 
% 
% EXAMPLES
%       p=transpose([1+i -1+i -1-i 1-i])
%
%       heleshawflow(p) run a single step of the heleshawflow with initial
%                       polygon p
%
%       H=heleshawflow(p,'numberofsteps',10,'timestep',0.2)  run the same
%                       heleshaw flow for 10 steps with a smaller timestep
%                       H.vertices then has 11 columns      
%
%       H=heleshawflow(H,'numberofsteps',20)    add a further 20 steps to H
%                                               so H.vertices now has
%                                               31 columns
%
%       f=@(x) 1+ abs(x).^2;
%       heleshawflow(p,'density',f)   run the heleshawflow with the
%                                     density determined by the function f
%                                     
%                                               
% NOTES
%       there is a small amount of error handling.  if warnings are given
%       the the function should output the steps calculated thus far
%       but the last step(s) should be treated with caution
%
% END OF DOCUMENTATION

% CODE

% Parse inputs

 p = inputParser; 
 addRequired(p,'W');
 addOptional(p,'density','1');
 addOptional(p,'numberofsteps',1);
 addOptional(p,'timestep',0.1);
 addOptional(p,'center',0);
 defaultshowtimes = 'on';
 expectedshowtimes =  {'on','off'};
 addOptional(p,'showtimes',defaultshowtimes, @(x) any(validatestring(x,expectedshowtimes)));
 parse(p,W,varargin{:});

 %parse the inputs differently depending on whether the first is a vector
 %or a heleshawobject
 switch class(W)
    case 'double'
        if ismember('density',p.UsingDefaults) 
            density=@(x) 1; % if not specified then use the default constant density
        else
            density=p.Results.density;
        end
        density;        numberofsteps=p.Results.numberofsteps;
        timestep=p.Results.timestep;
        M = W;     %% initialise the matrix of vertices with the input
        Points = zeros(8,0);  %% initalise the regularpoints with a zero matrix
        Radii = zeros(1,0);   %% initalise the radii with a zero matrix
        center = p.Results.center;
     case 'heleshaw'
        numberofsteps=p.Results.numberofsteps;
        timestep=W.timestep;  %take the timestep from the input object
        density=W.density;    %take the density from the input object
        M=W.vertices;         %take the matrix of vertives from the input object
        center=W.center;      %take the center from the input object
        s=size(M);
        Points=W.regularpoints([1:8],[1:s(2)-1]);  %take all but the last of the regularpoints
        Radii=W.conformalradii([1],[1:s(2)-1]);    %take all but the last of the conformalradii
 end

 % End of parsing inputs
 
 s=size(M);
 n=s(1);
 m=s(2);

 warning('');                             %reset old warnings
 wnew=M(1:n,m);                           %start with the last column of M
 k=m+1;


 
while (k<=m+numberofsteps) && (strcmp(lastwarn,'')==1)
    tic;                                % set timer
    
    [wnew,deltaw, wregular, norm] = heleshawflowstep(wnew,density,center);
    
    wnew = wnew + (1/(2.*pi))*timestep.*deltaw;
    M=[M wnew];                         %add the new column to the matrix M
    Points=[Points transpose(wregular)];           %add the new regular points to Points
    Radii=[Radii norm];                 %add the new norm to Radii
    
    
    elapsedtime=toc;
    if strcmp(p.Results.showtimes,'on')
        fprintf('Step %d of %d completed.  Time taken: %.1f seconds.\n',k-m,numberofsteps,elapsedtime)    
    end
    k=k+1;
end

% Compute the Regular Points and radii for the last step (if there have
% been no warnings so far)
if (strcmp(lastwarn,'')==1)
    [wnew,deltaw, wregular, norm] = heleshawflowstep(wnew,density,center);
    Points=[Points transpose(wregular)];
    Radii=[Radii norm];
end
    
  
% Output the heleshaw object
  H=heleshaw;  
  H.vertices=M;
  H.regularpoints=Points;
  H.conformalradii=Radii;
  H.density=density;
  H.timestep=timestep;
  H.center = center;

end


