function NVCP_ants_Transfinv(RefImage,DataType,Input,Trans0,Trans1,OutImage)
%% registration with ANTs's antsApplyTransforms
% DataType : 0-single image; 3-time-series
% Input: input image
% RefImage: reference image
% Trans0: linear trans
% Trans1: non-linear trans
%%
command =  ['antsApplyTransforms -d 3 -e ',num2str(DataType),' -i ',Input,' -r ',...
    RefImage,' -t [',Trans0,',1] -t ',Trans1,' -o ',OutImage];
system(command);

