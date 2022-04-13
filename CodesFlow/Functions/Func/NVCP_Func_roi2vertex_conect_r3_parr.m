function NVCP_Func_roi2vertex_conect_r3_parr(subi)
%% roi2vertex functional connectivity analysis
% change roi and roiname when needed 
%% D400
hem = {'right' 'left'};
% ROIName = 'V1_right';
ROIName = 'V1_left';
suffix = 'FC';
[SubFiles,SubNames] = my_ls('/home/limingyang/WorkSpace/NVCP/Surface_Results/Func');
%% rois and mask
switch ROIName
    case 'V1_right'
        rois_r = NVCP_make_surfroi(ROIName);
        rois_l = 0*rois_r;
    case 'V1_left'
        rois_l = NVCP_make_surfroi(ROIName);
        rois_r = 0*rois_l;
end
versize = size(rois_r,1);
rois = cat(1,rois_r,rois_l); 
empty_gdata{1} = gifti('/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-right_space-dhcpSym_dens-32k_thickness.shape.gii');
empty_gdata{2} = gifti('/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-left_space-dhcpSym_dens-32k_thickness.shape.gii');
%% data and calculate
mkdir(['/home/limingyang/WorkSpace/NVCP/Results/IndividualSurface/',SubNames{subi},'/Func/',ROIName,'_',suffix]);
g_data = gifti([SubFiles{subi},'/Func_surf/fMRI4D_smooth_',hem{1},'.template.func.gii']);
data1 = g_data.cdata;
g_data = gifti([SubFiles{subi},'/Func_surf/fMRI4D_smooth_',hem{2},'.template.func.gii']); 
data2 = g_data.cdata;
data = cat(1,data1,data2);
MaskName = ['whole_',hem{1}];
mask1 = NVCP_make_surfroi(MaskName);
MaskName = ['whole_',hem{2}];
mask2 = NVCP_make_surfroi(MaskName);
mask = cat(1,mask1,mask2);
[r,p] = NVCP_Func_connect_roi(data,rois,mask);
%% separate
for hi = 1 : 2
    empty_gdata{hi}.cdata = r(versize*(hi-1)+1:versize*hi);
    output = ['/home/limingyang/WorkSpace/NVCP/Results/IndividualSurface/',SubNames{subi},'/Func/',ROIName,'_',suffix,'/r_map_',hem{hi},'.func.gii'];       
    gifti_save(empty_gdata{hi},output,'ASCII');
    empty_gdata{hi}.cdata = p(versize*(hi-1)+1:versize*hi);
    output = ['/home/limingyang/WorkSpace/NVCP/Results/IndividualSurface/',SubNames{subi},'/Func/',ROIName,'_',suffix,'/p_map_',hem{hi},'.func.gii'];       
    gifti_save(empty_gdata{hi},output,'ASCII');   
end