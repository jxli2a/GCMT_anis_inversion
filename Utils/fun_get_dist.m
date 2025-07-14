function dist0 = fun_get_dist(evt,slab_vert,varargin)
num_pts = 60;
con_int = 50; % contour depth interval
% get distance of one event to slab
lat = evt.evla;
lon = evt.evlo;
dep = evt.evdp;
ratio = dep/con_int;
n = floor(ratio);
ratio = ratio-n;
n1 = n*num_pts+1; n2 = n1+2*num_pts-1;
line_evlo = (1-ratio)*slab_vert(n1:n1+num_pts-1,1)+ratio*slab_vert(n1+num_pts:n2,1);
line_evla = (1-ratio)*slab_vert(n1:n1+num_pts-1,2)+ratio*slab_vert(n1+num_pts:n2,2);
line_dist = zeros(1,num_pts);
for k = 1:num_pts
    line_dist(k) = distance(lat,lon,line_evla(k),line_evlo(k));
end
dist0 = min(line_dist);
end