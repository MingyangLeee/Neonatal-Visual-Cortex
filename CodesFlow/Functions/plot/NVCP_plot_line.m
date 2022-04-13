function [r,p] = NVCP_plot_line(x,y,y_std,colorsty)
if nargin < 3
    y_std = [];
    colorsty = 0; % 0: white, 1 black;
end
colortable = [70 150 210]/255;
colortable2 = [160 230 230]/255;
% figure('color','w');
if size(x,1) == 1
    x = x';
    y = y';
end
%%
y1_line = plot(x,y,'-o','MarkerFaceColor',colortable,'color',colortable,'MarkerSize',5.5,'linewidth',1.5);
hold on
k=polyfit(x,y,1);
yy1=polyval(k,x);
% plot(x,yy1,'color',colortable2,'LineWidth',2.5);
%
% xlim([37 45]);
% ylim([0.1 0.5]);
% set(gca,'xtick',37:2:45);
% set(gca,'ytick',-0.2:0.2:1);
if ~isempty(y_std)
    errorbar(x,y,y_std,'linewidth',1.5,'linestyle','None','color',colortable);
end
%
box on;
set(gca,'ticklength',[0.01 0.01]);
set(gca,'linewidth',2.5)
set(gca,'tickdir','in');
set(gca,'fontsize',13);
[r,p] = corr(x,y,'type','Pearson');
%% label r 
if p < 0.001
    mark = '*';
else
    mark = [];
end
if colorsty == 1
    set(gca,'color',[0 0 0]);
    set(gca,'Xcolor',[1 1 1],'Ycolor',[1 1 1]);
    title(['r = ',num2str(r,'%2.2f'),mark],'color','w');
else
    title(['r = ',num2str(r,'%2.2f'),mark]);
end