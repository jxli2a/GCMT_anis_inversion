function [xr,yr,zr] = rotate_vec(dx,dy,dz,theta,phi)
d2r = pi/180;
theta = theta*d2r; phi = phi*d2r;
xr = (-1).*dy.*sin(phi)+cos(phi).*(dx.*cos(theta)+(-1).*dz.*sin(theta));
yr = dy.*cos(phi)+sin(phi).*(dx.*cos(theta)+(-1).*dz.*sin(theta));
zr = dz.*cos(theta)+dx.*sin(theta);
end