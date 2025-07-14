function evts = fun_evt_2d_projection(evts, strike, center)
% get projection of events in 3d space onto 2d vertical plane (plane containing slab normal vector).
% Input Units: evts.(evlo, evla, evdp) (deg, deg, km)
%              strike: deg
% Output Units: evts.(evtX, evtY): (deg, deg)
% By Jiaxuan Li  --2018-01-04--
km2d = 1/111.1949;
V = [evts.evlo; evts.evla; evts.evdp];
V(3,:) = V(3,:)*km2d;
e1 = [sind(strike+90);cosd(strike+90);0];
e2 = [0;0;1];
[evtX, evtY] = fun_3d_proj_2d(V, center, e1, e2);
% add evtX and evtY to evts structure
tmpX = num2cell(evtX); tmpY = num2cell(evtY);
[evts.X] = tmpX{:};    [evts.Y] = tmpY{:};
end