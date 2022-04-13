function NVCP_wb_vol2surf_rcm(inmetric,inmesh,output,inwhite,inpial,goodvoxel,surfinroi)
%% transform volume to surface with ribbon constrained methods
%%
if ~exist('goodvoxel','var')
    goodvoxel = [];
end
if ~exist('surfinroi','var')
    surfinroi = [];
end
%% correct the surface for dHCP-release 3 data(don't know why) becasue I 
% found something wrong with the surface space between midthick and pial
% and white, so I would take midthick as standard (may not a good way).
% a = gifti(inmesh);
% b = gifti(inwhite);
% c = gifti(inpial);
% d = a.faces;
% e = b.faces;
% f = c.faces;
% g = unique(d-e);
% if length(g) > 1
%     b.faces = d;
%     savename = [inwhite(1:end-9),'_my.surf.gii'];
%     inwhite = savename;
%     gifti_save(b,savename,'ASCII');
% end
% g = unique(d-f);
% if length(g) > 1
%     c.faces = d;
%     savename = [inpial(1:end-9),'_my.surf.gii'];
%     inpial = savename;
%     gifti_save(c,savename,'ASCII');
% end
%% individual space
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
