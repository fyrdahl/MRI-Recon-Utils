function [ dmtx, noiseCorr ] = noiseDMTX( noise )
%NOISEDMTX Caluclate the noise decorrelation matrix from the noise adjustment scan
%Noise should be on the form NCol x NLin x NCha
%Alexander Fyrdahl, 2017
        
    
    % First, calculate a noise correlation matrix which is nCoils x nCoils
    n = reshape(noise,numel(noise)/size(noise,length(size(noise))), size(noise,length(size(noise))));
    n = permute(n,[2 1]);
    M = size(n,2);
    noiseCorr = (1/(M-1))*(n*n');
    
    % The noise decorrelation is found to be the lower-triangular Cholesky decomposition of the
    % noise correlation matrix such that dmtx.*noiseCorr is unitary.
    dmtx = inv(chol(noiseCorr,'lower'));
    dmtx = dmtx.*sqrt(2);

end

