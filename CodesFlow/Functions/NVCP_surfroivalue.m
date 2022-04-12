function [surf_mean,surf_std,surf_pattern] = NVCP_surfroivalue(SurfROI,SurfMatrix)
%% darw value from in ROI from a surface
% SurfROI : roi in a surface file
% SurfMatrix: target metrix file
%%
mask_temp = single(SurfROI);
mask = mask_temp * 0;
mask(mask_temp > 0) = 1;
% get data
SurfMat = gifti(SurfMatrix);
b = SurfMat.cdata;
data = single(b);
% roi value
surf_pattern = data(mask == 1);
surf_mean = mean(surf_pattern);
surf_std = std(surf_pattern);
