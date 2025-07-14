function cmap = create_colormap ( mymap) 
%% purpose: cmp = create_colormap ( mymap) 
% 4-column colormap; 
 
% mymap = [1   0       0         0.5
%          31  0       0.7500    1.0000
%          32  0.5     1.        0.5
%          33  1.0000  0.7500    0
%          64  0.5000  0         0]; 
ind = [1:64]'; 
ri = interp1(mymap(:,1), mymap(:,2), ind); 
gi = interp1(mymap(:,1), mymap(:,3), ind); 
bi = interp1(mymap(:,1), mymap(:,4), ind); 
cmap = [ri gi bi]; 
end
