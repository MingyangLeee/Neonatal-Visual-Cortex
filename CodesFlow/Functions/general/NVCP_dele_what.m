function NVCP_dele_what(type,filename)
%%
% type: Func, MSM
% filename: subdirectory
%%
files = my_ls(['/home/limingyang/WorkSpace/dHCP/D40/Surface_Results/',type]);
for i = 1 : length(files)
    rmdir([files{i},'/',filename],'s');
end
