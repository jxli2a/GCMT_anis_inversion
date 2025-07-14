function [normal_vec,strike,dip] = get_slab_geometry(vert,group_center)
%% Usage: [n,strike,dip] = get_slab_geometry(slab_name,evlo0,evla0,evdp0)
%  This function is used to get local normal vector and strike, dip of an
%  EQ group.
%  Input:  slab patch: vert (Dimension: nvert*3)
%          group_center = [evlo0,evla0,evdp0]
%          evlo0: longitude of group center
%          evla0: latitude of group center
%          evdp0: depth of group center (Unit in degree)
%          * Units of all inputs should be in degree *
%  Output: n: normal vector
%          strike of local slab: strike
%          dip of local slab: dip
%  By Jiaxuan Li    --2016-09-24--      Email: lijiaxuanmail@gmail.com
nvert = size(vert,1);
dist0 = vert-repmat(group_center,nvert,1);
dist1 = sqrt(sum(dist0.*dist0,2));
tmp = [dist1,vert];
tmp = sortrows(tmp);
plane = tmp(1:10,2:4);
[n,~,~] = affine_fit(plane);
normal_vec = n';
% Get dip and strike of local fault
dip = acos(abs([0,0,1]*n))/pi*180;
n = -n*sign(n(3));
n1 = n; n1(3) = 0;
n1 = n1/norm(n1);
tmp = atan2(n1(1),n1(2))/pi*180;
if tmp < 0
    tmp = tmp+360;
end
tmp = tmp-90;
if tmp < 0
    tmp = tmp+360;
end
strike = tmp;
end