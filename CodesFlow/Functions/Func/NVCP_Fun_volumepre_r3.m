function NVCP_Fun_volumepre_r3(subi)
%% preprocessing of Functional MRI data of dHCP-3
%
%% prepare files
datainfo = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
SubInfo = datainfo.subinfo;
temp_f{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_fmri_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
% check the bold file
[FunFiles,FunNames] = my_ls([temp_f{1},'/func/*task-rest_desc-preproc_bold.nii.gz']);
FunTemt = ['/home/limingyang/WorkSpace/NVCP/Volume_Results/Func/',SubInfo{subi,1},'/Func_tempt'];
if isfile(['/home/limingyang/WorkSpace/NVCP/Volume_Results/Func/',SubInfo{subi,1},'/Func_volume/rfMRI_dcf_4D.nii'])
    error('fMRI DATA was already done!!!')
end
mkdir(FunTemt);
% copy and gzip: fMRI DATA
copyfile(FunFiles{1},FunTemt);
command = ['gzip -d ',[FunTemt,filesep,FunNames{1}]]; % no java support
system(command);
%% crop data with lowest head motion 
[Data,VoxSize,FileList,Header] = y_ReadAll(FunTemt); % I modified this function to make the reading without rotation in affine matrix !!!
load_tempt = load('/home/limingyang/WorkSpace/NVCP/documents/rfMRI_crop.mat');
crop_range = load_tempt.range{subi};
Data = Data(:,:,:,crop_range);
y_Write(Data,Header,FileList{1});
clear Data;
%% flirt to T2w space
FunVolume = ['/home/limingyang/WorkSpace/NVCP/Volume_Results/Func/',SubInfo{subi,1},'/Func_volume'];
mkdir(FunVolume);
temp_f_ts{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
[T2file,T2name] = my_ls([temp_f_ts{1},'/anat/*desc-restore_T2w.nii.gz']);
copyfile(T2file{1},FunVolume);
command = ['gzip -d ',[FunVolume,filesep,T2name{1}]]; % no java support
system(command);
% reslice the T2 image
InputFile = my_ls([FunVolume,'/*desc-restore_T2w.nii']);
OutputFile = [FunVolume,'/T2w_reslice.nii'];
rest_ResliceImage(InputFile{1},OutputFile,VoxSize,1,'ImageItself');
% flirt 
data_orgspace = my_ls([FunTemt,'/*.nii']);
ref = [FunVolume,'/T2w_reslice.nii'];
trans_mat = my_ls([temp_f{1},'/xfm/*from-bold_to-T2w_mode-image.mat']);
out = [FunVolume,'/rfMRI_T2w.nii.gz'];
command = ['flirt -in ',data_orgspace{1},' -ref ',ref,' -applyxfm -init ',trans_mat{1},' -out ',out];
system(command)
% move file 
rmdir(FunTemt,'s');
mkdir(FunTemt);
copyfile(out,FunTemt);
command = ['gzip -d ',[FunTemt,filesep,'rfMRI_T2w.nii.gz']]; % no java support
system(command);
%% detrend; do it before copy other files in the folder
y_detrend (FunTemt);
%% tissue data
[tissuefile,tissname] = my_ls([temp_f_ts{1},'/anat/*drawem9_dseg.nii.gz']);
copyfile(tissuefile{1},FunTemt);
command = ['gzip -d ',[FunTemt,filesep,tissname{1}]];
system(command);
% brainmask
[maskfile,maskname] = my_ls([temp_f_ts{1},'/anat/*brain_mask.nii.gz']);
copyfile(maskfile{1},FunTemt);
command = ['gzip -d ',[FunTemt,filesep,maskname{1}]];
system(command);
% reslice tissue and brainmask to func data
FunFiles = [FunVolume,'/T2w_reslice.nii'];
tissuefile = my_ls([FunTemt,'/*drawem9_dseg.nii']);
maskfile = my_ls([FunTemt,'/*brain_mask.nii']);
y_Reslice(tissuefile{1},[FunVolume,'/tissue_labels.nii'],VoxSize,0,FunFiles);
y_Reslice(maskfile{1},[FunVolume,'/brainmask.nii'],VoxSize,0,[FunVolume,'/tissue_labels.nii']);
%% nuisance signal
Mask_all = y_Read([FunVolume,'/tissue_labels.nii']);
ROIDef = [];
ROIDef{1} = Mask_all*0; % White matter
ROIDef{1}(Mask_all==3) = 1;
ROIDef{2} = Mask_all*0; % CSF
ROIDef{2}(Mask_all==1) = 1; 
ROIDef{3} = y_Read([FunVolume,'/brainmask.nii']);
ROISignals = y_ExtractROISignal([FunTemt,'_detrend/Detrend_4DVolume.nii'],ROIDef,...
    [FunTemt,'/detrend'],ROIDef{3}, 0, 0, [],0.392);
%% muliti-regress
Q1 = load_tempt.HM_crop{subi};
Q24 = [Q1, [zeros(1,size(Q1,2));Q1(1:end-1,:)], Q1.^2, [zeros(1,size(Q1,2));Q1(1:end-1,:)].^2];
CovariablesDef.polort = 1;
CovariablesDef.CovMat = [Q24,ROISignals];
CovariablesDef.IsAddMeanBack = 1;
y_RegressOutImgCovariates([FunTemt,'_detrend'],CovariablesDef,'cov');
%% ALFF and fALFF
maskfile = [];
AResultFilename{1} = [FunVolume,'/ALFF.nii'];
AResultFilename{2} = [FunVolume,'/fALFF.nii'];
y_alff_falff([FunTemt,'_detrendcov/CovRegressed_4DVolume.nii'],0.392, 0.08, 0.01,maskfile,AResultFilename);
%% filter 0.01-0.08  
y_bandpass([FunTemt,'_detrendcov'],0.392, 0.08, 0.01,1,maskfile);
%% reho
y_reho([FunTemt,'_detrendcov_filtered'],27,[],[FunVolume,'/reho.nii'],0,maskfile,0.392);
%% clean the files
try
    rmdir(FunTemt,'s');
    rmdir([FunTemt,'_detrend'],'s');
    rmdir([FunTemt,'_detrendcov'],'s');
    movefile([FunTemt,'_detrendcov_filtered/Filtered_4DVolume.nii'],[FunVolume,'/rfMRI_dcf_4D.nii']);
    rmdir([FunTemt,'_detrendcov_filtered'],'s');
end
