function my_sort_mri(data_file,data_name,move_file)
% mir_files = dir([data_file,data_name]);
mir_files = dir([data_file,data_name]);
for i = 1:length(mir_files)
    mir_files_name = [data_file,mir_files(i).name];
    mir_move_name = [move_file,mir_files(i).name];
    movefile(mir_files_name,mir_move_name);
end