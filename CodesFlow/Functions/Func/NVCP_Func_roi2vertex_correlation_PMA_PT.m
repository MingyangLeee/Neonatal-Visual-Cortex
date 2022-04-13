function NVCP_Func_roi2vertex_correlation_PMA_PT(FCName)
%% Batch functional connectivity analysis - averaging surface across age
data = [];
data_pre = [];
hemi = {'right' 'left'};
n1 = 1; n2 = 1;
for hi = 1 : 2
    file_r3 = my_ls('/home/limingyang/WorkSpace/NVCP/Results/IndividualSurface');
    SI_tempt = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
    SubInfo = SI_tempt.subinfo;
    for subi = 1 : 407
        Sub_age = round(SubInfo{subi,5});
        Birth_age = SubInfo{subi,4};
        if Birth_age >= 37
            subgii = gifti([file_r3{subi},'/Func/',FCName,'/r_map_',hemi{hi},'.func.gii']);
            a = subgii.cdata;
            data(:,n1) = a;
            data_info(n1,1) = SubInfo{subi,4};
            data_info(n1,2) = SubInfo{subi,5};
            data_info(n1,3) = SubInfo{subi,6};
            n1 = n1 + 1;
        else
            subgii = gifti([file_r3{subi},'/Func/',FCName,'/r_map_',hemi{hi},'.func.gii']);
            a = subgii.cdata;
            data_pre(:,n2) = a;
            datapre_info(n2,1) = SubInfo{subi,4};
            datapre_info(n2,2) = SubInfo{subi,5};
            datapre_info(n2,3) = SubInfo{subi,6};
            n2 = n2 + 1;            
        end
    end
% correlation r map
xs = data_info(:,2);
xp = data_info(:,3);
roi = mean(data,2);
for v = 1 : size(data,1)
    if roi(v) ~= 0
        r_data = 0.5*log((1+data(v,:))./(1-data(v,:)));
        [r{1}(v,1),p{1}(v,1)] = corr(r_data',xs); 
        [r{2}(v,1),p{2}(v,1)] = corr(r_data',xp); 
    else
        r{1}(v,1) = 0;
        r{2}(v,1) = 0;
        p{1}(v,1) = 1;
        p{2}(v,1) = 1;
    end
end
names = {'xs' 'xp'};
mkdir(['/home/limingyang/WorkSpace/NVCP/Results/WholeSurface/FC/',FCName]);
for i = 1 : 2
fdr_p = p{i}(roi ~= 0); fdr_r = r{i}(roi ~= 0);
fdr = mafdr(fdr_p,'BHFDR',true); % fdr correction
h = fdr < 0.05;
r_fdr = fdr_r.*h;
r_fdr0 = r_fdr(r_fdr ~= 0);
r_fdr_th{i} = min(abs(r_fdr0));
subgii.cdata = r{i};
output = ['/home/limingyang/WorkSpace/NVCP/Results/WholeSurface/FC/',FCName,'/Corr_',names{i},'_',hemi{hi},'.func.gii'];
gifti_save(subgii,output,'ASCII');
command = ['wb_command -set-map-names ',output,' -map 1 correlation'];
save(['/home/limingyang/WorkSpace/NVCP/Results/WholeSurface/FC/Info/Corr_',FCName,'_',names{i},'_',hemi{hi},'_Info.mat'],'data','data_pre','data_info','datapre_info','r_fdr_th','r','p');
end
end