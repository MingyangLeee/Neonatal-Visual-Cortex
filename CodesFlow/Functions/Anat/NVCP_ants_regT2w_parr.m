function NVCP_ants_regT2w_parr(subi)
%% registering T2w imaging to the age-matched template (Schuh et. al., 2018) by ANTs'SyN
[SubFiles,SubNames] = my_ls('/home/data/dhcp/dhcp-rel-1/derivatives');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
temp_f = my_ls([SubFiles{subi}]);
Sub_age = round(SubInfo{subi,4});
FixImage = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean/ga_',num2str(Sub_age),'/template_t2.nii.gz'];
MoveImage = my_ls([temp_f{1},'/anat/*T2w_restore_brain.nii.gz']);
OPImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w'];
mkdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi}]);
NVCP_ants_regT2W(FixImage,MoveImage{1},OPImage);    