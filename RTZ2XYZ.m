function [ X,Y,Z ] = RTZ2XYZ( C,ex,ey,ez,R,Theta,Z )
%FROM R-THETA-Z COORDINATES (Tube-Local) TO X-Y-Z COORDINATES (Image-Global)
%
%       [ X,Y,Z ] = RTZ2XYZ( C,ex,ey,ez,R,Theta,Z )
%       -------------------------------------------
%
% Inputs:
% -------
%   - C: the tube-local coordinates' origin (Tube-Local)
%   - ex,ey,ez: the tube-local axis (Image-Global)
%   - R,Theta,Z: R-Theta-Z coordinates
%
% Outputs:
% --------
%   - X,Y,Z
% 
% written by Yang Chen 2014-2015
%

%
X = R.*cos(Theta);
Y = R.*sin(Theta);


XYZ=[X,Y,Z];

XYZ = XYZ*[ex;ey;ez];
XYZ = [XYZ(:,1)+C(1) XYZ(:,2)+C(2) XYZ(:,3)+C(3)];

X = XYZ(:,1);
Y = XYZ(:,2);
Z = XYZ(:,3);




end