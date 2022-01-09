function C = kron_npts(a,b)
%kronecker product between two vectors at many points (npts)
%
%   B = kron_manypts(a,b)
%   ---------------------
%
%   Inputs:
%     > a : npts x n matrix
%     > b : npts x m matrix
%
%   Outputs:
%     > C : the product result
%
%   Yang Chen 2020.05.30
%
n = size(a,2);
m = size(b,2);
npts = size(a,1);

C = zeros(n,m,npts);

for i=1:n
    for j=1:m
        C(i,j,:) = a(:,i).*b(:,j);
    end
end
