function [eps,gamma,delta] = cijkl_to_thomsen(c11,c33,c44,c66,c13)
%% Usage:[eps,gamma,delta] = cijkl_to_thomsen(c11,c33,c44,c66,c13)
eps = (c11-c33)/(2*c33);
gamma = (c66-c44)/(2*c44);
delta = ((c13+c44)^2-(c33-c44)^2)/(2*c33*(c33-c44));
end