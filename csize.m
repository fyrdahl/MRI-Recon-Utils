function B = csize(A,varargin)
%  B = CSIZE(A,[sx,sy,...]) or B = CSIZE(A,sx,sy,...)
%  Creates a matrix B which is a copy of A resized around its center. If
%  the target size is bigger than the input, the output matrix is
%  zero-padded around the center. If the target size is smaller than the
%  input matrix, the output matrix is cropped around the center.
%
%  The code operates on each dimension separately, i.e. it is possible to
%  crop one dimension and zero-pad another.
%
%  TODO: The code relies on some really ugly eval-hacks to preserve
%  generality. I would be grateful if someone could suggest a better
%  method.
%
% (c) Alexander Fyrdahl 2018

if nargin < 2
    error('No target size specified!');
end

sz = [];
for ii = 1:nargin-1
    sz = cat(1,sz,varargin{ii});
end
sz = sz(:)';

if numel(sz) > ndims(A)
    sz = sz(1:ndims(A));
    warning('Target size has more dimensions than input data!');
end

dims = numel(sz);

% Do we have to zero-pad? If yes, do so to the largest dimension.
if max(size(A)) < max(sz)
    B = zeros(sz);
    
    m = size(A);
    if length(m) < length(sz)
        m = [m, ones(1,length(s)-length(m))];
    end

    for d=1:dims
        idx{d} = floor(max(sz)/2)+1+ceil(-m(d)/2) : floor(max(sz)/2)+ceil(m(d)/2);
    end

    cmd = 'B(idx{1}';
    for n=2:numel(idx)
        cmd = sprintf('%s,idx{%d}',cmd,n);
    end
    cmd = sprintf('%s)=A;',cmd);
    eval(cmd);
else
    B = A;
end

% Unless we have arrived at our final size, crop it down to size
if ~all(size(B) == sz)
    
    idx = {};
    
    for d = 1:dims
     tmp = (size(B, d) - sz(d))/2;
     idx{d} = ceil(tmp+1:tmp+sz(d));
    end

    if numel(idx) < ndims(B)
        for d = dims+1:ndims(B)
            idx{d} = 1:size(A,d);
        end
    end

    cmd = 'B = B(idx{1}';
    for n=2:numel(idx)
        cmd = sprintf('%s,idx{%d}',cmd,n);
    end
    cmd = sprintf('%s);',cmd);
    eval(cmd);
end
