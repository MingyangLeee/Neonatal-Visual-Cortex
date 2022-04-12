function [r,p] = NVCP_Func_connect_roi(data,rois,mask)
%% do functional connectivity analysis between ROI1 to ROI2 or ROI1 to other voxles
% data: time-series data
% rois: single or mulit-rois (index > 0)
% mask: do analysis in the mask
% to speed up, using data insatead of file to reduce the repeated file load
%% variables
if ~exist('mask','var') 
    mask = [];
end
r = [];
p = [];
%% average time-series in rois
a = unique(rois);
for i = 1 : max(a)
    b = rois==i;
    ts_roi = data(b,:);
    ts_roi_m(:,i) = mean(ts_roi,1);
%     ts_roi_std(:,i) = std(ts_roi,0,1);
end
if size(ts_roi_m,2) == 1 % do voxel-based analysis
    for i = 1 : length(mask)
        if mask(i) > 0
            [r(i,1),p(i,1)] = corr(ts_roi_m,data(i,:)','type','Pearson');
            if isnan(r(i,1))
                r(i,1) = 0;
                p(i,1) = 0;     
            end
        else 
            r(i,1) = 0;
            p(i,1) = 0;
        end
    end
elseif size(ts_roi_m,2) > 1 % do rois-based analysis
    for i = 1 : size(ts_roi_m,2)
        for j = 1 : size(ts_roi_m,2)
            if i ~= j
            [r(i,j),p(i,j)] = corr(ts_roi_m(:,i),ts_roi_m(:,j),'type','Pearson');
%                 [r(i,j),p(i,j)] = corr(ts_roi_m(:,i),ts_roi_m(:,j));
                if isnan(r(i,j))
                    r(i,j) = 0;
                    p(i,j) = 0;     
                end
            else
                r(i,j) = 0;
                p(i,j) = 0;    
            end
        end
    end     
end
    
    
