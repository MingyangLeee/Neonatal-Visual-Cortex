function [Q1,Q24] = NVCP_FuncPre_Headmotion(subi)
%% preprocessing of the rest-fMRI data for 
% copy file into local place
[SubFiles,SubNames] = my_ls('/home/data/dhcp/dhcp-rel-1/sourcedata');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
temp_f = my_ls([SubFiles{subi}]);
[FunFile,FunName] = my_ls([temp_f{1},'/func/*task-rest_bold.nii.gz']);
FunTemt = ['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/orgdata'];
mkdir(FunTemt);
copyfile(FunFile{1},FunTemt);
command = ['gzip -d ',[FunTemt,filesep,FunName{1}]]; % no java support
system(command);
% filename = gunzip([FunTemt,filesep,FunName{1}]);
delete([FunTemt,filesep,FunName{1}]);
filename = my_ls([FunTemt,filesep]);
%% 4D >> 3D
mkdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/org3D']);
matlabbatch{1}.spm.util.split.vol = filename(1);
matlabbatch{1}.spm.util.split.outdir = {['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/org3D']};
spm_jobman('run',matlabbatch);
clear matlabbatch
%% estimate the headmotion
eh_files  = my_ls(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/org3D']);
matlabbatch{1}.spm.spatial.realign.estimate.data = {eh_files};
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
spm_jobman('run',matlabbatch);
clear matlabbatch
for i = 1 : length(eh_files)
    delete(eh_files{i});
end
eh_txtfile = my_ls(['/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/',SubNames{subi},'/org3D/rp*.txt']);
Q1 = textread(eh_txtfile{1});
Q24 = [Q1, [zeros(1,size(Q1,2));Q1(1:end-1,:)], Q1.^2, [zeros(1,size(Q1,2));Q1(1:end-1,:)].^2];

