function plot_beach_ball(mt)
%% This script is used to plot beach ball
%  The initial movement of:
%  blue region on the beach ball is inward  (P axis) (minimum eigen value of moment tensor)
%  red  region on the beach ball is outward (T axis) (maximum eigen value of moment tensor)
%  Usage: 
%  input is one moment tensor in CMT format
%  mt = [mrr,mtt,mpp,mrt,mrp.mtp]
%  output is one beach ball figure for this mechanism
%  By Jiaxuan Li Email: lijiaxuanmail@gmail.com
rho = 3400; % kg/m^3
vp0 = 10000;
%ntheta = 61;nphi = 181;
ntheta = 61;nphi = 181;
phi1 = linspace(0, 2*pi, nphi);
th1 = linspace(0, pi/2, ntheta);
xx = zeros(nphi,ntheta);
yy = xx; vv = xx; vv1 = xx;
for j =1: ntheta
    for k =1: nphi
        phi = phi1(k);
        theta = th1(j);
        xx(k,j) = tan(theta/2)*sin(phi);
        yy(k,j) = tan(theta/2)*cos(phi);
        [ux,uy,uz, up] = get_farfield_up_mt_analytical (mt(2),mt(3),mt(1),-mt(5),mt(4),-mt(6),1, phi,theta,vp0,rho) ;
        %[ux,uy,uz, up] = get_farfield_up_mt(mt(2),mt(3),mt(1),-mt(5),mt(4),-mt(6),1, phi,theta,vp0,rho) ;
        vv(k,j) = up;
    end
end
%% colormap
% red and white
% mymap = [1  1    1       1
%         32  1    1.0     1.0
%     %      32        .5 1 .5
%         33  0.88  0.0     0.0
%         64  0.89  0.0     0.0];

% red and blue
% mymap = [1  0.00  0.00    1
%         31  0.00  0.00    0.7000
%         32  0.5   1       .5
%         33  0.70  0.00    0
%         64  1.00  0       0];

% white and gray
mymap = [1  1    1       1
        32  1    1.0     1.0
    %      32        .5 1 .5
    33  0.35  0.35     0.35
    64  0.36  0.36     0.36];
% mymap = [1  1    1       1
%     32  1    1.0     1.0
%     %      32        .5 1 .5
%     33  0.5  1     0.5
%     64  0.5  1     0.5];
% mymap = [1  1    1       1
%     31  0.9   1.0 0.9
%     32  0.8    1.0     0.8
%     %      32        .5 1 .5
%     33  0.7  1     0.7
%     64  0.4  1     0.4];

cmap = create_colormap ( mymap) ;
colormap(cmap)
pcolor (xx,yy, vv);
hold on;shading interp;
tt = linspace(0,2*pi,400);
xx = cos(tt);
yy = sin(tt);
plot(xx,yy,'-','color',[0.8,0.8,0.8],'linewidth',1)
axis equal;
axis off;
end