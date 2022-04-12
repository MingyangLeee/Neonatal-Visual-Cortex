% Batch drawing measures in the ventral mask
%% draw differnt measures 
clear
hem = {'left' 'right'};
ROIPool = {'V34' 'VOTC' 'V1'};
folders = ['the output from Batch01 with all inidvidual folders'];
for roii = 1 : 3
for hemi = 1 : 2
roifilename = [ROIPool{roii},'_',hem{hemi}];
SurfROI = NVCP_make_surfroi(roifilename);
for m = 1 : 2
    n1 = 1; n2 = 1;
    file_r3 = my_ls(folders);
    SI_tempt = load('~/SubInfo.mat');
    SubInfo = SI_tempt.subinfo;    
    measures = {'desc-corr_thickness' 'myelinmap'};
    for subi = 1 : length(file_r3)
        Birth_age = SubInfo{subi,4};
        Sub_age = round(SubInfo{subi,5});
        if Birth_age >= 37
            SurfMatrix = [file_r3{subi},'/DHCP_template40/hemi-',hem{hemi},'_',measures{m},'.shape.gii'];
            data(n1,m) = NVCP_surfroivalue(SurfROI,SurfMatrix);
            datainfo(n1,1) = SubInfo{subi,4}; 
            datainfo(n1,2) = SubInfo{subi,5};
            datainfo(n1,3) = SubInfo{subi,6}; 
            n1 = n1 + 1;
        else
            SurfMatrix = [file_r3{subi},'/DHCP_template40/hemi-',hem{hemi},'_',measures{m},'.shape.gii'];
            data_pre(n2,m) = NVCP_surfroivalue(SurfROI,SurfMatrix);
            datainfo_pre(n2,1) = SubInfo{subi,4}; 
            datainfo_pre(n2,2) = SubInfo{subi,5}; 
            datainfo_pre(n2,3) = SubInfo{subi,6}; 
            n2 = n2 + 1;
        end
    end
end
save(['~/Anat/',roifilename,'.mat'],'data','data_pre','datainfo','datainfo_pre');
end
end