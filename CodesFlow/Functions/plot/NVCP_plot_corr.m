function [r,p] = NVCP_plot_corr(x,y,colorsty)
if nargin < 3
    colorsty = 0; % 0: white, 1 black;
end
colortable = [70 150 210]/255;
colortable2 = [213 84 79]/255;
colortable3 = [255 255 255;240 220 100;255 60 60;41 230 41;255 190 190;112 48 160;165 165 165]/255;
% figure('color','w');
if size(x,1) == 1
    x = x';
    y = y';
end
%%
y1_line = plot(x,y,'o','MarkerFaceColor',colortable,'color',colortable,'MarkerSize',5.5);
hold on
k=polyfit(x,y,1);
yy1=polyval(k,x);
plot(x,yy1,'color',colortable2,'LineWidth',2.5);
%
% xlim([37 45]);
% ylim([-0.3 0.6]);
% set(gca,'xtick',37:2:45);
% set(gca,'ytick',-0.2:0.2:1);
%
box on;
set(gca,'ticklength',[0.01 0.01]);
set(gca,'linewidth',2.5)
set(gca,'tickdir','in');
set(gca,'fontsize',14);
[r,p] = corr(x,y,'type','Pearson');
%% label r 
if p < 0.005
    mark = '*';
else
    mark = [];
end
if colorsty > 0
    set(gca,'color',[0 0 0]);
    set(gca,'Xcolor',colortable3(colorsty,:),'Ycolor',colortable3(colorsty,:));
    title(['r = ',num2str(r,'%2.2f'),mark],'color','w');
else
    title(['r = ',num2str(r,'%2.2f'),mark]);
end