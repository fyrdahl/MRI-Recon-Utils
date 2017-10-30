function w = areaDCF( k, varargin )
% Area based density correction
%
% Input:
%   k - k-space trajectory
%   angles - azimuthal angles of the radial trajectory [optional]
%
% Output:
%   w - Density compensation factor for each k-space sample
% 
% Alexander Fyrdahl, 2017


    % Initialize
    [nSamples, nSpokes] = size(k);

    % Assume linear distribution if no parameter is passed
    if nargin < 2
        angles = linspace(0,pi,nSpokes);
        if mod(angles,2)
            angles = angles*2;
        end
    else
        angles = varargin{1};
        angles = angles(:)';
    end
    
    % Angular density correction
    beta = sort(angles,'ascend');
    beta = [beta(end)-pi beta beta(1)+pi];
    d = zeros(1,numel(beta)-2);
    for i = 2:numel(beta)-1
        d(i) = abs(beta(i+1)-beta(i-1))/2;
    end
    w = squeeze(d(2:end));


    % Radial density correction
    dk = abs(k(end,1)-k(1,1))/(nSamples-1); % Sampling density in radial direction
    w = (repmat(w,[nSamples, 1]).*abs(k))/dk;
    w(k==0) = 1/4/nSpokes;

    w = w./sum(w(:))*(pi*0.5^2); % Scale to FOV

end
