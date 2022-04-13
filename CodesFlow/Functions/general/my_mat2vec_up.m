function vect = my_mat2vec_up(matr,matw)
% mat to superior triangle or inverse
%
if nargin == 1
    matw = length(matr);
end
if min(size(matr)) > 1
    n = 1;
    for i = 1 : size(matr,1)
        for j = 1 : size(matr,2)
            if i < j
                vect(n) = matr(i,j);
                n = n + 1;
            end
        end
    end
elseif min(size(matr)) == 1
    item = length(matr);
    n = 1;
    for i = 1 : matw
        for j = 1 : matw
            if i < j
                vect(i,j) = matr(n);
                n = n + 1;
            end
        end
    end
end
    
    
    