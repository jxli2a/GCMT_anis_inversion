function rot = fun_get_rot_mat(angle,direction)
%% get rotation matrix along 3 axes in 3D
%  angle is positive for right hand rotation
%           negative for left  
ct = cosd(angle);
st = sind(angle);
switch direction
    case 1
        rot = [1, 0, 0
               0, ct,-st
               0, st, ct];
    case 2
        rot = [ct, 0, st
               0,  1,  0
               -st, 0, ct];
    case 3
        rot = [ct, -st, 0
               st,  ct, 0
               0 ,  0,  1];
end
end