function NVCP_transHCP2bozek(age)
%% batch transform ROI in MNI space to the surface in Bozek2018
config = [];
% for age = 36 : 44
    mkdir(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/sulc/',num2str(age)]);
    mkdir(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/myelin/',num2str(age)]);
    mkdir(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/curv/',num2str(age)]);
    % defining the surface space
    refmesh{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.L.sphere.32k_fs_LR.surf.gii';
    refmesh{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.R.sphere.32k_fs_LR.surf.gii';
    inmesh{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.L.sphere.surf.gii'];
    inmesh{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.R.sphere.surf.gii'];
    % firstly using sulc informaiton
    refdata{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.L.sulc.shape.gii';
    refdata{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.R.sulc.shape.gii';
    indata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.L.sulc.shape.gii'];
    indata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.R.sulc.shape.gii'];
    output{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/sulc/',num2str(age),'/L.'];
    output{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/sulc/',num2str(age),'/R.'];
    NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config);
    NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config);
    % secondly using myelin information
    trans{1} = [output{1},'sphere.reg.surf.gii'];
    trans{2} = [output{2},'sphere.reg.surf.gii'];
    refdata{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.L.myelinmap.func.gii';
    refdata{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.R.myelinmap.func.gii';
    indata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.L.MyelinMap.func.gii'];
    indata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.R.MyelinMap.func.gii'];
    output{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/myelin/',num2str(age),'/L.'];
    output{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/myelin/',num2str(age),'/R.'];
    NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config,trans{1});
    NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config,trans{2});
    % thirdly using curvature information
    trans{1} = [output{1},'sphere.reg.surf.gii'];
    trans{2} = [output{2},'sphere.reg.surf.gii'];
    refdata{1} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.L.curvature.func.gii';
    refdata{2} = '/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/HCP_S1200_GroupAvg_v1/S1200.R.curvature.func.gii';
    indata{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.L.curvature.shape.gii'];
    indata{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/dHCP.week',num2str(age),'.R.curvature.shape.gii'];
    output{1} = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/curv/',num2str(age),'/L.'];
    output{2} = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/curv/',num2str(age),'/R.'];
    NVCP_MSM_surf(inmesh{1},refmesh{1},indata{1},refdata{1},output{1},config,trans{1});
    NVCP_MSM_surf(inmesh{2},refmesh{2},indata{2},refdata{2},output{2},config,trans{2});
    % movefiles
    regfolder = ['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/RegFiles/',num2str(age)];
    mkdir(regfolder);
    movefile([output{1},'sphere.reg.surf.gii'],[regfolder,'/left_MSMALL.reg.surf.gii']);
    command = ['wb_command -set-structure ',[regfolder,'/left_MSMALL.reg.surf.gii'],' CORTEX_LEFT'];
    system(command);
    movefile([output{2},'sphere.reg.surf.gii'],[regfolder,'/right_MSMALL.reg.surf.gii']);
    command = ['wb_command -set-structure ',[regfolder,'/right_MSMALL.reg.surf.gii'],' CORTEX_RIGHT'];
    system(command);
    % clear files
%     rmdir(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/sulc'],'s');
%     rmdir(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/myelin'],'s');
%     rmdir(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/BozekSpace/curv'],'s');
% end