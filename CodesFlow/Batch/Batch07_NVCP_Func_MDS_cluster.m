%% arealization
clear
maskinfo = load('~/HCP_MMP_VOTC.mat'); % maskinfo
NKdata = load('~/VOTC34.mat'); % network data
load('~/NVCP_Subsets.mat'); % 
SubInfo = NKdata.rr_info;
subsets = NVCP_subsets(subset,'oneday'); % choose the subjects scanning within one day after birth
data = NKdata.rr([1:34],[35:68],subsets); % right-left matrix
thr = [];
maski = maskinfo.V34(:,2);
label_all = maskinfo.HCPlabel(maski);
order = maskinfo.order;
label_all = label_all(order);
matr = squeeze(mean(data,3));
if ~isempty(thr)
    matr(abs(matr) < thr) = NaN;
end
figure('color',[0 0 0],'position',[300 0 1200 980]);
new_mat = matr(order,order);
plot_mat_arealization = new_mat;
h = heatmap(label_all,label_all,plot_mat_arealization);
set(h,'MissingDataColor',[1 1 1]);
set(h,'fontsize',17);
grid off;
colormap('jet');
caxis([-0.15 0.45])

%% MDS
clear
maskinfo = load('~/HCP_MMP_VOTC.mat'); % maskinfo
NKdata = load('~/VOTC34.mat'); % network data
load('~/NVCP_Subsets.mat');
SubInfo = NKdata.rr_info;
subsets = NVCP_subsets(subset,'oneday'); % endo or exp
data = NKdata.rr([1:34],[1:34],subsets); % 34*34 matrix in right hemisphere
% data = NKdata.rr([35:68],[35:68],subsets); % left
data_m = squeeze(mean(data,3));
mat = data_m;
mask = 1-diag(ones(size(mat,1),1));
dismat = mask.*(1 - mat);  % distance matrix
maski = maskinfo.V34(:,2);
mat = data_m;
thr = 0.15;
mat(mat<thr) = 0;
labels = maskinfo.HCPlabel(maski);
mat_plot = mat;    
[Ci,Q] = modularity_und(mat_plot);
mat_d = dismat;
D = my_mat2vec_up(mat_d);
[Y,stress,disparities] = mdscale(D,2);
figure('color',[0 0 0],'position',[100 100 1500 800]);
NVCP_plot_network(mat_plot,labels,Y,cc);