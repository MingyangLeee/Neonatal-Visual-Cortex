function [x_m,y_m,y_std,y_ste] = NVCP_bin_corr(x,y,bin,xx)
if nargin < 4 
    xx = [];
end
if size(y,2) == 1
    [ox,oi] = sort(x,'descend');
    oy = y(oi);
    bin_num = ceil(length(y)/bin);
    bin_l = [1:bin_num:length(y)];
    bin_h = [bin_num:bin_num:length(y)];
    if length(bin_h) < bin
        bin_h(bin) = length(y);
    end
    % mean across x
    for i = 1 : bin
        n = length(oy([bin_l(i):bin_h(i)]));
        x_m(i) = mean(ox([bin_l(i):bin_h(i)]));
        y_m(i) = mean(oy([bin_l(i):bin_h(i)]));
        y_std(i) = std(oy([bin_l(i):bin_h(i)]));
        y_ste(i) = y_std(i)/sqrt(n);
    end
elseif size(y,2)>1 % corrleation in the data now
    [ox,oi] = sort(x,'descend');
    oy = y(oi,:);
    bin_num = ceil(length(y)/bin);
    bin_l = [1:bin_num:length(y)];
    bin_h = [bin_num:bin_num:length(y)];
    if length(bin_h) < bin
        bin_h(bin) = length(y);
    end
    % mean across x
    for i = 1 : bin
        n = length(oy([bin_l(i):bin_h(i)]));
        x_m(i) = mean(ox([bin_l(i):bin_h(i)]));
        yyy = mean(oy([bin_l(i):bin_h(i)],:));
        [r,~] = corr(yyy',xx);
        y_m(i) = r;
    end
end
