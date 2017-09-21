function w = linearDCF( k )
% Linear approximation density correction (fast)
%
% Input:
%   k - k-space trajectory
%
% Output:
%   w - Density compensation factor for each k-space sample
% 
% Alexander Fyrdahl, 2016

    % Initialize
    [nSamples, nSpokes] = size(k);

    % Angular density correction
    w = ones(1,nSpokes);

    % Radial density correction
    dk = abs(k(end,1)-k(1,1))/(nSamples-1); % Sampling density in radial direction
    w = w.*abs(k)/dk;
    w(k==0) = 1/4/nSpokes;
    w = w./sum(w(:))*(pi*0.5^2); % Scale to FOV
end

