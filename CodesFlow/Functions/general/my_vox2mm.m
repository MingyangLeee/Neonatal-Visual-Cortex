function mm = my_vox2mm(vox,ImgInfo)
%% my_function:
% Nifti image vox to mm
% see also my_mm2vox
%%
if size(vox,1) ~= 3 && size(vox,2) == 3
    vox = vox';
else error('vox must be 3D vectors');
end
centmm1=ImgInfo.mat*[vox;1];
mm = centmm1(1:3)';
    