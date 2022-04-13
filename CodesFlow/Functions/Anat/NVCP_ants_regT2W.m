function NVCP_ants_regT2W(FixImage,MoveImage,OPImage)
%% registration with ANTs's antsRegistrationSyNQuick.sh
% FixImage: refered space
% MoveImage: image to be registered 
% OPImage: Output
%%
command =  ['antsRegistrationSyNQuick.sh -d 3 -f ',FixImage,' -m',MoveImage,' -o',OPImage];
system(command);