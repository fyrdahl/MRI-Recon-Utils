function [ out ] = applyDMTX( dmtx, in )

origSize = size(in);
nCoils = size(dmtx,1);
nElements = numel(in)/nCoils;
in = permute(reshape(in,nElements,nCoils),[2 1]);
out = reshape(permute(dmtx*in,[2 1]),origSize);

end

