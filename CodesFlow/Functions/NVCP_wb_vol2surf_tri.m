function NVCP_wb_vol2surf_tri(inmetric,inmesh,output,surfinroi)
%% transform volume to surface with trilinear methods 
% something wrong when used ribbon constrained approch with dHCP dataset
% so I used trilinear methods instead of ribbon constrained
%% individual space
command = ['wb_command -volume-to-surface-mapping ',inmetric,' ',inmesh,...
    ' ',output,' -trilinear'];    
system(command);
% 
command = ['wb_command -metric-dilate ',output,' ',inmesh,' 10 ',output,' -nearest'];
system(command); 
if ~isempty(surfinroi)
    command = ['wb_command -metric-mask ',output,' ',surfinroi,' ',output];
    system(command); 
end
