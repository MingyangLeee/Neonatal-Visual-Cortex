function NVCP_batch_transfmri_r3(subi)
%%
[SubSFiles,SubNames] = my_ls('/home/limingyang/WorkSpace/NVCP/Surface_Results/Func');
SubVFiles = my_ls('/home/limingyang/WorkSpace/NVCP/Volume_Results/Func');
SI_tempt = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
SubInfo = SI_tempt.subinfo;
Sub_age = round(SubInfo{subi,5});
if Sub_age > 44 
    Sub_age = 44;
elseif Sub_age < 36
    Sub_age = 36;
end
SufFolder = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2}),'/anat'];
TemptFolder = [SubSFiles{subi},'/Func_tempt'];
mkdir(TemptFolder);
%% volume to surface in quadruple steps: transform, dilate, mask and resample
% inwhite(1) = my_ls([SufFolder,'/*hemi-left_wm.surf.gii']);
% inwhite(2) = my_ls([SufFolder,'/*hemi-right_wm.surf.gii']);
% inpial(1) = my_ls([SufFolder,'/*hemi-left_pial.surf.gii']);
% inpial(2) = my_ls([SufFolder,'/*hemi-right_pial.surf.gii']);
FuncSurfFolder = [SubSFiles{subi},'/Func_surf'];
sufmask(1) = my_ls([SufFolder,'/*hemi-left_desc-medialwall_mask.shape.gii']);
sufmask(2) = my_ls([SufFolder,'/*hemi-right_desc-medialwall_mask.shape.gii']);
inmesh(1) = my_ls([SufFolder,'/*hemi-left_midthickness.surf.gii']);
inmesh(2) = my_ls([SufFolder,'/*hemi-right_midthickness.surf.gii']);
temp_f{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
regfile(1) = my_ls([temp_f{1},'/xfm/*hemi-left_from-native_to-dhcpSym40*']);
regfile(2) = my_ls([temp_f{1},'/xfm/*hemi-right_from-native_to-dhcpSym40*']);
%% transform local properties to template
metrics = {'ALFF' 'fALFF' 'reho'};
hemi = {'left' 'right'}; Mhemi = {'L' 'R'};
for i = 1 : 3
    for hi = 1 : 2
        output = [TemptFolder,'/',metrics{i},'.func.gii'];
        input_nifti = [SubVFiles{subi},'/Func_volume/',metrics{i},'.nii']; 
        NVCP_wb_vol2surf_tri(input_nifti,inmesh{hi},output,sufmask{hi});
%             NVCP_wb_vol2surf_rcm(input_nifti,inmesh{hi},output,inwhite{hi},inpial{hi},...
%         [],sufmask{hi}); 
        % MSMALL:
        input_metric = output; 
        outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-',hemi{hi},...
            '_space-dhcpSym_dens-32k_sphere.surf.gii'];
        outmesh = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-',hemi{hi},...
            '_space-dhcpSym_dens-32k_midthickness.surf.gii'];
        outmetric = [FuncSurfFolder,'/',metrics{i},'_',hemi{hi},'.template.func.gii'];
        outsufmask = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-',hemi{hi},...
            '_space-dhcpSym_dens-32k_desc-medialwall_mask.shape.gii'];
        NVCP_wb_imetric2template(input_metric,regfile{hi},outsphere,outmetric,inmesh{hi},...
            outmesh,sufmask{hi},outmesh,outsufmask);   
    % smooth
        surfroi = ['/home/limingyang/WorkSpace/NVCP/Surface_Results/MSM/',SubNames{subi},'/DHCP_template40/hemi-',...
            hemi{hi},'_desc-medialwall_mask.shape.gii'];
        delete([FuncSurfFolder,'/',metrics{i},'_smooth_',hemi{hi},'.template',num2str(Sub_age),'.func.gii']);
        NVCP_wb_smooth(outmesh,outmetric,...
            [FuncSurfFolder,'/',metrics{i},'_smooth_',hemi{hi},'.template.func.gii'],surfroi,2);
    end
end
%%
rmdir(TemptFolder,'s');