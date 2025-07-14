function d = get_fault_geometry(strike,dip,rake)
%% Usage: d = get_fault_geometry(strike,dip,rake)
% Input: strike, dip and rake are defined in Aki and Richard's System.
% Unit is in degree
% Output: d = (n1v1,n2v2,n3v3,n2v3+n3v2,n3v1+n1v3,n2v1+n1v2);
% -------------------------------------------------------------------------
% n = [n1,n2,n3] and v = [v1,v2,v3] are defined in SEU (South, East, Up) Coordinate System
% 1 is south, 2 is east and 3 is up
% n is the normal vector of fault, v is the slip vector of fault
% theta and phi is the n vector's angle with respect to 3 and north
% pusai is the v vector's angle with respect to strike.
% theta = dip, phi = strike+pi/2, pusai = rake;
% -------------------------------------------------------------------------
% By Jiaxuan Li Email: lijiaxuanmail@gmail.com
d2r = pi/180;
theta = dip*d2r;
phi = strike*d2r+pi/2;
pusai = rake*d2r;
n1 = -sin(theta)*cos(phi);
n2 = sin(theta)*sin(phi);
n3 = cos(theta);
v1 = (-1).*cos(pusai).*sin(phi)+cos(phi).*cos(theta).*sin(pusai);
v2 = (-1).*cos(phi).*cos(pusai)+(-1).*cos(theta).*sin(phi).*sin(pusai);
v3 = sin(pusai).*sin(theta);
% n = [n1,n2,n3];
% v = [v1,v2,v3];
d1 = n1*v1; d2 = n2*v2; d3 = n3*v3;
d4 = n2*v3+n3*v2;
d5 = n3*v1+n1*v3;
d6 = n2*v1+n1*v2;
d = [d1,d2,d3,d4,d5,d6];
end