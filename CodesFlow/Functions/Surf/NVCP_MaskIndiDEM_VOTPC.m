function NVCP_MaskIndiDEM_VOTPC(subi)
%% mask VOTCP with individual Gray matter issure
% read files
[SubFiles,SubNames] = my_ls('/home/data/dhcp/dhcp-rel-1/derivatives');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
temp_f = my_ls([SubFiles{subi}]);
% prepare Gray matter tissue
% volfile = '/home/limingyang/WorkSpace/dHCP/D40/Results/Native/sub-CC00117XX10/Mask_VOTPC.nii';
% % [Indi_tissue,TissName]= my_ls([temp_f{1},'/anat/*_drawem_tissue_labels.nii.gz']); % tissue
% [Indi_tissue,TissName]= my_ls([temp_f{1},'/anat/*_drawem_all_labels.nii.gz']); % DEM labels
% Mask_number = [5:16,22:29,51:56,59:72];
% Des_tissue = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/',TissName{1}];
% copyfile(Indi_tissue{1},Des_tissue);
% [data,VoxDim,Header]=rest_readfile(Des_tissue);
% mask = 0*data;
% for i = 1 : length(Mask_number)
%     mask(data == Mask_number(i)) = 1;
% end
% Mask_file = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/SurfMask.nii'];
% rest_writefile(mask,Mask_file,Header.dim,VoxDim,Header,'double');
% delete(Des_tissue);
% dilation
outfilename = ['/home/limingyang/WorkSpace/dHCP/D40/Results/Native/',SubNames{subi},'/Mask_VOTPC_dilate.nii'];
% command = ['wb_command -volume-dilate ',volfile,' 2 NEAREST ',outfilename,' -data-roi ',Mask_file];
command = ['wb_command -volume-dilate ',volfile,' 2 NEAREST ',outfilename];
system(command)