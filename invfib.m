function [ i ] = invfib( f )
%   INVFIB(X) returns the order of the Fibonacci number closest to X.
%   Alexander Fyrdahl, 2018

    if f < 2
        i = f;
    else
        phi = (1+sqrt(5))/2;
        i = round(log(f * sqrt(5))/log(phi));
    end
end

