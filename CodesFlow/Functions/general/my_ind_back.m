function [x,y,z] = my_ind_back(index,matrix)
%%% index = position
%%% matrix: 2D or 3D dim [5 7] meaning 5*7 matrix;
dim_num = length(matrix);
switch dim_num
    case 2
        y = fix(index/matrix(1)) + 1;
        x = mod(index,matrix(1));
        if x == 0
            y = y - 1;
            x = matrix(1);
        end
    case 3
        z = fix(index/(matrix(1)*matrix(2))) + 1;
        zmod = mod(index,(matrix(1)*matrix(2)));
        if zmod == 0;
            z = z - 1;
            y = matrix(2);
            x = matrix(1);
        else
            y = fix(zmod/matrix(1))+1;
            x = mod(zmod,matrix(1));
            if x == 0
                y = y - 1;
                x = matrix(1);
            end
        end
end
        