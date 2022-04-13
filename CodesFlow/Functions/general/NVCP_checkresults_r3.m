function resultID = NVCP_checkresults_r3(type,dele)
%%
if nargin < 2
    dele = 0;
end
resultID = [];
%% fMRI VOLUME CHEAK type
if strcmp(type,'fMRI_volume')
    a = [];
    files = my_ls('/home/limingyang/WorkSpace/NVCP/Volume_Results/Func/');
    for i = 1 : length(files)
        a(i) = isfile([files{i},'/Func_volume/rfMRI_dcf_4D.nii']);
    end
    resultID = find(a==0);
    resultID = resultID';
    if dele == 1
        for i = resultID'
            rmdir([files{i},'/Func_volume'],'s');
            rmdir([files{i},'/Func_tempt'],'s');
        end
    end
elseif strcmp(type,'fMRI_surf')
    a = [];
    files = my_ls('/home/limingyang/WorkSpace/NVCP/Surface_Results/Func/');
    for i = 1 : length(files)
        try 
            b = my_ls([files{i},'/Func_surf/fMRI4D_smooth_right.template*.func.gii']);
            a(i) = 1;
        catch
            a(i) = 0;
        end
    end
    resultID = find(a==0);
    resultID = resultID';
elseif strcmp(type,'MSM')
    a = [];
    files = my_ls('/home/limingyang/WorkSpace/NVCP/Surface_Results/MSM/');
    for i = 1 : length(files)
        a(i) = isfile([files{i},'/regfile/right_MSMALL.reg40.surf.gii']);
    end
    resultID = find(a==0);
    resultID = resultID';
    if dele == 1
        for i = resultID'
            rmdir(files{i},'s');
        end
    end
elseif strcmp(type,'dhcp40')
    c = [];
    files = my_ls('/home/limingyang/WorkSpace/NVCP/Surface_Results/MSM/');
    for i = 1 : length(files)
        a = isfile([files{i},'/DHCP_template40/hemi-right_desc-medialwall_mask.shape.gii']);
        b = isfile([files{i},'/DHCP_template40/hemi-left_desc-medialwall_mask.shape.gii']);
        c(i) = a*b;
    end
    resultID = find(c==0);
    resultID = resultID'; 
    if dele == 1
        for i = resultID'
            rmdir(files{i},'s');
        end
    end
end
%% fMRI SURFACE CHECK
