function plot_contour_line(ax)
% plot radial and tangential contour line in a unit circle
% By Jiaxuan Li     2017-10-15
axes(ax);
hold(ax,'on');
d2r = pi/180;
t = (0:5:90)*d2r; p = (0:5:360)*d2r;
for nt = 1:length(t)
    t0 = t(nt);
    x = tan(t0/2)*cos(p);
    y = tan(t0/2)*sin(p);
    if mod(nt,9) == 1
        plot(x,y,'k-');
    else
        plot(x,y,'-','color',[0.75,0.75,0.75]);
    end
end
for np = 1:length(p)
    x = [0,cos(p(np))];
    y = [0,sin(p(np))];
    if mod(np,9) == 1
        plot(x,y,'k-');
    else
        plot(x,y,'-','color',[0.75,0.75,0.75]);
    end
end
axis equal;
axis off;
end