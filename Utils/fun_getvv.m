function [xx,yy,vv] = fun_getvv(optim,nphi,ntheta,varargin)
%% Usage: [xx,yy,vv] = fun_getvv(optim,nphi,ntheta)
% prepare xx, yy, vv for pcolor()
% modified 2017-10-15  add varargin to control the misfit column index
if nargin >= 4
    cindx = varargin{1};
else
    cindx = 2;
end
th1 = linspace(0,pi/2,ntheta);
phi1 = linspace(0,2*pi,nphi);
xx = zeros(nphi,ntheta);
yy = zeros(nphi,ntheta);
vv = zeros(nphi,ntheta);
number = 1;
for i = 1:ntheta
    for j = 1:nphi
        theta = th1(i);
        phi = phi1(j);
        % xx is right, yy is up in the figure
        xx(j,i) = tan(theta/2) * (-sin(phi));
        yy(j,i) = tan(theta/2) * (-cos(phi));
        vv(j,i) = optim(10*(number-1)+1,cindx);
        number = number+1;
    end
end
end