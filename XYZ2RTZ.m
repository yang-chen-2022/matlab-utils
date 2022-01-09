function [ R,THETA,Z ] = XYZ2RTZ( C,ex,ey,ez,X,Y,Z )
%FROM X-Y-Z COORDINATES (Image-Global) TO R-THETA-Z COORDINATES (Tube-Local)
%
%   [ R,THETA,Z ] = XYZ2RTZ( C,ex,ey,ez,X,Y,Z )
%
% Inputs:
%   - C: the tube-local coordinates' origin (Image-Global)
%   - ex,ey,ez: the tube-local axis (Image-Global)
%   - X,Y,Z: XYZ coordinates
%
% Outputs:
%   - R,THETA,Z: RTZ coordinates

% Z = (M - C)*ez';
% 
% Mp = Z*ez + C;
% 
% MpM = M - Mp;
% 
% R = norm(MpM);
% 
% costheta = ex*MpM'/R;
% 
% % if costheta > 1.; costheta=1; end
% % if costheta < -1.; costheta=-1; end
% 
% ang_M_y = ey*MpM';
% 
% if ang_M_y>0; THETA = acos(costheta); end
% if ang_M_y<=0; THETA = 2*pi-acos(costheta); end
% THETA = real(THETA);
% 
% end

X=double(X); Y=double(Y); Z=double(Z);

Z = [X-C(1) Y-C(2) Z-C(3)]*ez';

Mp = Z*ez;
Mp = [Mp(:,1)+C(1) Mp(:,2)+C(2) Mp(:,3)+C(3)];

MpM = [X Y Z] - Mp;

R = sqrt(sum(MpM.*MpM,2));

costheta = ex*MpM'./R';

ang_M_y = ey*MpM';

THETA = R.*0;
idx0=(ang_M_y>0);  idx1=(ang_M_y<=0);
THETA(idx0) = acos(costheta(idx0));
THETA(idx1) = 2*pi-acos(costheta(idx1));
THETA = real(THETA);

end