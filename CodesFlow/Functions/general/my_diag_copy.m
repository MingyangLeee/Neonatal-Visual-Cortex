function new_mat = my_diag_copy(mat,replace)
%% up_diag flip to full matrix
% matrix: up_diag
% replace: use this value to replace diagonal cell and missing data
%%
new_mat = mat;
for i = 1 : size(mat,1)
    for j = 1 : size(mat,2)
        if i > j
            if ismissing(mat(j,i))
                mat(j,i) = replace;
                new_mat(j,i) = replace;
                mew_mat(i,j) = mat(j,i);
            else
                new_mat(i,j) = mat(j,i);
            end
        elseif i == j
            new_mat(i,j) = replace;
        end
    end
end