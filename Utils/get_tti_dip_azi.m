function [dip, azi] = get_tti_dip_azi(strike, dip, nvec, tvec)
%% get dipping angle and azimuth in the slab normal local system
%  nvec: normal vector of slab
%  tvec: symmetry vector of tti
%  strike: strike of slab [deg]
%  dip: dip of slab       [deg]
svec = [sind(strike),cosd(strike),0];
% updip vector
dvec = [cosd(dip),sind(dip)*sind(strike),sind(dip)*cosd(strike)];
% theta
dip = acosd(abs(sum(tvec.*nvec)));
% phi
sympara = tvec-nvec*sum(tvec.*nvec);
x =  sum(sympara.*svec); % change from - to + 2018-03-20
y =  sum(sympara.*dvec);
azi = atan2d(x,y);
if azi < 0, azi = azi+360; end
end