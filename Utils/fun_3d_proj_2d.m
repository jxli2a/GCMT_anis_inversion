function [X,Y] = fun_3d_proj_2d(V, center, e1, e2)
%% get projection of 3d vector on 2d plane formed by orthorgonal vector pair (e1, e2)
center = center(:);
e1 = e1(:);
e2 = e2(:);
% V, center, e1, e2 are column vectors;
V0 = V-repmat(center, 1, size(V, 2));
X = e1'*V0;
Y = e2'*V0;
end