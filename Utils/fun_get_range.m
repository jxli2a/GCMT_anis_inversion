function [t1,t2,p1,p2] = fun_get_range()
%% Usage: This script is used to pick the narrower range for eigvec searching method
%  Output unit is in radian
d2r = pi/180; r2d = 180/pi;
[x,y] = ginput(2);
theta = 2*atan(sqrt(x.^2+y.^2));
phi = atan2(x,y)+pi;
t1 = theta(1); t2 = theta(2);
p1 = phi(1);   p2 = phi(2);
if t1 > t2
    tmp = t1;
    t1 = t2;
    t2 = tmp;
end
t1 = floor(t1*r2d)*d2r; t2 = ceil(t2*r2d)*d2r;
if p1 > p2
    tmp = p1;
    p1 = p2;
    p2 = tmp;
end
p1 = floor(p1*r2d)*d2r; p2 = ceil(p2*r2d)*d2r;
end