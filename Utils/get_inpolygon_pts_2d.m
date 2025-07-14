function indx = get_inpolygon_pts_2d(evtX, evtY)
%% get points inside mannually picked polygon
%  Jiaxuan Li  --2019-01-07--
[xv, yv] = ginput();
xv(end+1) = xv(1);
yv(end+1) = yv(1);
plot(xv, yv, 'k-');
indx = inpolygon(evtX, evtY, xv, yv);

end