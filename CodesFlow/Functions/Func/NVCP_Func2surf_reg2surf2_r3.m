function NVCP_Func2surf_reg2surf2_r3(subi)
%% register fucntional data into surface without goodvoxel estimation
% functional data in volume should be preprocessed 
% reg2surf
%% prepare files
[SubFiles,SubNames] = my_ls('/home/limingyang/WorkSpace/NVCP/Volume_Results/Func');
fMRI4D = [SubFiles{subi},'/Func_volume/rfMRI_dcf_4D.nii'];
SI_tempt = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
SubInfo = SI_tempt.subinfo;
Sub_age = round(SubInfo{subi,5});
if Sub_age > 44 
    Sub_age = 44;
elseif Sub_age < 36
    Sub_age = 36;
end
%% surface files
SufFolder = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2}),'/anat'];
hemi = {'left' 'right'};
% inwhite(1) = my_ls([SufFolder,'/*hemi-left_wm.surf.gii']);
% inwhite(2) = my_ls([SufFolder,'/*hemi-right_wm.surf.gii']);
% inpial(1) = my_ls([SufFolder,'/*hemi-left_pial.surf.gii']);
% inpial(2) = my_ls([SufFolder,'/*hemi-right_pial.surf.gii']);
%% volume to surface in quadruple steps: transform, dilate, mask and resample
FuncSurfFolder = ['/home/limingyang/WorkSpace/NVCP/Surface_Results/Func/',SubInfo{subi,1},'/Func_surf'];
if isfile([FuncSurfFolder,'/fMRI4D_smooth_right.template',num2str(Sub_age),'.func.gii'])
    error('fun2surface done already!!!')
else
    mkdir(FuncSurfFolder);
end
sufmask(1) = my_ls([SufFolder,'/*hemi-left_desc-medialwall_mask.shape.gii']);
sufmask(2) = my_ls([SufFolder,'/*hemi-right_desc-medialwall_mask.shape.gii']);
inmesh(1) = my_ls([SufFolder,'/*hemi-left_midthickness.surf.gii']);
inmesh(2) = my_ls([SufFolder,'/*hemi-right_midthickness.surf.gii']);
temp_f{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
regfile(1) = my_ls([temp_f{1},'/xfm/*hemi-left_from-native_to-dhcpSym40*']);
regfile(2) = my_ls([temp_f{1},'/xfm/*hemi-right_from-native_to-dhcpSym40*']);
for hi = 1 : 2
    output = [FuncSurfFolder,'/fMRI4D_',hemi{hi},'.native.func.gii'];
    NVCP_wb_vol2surf_tri(fMRI4D,inmesh{hi},output,sufmask{hi});
%     NVCP_wb_vol2surf_rcm(fMRI4D,inmesh{hi},output,inwhite{hi},inpial{hi},...
%         [],sufmask{hi});  
    % MSMALL:
    outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-',hemi{hi},...
            '_space-dhcpSym_dens-32k_sphere.surf.gii'];
    outmesh = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-',hemi{hi},...
            '_space-dhcpSym_dens-32k_midthickness.surf.gii'];
    outmetric = [FuncSurfFolder,'/fMRI4D_',hemi{hi},'.template.func.gii'];
    outsufmask = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-',hemi{hi},...
            '_space-dhcpSym_dens-32k_desc-medialwall_mask.shape.gii'];
    NVCP_wb_imetric2template(output,regfile{hi},outsphere,outmetric,inmesh{hi},...
        outmesh,sufmask{hi},outmesh,outsufmask);   
% smooth
    surfroi = ['/home/limingyang/WorkSpace/NVCP/Surface_Results/MSM/',SubNames{subi},'/DHCP_template40/hemi-',...
        hemi{hi},'_desc-medialwall_mask.shape.gii'];
    NVCP_wb_smooth(outmesh,[FuncSurfFolder,'/fMRI4D_',hemi{hi},'.template.func.gii'],...
        [FuncSurfFolder,'/fMRI4D_smooth_',hemi{hi},'.template.func.gii'],surfroi,2);
end