function [coord,coef] = findOffset3D(f,B,coord0,sD)
%find the 3D offset of a small 2D/3D image f relative to a large 3D image B
%
%   [coord,coef] = findOffset3D(f,B,coord0,sD)
%   -----------------------------------------
%
%   Inputs:
%       -      f : the feature image (2D/3D)
%       -      B : the target image (its dimension must be larger than f)
%       - coord0 : initial guess of the coordinates of f in B  ("x, y, z")
%       -     sD : search domain ("x, y, z")
%
%   Outputs:
%       -  coord : the optimal coord of f relative to B ("x, y, z")
%       -   coef : the corresponding correlation coefficient
%                  an optimal correlation gives a values close to zero
%
%   Note: the precision is at voxel level, cross correlation function is
%   used for searching the best offset.
%
% Yang CHEN 2019.01.17

% voxel-wise searching
f = f - mean(f(:));
sizW(1) = size(f,1)-1; %for saving time in the loop
sizW(2) = size(f,2)-1;
sizW(3) = size(f,3)-1;

tic
fprintf('calculating the optimal coordinates...\n')
coef = 1;
offset = coord0.*0;
for i=-sD(1):sD(1)
    for j=-sD(2):sD(2)
        for k=-sD(3):sD(3)
            % gray level map in the deformed config. (only translation)
            g = B(coord0(2)+j:coord0(2)+sizW(1)+j, ...
                  coord0(1)+i:coord0(1)+sizW(2)+i, ...
                  coord0(3)+k:coord0(3)+sizW(3)+k);
            g = g - mean(g(:));
            % compute the correlation coefficient (cross correlation)
            tmp = f.*g;
            tmp = 1 - sum(tmp(:))/sqrt(sum(f(:).^2)*sum(g(:).^2));
            % update the correl. coef. and the corresponding position
            if tmp<coef
                coef = tmp;
                offset(1)=i;
                offset(2)=j;
                offset(3)=k;
            end
        end
    end
end
% optimal coord
coord = coord0 + offset;
T=toc;
fprintf(['completed, time consumed = ',num2str(T),' seconds\n'])