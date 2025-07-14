function [iso, clvd, dc] = fun_mt_decomp_new(mt, varargin)
if nargin >= 2
    coordsys = lower(varargin{1});
    switch coordsys
        case 'cmt'
            mt = Change_mt_coordinate(mt,1);
        case 'jma'
            mt = Change_mt_coordinate(mt,2);
        case 'voigt'
        otherwise
            disp('Coordinate system not recignized!');return;
    end
end
% full moment tensor
mt0 = [mt(1),mt(6),mt(5)
       mt(6),mt(2),mt(4)
       mt(5),mt(4),mt(3)];
% [vec, lambda] = eig(mt0);
% lambda0 = diag(lambda);
% if ~ issorted(lambda0)
%     [lambda0, I] = sort(lambda0);
%     vec = vec(:, I);
% end
lambda0 = sort(eig(mt0));
[~, idx] = max(abs(lambda0));
Mmax0 = lambda0(idx);
% deviatoric part
mii = mean(mt(1:3));
mt1 = [mt(1)-mii,mt(6),mt(5)
       mt(6),mt(2)-mii,mt(4)
       mt(5),mt(4),mt(3)-mii];
lambda1 = sort(eig(mt1));
[~, idx] = min(abs(lambda1));
Mmin1 = lambda1(idx);
[~, idx] = max(abs(lambda1));
Mmax1 = lambda1(idx);
eps = -(Mmin1/abs(Mmax1));
iso = mii/abs(Mmax0);
clvd = 2*eps*(1-abs(iso));
dc = 1-abs(iso)-abs(clvd);
end