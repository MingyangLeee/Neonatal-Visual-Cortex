function NVCP_FunPreprocessing(subi)
%% preprocessing of Functional MRI data
%
%% prepare file
[FunFiles,FunNames] = my_ls('/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/FUNC');
[~,SubNames] = my_ls('/home/data/dhcp/dhcp-rel-1/sourcedata');
FunTemt = ['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/reg_data'];
mkdir(FunTemt);
copyfile(FunFiles{subi},FunTemt);
% filename = gunzip([FunTemt,filesep,FunNames{subi}]);
command = ['gzip -d ',[FunTemt,filesep,FunNames{subi}]]; % no java support
system(command);
delete([FunTemt,filesep,FunNames{subi}]);
%% detrend
y_detrend (FunTemt);
%% nuisance signal
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
Sub_age = round(SubInfo{subi,4});
Mask_all = y_Read(['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean2mm/ga_',num2str(Sub_age),'/tissues.nii']);
ROIDef = [];
ROIDef{1} = Mask_all*0; % White matter
ROIDef{1}(Mask_all==3) = 1;
ROIDef{2} = Mask_all*0; % CSF
ROIDef{2}(Mask_all==1) = 1; % Global
% maskfile = ['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean2mm/ga_',num2str(Sub_age),'/mask.nii'];
ROIDef{3} = y_Read(['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean2mm/ga_',num2str(Sub_age),'/mask.nii']);
ROISignals = y_ExtractROISignal([FunTemt,'_detrend/Detrend_4DVolume.nii'],ROIDef,...
    [FunTemt,'/detrend'],ROIDef{3}, 0, 0, [],0.392);
%% muliti-regress
maskfile = [];
eh_txtfile = my_ls(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/org3D/rp*.txt']);
Q1 = textread(eh_txtfile{1});
Q24 = [Q1, [zeros(1,size(Q1,2));Q1(1:end-1,:)], Q1.^2, [zeros(1,size(Q1,2));Q1(1:end-1,:)].^2];
CovariablesDef.CovMat = [Q24,ROISignals];
CovariablesDef.IsAddMeanBack = 1;
y_RegressOutImgCovariates([FunTemt,'_detrend'],CovariablesDef,'cov');
%% ALFF and fALFF
mkdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/local']);
AResultFilename{1} = ['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/local/ALFF.nii'];
AResultFilename{2} = ['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/local/fALFF.nii'];
y_alff_falff([FunTemt,'_detrendcov/CovRegressed_4DVolume.nii'],0.392, 0.08, 0.01,maskfile,AResultFilename);
%% filter 0.01-0.08  
y_bandpass([FunTemt,'_detrendcov'],0.392, 0.08, 0.01,1,maskfile);
%% reho
y_reho([FunTemt,'_detrendcov_filtered'],27,[],...
    ['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/local/reho.nii'],0,maskfile,0.392);
%% arrange the files
try
    mkdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/parameters']);
    movefile(eh_txtfile{1},['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/parameters']);
    rmdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/org3D'],'s');
    rmdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/orgdata'],'s');
    ROIfiles = my_ls(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/reg_data/*.mat']);
    for i = 1 : length(ROIfiles)
        movefile(ROIfiles{i},['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/parameters']);
    end
    rmdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/reg_data_detrend'],'s');
    rmdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/reg_data'],'s');
end