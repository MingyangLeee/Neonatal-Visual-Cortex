function NVCP_wb_smooth(refsurf,metric,output,surfroi,fwhm)
%% 
if ~isempty(surfroi)
    command = ['wb_command -metric-smoothing ',refsurf,' ',metric,' ',num2str(fwhm),' ',output,' -roi ',surfroi];
else
    command = ['wb_command -metric-smoothing ',refsurf,' ',metric,' ',num2str(fwhm),' ',output];
end
    system(command);
