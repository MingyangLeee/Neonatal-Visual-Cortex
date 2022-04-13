function NVCP_MSMALL_applyreg_r3_dhcp(subi)
%% apply wrap from individual space to template with wb_command 
% with idividual 
%%
datainfo = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
SubInfo = datainfo.subinfo;
temp_f{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
%% reg2age match
% preparing the folder and file
subfolder = ['/home/limingyang/WorkSpace/NVCP/Surface_Results/MSM/',SubInfo{subi,1},'/DHCP_template40'];
mkdir(subfolder);
regfile(1) = my_ls([temp_f{1},'/xfm/*hemi-left_from-native_to-dhcpSym40*']);
regfile(2) = my_ls([temp_f{1},'/xfm/*hemi-right_from-native_to-dhcpSym40*']);
%% warp all ??? 
hemi = {'hemi-left' 'hemi-right'};
for hi = 1 : 2
%% surface
    surfnames = {'midthickness' 'wm' 'pial'};
    for si = 1 : length(surfnames)
        surfin = my_ls([temp_f{1},'/anat/*',hemi{hi},'_',surfnames{si},'.surf.gii']);
        outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_',hemi{hi},...
            '_space-dhcpSym_dens-32k_sphere.surf.gii'];
        outname = [subfolder,'/',hemi{hi},'_',surfnames{si},'.surf.gii'];
        NVCP_wb_surf_reg(surfin{1},regfile{hi},outsphere,outname);  
    end
    % regenerate inflated surface
    surfin = [subfolder,'/',hemi{hi},'_midthickness.surf.gii'];
    outinflate = [subfolder,'/',hemi{hi},'_inflated.surf.gii'];
    veryinflate = [subfolder,'/',hemi{hi},'_very_inflated.surf.gii'];
    command = ['wb_command -surface-generate-inflated ',surfin,' ',outinflate,' ',veryinflate];
    system(command);
end
%% metric
for hi = 1 : 2 
    metricnames = {'desc-corr_thickness.shape' 'curv.shape' 'myelinmap.shape' 'desc-smoothed_myelinmap.shape'...
        'sulc.shape' 'thickness.shape' 'desc-medialwall_mask.shape'};
    for mi = 1 : length(metricnames)
        inmetric = my_ls([temp_f{1},'/anat/*',hemi{hi},'_',metricnames{mi},'.gii']);
        outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_',hemi{hi},...
            '_space-dhcpSym_dens-32k_sphere.surf.gii'];
        inmidthick = my_ls([temp_f{1},'/anat/*',hemi{hi},'_midthickness.surf.gii']);
        outmidthick = [subfolder,'/',hemi{hi},'_midthickness.surf.gii'];
        outname = [subfolder,'/',hemi{hi},'_',metricnames{mi},'.gii'];
        command =  ['wb_command -metric-resample ',inmetric{1},' ',regfile{hi},' ',outsphere,' ADAP_BARY_AREA ',outname,...
            ' -area-surfs ',inmidthick{1},' ',outmidthick];
        system(command);
    end
end