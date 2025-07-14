function plot_mt_PBT(mt,varargin)
%% Usage: plot_mt_PBT(evts)
% This script is used to plot P, B, T axis distribution for evts
% By Jiaxuan Li Email: lijiaxuanmail@gmail.com
% Modified 2017-10-18       plot PBT for a given mt
hold on;
linspec = 'mo';
showtext = 1;
if nargin >= 2
    coordsys = varargin{1};
    if nargin >= 3
        linspec = varargin{2};
        showtext = varargin{3};
    end
end
switch coordsys
    case 'cmt'
        mt = Change_mt_coordinate(mt,1);
    case 'voigt'
    case 'jma'
        mt = Change_mt_coordinate(mt,2);
    otherwise
        disp('No valid option')
end
M = [mt(1) mt(6) mt(5)
    mt(6) mt(2) mt(4)
    mt(5) mt(4) mt(3)];
[V,D] = eig(M);
% sorted eigen values from low to high values %
if ~issorted(diag(D))
    [~,I] = sort(diag(D));
    V = V(:, I);
end
% 1 is P axis, 2 is B axis and 3 is T axis
% define pointing outside is positive (conventinal deinition in elastic mechanics)
% P axis initial movement is inside,  negtive  eigenvalue
% T axis initial movement is outside, positive eigenvalue
V(:,1) = V(:,1)*sign(V(3,1));
V(:,2) = V(:,2)*sign(V(3,2));
V(:,3) = V(:,3)*sign(V(3,3));
v1 = V(:,1); v2 = V(:,2); v3 = V(:,3);
theta1 = acos(abs(v1(3))); phi1 = pi-atan2(v1(2),v1(1));
theta2 = acos(abs(v2(3))); phi2 = pi-atan2(v2(2),v2(1));
theta3 = acos(abs(v3(3))); phi3 = pi-atan2(v3(2),v3(1));
x1 = tan(theta1/2) * (-sin(phi1)); y1 = tan(theta1/2)* (-cos(phi1));
x2 = tan(theta2/2) * (-sin(phi2)); y2 = tan(theta2/2)* (-cos(phi2));
x3 = tan(theta3/2) * (-sin(phi3)); y3 = tan(theta3/2)* (-cos(phi3));
plot(x1,y1,linspec,x2,y2,linspec,x3,y3,linspec,'Markersize',10);
if showtext
    text(x1,y1,'  P','color','k','fontweight','bold','fontsize',20);
    text(x2,y2,'  B','color','k','fontweight','bold','fontsize',20);
    text(x3,y3,'  T','color','k','fontweight','bold','fontsize',20);
end
end