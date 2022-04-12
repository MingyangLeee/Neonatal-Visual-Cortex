function NVCP_MSMALL_applyreg_r3_dhcp(subi)
%% apply wrap from individual space to template using wb_command 
% Dependencies: connectome workbench
%%
% preparing folders and files
datainfo = load('~/SubInfo.mat'); % load the subject information
SubInfo = datainfo.subinfo;
SubAnatFolder = ['~/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})]; % subjects' structural output from dHCP pipeline
suboupfolder = ['~/',SubInfo{subi,1},'/DHCP_template40'];
mkdir(suboupfolder);
%% reg2age match
regfile(1) = my_ls([SubAnatFolder,'/xfm/*hemi-left_from-native_to-dhcpSym40*']); % trasform file 
regfile(2) = my_ls([SubAnatFolder,'/xfm/*hemi-right_from-native_to-dhcpSym40*']);
%% warping surfaces and metrics 
hemi = {'hemi-left' 'hemi-right'};
for hi = 1 : 2
%% surface
    surfnames = {'midthickness' 'wm' 'pial'};
    for si = 1 : length(surfnames)
        surfin = my_ls([SubAnatFolder,'/anat/*',hemi{hi},'_',surfnames{si},'.surf.gii']);
        outsphere = ['~/week-40_',hemi{hi},'_space-dhcpSym_dens-32k_sphere.surf.gii']; % sphere surface in template space
        outname = [suboupfolder,'/',hemi{hi},'_',surfnames{si},'.surf.gii'];
        NVCP_wb_surf_reg(surfin{1},regfile{hi},outsphere,outname);  
    end
    % regenerate inflated surface
    surfin = [suboupfolder,'/',hemi{hi},'_midthickness.surf.gii'];
    outinflate = [suboupfolder,'/',hemi{hi},'_inflated.surf.gii'];
    veryinflate = [suboupfolder,'/',hemi{hi},'_very_inflated.surf.gii'];
    command = ['wb_command -surface-generate-inflated ',surfin,' ',outinflate,' ',veryinflate];
    system(command);
end
%% metrics
for hi = 1 : 2 
    metricnames = {'desc-corr_thickness.shape' 'curv.shape' 'myelinmap.shape' 'desc-smoothed_myelinmap.shape'...
        'sulc.shape' 'thickness.shape' 'desc-medialwall_mask.shape'};
    for mi = 1 : length(metricnames)
        inmetric = my_ls([SubAnatFolder,'/anat/*',hemi{hi},'_',metricnames{mi},'.gii']);
        outsphere = ['~/week-40_',hemi{hi},'_space-dhcpSym_dens-32k_sphere.surf.gii']; % sphere surface in template space
        inmidthick = my_ls([SubAnatFolder,'/anat/*',hemi{hi},'_midthickness.surf.gii']);
        outmidthick = [suboupfolder,'/',hemi{hi},'_midthickness.surf.gii'];
        outname = [suboupfolder,'/',hemi{hi},'_',metricnames{mi},'.gii'];
        command =  ['wb_command -metric-resample ',inmetric{1},' ',regfile{hi},' ',outsphere,' ADAP_BARY_AREA ',outname,...
            ' -area-surfs ',inmidthick{1},' ',outmidthick];
        system(command);
    end
end