function [res_mean,res_pattern] = NVCP_AnatROI_value(Type,ROI)
%% darw value from specific ROI in age-matched template
% Type: image type, T1, T2, T1DT2...
% ROI: EBA, FFA, PPA, VWFA, VOTFPC
%%
[DataFiles,~] = my_ls(['/home/limingyang/WorkSpace/dHCP/D40/Results/Reg_files/',Type]);
SI_tempt = load('/home/limingyang/WorkSpace/dHCP/D40/documents/SubInfo_r1.mat');
SubInfo = SI_tempt.SubInfo;
% mask
MaskFiles = my_ls(['/home/limingyang/WorkSpace/dHCP/Masks/My_ROI/FuncSpec/Schuh_Space/',ROI]);
MaskData = [];
for mi = 1 : length(MaskFiles)
    tempt_mask = rest_readfile(MaskFiles{mi},'all');
    GrayMask = rest_readfile(['/home/limingyang/WorkSpace/dHCP/Masks/Schuh2018/mean/ga_',num2str(mi+35),'/mask.nii.gz']);
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
for i = 1 : length(DataFiles)
    data = rest_readfile(DataFiles{i},'all');
    SubAge = round(SubInfo{i,4});
    for j = 1 : 3
        DataMaskROI = data.*MaskData{SubAge-35,j};
        res_pattern{i,j} = DataMaskROI(MaskData{SubAge-35,j}==1);
        res_mean(i,j) = mean(res_pattern{i,j});
    end
end