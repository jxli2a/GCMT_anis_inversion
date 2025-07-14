function [vert_anis, face_anis] = get_volume_intersection_point(point,nvec,dx,dy,dz,direction)
planex = @(y,z) (point*nvec-nvec(2)*y-nvec(3)*z)/nvec(1);
planey = @(z,x) (point*nvec-nvec(3)*z-nvec(1)*x)/nvec(2);
planez = @(x,y) (point*nvec-nvec(1)*x-nvec(2)*y)/nvec(3);
switch direction
    case 'x'
        plane = planex;
        da = dy; db = dz;
        ia = 2;  ib = 3; ic = 1;
    case 'y'
        plane = planey;
        da = dz; db = dx;
        ia = 3;  ib = 1; ic = 2;
    case 'z'
        plane = planez;
        da = dx; db = dy;
        ia = 1;  ib = 2; ic = 3;
end
pt1(ic) = plane(da,db);   pt1(ia) = da;  pt1(ib) = db;
pt2(ic) = plane(da,-db);  pt2(ia) = da;  pt2(ib) = -db;
pt3(ic) = plane(-da,-db); pt3(ia) = -da; pt3(ib) = -db;
pt4(ic) = plane(-da,db);  pt4(ia) = -da; pt4(ib) = db;
vert_anis = [pt1;pt2;pt3;pt4];
face_anis = [1,2,3,4];
end