function NVCP_bar(data_mean,data_ste)
% BATCH polt bar for ANOVA ER 
% color 
colortable = [240 220 100;255 60 60;23 195 123;112 48 160;255 190 190]/255;
colortable2 = [85 85 197]/255;
% bar
nbar = size(data_mean,2);
nroi = size(data_mean,1);
if nroi == 1
    data_mean(2,:) = 0;
    data_ste(2,:) = 0;
end
% figure('color',[1 1 1]);
pic = bar(data_mean);
for i = 1 : nbar
    pic(i).FaceColor = colortable(i,:);
    pic(i).EdgeColor = [1 1 1];
    pic(i).LineWidth = 3;
end
set(pic,'BarWidth',0.8);
% error bar
ngroup = size(data_mean,1);
groupwidth =min(0.8, nbar/(nbar+1.5));
hold on
for i = 1: nbar
    x(i,:) = (1:ngroup) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbar);
    errorbar(x(i,:),data_mean(:,i),data_ste(:,i),'linewidth',3,'linestyle','None','color',[0.5 0.5 0.5]);
end
% box 
box on
set(gca,'ticklength',[0 0]);
set(gca,'tickdir','out');
% ydis = (ymax-ymin);
% set(gca,'ytick',[-10 0 10 20 30]);
% set(gca,'Ylim',[-11 45]);
xmax = nroi + 0.6;
% set(gca,'Xlim',[0.6 1.4]);  % xmax
line([0.4 xmax],[0 0],'linewidth',2.5,'color',[0 0 0]);
set(gca,'linewidth',2.5);
set(gca,'FontName','Arial','FontSize',14);
set(gca,'color',[0 0 0]);
set(gca,'Xcolor',[1 1 1],'Ycolor',[1 1 1]);