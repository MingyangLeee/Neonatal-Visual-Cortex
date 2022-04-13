function allmat = NVCP_acrossage_cat(mat)
%% mat: containing vertex data across ages
%
%%
n = 1;
for i = 1 : length(mat)
    if ~isempty(mat{i})
        if n == 1
            allmat = mat{i}; n = n + 1;
        else
            allmat = cat(2,allmat,mat{i});
            n = n + 1;
        end
    end
end