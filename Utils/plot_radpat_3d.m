function fig = plot_radpat_3d(mt)
%% By Jiaxuan Li
fig = figure;
RES=.025;              % increase RES for faster plotting
%RES = .08;
sc = 1;
range=[-2:RES:2]*sc;
[x,y,z]=meshgrid(range);
[ph,th,r] = cart2sph(x,y,z);
th=pi/2-th; 
rho = 3400; % kg/m^3
vp0 = 10000;
up = zeros(size(x));
[nx,ny,nz] = size(x);
for ix = 1:nx
    for iy = 1:ny
        for iz = 1:nz
            phi = ph(ix,iy,iz);
            theta = th(ix,iy,iz);
            [~,~,~, up(ix,iy,iz)] = get_farfield_up_mt_analytical (mt(2),mt(3),mt(1),-mt(5),mt(4),-mt(6),1, phi,theta,vp0,rho);
            up(ix,iy,iz) = up(ix,iy,iz)/r(ix,iy,iz);
        end
    end
end
p = up;
p(p<0) = 0;
n = up;
n(n>=0) = 0;
p= patch(isosurface(x, y, z, abs(p),+.5/sc));
n= patch(isosurface(x, y, z, abs(n),+.5/sc));
isonormals(x,y,z,up,p);
isonormals(x,y,z,up,n);
set(p, 'FaceColor', 'red', 'EdgeColor', 'none'); alpha(p,.75);
set(n, 'FaceColor', 'blue', 'EdgeColor', 'none');alpha(n,.75);
daspect([1 1 1]);  view(3);
camlight; lighting flat; axis off;

