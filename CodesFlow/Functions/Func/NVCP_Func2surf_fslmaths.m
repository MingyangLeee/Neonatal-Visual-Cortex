function NVCP_Func2surf_fslmaths(subi)
%% register fucntional data into surface 
% functional data in volume should be preprocessed 
% do fslmaths to calculate goodvoxels
%
%% prepare file
[SubFiles,~] = my_ls('/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/Func');
TemptFolder = [SubFiles{subi},'/Func_tempt'];
VolumeFolder = [SubFiles{subi},'/Func_volume'];
%% creating good voxels; not necessary 
% Something different when I use matlab-math to do following calculation
% so be it with fsl math
command = ['fslmaths ',TemptFolder,'/mean -div ',TemptFolder,'/std ',TemptFolder,'/cov -odt float'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov -mas ',TemptFolder,'/ribbon2 ',TemptFolder,'/cov_ribbon'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_ribbon -div `fslstats ',TemptFolder,'/cov_ribbon -M` '...
    TemptFolder,'/cov_rib_norm'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_rib_norm -bin -s 5 ',TemptFolder,'/smoothnorm'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_rib_norm -s 5 -div ',TemptFolder,...
    '/smoothnorm -dilD ',TemptFolder,'/crns'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov -div `fslstats ',TemptFolder,'/cov_ribbon -M` '...
    '-div ',TemptFolder,'/crns ',TemptFolder,'/cov_norm_mod'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_norm_mod -mas ',TemptFolder,'/ribbon2 ',TemptFolder,'/cnmr'];
system(command);
% Indeed -.-!
y = y_ReadAll([TemptFolder,'/cnmr.nii.gz']);
a = find(y~=0); b = y(a); c = mean(b); d = std(b); 
LimUp = c + 0.5*d;
command = ['fslmaths ',TemptFolder,'/mean -bin ',TemptFolder,'/mask'];
system(command);
command = ['fslmaths ',TemptFolder,'/cov_norm_mod -thr ',num2str(LimUp),...
    ' -bin -sub ',TemptFolder,'/mask -mul -1 ',VolumeFolder,'/goodvoxels'];
system(command);