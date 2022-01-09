function [Vrot,varargout] = rotV2XYZ(V,axis,varargin)
%rotate a 3D image along one of the axes X Y Z
%
% [Vrot] = rotV2XYZ(V,axis)
% [Vrot] = rotV2XYZ(V,axis,ang)
% [Vrot] = rotV2XYZ(V,axis,pt1,pt2)
% [Vrot,ang,pt1,pt2] = rotV2XYZ(...)
% ----------------------------------
%
% Inputs:
%   >   V  : input 3D image to be rotated
%   > axis : (scalar) the rotation axis: 1-X, 2-Y, 3-Z
%   >  ang : (optional) if present, defines the rotation angle
%   > pt1,pt2: (optional) the two points that define the rotation angle
%
% Outputs:
%   > Vrot : rotated 3D image
%   >  ang : (optional) rotation angle
%   > pt1,pt2: (optional) the two points defining the rotation angle
%
% written by Yang CHEN
% 2020.04.19
%

narginchk(2,4)

%
[nR,nC,nB] = size(V);

% permute the 3D image according to the rotation axis
switch axis
    case 1
        V = permute(V,[3 2 1]);
    case 2
        V = permute(V,[3 1 2]);
    case 3
        %no need to permute
end
%
switch axis
    case 1
        nz = nR;
    case 2
        nz = nC;
    case 3
        nz = nB;
end

% rotation angle
switch nargin
    case 2
        isl = round(nz/2); %TODO: --> user-defined
        SL = V(:,:,isl);
        figure;imshow(SL);
        [x,y] = ginput2(2);
        hold on;plot(x,y,'or-')
        ang = atan( (y(2)-y(1))/(x(2)-x(1)) ) * 180/pi; %[degree]
    case 3
        ang = varargin{1};
    case 4
        x = varargin{1};
        y = varargin{2};
        ang = atan( (y(2)-y(1))/(x(2)-x(1)) ) * 180/pi; %[degree]
end

% rotation
SL = V(:,:,round(nB/2));
SL = imrotate(SL,ang,'bilinear','loose');
sizROT = size(SL);
sizROT = [sizROT(1), sizROT(2), nz];

fprintf('rotating the image ...');  tic
Vrot = zeros(sizROT,class(V));
for i=1:nz
    SL = V(:,:,i);
    SL = imrotate(SL,ang,'bilinear','loose');
    Vrot(:,:,i) = SL;
end
T=toc;fprintf(['image rotation finished, T=',num2str(T),' seconds\n']);


% permute back into the original dimension order
switch axis
    case 1
        Vrot = permute(Vrot,[3 2 1]);
    case 2
        Vrot = permute(Vrot,[2 3 1]);
    case 3
        %no need to permute
end

% outputs
switch nargout
    case 2
        varargout{1} = ang;
    case 4
        varargout{1} = ang;
        varargout{2} = x;
        varargout{3} = y;
end

end