function All_coeff = NVCP_BCT_all(mat,thr_method,thr,output)
%% collect matrix and network measures
% mat: nodes * nodes * subjects
% thr_method: 1: direct value (use right side)
%             2: abs value (out of the low range which will include negative value)
%             3: density (right side)
%             4: 
%% threshold the network
switch thr_method
    case 1
        a = mat;
        a(mat < thr) = 0;
    case 2
        a = mat;
        a(abs(mat) < thr) = 0;
    case 3
        ape = size(mat,1)*(size(mat,1)-1);
        ne = round(ape*thr);
        em = mean(mat,3);
        ed = em(:);
        sa = sort(ed,'ascend');
        th = sa(ne);
        a = mat;
        a(mat < th) = 0; 
        a(mat < 0) = 0; 
end      
%%
All_coeff.connectivity = a;
for subi = 1 : size(a,3)
    net = squeeze(a(:,:,subi));
    binet = net;  binet(binet > 0) = 1;
    Dis_path = distance_wei(net);
    Dis_path_bin = distance_bin(binet);
    %%%%%%%%%%%%%%%%%%%%%%%%%%% network measures %%%%%%%%%%%%%%%%%%%%
    All_coeff.shortestpath(:,:,subi) = Dis_path;
    All_coeff.SP_bin(:,:,subi) = Dis_path_bin;
    All_coeff.univar(subi).density = density_und(net);
    All_coeff.univar(subi).transit = transitivity_wu(net);
    All_coeff.univar(subi).charpath = charpath(net);
    All_coeff.univar(subi).effeciency = efficiency_wei(net);
    All_coeff.univar(subi).effeciency_bin = efficiency_bin(net);
    All_coeff.univar(subi).assortativity = assortativity_wei(net,0);
    All_coeff.univar(subi).richclub15 = mean(rich_club_wu(net,15));
    All_coeff.degree(subi,:) = degrees_und(net);
    All_coeff.effeciency_loc(subi,:) = efficiency_wei(net,1);
    All_coeff.cluster_coef(subi,:) = clustering_coef_wu(net);
    All_coeff.betweenness(subi,:) = betweenness_wei(net);
end
save(output,'All_coeff'); % savefile