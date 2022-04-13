function [res_mean,res_pattern] = NVCP_FunROI_values(measure,ROI)
%% darw all local value from specific ROI in rs-fMRI data
% measure: ALFF, fALFF and reho
% ROI: 'EBA','FFA','PPA','VWFA'
%%
[SubFiles,~] = my_ls('/home/limingyang/WorkSpace/dHCP/D40/Results/FUNC/Prepro/');
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
% mask
% ROI = {'EBA','FFA','PPA','VWFA'};
% for i = 1 : length(ROI)
MaskFiles = my_ls(['/home/limingyang/WorkSpace/dHCP/Masks/My_ROI/FuncSpec/Schuh_Space2mm/',ROI]);
% end
MaskData = [];
for mi = 1 : length(MaskFiles)
    tempt_mask = rest_readfile(MaskFiles{mi},'all');
    GrayMask = rest_readfile(['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean2mm/ga_',num2str(mi+35),'/mask.nii']);
    tempt_mask = tempt_mask.* GrayMask; %mask in brain
    MaskData{mi,1} = tempt_mask;
    MaskData{mi,1}(MaskData{mi,1} > 0) = 1; % whole brain
    MaskData{mi,2} = tempt_mask;
    MaskData{mi,2}(tempt_mask == 2) = 0; % left brain
    MaskData{mi,3} = tempt_mask;
    MaskData{mi,3}(tempt_mask == 1) = 0; MaskData{mi,3}(MaskData{mi,3} > 0) = 1;% right brain    
end
% data
res_pattern = [];
res_mean = [];
for i = 1 : length(SubFiles)
    datafile = [SubFiles{i},'/local/',measure,'.nii'];
    data = rest_readfile(datafile,'all');
    SubAge = round(SubInfo{i,4});
    for j = 1 : 3
        DataMaskROI = data.*MaskData{SubAge-35,j};
        res_pattern{i,j} = DataMaskROI(MaskData{SubAge-35,j}==1);
        res_mean(i,j) = mean(res_pattern{i,j});
    end
end