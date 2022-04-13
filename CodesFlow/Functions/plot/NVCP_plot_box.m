function NVCP_plot_box(x,g,ci)
%%
colortable{2} = [255 192 0;255 60 60;23 195 123;112 48 160;255 190 190;15 255 233;246 138 30]/255;
colortable{1} = [255 233 162;255 180 180;143 255 194;200 160 220;255 190 190;242 182 130;242 182 130]/255;
%% prepare something
bh = boxplot(x,g);
h = findobj(gca,'Tag','Box');
for j = 1 : length(h)
    p_x{j} = get(h(j),'XData');
    p_y{j} = get(h(j),'YData');
end
close all
%% plot
figure('color',[0 0 0],'position',[300 300 600 300]);
for j = 1 : length(p_x)
    patch(p_x{j},p_y{j},'y','FaceColor',colortable{j}(ci,:));
    hold on
end
bh = boxplot(x,g,'symbol','o','color','w');
set(gca,'color',[0 0 0]);
set(gca,'Xcolor','w','Ycolor','w');
set(gca,'linewidth',2.5)
set(bh,'linewidth',2.2)
set(gca,'fontsize',15);
% ylim([0.1 0.5]);  
%% ttest2