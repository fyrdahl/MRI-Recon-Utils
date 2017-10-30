function [ f ] = fib( i )
%   FIB(X) approximates the Xth Fibonacci number with Binet's formula.
    phi = (1+sqrt(5))/2;
    f = floor(phi.^i/sqrt(5)+0.5);
end

