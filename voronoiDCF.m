function w = voronoiDCF( k )
% Density correction for arbitrary k-space trajectories from Voronoi diagrams 
% based on Rasche et. al. IEEE Trans. Med Imag., vol. 18, no 5, pp 385-392, 1999
%
% Note: The code assumes circular k-space FOV, i.e. radial or spiral.
%
% Input:
%   k - k-Space trajectory
%
% Output:
%   w - Density compensation factor for each k-space sample
% 
% Alexander Fyrdahl, 2016

k = squeeze(k);
kSize = size(k);

% Radial imaging means that k-space center is sampled multiple times,
% this redundancy will cause MATLAB's Voronoi function to fail.
[k,~,n]=unique(k);

kxy = [real(k) imag(k)];
[v,c] = voronoin(kxy); % Calculate vertices and center points
w = zeros(1,size(kxy,1));

for j = 1:size(kxy,1)
    
    x = v(c{j},1); 
    y = v(c{j},2);
    
    % Remove vertices outside of unit circle, i.e. x^2 + y^2 > r^2
    ind=find((x.^2 + y.^2)>0.5^2);
    x(ind)=[]; y(ind)=[];
    
    % Calculate area
    lxy = length(x);
    if lxy > 2
        ind=[2:lxy 1];
        a = abs(sum(0.5*(x(ind)-x(:)).*(y(ind)+y(:))));
    else
        a = 0;
    end
    w(j) = a;

end

w = w(n);                                  % Recover duplicates of k-space center
w = reshape(w,kSize(1),kSize(2));          % Reshape to correct dimensions

w(round(kSize(1)/2)+1,:) = 1/8*min(w(:));  % Correct value for the k-space center

% TODO: This could use some improvement, e.g. linear extrapolation, but does it matter?
w(2,:) = w(3,:); w(1,:) = w(2,:); w(end-1,:) = w(end-2,:); w(end,:) = w(end-1,:);

w = w./sum(w(:))*(pi*0.5^2);               % Normalize sum(w(:)) to unit circle