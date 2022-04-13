function NVCP_plot_inter(dt1,dt2,dt3,dt4)
%%
colortable = [237 125 49; 91 155 213]/255;
% colortable = [255 190 190;112 48 160]/255;
%%
a(1) = mean(dt1);
a(2) = mean(dt2);
b(1) = mean(dt3);
b(2) = mean(dt4);
ast(1) = std(dt1)/sqrt(length(dt1));
ast(2) = std(dt2)/sqrt(length(dt2));
bst(1) = std(dt3)/sqrt(length(dt3));
bst(2) = std(dt4)/sqrt(length(dt4));
x = [1 2];
errorbar(x,a,ast,'linewidth',3,'linestyle','None','color',[0.3 0.3 0.3]);
hold on
plot(x,a,'-o','MarkerFaceColor',colortable(1,:),'color',colortable(1,:),'MarkerSize',5.5,'linewidth',2.5);
hold on 
errorbar(x,b,bst,'linewidth',3,'linestyle','None','color',[0.3 0.3 0.3]);
hold on
plot(x,b,'-o','MarkerFaceColor',colortable(2,:),'color',colortable(2,:),'MarkerSize',5.5,'linewidth',2.5);
xlim([0.5 2.5]);
ylim([0.1 0.6]);
xticks([1 2]);
set(gca,'linewidth',2.5)
set(gca,'tickdir','in');
set(gca,'fontsize',15,'fontname','Times');
%
% set(gca,'color',[0 0 0]);
% set(gca,'Xcolor',[1 1 1],'Ycolor',[1 1 1]);