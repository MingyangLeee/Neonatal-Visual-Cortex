function NVCP_wb_surf_reg(surfin,insphere,outsphere,outname)

command = ['wb_command -surface-resample ',surfin,' ',insphere,' ',outsphere,' BARYCENTRIC ',outname];
system(command);