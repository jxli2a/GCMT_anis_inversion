function [c11,c33,c44,c66,c13] = thomsen_to_cijkl(c33,c44,eps,gamma,delta)
c11 = (1+2*eps)*c33;
c66 = (1+2*gamma)*c44;
c13 = sqrt(2*delta*c33*(c33-c44)+(c33-c44)^2)-c44;
end