function w = goldenDCF( k )
% Golden Angle density correction based on Winklemann et. al. IEEE Trans. Med. Imag. 2007;26:68-76
% For re-sorted data, please refer to voronoiDCF or the linear approximation linearDCF!
%
% Input:
%   k - k-space trajectory
%
% Output:
%   w - Density compensation factor for each k-space sample
% 
% Alexander Fyrdahl, 2016

    % Initialize & pre-allocate
    [nSamples, nSpokes] = size(k);
    w = zeros(nSpokes,1);
    goldenRatio = (1+sqrt(5))/2;
        
    % Binet's formula
    fib = @(n) round((goldenRatio.^n-(-1*goldenRatio).^(-1*n))./(2*goldenRatio-1));
    
    % Fast approximation of the n:th Fibonacci number
    %fib = @(n) floor(goldenRatio.^n/sqrt(5)+0.5);

    % Angular density correction
    % --------------------------
    
    n = 1; while fib(n)<nSpokes;n=n+1;end;n = n-1;    
    m = nSpokes - fib(n); % Distance to next Fibonacci-number

    if m==0
        % If nSpokes is a Fibonacci number there are 2 different gaps
        w(1:fib(n-2)) = 1+goldenRatio;
        w(fib(n-2)+1:fibonacci(n-1)) = 2;
        w(fib(n-1)+1:end) = 1+goldenRatio;
    else
        % ...otherwise there are 3 different gaps
        w(1:m) = 1;
        w(nSpokes-m+1:nSpokes) = 1;
        if m<=fib(n-3)
            w(fib(n-2)+1:fib(n-1)) = 2;
            w(m+1:fib(n-2)+m) = 1+goldenRatio;
            w(fib(n-1)+1:fib(n)) = 1+goldenRatio;
        else
            w(m+1:fib(n-1)) = 1+goldenRatio;
            w(fib(n-1)+1:fib(n-2)+m) = 2*goldenRatio;
            w(fib(n-2)+m+1:fib(n)) = 1+goldenRatio;
        end
    end

    w = w/sum(w);
    w = repmat(w', [nSamples 1]);

    % Radial density correction
    % --------------------------
    dk = abs(k(end,1)-k(1,1))/(nSamples-1); % Sampling density in radial direction
    w = w.*abs(k)/dk;
    w(k==0) = 1/4/nSpokes;
    
    w = w./sum(w(:))*(pi*0.5^2); % Scale to FOV
end

