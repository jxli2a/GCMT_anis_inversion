function [strike2,dip2,rake2] = auxiliaryplane(strike1,dip1,rake1)
%% calculate the auxiliary plane geometry using the fault geometry
% inputs and outputs are in degrees
% By Jiaxuan Li     2017-09-25
r2d = 180/pi; d2r = pi/180;
theta1 = strike1*d2r;
delta1 = dip1*d2r;
phi1 = rake1*d2r;
ct = cos(theta1); st = sin(theta1);
cd = cos(delta1); sd = sin(delta1);
cp = cos(phi1);   sp = sin(phi1);
% strike vector
% n1 = [st,ct,0];
% fault vector
% n2 = [(-1).*cd.*ct,cd.*st,sd];
% fault normal vector: n3 = cross(n1,n2);
n3 = [ct.*sd,(-1).*sd.*st,cd];
% fault rake vector: nr = n1*cos(phi)+n2*sin(phi)
nr = [(-1).*cd.*ct.*sp+cp.*st,cp.*ct+cd.*sp.*st,sd.*sp];
% auxiliary normal vector (n3a(3)>0)
if nr(3) ~= 0
    n3a = nr*sign(nr(3));
else
    n3a = nr;
end
% auxiliary rake vector
nra = n3*sign(n3(3));
%% auxiliary fault geometry
delta2 = acos(abs(n3a(3)));
theta2 = atan2(-n3a(2),n3a(1));
if theta2 < 0
    theta2 = 2*pi+theta2;
end
phi2 = atan2(nra(3)/sin(delta2),nra(1)*sin(theta2)+nra(2)*cos(theta2));
if rake1 < 0
    phi2 = phi2-pi;
end
strike2 = theta2*r2d;
dip2 = delta2*r2d;
rake2 = phi2*r2d;
end