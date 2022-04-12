%% Batch processing of anatomical data in the surface
%% right hemisphere
clear
data = [];
data_pre = [];
folders = ['the output from Batch01 with all inidvidual folders'];
for m = 1 : 2
    file = my_ls(folders);
    SI_tempt = load('~/SubInfo.mat');
    SubInfo = SI_tempt.subinfo;
    measures = {'desc-corr_thickness.shape' 'myelinmap.shape'};
    ni = ones([1,10]);
    ni_pre = ni;
    for subi = 1 : length(files)
        Sub_age = round(SubInfo{subi,5});
        Birth_age = SubInfo{subi,4};
        if Birth_age >= 37
            subgii = gifti([file{subi},'/DHCP_template40/hemi-right_',measures{m},'.gii']);
            a = subgii.cdata;
            data{m}{Sub_age-35}(:,ni(Sub_age-35)) = a;
            ni(Sub_age-35) = ni(Sub_age-35) + 1;
        else
            subgii = gifti([file{subi},'/DHCP_template40/hemi-right_',measures{m},'.gii']);
            a = subgii.cdata;
            data_pre{m}{Sub_age-35}(:,ni_pre(Sub_age-35)) = a;
            ni_pre(Sub_age-35) = ni_pre(Sub_age-35) + 1;            
        end
    end
end
%% save gii files across ages
roi_gii = gifti('~/VOTC34_R_binary.label.gii');
a = single(roi_gii.cdata);
a(a>0)=1;
roi = a;
res_file = ['~'];
mkdir(res_file);
measures = {'thickness' 'myelin'};
% informaiton of data and preterm data
for i = 1 : length(data{1})
    DataInfo(i).ages = 35 + i;
    if ~isempty(data{1}{i})
        DataInfo(i).subn_term = size(data{1}{i},2);
    end
end
for i = 1 : length(data_pre{1})
    if ~isempty(data_pre{1}{i})
        DataInfo(i).subn_preterm = size(data_pre{1}{i},2);
    end    
end
%
for m = 1 : 2
    mkdir([res_file,'/term/',measures{m}]);
    mkdir([res_file,'/preterm/',measures{m}]);
    for ai = 1 : 10
        % term
        tempt = data{m}{ai};
        output1 = [res_file,'/term/',measures{m},'/Age_',num2str(ai + 35),'_right_',measures{m},'.shape.gii'];
        if ~isempty(tempt)
            gii_mean = mean(tempt,2);
            gii_mean = gii_mean.*roi;
            subgii.cdata = gii_mean;
            gifti_save(subgii,output1,'ASCII');
            command = ['wb_command -set-map-names ',output1,' -map 1 ',measures{m},num2str(ai+35)];
            system(command);
        end
        % preterm
        if ai ~= 10
        tempt = data_pre{m}{ai};
        output2 = [res_file,'/preterm/',measures{m},'/Age_',num2str(ai + 35),'_right_',measures{m},'.shape.gii'];
        if ~isempty(tempt)
            gii_mean = mean(tempt,2);
            subgii.cdata = gii_mean;
            gifti_save(subgii,output2,'ASCII');
            command = ['wb_command -set-map-names ',output2,' -map 1 ',measures{m},num2str(ai+35)];
            system(command);
        end   
        end
    end
end
%%
load('~/DataInfo_anat.mat'); % The output from Batch02_surf_average_left
DATA.right_term = data;
DATA.right_preterm = data_pre;
save('~/DataInfo_anat.mat','DataInfo','DATA');