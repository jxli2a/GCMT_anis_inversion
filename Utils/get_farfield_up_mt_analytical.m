function [upx,upy,upz,up]=get_farfield_up_mt_analytical (M11,M22,M33,M23,M13,M12,R, phi,theta,vp,rho)
%% (1,2,3)=(x,y,z)=(North,East,Down);
gamma1 = sin(theta)*cos(phi);
gamma2 = sin(theta)*sin(phi);
gamma3 = cos(theta);
M21 = M12; M31=M13; M32=M23; 
M0 = M11^2 + M12^2 + M13^2 + M21^2 + M22^2 + M23^2 + M31^2 + M32^2 + M33^2;
M0 =sqrt(M0/2);
%%  
upx= gamma1^3*M11 + 2*gamma1^2*gamma2*M12 + 2*gamma1^2*gamma3*M13 + gamma1*gamma2^2*M22 + 2*gamma1*gamma2*gamma3*M23 +...
    gamma1*gamma3^2*M33;
upy = gamma1^2*gamma2*M11 + 2*gamma1*gamma2^2*M12 + 2*gamma1*gamma2*gamma3*M13 + gamma2^3*M22 + 2*gamma2^2*gamma3*M23 +...
    gamma2*gamma3^2*M33;
upz = gamma1^2*gamma3*M11 + 2*gamma1*gamma2*gamma3*M12 + 2*gamma1*gamma3^2*M13 + gamma2^2*gamma3*M22 + ...
    2*gamma2*gamma3^2*M23 + gamma3^3*M33;
er = [gamma1 ,gamma2, gamma3];
up = dot(er, [upx upy upz]);
%
upx = upx/M0;
upy = upy/M0;
upz = upz/M0; 
up = up/M0;
end
