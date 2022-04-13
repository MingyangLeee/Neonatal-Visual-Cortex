function [r,p] = NVCP_scatter(x1,y1,x2,y2,x3,y3)
%%
shadow = 0;
%
colortable = [248 118 109;0 191 196;169 209 142;135 226 147]/255;
colortable2 = [253 196 182;142 192 228;197 224 180;168 219 168]/255;
figure('color','w');
y1_line = plot(x1,y1,'o','MarkerFaceColor',colortable(1,:),'color',colortable(1,:),'MarkerSize',5);
hold on
[k,s]=polyfit(x1,y1,1);
yy1=polyval(k,x1);
[yfit,dy] = polyconf(k,x1,s,'predopt','curve');
[x,index] = sort(x1,'Descend');
[y,index2] = sort(yfit);
dy = dy(index);
x=x';
y=y';
dy=dy';
plot(x1,yfit,'color',colortable(1,:),'LineWidth',2.0);
hold on 
if shadow == 1
    y1_fill = fill([x,fliplr(x)],[y-dy,fliplr(y+dy)],colortable2(1,:));
    set(y1_fill,'LineStyle','none','facealpha',0.5);
    hold on
end
[rt,pt] = corr(x1,y1,'type','Spearman');
r = rt(1);p = pt(1);
% line 2
if nargin > 2 
y2_line = plot(x2,y2,'o','MarkerFaceColor',colortable(2,:),'color',colortable(2,:),'MarkerSize',5);
hold on
[k,s]=polyfit(x2,y2,1);
yy2=polyval(k,x2);
[yfit,dy] = polyconf(k,x2,s,'predopt','curve');
[x,index] = sort(x2,'Descend');
[y,index2] = sort(yfit);
dy = dy(index);
x=x';
y=y';
dy=dy';
plot(x2,yfit,'color',colortable(2,:),'LineWidth',2.0);
hold on 
if shadow == 1
    y2_fill = fill([x,fliplr(x)],[y-dy,fliplr(y+dy)],colortable2(2,:));
    set(y2_fill,'LineStyle','none','facealpha',0.3);
    hold on    
end
[rt,pt] = corr(x2,y2,'type','Spearman');
r(2) = rt(1);p(2) = pt(1);
end
if nargin > 4 
y3_line = plot(x3,y3,'o','MarkerFaceColor',colortable(3,:),'color',colortable(3,:),'MarkerSize',5);
hold on
[k,s]=polyfit(x3,y3,1);
yy3=polyval(k,x3);
[yfit,dy] = polyconf(k,x3,s,'predopt','curve');
[x,index] = sort(x3,'Descend');
[y,index2] = sort(yfit);
dy = dy(index);
x=x';
y=y';
dy=dy';
plot(x3,yfit,'color',colortable(3,:),'LineWidth',2.0);
hold on 
if shadow == 1
    y3_fill = fill([x,fliplr(x)],[y-dy,fliplr(y+dy)],colortable2(3,:));
    set(y3_fill,'LineStyle','none','facealpha',0.3);
    hold on   
end
[rt,pt] = corr(x3,y3,'type','Spearman');
r(3) = rt(1);p(3) = pt(1);
end

box on;
set(gca,'ticklength',[0.01 0.01]);
set(gca,'linewidth',1.5)
set(gca,'tickdir','in');
% 