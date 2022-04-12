% function NVCP_Func_roi2vertex_conect_r1_parr(subi)
%% define ROIs
clear
hem = {'right' 'left'};
gmask{1} = gifti('~/VOTC34_R.label.gii');
gmask{2} = gifti('~/VOTC34_L.label.gii');
rois{1} = single(gmask{1}.cdata);
rois{2} = single(gmask{2}.cdata); 
roimask = rois{2};roimask(roimask>0)=1;
rois{2} = rois{2}+34;
roi = cat(1,rois{1},rois{2});
FCName = 'VOTC34'; 
%% data and calculate
SubFiles = my_ls('~/Func');
numofsubjects = 407;
parfor subi = 1 : numofsubjects
        g_data = gifti([SubFiles{subi},'/Func_surf/fMRI4D_smooth_',hem{1},'.template.func.gii']);
        data1 = g_data.cdata;
        g_data = gifti([SubFiles{subi},'/Func_surf/fMRI4D_smooth_',hem{2},'.template.func.gii']);
        data2 = g_data.cdata;
        data = cat(1,data1,data2);
        [r,p] = NVCP_Func_connect_roi(data,roi,[]); 
        rr3(:,:,subi) = r;
end
%% 
SI_tempt = load('~/SubInfo.mat');
SubInfo = SI_tempt.subinfo;  
n1 = 1; n2 = 1;
for subi = 1 : 407
    Birth_age = SubInfo{subi,4};
    if Birth_age >= 37    
        rr(:,:,n1) = rr3(:,:,subi);
        rr_info(n1,1) = SubInfo{subi,4}; 
        rr_info(n1,2) = SubInfo{subi,5}; 
        rr_info(n1,3) = SubInfo{subi,6}; 
        n1 = n1 + 1;
    else
        rr_pre(:,:,n2) = rr3(:,:,subi);
        rr_pre_info(n2,1) = SubInfo{subi,4}; 
        rr_pre_info(n2,2) = SubInfo{subi,5}; 
        rr_pre_info(n2,3) = SubInfo{subi,6}; 
        n2 = n2 + 1;       
    end
end
save(['~/FC_connect/',FCName,'.mat'],...
    'rr','rr_info','rr_pre','rr_pre_info','rr3');