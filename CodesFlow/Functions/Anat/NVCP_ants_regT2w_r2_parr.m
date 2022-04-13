function NVCP_ants_regT2w_r2_parr(subi)
%% registering T2w imaging to the age-matched template (Schuh et. al., 2018) by ANTs'SyN
[SubFiles,SubNames] = my_ls('/home/limingyang/WorkSpace/dHCP/DATA/dhcp2/dhcp_anat_pipeline');
temp_f = my_ls([SubFiles{subi}],'dir');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D300/documents/SubInfo_r2.mat');
SubInfo = SI_tempt.SubInfo;
subid = cell2mat(SubInfo(:,1));
a = find(subid == subi);
% Subject's age, if outof the range of the template, using cloest one
Sub_age = round(SubInfo{a,6});
if Sub_age > 44 
    Sub_age = 44;
elseif Sub_age < 36
    Sub_age = 36;
end
[MoveImage,movename] = my_ls([temp_f{1},'/anat/*desc-restore_T2w.nii.gz']);
[MaskImage,maskname] = my_ls([temp_f{1},'/anat/*bet_space-T2w_brainmask.nii.gz']);
AnatTemt = ['/home/limingyang/WorkSpace/dHCP/D300/Results/T2_reg/',SubNames{subi}];
mkdir(AnatTemt);
copyfile(MoveImage{1},AnatTemt);
command = ['gzip -d ',[AnatTemt,filesep,movename{1}]]; % no java support
system(command);
copyfile(MaskImage{1},AnatTemt);
command = ['gzip -d ',[AnatTemt,filesep,maskname{1}]]; % no java support
system(command);
%%
datafile = my_ls([AnatTemt,'/*desc-restore_T2w.nii']);
[Data,~,~,Header] = y_ReadAll(datafile{1});
maskfile = my_ls([AnatTemt,'/*bet_space-T2w_brainmask.nii']);
mask = y_ReadAll(maskfile{1});
T2_bet = Data.*mask;
Movefile = [AnatTemt,'/T2w_Bet.nii'];
y_Write(T2_bet,Header,Movefile);
%%
FixImage = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean/ga_',num2str(Sub_age),'/template_t2.nii.gz'];
OPImage = ['/home/limingyang/WorkSpace/dHCP/D300/Results/T2_reg/',SubNames{subi},'/T2w'];
mkdir(['/home/limingyang/WorkSpace/dHCP/D300/Results/T2_reg/',SubNames{subi}]);
NVCP_ants_regT2W(FixImage,Movefile,OPImage);    