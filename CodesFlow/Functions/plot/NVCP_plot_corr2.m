function [r,p] = NVCP_plot_corr2(x,y1,y2,c3)
%%
if nargin < 4
    c3 = 6;
end
colortable = [255 190 190;216 62 64]/255;
colortable2 = [157 239 241;0 150 255]/255;
colortable3 = [240 220 100;255 60 60;41 230 41;255 190 190;112 48 160;255 255 255]/255;
% c3 = 3;
% figure('color','w');
%%
if size(x,1) == 1
    x = x';
    y1 = y1';
    y2 = y2';
end
y1_line = plot(x,y1,'o','MarkerFaceColor',colortable(1,:),'color',colortable(1,:),'MarkerSize',6);
hold on
y2_line = plot(x,y2,'o','MarkerFaceColor',colortable2(1,:),'color',colortable2(1,:),'MarkerSize',6);
hold on
k=polyfit(x,y1,1);
yy1=polyval(k,x);
plot(x,yy1,'color',colortable(2,:),'LineWidth',2.5);
hold on
k=polyfit(x,y2,1);
yy2=polyval(k,x);
plot(x,yy2,'color',colortable2(2,:),'LineWidth',2.5);
%%
box on;
% xlim([37 45]);
% ylim([0.9 1.5]);
set(gca,'color',[0 0 0]);
% set(gca,'xtick',[0 1 2 3 4 5]);
% set(gca,'xtick',[37 39 41 43 45]);
% set(gca,'ytick',[0.8 1 1.2 1.4]);
set(gca,'ticklength',[0.01 0.01]);
set(gca,'linewidth',2.5)
set(gca,'tickdir','in');
set(gca,'fontsize',15,'fontname','Times');
set(gca,'Xcolor',colortable3(c3,:),'Ycolor',colortable3(c3,:));
[r(1),p(1)] = corr(x,y1,'type','Pearson');
[r(2),p(2)] = corr(x,y2,'type','Pearson');
%% text
% ylim([0.5 1.8]);
% for mi = 1 : 2
%     mark{mi} = [];
%     if p(mi) < 0.05 && p(mi) >= 0.01
%         mark{mi} = '*';
%     elseif p(mi) < 0.01 && p(mi) >= 0.001
%         mark{mi} = '**';
%     elseif p(mi) < 0.001
%         mark{mi} = '***';
%     end
% end
% text(0.6,0.7,['r = ',num2str(r(1),'%0.2f'),mark{1}],'color',colortable(1,:));
% text(0.6,0.6,['r = ',num2str(r(2),'%0.2f'),mark{2}],'color',colortable2(1,:));