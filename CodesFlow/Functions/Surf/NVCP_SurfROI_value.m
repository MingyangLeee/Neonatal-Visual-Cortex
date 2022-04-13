function [surf_mean,surf_std,surf_pattern] = NVCP_SurfROI_value(SurfMask,SurfMatrix,Maskindex)
%% darw value from in ROI from a surface
% SurfMask : roi in a surface file
% Surf: target metrix in the same surface as the Surfmask
%%
if nargin < 3
    Maskindex = [];
end
%% get mask 
SurfROI = gifti(SurfMask);
a = SurfROI.cdata;
mask_temp = single(a);
mask = mask_temp * 0;
if isempty(Maskindex)
    mask(mask_temp > 0) = 1;
else
    for i = 1 : length(Maskindex)
        mask(mask_temp == Maskindex(i)) = 1;
    end
end
% get data
SurfMat = gifti(SurfMatrix);
b = SurfMat.cdata;
data = single(b);
% roi value
surf_pattern = data(mask == 1);
surf_mean = mean(surf_pattern);
surf_std = std(surf_pattern);
