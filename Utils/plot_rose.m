function fig = plot_rose(angle0)
% plot the rose diagram for the angle between P, B, and T axes.
% input angles are in degrees
% By Jiaxuan Li 2017-10-16
fig = figure;
set(fig, 'Visible', 'on','Color','white','Unit','Normalized', ... 
    'Position',[0.1861    0.0556    0.5292    0.8300]);
h = rose(angle0(:,1)/180*pi);hold on;
x = get(h,'Xdata');y = get(h,'Ydata');g1=patch(x,y,'r');
h = rose(angle0(:,2)/180*pi+2*pi/3);
x = get(h,'Xdata');y = get(h,'Ydata');g2=patch(x,y,'g');
h = rose(angle0(:,3)/180*pi+4*pi/3);
x = get(h,'Xdata');y = get(h,'Ydata');g3=patch(x,y,'b');
% hobj = findobj(gca,'Type','patch');
% legend(hobj,'T axis','B axis','P axis');
legend([g1,g2,g3],'T axis','B axis','P axis');
end