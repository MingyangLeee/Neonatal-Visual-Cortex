function [nx,ny1,ny2,ord] = NVCP_cleardata(x,y1,y2)
%% data clear with 3 std
ord = 1 : length(x);
if nargin == 3
    % y
    data = cat(1,y1,y2);
    dmean = mean(data);
    dstd = std(data);
    d_up = dmean + 3*dstd;
    d_low  = dmean - 3*dstd;
    a = find(y1 > d_up); b = find(y1 < d_low);
    c = [a;b];
    x(c) = []; y1(c) = []; y2(c) = []; ord(c) = [];
    a = find(y2 > d_up); b = find(y2 < d_low);
    c = [a;b];
    x(c) = []; y1(c) = []; y2(c) = []; ord(c) = [];
    % x
    data = x;
    dmean = mean(data);
    dstd = std(data);
    d_up = dmean + 3*dstd;
    d_low  = dmean - 3*dstd;
    a = find(x > d_up); b = find(x < d_low);
    c = cat(1,a,b);
    x(c) = []; y1(c) = []; y2(c) = []; ord(c) = [];
    nx = x; ny1 = y1; ny2 = y2;
elseif nargin == 2
    data = y1;
    dmean = mean(data);
    dstd = std(data);
    d_up = dmean + 3*dstd;
    d_low  = dmean - 3*dstd;
    a = find(y1 > d_up); b = find(y1 < d_low);
    c = cat(1,a,b);
    x(c) = []; y1(c) = []; ord(c) = [];
    % x
    data = x;
    dmean = mean(data);
    dstd = std(data);
    d_up = dmean + 3*dstd;
    d_low  = dmean - 3*dstd;
    a = find(x > d_up); b = find(x < d_low);
    c = [a;b];
    x(c) = []; y1(c) = []; ord(c) = [];
    nx = x; ny1 = y1; ny2 = [];
end