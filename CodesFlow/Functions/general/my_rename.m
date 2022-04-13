function my_rename(files_org,files_rename,prefix)
[file_one,filenames] = my_ls(files_org);
for i = 1 : length(files_org)
    copy(files_org{i},[files_rename,'\',prefix,filenames{i}]);
end