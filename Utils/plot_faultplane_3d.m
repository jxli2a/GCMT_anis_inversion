function plot_faultplane_3d(strike,dip,slab_strike,slab_dip)
rot_fault1 = fun_get_rot_mat(-dip,1);
rot_fault3 = fun_get_rot_mat(-strike,3);
nvec_fault = rot_fault3*rot_fault1*[0;0;1];
nvec_fault = inv(rot1)*inv(rot3)*nvec_fault;
[thisvert, thisface] = get_volume_intersection_point([0,0,0],nvec_fault,dx,dy,dz,'y');
thisvert = (rot3*(rot1*thisvert'))';
plot3(thisvert([1:4,1],1),thisvert([1:4,1],2),thisvert([1:4,1],3),'k-','linewidth',1.5);
patch('Faces',thisface,'Vertices',thisvert,'FaceColor','y','FaceAlpha',0.7);
end