function [poreVol,poreCoG,poreDir,poreRatio,poreAng,poreL] = voidprops(CC,ThresAREA,Oim,Ot,ez,varargin)
%VOIDPROPS Measures the properties of voids in an image (3D): porosity, cracks, ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   [poreVol,poreCoG,poreDir,poreRatio0,poreRatio1] = voidprops(CC,ThresAREA,Oim,Ot,ez)
%   [poreVol,poreCoG,poreDir,poreRatio0,poreRatio1] = voidprops(CC,ThresAREA,Oim,Ot,ez,model)
%
%   Inputs:
%              CC: the connected components found in a binary image
%       ThresAREA: the threshold for selecting the voids (> ThresAREA)
%             Oim: the image origin (for transfering the coordinates)
%		      - if the analyzed image is complete, Oim = [1,1,1]
%		      - if only part of the tube is analyzed, Oim = [X0,Y0,Z0], with [X0,Y0,Z0]
%			represent the coordinates of the 1st voxel of the analyzed image over 
%			the initial image
%             Ot:  the origin of the tube coordinates
%             ez:  the tube axis direction expressed in the image coordinates
%                  if Ot=[] and ez=[], the poreDir will not be transformed
%                  into tube-local coordinates, and poreAng will not be
%                  calculated
%             model : string defining the geometrical model for computing aspect ratio
%                     - ellipsoid (defaut)
%                       c/a=sqrt(beta-gamma+alpha)/sqrt(beta-alpha+gamma)
%                       c/b=sqrt(beta-gamma+alpha)/sqrt(alpha-beta+gamma)
%                     - coordinate : (use the coordinates' edges)
%                       c/a=max(height)/max(length)
%                       c/b=max(height)/max(width)
%                     - plate
%                       to be completed
%                     - cylinder
%                       to be completed
%
%   Outputs:
%         poreVol: void volume
%         poreCoG: void center of gravity
%         poreDir: void principal directions in RTZ coordinates ([elongation,largeur,thickness])
%       poreRatio: void aspect ratio 
%                     poreRatio - a nx2 matrix, computed by a geometrical model defined by "model"
%                                 poreRatio(i,1)=c/a;
%                                 poreRatio(i,2)=c/b;   with a>b>c
%	  poreAng: void orientation angle (between void elongation direction and local ez)
%
%   Note:
%       1. poreDir and poreRatio are defined basing on the moment of inertia
%       2. We could compute some useful void angles using poreDir
%
% 21/09/2015 (Y.Chen)
% 13/12/2016 Yang Chen: add an option for choosing whether the poreDir is
% transformed into tube-local coordinates
% 04/07/2017 Yang Chen: add an output for the length of pores
%
disp 'void properties analysing...';

imsize = CC.ImageSize;w=imsize(2);h=imsize(1);d=imsize(3);
X0=Oim(1); Y0=Oim(2); Z0=Oim(3);

tic

% ==== allocate the memory
poreVol=zeros(CC.NumObjects,1);
if(nargout>1);  poreCoG=zeros(CC.NumObjects,3); end
if(nargout>2);  poreDir=zeros(3,3,CC.NumObjects); end
if(nargout>3);  poreRatio=zeros(CC.NumObjects,2); end
if(nargout>4);  poreAng=zeros(CC.NumObjects,1); end
if(nargout>5);  poreL=zeros(CC.NumObjects,3); end


% ==== loop
for i=1:CC.NumObjects
    idx0 = CC.PixelIdxList{i};
    [Y,X,Z] = ind2sub([h,w],idx0);
    poreVol(i) = size(idx0,1);
    if poreVol(i)>=ThresAREA       % tiny pores were neglected with the noise
        
        if(nargout>1)
            
            X=X0+X-1;  Y=Y0+Y-1;  Z=Z0+Z-1;
            poreCoG(i,:) = [mean(X),mean(Y),mean(Z)];
            
              if(nargout>2)
                % inertia tensor about the COG & principal directions
                X=X-poreCoG(i,1);  Y=Y-poreCoG(i,2);  Z=Z-poreCoG(i,3);
                A=sum(Y.^2+Z.^2);  B=sum(X.^2+Z.^2);  C=sum(X.^2+Y.^2);
                D=-1*sum(Z.*Y);  E=-1*sum(Z.*X);  F=-1*sum(Y.*X);
                Itens = [A,F,E;F,B,D;E,D,C];
                [dir,amp]=eig(Itens);

                if ~issorted(diag(amp))     % ensure the eigen things are sorted
            		[useless,I]=sort(diag(amp));amp=amp(:,I);dir=dir(:,I);
                end
                if dir(3,1)<0;  dir=-1.*dir;  end %ensure that the principal vector points to +Z
                if isempty(Ot) && isempty(ez)
                    poreDir(:,:,i) = dir;
                else
                    % 3 principal directions in local rtz coordiantes & angle about theta-axis in theta-z plane
                    [er,et]=LocAxisCalc_v2(Ot,ez,poreCoG(i,:));  Q=[er;et;ez];
                    poreDir(:,:,i) = Q*dir;  % 3 colomns of poreDir represent resp. 3 principal directions
                end
              end      
            
              if(nargout>3)
                [model] = ParseInputs(varargin{:});

                % aspect ratio
                XYZ=dir'*[X Y Z]';
                if strcmp(model,'coordinate')
                    poreRatio(i,1) = (max(XYZ(3,:))-min(XYZ(3,:)))/(max(XYZ(1,:))-min(XYZ(1,:)));
                    poreRatio(i,2) = (max(XYZ(3,:))-min(XYZ(3,:)))/(max(XYZ(2,:))-min(XYZ(2,:)));
                elseif strcmp(model,'plate')
                    disp '"plate" model is not yet implemented!';
                elseif strcmp(model,'cylinder')
                    disp '"cylinder" model is not yet implemented!';
                else
                    poreRatio(i,1) = sqrt((amp(1,1)+amp(2,2)-amp(3,3))/(amp(2,2)+amp(3,3)-amp(1,1)));
                    poreRatio(i,2) = sqrt((amp(1,1)+amp(2,2)-amp(3,3))/(amp(1,1)+amp(3,3)-amp(2,2)));
                end
              end

	      if nargout>4 && (~isempty(Ot) && ~isempty(ez))
                % orientation angle
                poreAng(i) = acos(poreDir(2,1,i)/norm([poreDir(2,1,i),poreDir(3,1,i)]));
          end
          if nargout>5
                % length of pores (04/07/2017)
                poreL(i,:) = [max(XYZ(3,:))-min(XYZ(3,:)), max(XYZ(2,:))-min(XYZ(2,:)), max(XYZ(1,:))-min(XYZ(1,:))];
          end

        end
 
    end
end
toc




%%%
%%% ParseInputs
%%%
function [model] = ParseInputs(varargin)

% default
model = 'ellipsoid';

% Check the number of input arguments.
narginchk(0,1);

% Determine the model from the user supplied string.
switch nargin   
    case 1
        model = varargin{1};
end
model = validatestring(model,{'ellipsoid','coordinate','plate','cylinder'},mfilename,'MODEL',1);

