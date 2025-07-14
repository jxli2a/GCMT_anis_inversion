function plot_faultplane_slab_3d(strike,dip,center,varargin)
%% plot fault plane together with slab in 3-D view
d2km = 111.1949;
radius = 0.4;
facecolor = 'y';
linecolor = 'b';
facealpha = 0.4;
if nargin >= 3
    for n = 1:2:nargin-4
        switch varargin{n}
            case 'radius'
                radius = varargin{n+1};
            case 'facecolor'
                facecolor = varargin{n+1};
            case 'linecolor'
                linecolor = varargin{n+1};
            case 'facealpha'
                facealpha = varargin{n+1};
            otherwise
                fprintf('Unvalid option');
        end
    end
end
th =(0:2*pi/100:2*pi);
x = radius*cos(th);
y = radius*sin(th);
z = zeros(size(x));
% S(1)E(2)U(3)
rot2 = fun_get_rot_mat(dip,2);
rot3 = fun_get_rot_mat(-strike,3);
X = rot3*(rot2*([x;y;z]));
xr = X(1,:); yr = X(2,:); zr = X(3,:)*d2km;
xr = xr+center(1);
yr = yr+center(2);
zr = -zr+center(3);
plot3(xr,yr,zr,'color',linecolor,'LineWidth',1);
fill3(xr,yr,zr,facecolor,'FaceAlpha',facealpha);
end