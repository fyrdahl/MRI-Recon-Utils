function [ out ] = isfib( in )
    
    x1 = 5 * in^2 + 4;
    x2 = 5 * in^2 - 4;
    
    if (rem(sqrt(x1), 1) <= eps) || (rem(sqrt(x2), 1) <= eps)
        out = true;
    else
        out = false;
    end
    
end

