function NVCP_wb_vol2surf_rcm(inmetric,inmesh,output,inwhite,inpial,goodvoxel,surfinroi)
%% transform volume to surface with ribbon constrained methods
%%
if ~exist('goodvoxel','var')
    goodvoxel = [];
end
if ~exist('surfinroi','var')
    surfinroi = [];
end
if ~isempty(goodvoxel)
    command = ['wb_command -volume-to-surface-mapping ',inmetric,' ',inmesh,...
        ' ',output,' -ribbon-constrained ',inwhite,' ',inpial,' -volume-roi ',goodvoxel];
else
    command = ['wb_command -volume-to-surface-mapping ',inmetric,' ',inmesh,...
        ' ',output,' -ribbon-constrained ',inwhite,' ',inpial];    
end
system(command);
% 
command = ['wb_command -metric-dilate ',output,' ',inmesh,' 10 ',output,' -nearest'];
system(command); 
if ~isempty(surfinroi)
    command = ['wb_command -metric-mask ',output,' ',surfinroi,' ',output];
    system(command); 
end
