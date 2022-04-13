function subs = NVCP_subsets(subset_mat,whatsub)
switch whatsub
    case 'endo' % endogenous
        a = subset_mat(:,5);
        b = find(a < 0.45); % 3days
        subs = subset_mat(b,1);
    case 'exp' % experience-denpandent
        a = subset_mat(:,4);
        b = find(a >= 40 & a <= 42);
        subs = subset_mat(b,1);
    case 'h_exp'
        a = subset_mat(:,5);
        b = find(a >= 3);
        subs = subset_mat(b,1);
    case 'oneday'
        a = subset_mat(:,5);
        b = find(a < 0.2);
        subs = subset_mat(b,1);
    case 'l_PMA'
        a = subset_mat(:,4);
        b = find(a < 39);
        subs = subset_mat(b,1);
    case 'h_PMA'
        a = subset_mat(:,4);
        b = find(a > 42);
        subs = subset_mat(b,1);
end