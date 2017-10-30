function [ out, nCoils ] = coilCompress(in, varargin)
% Coil sensitivites are not orthogonal and spans a lower dimensional space
% than the number of channels. By decomposing the coils into virtual 
% eigencoils we reduce the number of coils needed for the reconstruction
% The lower dimensionality coils will only contain noise and can be
% thresholded.
%
%   INPUT:
%     - in         [nSamples,nSpokes,nCoils]     : Input k-space data
%     - tol        (default 0.05)                : Tolerance for thresholding
%                                          
%   OUTPUT:
%     - out        [nSamples,nSpokes,nCoils]     : Output k-space data
%     - nCoils     scalar                        : Reduced number of coils
%
% Alexander Fyrdahl, 2016

if nargin < 2
    tol = 0.05;
else
    tol = varargin{1};
end

X = reshape(in,size(in,1)*size(in,2),size(in,3));
[~,S,V] = svd(X,'econ'); % If X is m-by-n where  m > n, S is n-by-n.
nCoils = find(diag(S)/S(1)>tol,1,'last');
out = reshape(X*V(:,1:nCoils),size(in,1),size(in,2),nCoils);

% TODO: Could this be done more effectively with k-means clustering?

end