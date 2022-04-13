function [filenames,names] = my_ls(path,type)
%%
% extract file list in the path
% lmy: last change in 2021 08 31;
%%
if nargin < 2
    type = [];
end
names=dir(path);
newpath = path;
bn=0;
for i=1:length(names(:,1))
    if ~strcmp(names(i).name,'.') && ~strcmp(names(i).name,'..')
        newnames{i-bn}=names(i).name;
    else bn=bn+1;
    end
end
names=newnames';
seploc = find(path==filesep);
maxsep=max(seploc);
a = strfind(path,'*');
if isempty(a)
    if maxsep < length(path)
        newpath(end + 1) = filesep;
    end
else
    if maxsep == length(path)
        last_sep = seploc(end - 1);
        newpath(last_sep+1:end) = [];
    else
        newpath(maxsep+1:end) = [];
    end
end
for i=1:length(names)
    filenames{i,1}=[newpath,names{i}];
end
%% type, add in 2021 08 31 by lmy
if ~isempty(type)
    switch type
        case 'dir'
            n = 1;
            for i = 1 : length(filenames)
                if ~isdir(filenames{i})
                    a(n) = i; n = n + 1;
                end
            end
            filenames(a) = [];
            names(a) = [];
        case 'file'
            n = 1;
            for i = 1 : length(filenames)
                if ~isfile(filenames{i}) % old matlab version might miss isfile command
                    a(n) = i; n = n + 1;
                end
            end
            filenames(a) = [];
            names(a) = [];        
    end
end
