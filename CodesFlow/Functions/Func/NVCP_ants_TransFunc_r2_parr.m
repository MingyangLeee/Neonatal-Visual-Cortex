function NVCP_ants_TransFunc_r2_parr(subi)
%% registering T2w imaging to the age-matched template (Schuh et. al., 2018) by ANTs'SyN
[SubFiles,SubNames] = my_ls('/home/limingyang/WorkSpace/dHCP/D300/Surface_Results/Func');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D300/documents/SubInfo_r2.mat');
SubInfo = SI_tempt.SubInfo;
Sub_age = round(SubInfo{subi,6});
% DWI and FUNC
DataType = 3;
RefImage = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean2mm/ga_',num2str(Sub_age),'/template_t2.nii'];
Trans0 = ['/home/limingyang/WorkSpace/dHCP/D300/Results/T2_reg/',SubNames{subi},'/T2w0GenericAffine.mat'];
Trans1 = ['/home/limingyang/WorkSpace/dHCP/D300/Results/T2_reg/',SubNames{subi},'/T2w1Warp.nii.gz'];
Input = [SubFiles{subi},'/Func_volume/rfMRI_dcf_4D.nii'];
OutImage = ['/home/limingyang/WorkSpace/dHCP/D300/Results/FUNC/',SubNames{subi},'/rfMRI_4D_template.nii'];
mkdir(['/home/limingyang/WorkSpace/dHCP/D300/Results/FUNC/',SubNames{subi}]);
NVCP_ants_Transf(RefImage,DataType,Input,Trans0,Trans1,OutImage);