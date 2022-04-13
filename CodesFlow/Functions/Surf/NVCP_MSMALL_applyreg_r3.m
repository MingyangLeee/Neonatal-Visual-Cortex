function NVCP_MSMALL_applyreg_r3(subi)
%% apply wrap from individual space to template with wb_command 
% with idividual 
%%
datainfo = load('/home/limingyang/WorkSpace/dHCP/D_R3/documents/SubInfo_r3.mat');
SubInfo = datainfo.subinfo;
temp_f{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
% Subject's age
Sub_age = round(SubInfo{subi,5});
if Sub_age > 44 
    Sub_age = 44;
elseif Sub_age < 36
    Sub_age = 36;
end
%% reg2age match
% preparing the folder and file
regfolder = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/regfile'];
subfolder = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/template',num2str(Sub_age)];
mkdir(subfolder);
regfile{1} = [regfolder,'/left_MSMALL.reg',num2str(Sub_age),'.surf.gii'];
regfile{2} = [regfolder,'/right_MSMALL.reg',num2str(Sub_age),'.surf.gii'];
%% warp all ??? 
hemi = {'hemi-left' 'hemi-right'}; Mhemi = {'L' 'R'};
for hi = 1 : 2
%% surface
    surfnames = {'midthickness' 'wm' 'pial'};
    for si = 1 : length(surfnames)
        surfin = my_ls([temp_f{1},'/anat/*',hemi{hi},'_',surfnames{si},'.surf.gii']);
        outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.sphere.surf.gii'];
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
command = [];
for hi = 1 : 2 
    metricnames = {'desc-corr_thickness.shape' 'curv.shape' 'myelinmap.shape' 'desc-smoothed_myelinmap.shape'...
        'sulc.shape' 'thickness.shape' 'desc-medialwall_mask.shape'};
    for mi = 1 : length(metricnames)
        inmetric = my_ls([temp_f{1},'/anat/*',hemi{hi},'_',metricnames{mi},'.gii']);
        outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.sphere.surf.gii'];
        inmidthick = my_ls([temp_f{1},'/anat/*',hemi{hi},'_midthickness.surf.gii']);
        outmidthick = [subfolder,'/',hemi{hi},'_midthickness.surf.gii'];
        outname = [subfolder,'/',hemi{hi},'_',metricnames{mi},'.gii'];
        command =  ['wb_command -metric-resample ',inmetric{1},' ',regfile{hi},' ',outsphere,' ADAP_BARY_AREA ',outname,...
            ' -area-surfs ',inmidthick{1},' ',outmidthick];
        system(command);
    end
end
%% reg2age40
if Sub_age ~= 40
    Sub_age = 40;
    % preparing the folder and file
    regfolder = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/regfile'];
    subfolder = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/template',num2str(Sub_age)];
    mkdir(subfolder);
    regfile{1} = [regfolder,'/left_MSMALL.reg',num2str(Sub_age),'.surf.gii'];
    regfile{2} = [regfolder,'/right_MSMALL.reg',num2str(Sub_age),'.surf.gii'];
    %% warp all ??? 
    hemi = {'hemi-left' 'hemi-right'}; Mhemi = {'L' 'R'};
    for hi = 1 : 2
    %% surface
        surfnames = {'midthickness' 'wm' 'pial'};
        for si = 1 : length(surfnames)
            surfin = my_ls([temp_f{1},'/anat/*',hemi{hi},'_',surfnames{si},'.surf.gii']);
            outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.sphere.surf.gii'];
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
    command = [];
    for hi = 1 : 2 
        metricnames = {'desc-corr_thickness.shape' 'curv.shape' 'myelinmap.shape' 'desc-smoothed_myelinmap.shape'...
            'sulc.shape' 'thickness.shape' 'desc-medialwall_mask.shape'};
        for mi = 1 : length(metricnames)
            inmetric = my_ls([temp_f{1},'/anat/*',hemi{hi},'_',metricnames{mi},'.gii']);
            outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.sphere.surf.gii'];
            inmidthick = my_ls([temp_f{1},'/anat/*',hemi{hi},'_midthickness.surf.gii']);
            outmidthick = [subfolder,'/',hemi{hi},'_midthickness.surf.gii'];
            outname = [subfolder,'/',hemi{hi},'_',metricnames{mi},'.gii'];
            command =  ['wb_command -metric-resample ',inmetric{1},' ',regfile{hi},' ',outsphere,' ADAP_BARY_AREA ',outname,...
                ' -area-surfs ',inmidthick{1},' ',outmidthick];
            system(command);
        end
    end
end