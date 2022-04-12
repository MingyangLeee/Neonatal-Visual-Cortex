%% 
clear
hem = {'right' 'left'};
roinames = {'V1' 'VOTC'};
for hi = 1 : 2
    roii = 1;
    MASK = [roinames{roii},'_',hem{hi}];
    rois = NVCP_make_surfroi(MASK);
    for roii = 2 : length(roinames)
        MASK = [roinames{roii},'_',hem{hi}];
        rois = rois + NVCP_make_surfroi(MASK)*roii;
    end
    roi_bi{hi} = rois;
end
roimask = roi_bi{2};roimask(roimask>0)=1;
roi_bi{2} = (roi_bi{2}+length(roinames)).*roimask;
roi = cat(1,roi_bi{1},roi_bi{2});
FCName = 'V1_VOTC';
%% data and calculate
[SubFiles,SubNames] = my_ls('~/Func');
tic
parfor subi = 1 : 407 % 407
        g_data = gifti([SubFiles{subi},'/Func_surf/fMRI4D_smooth_',hem{1},'.template.func.gii']);
        data1 = g_data.cdata;
        g_data = gifti([SubFiles{subi},'/Func_surf/fMRI4D_smooth_',hem{2},'.template.func.gii']);
        data2 = g_data.cdata;
        data = cat(1,data1,data2);
        [r,p] = NVCP_Func_connect_roi(data,roi,[]);        
        rr3(:,:,subi) = r;
%         fprintf(['subject:',num2str(subi)]);
end
toc
%% 
SI_tempt = load('/SubInfo.mat');
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