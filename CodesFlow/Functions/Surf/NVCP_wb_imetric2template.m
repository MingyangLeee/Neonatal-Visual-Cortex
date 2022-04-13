function NVCP_wb_imetric2template(metric,regfile,outsphere,outmetric,inarea,outarea,sufmaskin,outmesh,sufmaskout)
%% transform indivdial
%%
if ~isempty(sufmaskin)
    command = ['wb_command -metric-resample ',metric,' ',regfile,' ',outsphere,' ADAP_BARY_AREA ',...
        outmetric,' -area-surfs ',inarea,' ',outarea,' -current-roi ',sufmaskin];
else 
    command = ['wb_command -metric-resample ',metric,' ',regfile,' ',outsphere,' ADAP_BARY_AREA ',...
        outmetric,' -area-surfs ',inarea,' ',outarea];
end
system(command); 
command = ['wb_command -metric-dilate ',outmetric,' ',outmesh,' 10 ',outmetric,' -nearest'];
system(command);  
command = ['wb_command -metric-mask ',outmetric,' ',sufmaskout,' ',outmetric];
system(command); 