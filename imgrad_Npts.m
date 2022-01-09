function [varargout] = imgrad_Npts(A,varargin)
%compute the gradiant of a 2D/3D image
% using 3-point / 5-point numerical differentiation
%
%	[Ax,Ay] = imgrad_Npts(A)
%	[Ax,Ay,Az] = imgrad_Npts(A)
%	[...] = imgrad_Npts(A,N,h)
%   ---------------------------
%
%   Inputs:
%       > A : 2D / 3D image to be processed
%       > N : (optional input) integer, choose between 3 and 5 (default)
%       > h : (optional input) voxel size
%
%   Outputs:
%       > Ax,Ay,Az: gradiant components in x,y,z directions
%
% note: here we didnot yet carefully treat the image edges !
%       the convn uses zero-padded edges.
%
% Yang CHEN 2018.02.27
% Yang CHEN 2020.05.30

narginchk(1,3)

if isempty(varargin)
    derivNpt = [1 -8 0 8 -1];
elseif varargin{1}==3
    h = varargin{2};
    derivNpt = [1 0 -1] ./ (2*h);
elseif varargin{1}==5
    h = varargin{2};
    derivNpt = [1 -8 0 8 -1] ./ (12*h);
else
    error('N must be either 3 or 5');
end

siz = size(A);

if length(siz)==2
    Ax = convn(A,derivNpt,'same');
    Ay = convn(A,derivNpt','same');
    varargout{1} = Ax;
    varargout{2} = Ay;
elseif length(siz)==3
    Ax = convn(A,derivNpt,'same');
    Ay = convn(A,derivNpt','same');
    Az = convn(A,permute(derivNpt,[3,1,2]),'same');
    varargout{1} = Ax;
    varargout{2} = Ay;
    varargout{3} = Az;
end
