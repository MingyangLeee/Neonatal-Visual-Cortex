function NVCP_ants_Transf_parr(subi)
%% registering T2w imaging to the age-matched template (Schuh et. al., 2018) by ANTs'SyN
[SubFiles,SubNames] = my_ls('/home/data/dhcp/dhcp-rel-1/derivatives');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
temp_f = my_ls([SubFiles{subi}]);
Sub_age = round(SubInfo{subi,4});
%% T1 and T2
DataType = 0;
Input = my_ls([temp_f{1},'/anat/*T1w_restore_brain.nii.gz']);
RefImage = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean/ga_',num2str(Sub_age),'/template_t2.nii.gz'];
Trans0 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w0GenericAffine.mat'];
Trans1 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w1Warp.nii.gz'];
OutImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/T2/',SubNames{subi},'_T2_Reg.nii.gz'];
NVCP_ants_Transf(RefImage,DataType,Input{1},Trans0,Trans1,OutImage);
Input = my_ls([temp_f{1},'/anat/*T2w_restore_brain.nii.gz']);
OutImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/T1/',SubNames{subi},'_T1_Reg.nii.gz'];
NVCP_ants_Transf(RefImage,DataType,Input{1},Trans0,Trans1,OutImage);
% DWI and FUNC
DataType = 3;
Input = my_ls([temp_f{1},'/dwi/*dwi.nii.gz']);
RefImage = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean2mm/ga_',num2str(Sub_age),'/template_t2.nii'];
Trans0 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w0GenericAffine.mat'];
Trans1 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w1Warp.nii.gz'];
OutImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/DWI/',SubNames{subi},'_DWI_Reg.nii.gz'];
NVCP_ants_Transf(RefImage,DataType,Input{1},Trans0,Trans1,OutImage);
Input = my_ls([temp_f{1},'/func/*task-rest_bold.nii.gz']);
OutImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/FUNC/',SubNames{subi},'_FUNC_Reg.nii.gz'];
NVCP_ants_Transf(RefImage,DataType,Input{1},Trans0,Trans1,OutImage);
% T1/T2
DataType = 0;
Input = my_ls([temp_f{1},'/anat/*T1wdividedbyT2W.nii.gz']);
RefImage = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean/ga_',num2str(Sub_age),'/template_t2.nii.gz'];
Trans0 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w0GenericAffine.mat'];
Trans1 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w1Warp.nii.gz'];
OutImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/T1DT2/',SubNames{subi},'_T1DT2_Reg.nii.gz'];
NVCP_ants_Transf(RefImage,DataType,Input{1},Trans0,Trans1,OutImage);
