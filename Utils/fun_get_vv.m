function [xx,yy,vv] = fun_get_vv(optim,varargin)
nsave = 10;
th = unique(optim(:,3))/180*pi;
ph = unique(optim(:,4))/180*pi;
ntheta = numel(th);
nphi = numel(ph);
number = 1;
for i = 1:ntheta
    for j = 1:nphi
        theta = th(i);
        phi = ph(j);
        % xx is right, yy is up in the figure
        xx(j,i) = tan(theta/2) * (-sin(phi));
        yy(j,i) = tan(theta/2) * (-cos(phi));
        vv(j,i) = optim(nsave*(number-1)+1,2);
        number = number+1;
    end
end
end