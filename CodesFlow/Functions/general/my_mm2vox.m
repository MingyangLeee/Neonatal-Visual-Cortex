function vox = my_mm2vox(mm,ImgInfo)
%% my_function:
% Nifti image mm to vox
% see also my_vox2mm
%%
if size(mm,1) ~= 3 && size(mm,2) == 3
    mm = mm';
else error('vox must be 3D vectors');
end
mm4 = [mm;1]; 
centvox1 = inv(ImgInfo.mat)*mm4;
vox=centvox1(1:3)';
    