
clear
[SubFolders,SubNames] = my_ls('/home/limingyang/WorkSpace/dHCP/DATA/dhcp2/dhcp_fmri_pipeline');
load('/home/limingyang/WorkSpace/dHCP/D300/documents/SubInfo_r2.mat');
subjects = cell2mat(SubInfo(:,1));
subjects = subjects';
n = 1;
for subi = subjects
    temptfolder = my_ls(SubFolders{subi},'dir');
    hm_txt = my_ls([temptfolder{1},'/func/*.tsv']);
    fid = fopen(hm_txt{1});
    hm_line1 = textscan(fid,'%s%s%s%s%s%s%s',1);
    hm_all = textscan(fid,'%f%f%f%f%f%f%f');
    for i = 1 : 6
        Q1(:,i) = hm_all{i};
    end;
    [range{n},hm_std(n)] = NVCP_Func_HMLVs(Q1,1600);
    n = n + 1;
end
save('/home/limingyang/WorkSpace/dHCP/D300/documents/rfMRI_crop.mat','range');