function NVCP_Func2surf_ribbon(subi)
%% register fucntional data into surface 
% functional data in volume should be preprocessed 
%  create ribbon for goodvoxels
%% prepare file
[SubFiles,~] = my_ls('/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/Func');
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
    [pial_d,~,~,Header]=y_ReadAll([TemptFolder,'/',hemi{hi},'.pial.native.nii']);
    white_d(white_d < 0) = 0;
    white_d(white_d > 0) = 1;
    pial_d(pial_d > 0) = 0;
    pial_d(pial_d < 0) = 1;
    ribbon_d{hi} = pial_d.*white_d;
end
    ribbon = ribbon_d{1} + ribbon_d{2};
    y_Write(ribbon,Header,[TemptFolder,'/ribbon2.nii']);
%%
fMRI_d = y_ReadAll(fMRI4D);
fMRI_m = single(mean(fMRI_d,4));
fMRI_s = single(std(fMRI_d,0,4));
y_Write(fMRI_m,Header,[TemptFolder,'/mean.nii']);
y_Write(fMRI_s,Header,[TemptFolder,'/std.nii']);
