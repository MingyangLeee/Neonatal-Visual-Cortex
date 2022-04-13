function NVCP_Func_roi2vertex_connect_meanage_r3(FCName)
%% Batch functional connectivity analysis - averaging surface across age
data = [];
data_pre = [];
hemi = {'right' 'left'};
Hemi = {'R' 'L'};
ni = ones([1,10]);
ni_pre = ni;
for hi = 1 : 2
    file_r3 = my_ls('/home/limingyang/WorkSpace/NVCP/Results/IndividualSurface');
    SI_tempt = load('/home/limingyang/WorkSpace/NVCP/documents/SubInfo_r3.mat');
    SubInfo = SI_tempt.subinfo;
    for subi = 1 : 407
        Sub_age = round(SubInfo{subi,5});
        Birth_age = SubInfo{subi,4};
        if Birth_age >= 37
            subgii_l = gifti([file_r3{subi},'/Func/',FCName,'/r_map_',hemi{hi},'.func.gii']);
            a = subgii_l.cdata;
            data{Sub_age-35}(:,ni(Sub_age-35)) = a;
            ni(Sub_age-35) = ni(Sub_age-35) + 1;
        else
            subgii_l = gifti([file_r3{subi},'/Func/',FCName,'/r_map_',hemi{hi},'.func.gii']);
            a = subgii_l.cdata;
            data_pre{Sub_age-35}(:,ni_pre(Sub_age-35)) = a;
            ni_pre(Sub_age-35) = ni_pre(Sub_age-35) + 1;            
        end
    end
    %% save gii files across ages
    % roi
    for i = 1 : 10
        roi_gii = gifti(['/home/limingyang/WorkSpace/dHCP/Masks/Bozek2018/week-40_hemi-left_space-dhcpSym_dens-32k_myelinmap.shape.gii']);
        roi{i} = roi_gii.cdata;
        roi{i}(roi{i}>0) = 1;
    end
    res_file = '/home/limingyang/WorkSpace/NVCP/Results/AveragedSurface';
    % informaiton of data and preterm data
    mkdir([res_file,'/term/',FCName]);
    mkdir([res_file,'/preterm/',FCName]);
    for ai = 2 : 10
        % term
        tempt = data{ai};
        output1 = [res_file,'/term/',FCName,'/Age_',num2str(ai + 35),'_',hemi{hi},'_.shape.gii'];
        if ~isempty(tempt)
            gii_mean = mean(tempt,2);
            gii_mean = gii_mean.*roi{ai};
            gii_range(1,ai) = min(gii_mean);
            gii_range(2,ai) = max(gii_mean);
            subgii_l.cdata = gii_mean;
            gifti_save(subgii_l,output1,'ASCII');
            command = ['wb_command -set-map-names ',output1,' -map 1 ',FCName];
            system(command);
        end
        % preterm
        if ai ~= 10
        tempt = data_pre{ai};
        output2 = [res_file,'/preterm/',FCName,'/Age_',num2str(ai + 35),'_',hemi{hi},'_.shape.gii'];
        if ~isempty(tempt)
            gii_mean = mean(tempt,2);
            subgii_l.cdata = gii_mean;
            gii_range_pre(1,ai) = min(gii_mean);
            gii_range_pre(2,ai) = max(gii_mean);
            gifti_save(subgii_l,output2,'ASCII');
            command = ['wb_command -set-map-names ',output2,' -map 1 ',FCName];
            system(command);
        end   
        end
    end
    if hi == 1
        DATA.right_term = data;
        DATA.right_preterm = data_pre;
        DATA.right_range_term = gii_range;
        DATA.right_range_preterm = gii_range_pre;
        save(['/home/limingyang/WorkSpace/NVCP/Results/AveragedSurface/DataInfo/',FCName,'_Info.mat'],'DATA');
    elseif hi == 2
        a = load(['/home/limingyang/WorkSpace/NVCP/Results/AveragedSurface/DataInfo/',FCName,'_Info.mat']);
        DATA = a.DATA;
        DATA.left_term = data;
        DATA.left_preterm = data_pre;
        DATA.left_range_term = gii_range;
        DATA.left_range_preterm = gii_range_pre;  
        save(['/home/limingyang/WorkSpace/NVCP/Results/AveragedSurface/DataInfo/',FCName,'_Info.mat'],'DATA');
    end
end
