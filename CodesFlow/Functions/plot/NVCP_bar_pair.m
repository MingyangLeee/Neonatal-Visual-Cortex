function NVCP_bar_pair(data_mean,data_ste,colori)
% BATCH polt bar for ANOVA ER 
% color 
colortable{1} = [255 192 0;255 60 60;81 215 80;112 48 160;255 190 190;30 192 255;246 138 30]/255;
colortable{2} = [255 233 162;255 180 180;192 240 192;200 160 220;255 190 190;111 203 220;242 182 130]/255;
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
    pic(i).FaceColor = colortable{i}(colori,:);
end
set(pic,'BarWidth',0.8);
% error bar
ngroup = size(data_mean,1);
groupwidth =min(0.8, nbar/(nbar+1.5));
hold on
for i = 1: nbar
    x(i,:) = (1:ngroup) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbar);
    errorbar(x(i,:),data_mean(:,i),data_ste(:,i),'linewidth',2,'linestyle','None','color',[0.5 0.5 0.5]);
end
% box 
box off
set(gca,'ticklength',[0.01 0.01]);
set(gca,'tickdir','out');
set(gca,'color',[0 0 0]);
set(gca,'Xcolor',[1 1 1],'Ycolor',[1 1 1]);
% ydis = (ymax-ymin);
% set(gca,'ytick',[-10 0 10 20 30]);
% set(gca,'Ylim',[-11 45]);
xmax = nroi + 0.6;
set(gca,'Xlim',[0.4 xmax]);
line([0.4 xmax],[0 0],'linewidth',2.5,'color',[0 0 0]);
set(gca,'linewidth',2.5);
set(gca,'FontName','Arial','FontSize',14);