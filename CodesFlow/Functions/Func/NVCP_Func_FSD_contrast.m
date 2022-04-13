function [t,p,t_fdr_th] = NVCP_Func_FSD_contrast(FCNames)
%% Batch functional connectivity analysis - averaging surface across age
switch FCNames{1}(5)
    case 'l'
        saven = 'left';
    case 'r'
        saven = 'right';
end
for hi = 1 : 2
data = [];
data_pre = [];
hemi = {'right' 'left'};
n1 = 1; n2 = 1;
file_r3 = my_ls('/home/limingyang/WorkSpace/NVCP/Results/IndividualSurface');
SI_tempt = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
SubInfo = SI_tempt.subinfo;
for subi = 1 : 407
    Birth_age = SubInfo{subi,4};
    if Birth_age >= 37
        for fi = 1 : length(FCNames)
            subgii = gifti([file_r3{subi},'/Func/',FCNames{fi},'/r_map_',hemi{hi},'.func.gii']);
            a = subgii.cdata;
            data{fi}(:,n1) = a;
            data_info(n1,1) = SubInfo{subi,4};
            data_info(n1,2) = SubInfo{subi,5};
            data_info(n1,3) = SubInfo{subi,6};
        end
            n1 = n1 + 1;
    else
        for fi = 1 : length(FCNames)
            subgii = gifti([file_r3{subi},'/Func/',FCNames{fi},'/r_map_',hemi{hi},'.func.gii']);
            a = subgii.cdata;
            data_pre{fi}(:,n2) = a;
            datapre_info(n2,1) = SubInfo{subi,4};
            datapre_info(n2,2) = SubInfo{subi,5};
            datapre_info(n2,3) = SubInfo{subi,6};
        end
            n2 = n2 + 1;    
    end
end
save(['/home/limingyang/WorkSpace/NVCP/Results/AveragedSurface/DataInfo/Contrast_',hemi{hi},'_Info.mat'],'data','data_pre','data_info','datapre_info');
% contrst T test 
roi = mean(data{1},2);
for v = 1 : size(data{1},1)
    if roi(v) ~= 0
        t_data1 = 0.5*log((1+data{1}(v,:))./(1-data{1}(v,:)));
        t_data2 = 0.5*log((1+data{2}(v,:))./(1-data{2}(v,:)));
        [~,p(v,1),~,stats] = ttest(t_data1,t_data2);
        t(v,1) = stats.tstat;
    else
        p(v,1) = 1;
        t(v,1) = 0;
    end
end
fdr_p = p(roi ~= 0); fdr_t = t(roi ~= 0);
fdr = mafdr(fdr_p,'BHFDR',true); % fdr correction
h = fdr < 0.05;
t_fdr = fdr_t.*h;
t_fdr0 = t_fdr(t_fdr ~= 0);
t_fdr_th = min(abs(t_fdr0));
subgii.cdata = t;
output = ['/home/limingyang/WorkSpace/NVCP/Results/Contrast/FSD/Tempt/Con_',saven,'_',hemi{hi},'.func.gii'];
gifti_save(subgii,output,'ASCII');
command = ['wb_command -set-map-names ',output,' -map 1 contrast'];
% maskout VOTC
Hem = {'R','L'};
votc = gifti(['/home/limingyang/WorkSpace/dHCP/Masks/HCPS1200/MMP_MASK/subregions/VOTC15_',Hem{hi},'_binary.label.gii']);
votc_mask = single(votc.cdata); votc_mask(votc_mask > 0) = 1;
t_mask = t; t_mask(votc_mask == 1) = 0;
subgii.cdata = t_mask;
output = ['/home/limingyang/WorkSpace/NVCP/Results/Contrast/FSD/Tempt/Con_',saven,'_mask_',hemi{hi},'.func.gii'];
gifti_save(subgii,output,'ASCII');
command = ['wb_command -set-map-names ',output,' -map 1 contrast_mask'];
system(command);
save(['/home/limingyang/WorkSpace/NVCP/Results/Contrast/FSD/Tempt/',saven,'_ttest_info',hemi{hi},'.mat'],'t','p','t_fdr_th');
end