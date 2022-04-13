function NVCP_MSM_reg_parr_r3(subi)
%% run MSM registration for each of the subject (D300 version)
% subi = subject id 
% add continue function in this script 20211006
%% prepare files
datainfo = load('/home/limingyang/WorkSpace/dHCP/D_R3/documents/SubInfo_r3.mat');
SubInfo = datainfo.subinfo;
temp_f{1} = ['/home/limingyang/WorkSpace/dHCP/DATA/dhcp3/rel3_dhcp_anat_pipeline',...
    '/sub-',SubInfo{subi,1},'/ses-',num2str(SubInfo{subi,2})];
% Subject's age
Sub_age = round(SubInfo{subi,5});
if Sub_age > 44 
    Sub_age = 44;
elseif Sub_age < 36
    Sub_age = 36;
end
%% check the results
if ~isfile(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',...
        SubInfo{subi,1},'/regfile/right_MSMALL.reg40.surf.gii'])
    if isfolder(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc'])
        rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc'],'s');
        rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel'],'s');
        rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv'],'s'); 
    end
%% reg 2 age-matched template
% preparing the folders
mkdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc']);
mkdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel']);
mkdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv']);
% defining the surface space
inmesh(1) = my_ls([temp_f{1},'/anat/*hemi-left_sphere.surf.gii']);
inmesh(2) = my_ls([temp_f{1},'/anat/*hemi-right_sphere.surf.gii']);
refmesh{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.sphere.surf.gii'];
refmesh{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.sphere.surf.gii'];
% config = '/home/limingyang/WorkSpace/dHCP/Extension/MSM_HOCR_v2/MSM_strain_config_2018';
config = [];
% firstly using sulc informaiton
indata(1) = my_ls([temp_f{1},'/anat/*hemi-left_sulc.shape.gii']);
indata(2) = my_ls([temp_f{1},'/anat/*hemi-right_sulc.shape.gii']);
refdata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.sulc.shape.gii'];
refdata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.sulc.shape.gii'];
output{1} = ['/home/limingyang/WorkSpace/dHCP/D_R3//Surface_Results/MSM/',SubInfo{subi,1},'/sulc/L.'];
output{2} = ['/home/limingyang/WorkSpace/dHCP/D_R3//Surface_Results/MSM/',SubInfo{subi,1},'/sulc/R.'];
NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config);
NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config);
% secondly using myelin information
trans{1} = [output{1},'sphere.reg.surf.gii'];
trans{2} = [output{2},'sphere.reg.surf.gii'];
indata(1) = my_ls([temp_f{1},'/anat/*hemi-left_myelinmap.shape.gii']);
indata(2) = my_ls([temp_f{1},'/anat/*hemi-right_myelinmap.shape.gii']);
refdata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.MyelinMap.func.gii'];
refdata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.MyelinMap.func.gii'];
output{1} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel/L.'];
output{2} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel/R.'];
NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config,trans{1});
NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config,trans{2});
% thirdly using curvature information
trans{1} = [output{1},'sphere.reg.surf.gii'];
trans{2} = [output{2},'sphere.reg.surf.gii'];
indata(1) = my_ls([temp_f{1},'/anat/*hemi-left_curv.shape.gii']);
indata(2) = my_ls([temp_f{1},'/anat/*hemi-right_curv.shape.gii']);
refdata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.curvature.shape.gii'];
refdata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.curvature.shape.gii'];
output{1} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv/L.'];
output{2} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv/R.'];
NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config,trans{1});
NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config,trans{2});
% movefiles
regfolder = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/regfile'];
mkdir(regfolder);
movefile([output{1},'sphere.reg.surf.gii'],[regfolder,'/left_MSMALL.reg',num2str(Sub_age),'.surf.gii']);
command = ['wb_command -set-structure ',[regfolder,'/left_MSMALL.reg',num2str(Sub_age),'.surf.gii'],' CORTEX_LEFT'];
system(command);
movefile([output{2},'sphere.reg.surf.gii'],[regfolder,'/right_MSMALL.reg',num2str(Sub_age),'.surf.gii']);
command = ['wb_command -set-structure ',[regfolder,'/right_MSMALL.reg',num2str(Sub_age),'.surf.gii'],' CORTEX_RIGHT'];
system(command);
% clear files
rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc'],'s');
rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel'],'s');
rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv'],'s');
%% reg to age40
if Sub_age ~= 40
    Sub_age = 40;
    mkdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc']);
    mkdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel']);
    mkdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv']);
    % defining the surface space
    inmesh(1) = my_ls([temp_f{1},'/anat/*hemi-left_sphere.surf.gii']);
    inmesh(2) = my_ls([temp_f{1},'/anat/*hemi-right_sphere.surf.gii']);
    refmesh{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.sphere.surf.gii'];
    refmesh{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.sphere.surf.gii'];
    % config = '/home/limingyang/WorkSpace/dHCP/Extension/MSM_HOCR_v2/MSM_strain_config_2018';
    config = [];
    % firstly using sulc informaiton
    indata(1) = my_ls([temp_f{1},'/anat/*hemi-left_sulc.shape.gii']);
    indata(2) = my_ls([temp_f{1},'/anat/*hemi-right_sulc.shape.gii']);
    refdata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.sulc.shape.gii'];
    refdata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.sulc.shape.gii'];
    output{1} = ['/home/limingyang/WorkSpace/dHCP/D_R3//Surface_Results/MSM/',SubInfo{subi,1},'/sulc/L.'];
    output{2} = ['/home/limingyang/WorkSpace/dHCP/D_R3//Surface_Results/MSM/',SubInfo{subi,1},'/sulc/R.'];
    NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config);
    NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config);
    % secondly using myelin information
    trans{1} = [output{1},'sphere.reg.surf.gii'];
    trans{2} = [output{2},'sphere.reg.surf.gii'];
    indata(1) = my_ls([temp_f{1},'/anat/*hemi-left_myelinmap.shape.gii']);
    indata(2) = my_ls([temp_f{1},'/anat/*hemi-right_myelinmap.shape.gii']);
    refdata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.MyelinMap.func.gii'];
    refdata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.MyelinMap.func.gii'];
    output{1} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel/L.'];
    output{2} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel/R.'];
    NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config,trans{1});
    NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config,trans{2});
    % thirdly using curvature information
    trans{1} = [output{1},'sphere.reg.surf.gii'];
    trans{2} = [output{2},'sphere.reg.surf.gii'];
    indata(1) = my_ls([temp_f{1},'/anat/*hemi-left_curv.shape.gii']);
    indata(2) = my_ls([temp_f{1},'/anat/*hemi-right_curv.shape.gii']);
    refdata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.L.curvature.shape.gii'];
    refdata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(Sub_age),'.R.curvature.shape.gii'];
    output{1} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv/L.'];
    output{2} = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv/R.'];
    NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config,trans{1});
    NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config,trans{2});
    % movefiles
    regfolder = ['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/regfile'];
    mkdir(regfolder);
    movefile([output{1},'sphere.reg.surf.gii'],[regfolder,'/left_MSMALL.reg',num2str(Sub_age),'.surf.gii']);
    command = ['wb_command -set-structure ',[regfolder,'/left_MSMALL.reg',num2str(Sub_age),'.surf.gii'],' CORTEX_LEFT'];
    system(command);
    movefile([output{2},'sphere.reg.surf.gii'],[regfolder,'/right_MSMALL.reg',num2str(Sub_age),'.surf.gii']);
    command = ['wb_command -set-structure ',[regfolder,'/right_MSMALL.reg',num2str(Sub_age),'.surf.gii'],' CORTEX_RIGHT'];
    system(command);
    % clear files
    rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc'],'s');
    rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel'],'s');
    rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv'],'s');
end
elseif isfile(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',...
        SubInfo{subi,1},'/regfile/right_MSMALL.reg40.surf.gii'])
    if isfolder(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc'])
        rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/sulc'],'s');
        rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/myel'],'s');
        rmdir(['/home/limingyang/WorkSpace/dHCP/D_R3/Surface_Results/MSM/',SubInfo{subi,1},'/curv'],'s'); 
    end
end