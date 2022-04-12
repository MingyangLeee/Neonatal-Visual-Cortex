%% Batch preprocessing of FMRI DATA in volume space
% volume preprocessing
clear
for subi = 1 : numofsubjects
    NVCP_Fun_volumepre_r3(subi);
end
% surface preprocessing
for subi = 1 : numofsubejcts
    NVCP_Func2surf_reg2surf2_r3(subi)
end