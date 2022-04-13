function NVCP_MMP2INDI(subi)
%% transform MMP mask to indivudal space
%%
insphere{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.R.sphere.32k_fs_LR.surf.gii';
insphere{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.L.sphere.32k_fs_LR.surf.gii';
inmidthick{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii';
inmidthick{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii';
hemi = {'right' 'left'}; HEMI = {'R' 'L'};
%
[Files,~] = my_ls('/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/MSM');
OrgFiles = my_ls('/home/limingyang/WorkSpace/dHCP/DATA/dhcp1/derivatives');
TempFile = my_ls(OrgFiles{subi});
SurfFolder = [TempFile{1},'/anat/Native'];
%
files{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/MNISpace/VOTC15_R.label.gii';
files{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/MNISpace/VOTC15_L.label.gii';
resfolder = [Files{subi},'/Template2Indi'];
mkdir(resfolder);
for hi = 1 : 2
    inmetric = [files{hi}];
    regfile = [Files{subi},'/regfile/',hemi{hi},'_MSMALL.reg.surf.gii'];
    outmidthick = my_ls([SurfFolder,'/*_',hemi{hi},'_midthickness.surf.gii']);
    outname = [resfolder,'/VOTC_indi_',HEMI{hi},'.label.gii'];
    command =  ['wb_command -label-resample ',inmetric,' ',insphere{hi},' ',regfile,' ADAP_BARY_AREA ',outname,...
        ' -area-surfs ',inmidthick{hi},' ',outmidthick{1}];
    system(command);
%     volumespace = '/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/Func/sub-CC00099AN18/Func_volume/brainmask.nii';
%     outvolume = [resfolder,'/VOTC_indi_',HEMI{hi},'.nii'];
%     command = ['wb_command -label-to-volume-mapping ',outname,' ',...
%         outmidthick{1},' ',volumespace,' ',outvolume,' -nearest-vertex 3'];   
%     system(command);
end