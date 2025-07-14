function [iso, clvd, xx, yy] = get_tti_iso_clvd_stereo(c11, c33, c44, c66, c13)
%% get stereographic projection of the amount of isotropic and clvd components
%  for a fault n=(0,0,1) and v=(1,0,0); (ENU system;) on the upper
%  hemisphere
%%
% fault geometry
n = [0, 0, 1];                                        % fault normal vector
v = [1, 0, 0];                                        % fault slip vector
D = n'*v+v'*n;                                        % dyadic tensor
d = [D(1,1); D(2,2); D(3,3); D(2,3); D(1,3); D(1,2)]; % voigt notation of dyadic tensor
% TTI symmetry axis angle (theta, phi)
nth = 61;
nph = 181;
ph1 = linspace(0, 2*pi, nph);
th1 = linspace(0, pi/2, nth);
xx   = zeros(nph,nth);
yy   = xx; 
iso  = xx;
clvd = xx;
for j =1: nth
    for k =1: nph
        phi = ph1(k);
        theta = th1(j);
        xx(k,j) = tan(theta/2)*sin(phi);
        yy(k,j) = tan(theta/2)*cos(phi);
        Ct = VTI_to_TTI(c11,c33,c44,c66,c13,theta,phi);
        mt = Ct*d;
        [iso_tmp, clvd_tmp, ~] = fun_mt_decomp_new(mt);
        iso(k, j) = iso_tmp;
        clvd(k,j) = clvd_tmp;
    end
end
end