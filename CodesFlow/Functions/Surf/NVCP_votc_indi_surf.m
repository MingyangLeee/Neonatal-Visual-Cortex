function NVCP_votc_indi_surf(subi)
%% surface part
%% inverse transformatin to individual space
[SubFiles,SubNames] = my_ls('/home/data/dhcp/dhcp-rel-1/derivatives');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
temp_f = my_ls([SubFiles{subi}]);
Sub_age = round(SubInfo{subi,4});
RefImage = my_ls([temp_f{1},'/anat/*T2w_restore_brain.nii.gz']);
DataType = 0;
Input = ['/home/limingyang/WorkSpace/dHCP/Masks/My_ROI/VOTPC_reg05mm/ga_',num2str(Sub_age),'_VOTPC.nii']; % Thicken cortex
Trans0 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w0GenericAffine.mat'];
Trans1 = ['/home/limingyang/WorkSpace/dHCP/D40/Results/T2_reg/',SubNames{subi},'/T2w1InverseWarp.nii.gz'];
mkdir(['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi}]);
OutImage = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/Mask_VOTPC.nii'];
NVCP_ants_Transfinv(RefImage{1},DataType,Input,Trans0,Trans1,OutImage);
%% dilation
outfilename = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/Mask_VOTPC_dilate.nii'];
command = ['wb_command -volume-dilate ',OutImage,' 3 NEAREST ',outfilename];
system(command)
% workbench volume2surface
volfile = outfilename;
reffile = my_ls([temp_f{1},'/anat/Native/*_left_inflated.surf.gii']);
outfilename = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/Sur_VOTPC'];
command_l = ['wb_command -volume-to-surface-mapping ',volfile,' ',reffile{1},' ',...
    outfilename,'_L.shape.gii -trilinear'];
system(command_l);
reffile = my_ls([temp_f{1},'/anat/Native/*_right_inflated.surf.gii']);
command_r = ['wb_command -volume-to-surface-mapping ',volfile,' ',reffile{1},' ',...
    outfilename,'_R.shape.gii -trilinear'];
system(command_r);
%% amendment with surface mask
maskOP = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/MaskedSur_VOTPC'];
% left
Sur_file = my_ls([temp_f{1},'/anat/Native/*left_drawem.label.gii']);
Sur_data = gifti([outfilename,'_L.shape.gii']);
Sur_mask = gifti(Sur_file{1});
data_d = Sur_data.cdata;
data_d(data_d > 0) = 1;
mask_d = Sur_mask.cdata;
mask_l = Sur_mask.labels;
mask_dd = single(mask_d * 0);
lable_in = [2 3 4 6 7 9 10 11 12];
for i = 1 : length(lable_in)
    mask_dd(mask_d==mask_l.key(lable_in(i))) = 1;
end
n_data = mask_dd.*data_d;
Sur_data.cdata = n_data;
gifti_save(Sur_data,[maskOP,'_L.shape.gii']);
% right
Sur_file = my_ls([temp_f{1},'/anat/Native/*right_drawem.label.gii']);
Sur_data = gifti([outfilename,'_R.shape.gii']);
Sur_mask = gifti(Sur_file{1});
data_d = Sur_data.cdata;
data_d(data_d > 0) = 1;
mask_d = Sur_mask.cdata;
mask_l = Sur_mask.labels;
mask_dd = single(mask_d * 0);
lable_in = [2 3 4 6 7 9 10 11 12];
for i = 1 : length(lable_in)
    mask_dd(mask_d==mask_l.key(lable_in(i))) = 1;
end
n_data = mask_dd.*data_d;
Sur_data.cdata = n_data;
gifti_save(Sur_data,[maskOP,'_R.shape.gii']);