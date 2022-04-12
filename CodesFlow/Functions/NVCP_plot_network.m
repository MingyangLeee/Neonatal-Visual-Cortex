function NVCP_plot_network(mat,nodelables,postions,nodecolors)
%%
% colortable = [255 103 103; 91 209 215;255 173 96;157 211 168;197 197 197]/255;
colortable = [255 173 96;210 45 45;36 112 160;157 211 168;197 197 197]/255;
%%
G = graph(mat,'upper');
P = plot(G);
% defult:
P.ShowArrows = 'off';
P.MarkerSize = 15;

%
% set(gca,'XDIR','reverse');
%% adjust the location of label so that the label will not block the nodes
if 1
P.NodeLabel = [];
bais_X = 0.015;
bais_Y = 0;
postions(8,1) = postions(8,1) - 0.00; % LO1
text(postions(:,1) + bais_X,postions(:,2)+bais_Y,nodelables,'FontSize',14,'color',[1 1 1],'FontWeight','BOLD');
postions(8,1) = postions(8,1) + 0.00; % LO1 
else
P.NodeLabel = [];
bais_X = 0.015;
bais_Y = 0;
postions(8,1) = postions(8,1) + 0.08; % LO1 
text(postions(:,1) - bais_X,postions(:,2)+bais_Y,nodelables,'FontSize',14,'color',[1 1 1],'FontWeight','BOLD');
postions(8,1) = postions(8,1); % LO1 
end
%
if ~isempty(postions)
    P.XData = postions(:,1);
    P.YData = postions(:,2);
end
%% edges color
% P.LineWidth = (1+G.Edges.Weight).^4;
%% STYLE 2
P.LineWidth = 3.5;
colormap jet
P.EdgeCData = G.Edges.Weight;
caxis([-0.15 0.45]);
% P.NodeCData = nodecolors;
%% nodes color
subsets = unique(nodecolors);
colormask = zeros([length(nodecolors),3]);
for i = subsets'
    a = find(nodecolors == i);
    for j = a'
        colormask(j,:) = colortable(i,:);
    end
end
P.NodeColor = colormask;
%%
set(gca,'YDIR','reverse');
set(gca,'color',[0 0 0]);
axis off
%%  brain map 
if 1
giidata = gifti('~/1surface/VOTC34_R.label.gii');
giimask = giidata.cdata;
subsets = unique(nodecolors);
for i = subsets'
    newmask = giimask*0;
    a = find(nodecolors == i);
    for j = a'
        b = find(giimask == j);
        newmask(b) = i;
    end
    giidata.cdata = newmask;
    output = ['~/VOTC_MDS',num2str(i),'_R.label.gii'];
    gifti_save(giidata,output,'ASCII');
end
end
