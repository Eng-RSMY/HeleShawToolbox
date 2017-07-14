classdef heleshaw
%HELESHAW object to contain all relevant data from a heleshaw flow
%
% vertices   A matrix with numberofsteps columns.
%             Each column is the vector of complex points that give the polygon
%             at that step

% conformalradii a vector with entries [c_0 ... c_n] calculated as follows:
%                if f_m is the conformal map from the unit disc to the
%                polygon with defined at the mth step with f_m(0)=center and f'_m(0)>0 then c_m = |f'_m(0)|
% regularpoints  a matrix with 8 rows whose (j,m) entry is given by f_m(e^(2*pi (j-1)/8)

% density        the density function used for the flow
% timestep       the timestep used for the flow  
% center         the point of injection used for the flow
%                                    
    
    properties
        vertices
        regularpoints
        conformalradii
        density
        timestep
        center
    end
    
    methods
    end
    
end

