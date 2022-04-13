function NVCP_Func2surf(subi)
%% register fucntional data into surface 
% functional data in volume should be preprocessed 
% have to be seperated into three part: ribbon goodvoxels and reg2surf
%% prepare file
[SubFiles,SubNames] = my_ls('/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/Func');
fMRI4D = [SubFiles{subi},'/Func_volume/rfMRI_dcf_4D.nii'];
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
Sub_age = round(SubInfo{subi,4});
if Sub_age > 44 
    Sub_age = 44;
elseif Sub_age < 36
    Sub_age = 36;
end
%
temp = my_ls('/home/limingyang/WorkSpace/dHCP/DATA/dhcp1/derivatives');
DataFile = my_ls([temp{subi}]);
TemptFolder = [SubFiles{subi},'/Func_tempt'];
mkdir(TemptFolder);
VolumeFolder = [SubFiles{subi},'/Func_volume'];
SufFolder = [DataFile{1},'/anat/Native'];
%% creat ribbon
hemi = {'left' 'right'}; Mhemi = {'L' 'R'};
inwhite(1) = my_ls([SufFolder,'/*left_white.surf.gii']);
inwhite(2) = my_ls([SufFolder,'/*right_white.surf.gii']);
inpial(1) = my_ls([SufFolder,'/*left_pial.surf.gii']);
inpial(2) = my_ls([SufFolder,'/*right_pial.surf.gii']);
for hi = 1 : 2
    command = ['wb_command -create-signed-distance-volume ',inwhite{hi},...
        ' ',VolumeFolder,'/brainmask.nii',' ',TemptFolder,'/',hemi{hi},'.white.native.nii'];
    system(command);
    command = ['wb_command -create-signed-distance-volume ',inpial{hi},...
        ' ',VolumeFolder,'/brainmask.nii',' ',TemptFolder,'/',hemi{hi},'.pial.native.nii'];
    system(command);
    white_d = y_ReadAll([TemptFolder,'/',hemi{hi},'.white.native.nii']);
    [pial_d,~,~,Header] = y_ReadAll([TemptFolder,'/',hemi{hi},'.pial.native.nii']);
    white_d(white_d < 0) = 0;
    white_d(white_d > 0) = 1;
    pial_d(pial_d > 0) = 0;
    pial_d(pial_d < 0) = 1;
    ribbon_d{hi} = pial_d.*white_d;
end
    ribbon = ribbon_d{1} + ribbon_d{2};
    y_Write(ribbon,Header,[TemptFolder,'/ribbon2.nii']);
%% creating good voxels; not necessary 
command = ['fslmaths ',fMRI4D,' -Tmean ',TemptFolder,'/mean -odt float'];
system(command);
command = ['fslmaths ',fMRI4D,' -Tstd ',TemptFolder,'/std -odt float'];
system(command);
command = ['fslmaths ',TemptFolder,'/mean -div ',TemptFolder,'/std ',TemptFolder,'/cov -odt float'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov -mas ',TemptFolder,'/ribbon2 ',TemptFolder,'/cov_ribbon'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_ribbon -div `fslstats ',TemptFolder,'/cov_ribbon -M` '...
    TemptFolder,'/cov_rib_norm'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_rib_norm -bin -s 5 ',TemptFolder,'/smoothnorm'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_rib_norm -s 5 -div ',TemptFolder,...
    '/smoothnorm -dilD ',TemptFolder,'/crns'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov -div `fslstats ',TemptFolder,'/cov_ribbon -M` '...
    '-div ',TemptFolder,'/crns ',TemptFolder,'/cov_norm_mod'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_norm_mod -mas ',TemptFolder,'/ribbon2 ',TemptFolder,'/cnmr'];
system(command);
% Indeed -.-!
y = y_ReadAll([TemptFolder,'/cnmr.nii.gz']);
a = find(y~=0); b = y(a); c = mean(b); d = std(b); 
LimUp = c + 0.5*d;
command = ['fslmaths ',TemptFolder,'/mean -bin ',TemptFolder,'/mask'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_norm_mod -thr ',num2str(LimUp),...
    ' -bin -sub ',TemptFolder,'/mask -mul -1 ',VolumeFolder,'/goodvoxels'];
system(command);
%% volume to surface in quadruple steps: transform, dilate, mask and resample
FuncSurfFolder = [SubFiles{subi},'/Func_surf'];
mkdir(FuncSurfFolder);
sufmask(1) = my_ls([SufFolder,'/*left_roi.shape.gii']);
sufmask(2) = my_ls([SufFolder,'/*right_roi.shape.gii']);
inmesh(1) = my_ls([SufFolder,'/*left_midthickness.surf.gii']);
inmesh(2) = my_ls([SufFolder,'/*right_midthickness.surf.gii']);
regfile{1} = ['/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/MSM/',SubNames{subi},...
    '/regfile/left_MSMALL.reg.surf.gii'];
regfile{2} = ['/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/MSM/',SubNames{subi},...
    '/regfile/right_MSMALL.reg.surf.gii'];
for hi = 1 : 2
    output = [FuncSurfFolder,'/fMRI4D_',hemi{hi},'.native.func.gii'];
    NVCP_wb_vol2surf_rcm(fMRI4D,inmesh{hi},output,inwhite{hi},inpial{hi},...
        [VolumeFolder,'/goodvoxels.nii.gz'],sufmask{hi});  
    % MSMALL:
    outsphere = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.sphere.surf.gii'];
    outmesh = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.midthickness.surf.gii'];
    outmetric = [FuncSurfFolder,'/fMRI4D_',hemi{hi},'.template.func.gii'];
    outsufmask = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.',Mhemi{hi},'.roi.shape.gii'];
    NVCP_wb_imetric2template(output,regfile{hi},outsphere,outmetric,inmesh{hi},...
        outmesh,sufmask{hi},outmesh,outsufmask);   
% smooth
    surfroi = ['/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/MSM/',SubNames{subi},...
    '/template/',hemi{hi},'_roi.shape.gii'];
    NVCP_wb_smooth(outmesh,[FuncSurfFolder,'/fMRI4D_',hemi{hi},'.template.func.gii'],...
        [FuncSurfFolder,'/fMRI4D_smooth_',hemi{hi},'.template.func.gii'],surfroi,2);
end
%% clear up
rmdir(TemptFolder,'s');