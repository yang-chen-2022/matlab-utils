function [varargout] = vecRot2vec(u,v0,tt,varargin)
%Vector(s) rotates to fixed vector(s)
%
%     [u1] = vecRot2vec(u,v0,tt);
%     [u1] = vecRot2vec(u,v0,tt,'vector');
%      [Q] = vecRot2vec(u,v0,tt,'matrix');
%   [Q,u1] = vecRot2vec(u,v0,tt,'all');
%   ---------------------------------------
%
%   Inputs:
%   -------
%       >  u: the vector (1x3) or the list of vector (nx3) to be rotated
%       > v0: the fixed vector (1x3) or the list of the fixed vectors (nx3)
%             about which the vector(s) will be rotated
%       > tt: the rotation angle
%       > op: 'vector' (by default) -> output only the rotated vector(s)
%             'matrix' -> output only the rotation matrix(s)
%                'all' -> output both the rotation matrix(s) and the vector(s)
%
%   Outputs:
%   --------
%       > u1: the rotated vector(s)
%       >  Q: the rotation matrix(s)
%
% 28/02/2017 Yang Chen
%

op = 'vector';
if nargin>3
    op = varargin{1};
end


c = cos(tt);
s = sin(tt);

npts = size(v0,1);

x = v0(:,1);  x = reshape(x,1,1,npts);
y = v0(:,2);  y = reshape(y,1,1,npts);
z = v0(:,3);  z = reshape(z,1,1,npts);

u = permute(u,[3 2 1]);

if strcmp(op,'matrix')
    Q = cat( 1, cat( 2, x.^2*(1-c)+c, x.*y.*(1-c)-z.*s, x.*z.*(1-c)+y.*s ), ...
                cat( 2, x.*y.*(1-c)+z.*s, y.^2.*(1-c)+c, y.*z.*(1-c)-x.*s ), ...
                cat( 2, x.*z.*(1-c)-y.*s, y.*z.*(1-c)+x*s, z.^2.*(1-c)+c ) );
             
    varargout{1} = Q;
    
elseif strcmp(op,'all')
    Q = cat( 1, cat( 2, x.^2*(1-c)+c, x.*y.*(1-c)-z.*s, x.*z.*(1-c)+y.*s ), ...
                cat( 2, x.*y.*(1-c)+z.*s, y.^2.*(1-c)+c, y.*z.*(1-c)-x.*s ), ...
                cat( 2, x.*z.*(1-c)-y.*s, y.*z.*(1-c)+x*s, z.^2.*(1-c)+c ) );
    u1 = cat( 2, Q(1,1,:).*u(:,1,:)+Q(1,2,:).*u(:,2,:)+Q(1,3,:).*u(:,3,:),...
                 Q(2,1,:).*u(:,1,:)+Q(2,2,:).*u(:,2,:)+Q(2,3,:).*u(:,3,:),...
                 Q(3,1,:).*u(:,1,:)+Q(3,2,:).*u(:,2,:)+Q(3,3,:).*u(:,3,:) );
             
    varargout{1} = Q;
    varargout{2} = permute(u1,[3 2 1]);
             
elseif  strcmp(op,'vector')
    u1 = [ (x.^2.*(1-c)+c).*u(:,1,:)+(x.*y.*(1-c)-z.*s).*u(:,2,:)+(x.*z.*(1-c)+y.*s).*u(:,3,:),...
           (x.*y.*(1-c)+z.*s).*u(:,1,:)+(y.^2.*(1-c)+c).*u(:,2,:)+(y.*z.*(1-c)-x.*s).*u(:,3,:),...
           (x.*z.*(1-c)-y.*s).*u(:,1,:)+(y.*z.*(1-c)+x.*s).*u(:,2,:)+(z.^2.*(1-c)+c).*u(:,3,:) ];
 
    varargout{1} = permute(u1,[3 2 1]);
end        



