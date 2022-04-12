%% Batch correlation analysis across all subjects
% whole brain anatomical properties: myelin and thickness
%% preparing data from all subjects
clear
SurfDat = [];
SurfDat_pre = [];
hem = {'right' 'left'};
files = my_ls('the output from Batch01 with all inidvidual folders');
SI_tempt = load('~/SubInfo.mat');
SubInfo = SI_tempt.subinfo;  
savename = {'thickness' 'myelin'};
measures = {'desc-corr_thickness' 'myelinmap'};
for hemi = 1 : 2
    for m = 1 : 2 
    n1 = 1; n2 = 1;
    for subi = 1 : length(files)
        Birth_age = SubInfo{subi,4};
        Sub_age = round(SubInfo{subi,5});
        if Birth_age >= 37
            SurfMatrix = [files{subi},'/DHCP_template40/hemi-',hem{hemi},'_',measures{m},'.shape.gii'];
            SurfMat = gifti(SurfMatrix);
            SurfDat(:,n1) = SurfMat.cdata;
            SurfInfo(n1,1) = SubInfo{subi,4};
            SurfInfo(n1,2) = SubInfo{subi,5};
            SurfInfo(n1,3) = SubInfo{subi,6};
            n1 = n1 + 1;
        else
            SurfMatrix = [files{subi},'/DHCP_template40/hemi-',hem{hemi},'_',measures{m},'.shape.gii'];
            SurfMat = gifti(SurfMatrix);
            SurfDat_pre(:,n2) = SurfMat.cdata;
            SurfInfo_pre(n2,1) = SubInfo{subi,4};
            SurfInfo_pre(n2,2) = SubInfo{subi,5};
            SurfInfo_pre(n2,3) = SubInfo{subi,6};
            n2 = n2 + 1; 
        end
    end
    save(['~/Anat/',savename{m},'_',hem{hemi},'.mat'],'SurfDat','SurfInfo','SurfDat_pre','SurfInfo_pre');
    end
end