function misfit = fun_misfit_eigvec(v1syn,v2syn,v3syn,lambdasyn,v1obs,v2obs,v3obs,lambdaobs,varargin)
%% Usage:
%  misfit defined by difference between eigen value and eigen vectors of
%  synthetic and observed moment tensors
%  By Jiaxuan Li    2017-09-05
if nargin >= 9
    f = varargin{1};
else
    f = 0;
end
nsyn = size(v1syn,2);
% d_v
d_v = (3-abs(sum(v1syn.*v1obs))-abs(sum(v2syn.*v2obs))-abs(sum(v3syn.*v3obs)))/3;
% d_lambda
%amp = 10;
%f   = max(0.1,f);
amp = min(10,1/f);
tmp_lambda = (lambdasyn-lambdaobs).*repmat([1,amp,1]',1,nsyn);
% tmp_lambda = tmp_lambda.*tmp_lambda/6;
% lambda0 = (f^2+2*f+3)/(f^2+f+1);
% lambda0 = 0.5*(f^2-2*f+3)/(f^2-f+1);
lambda0 = (f^2-2*f+3)/(f^2-f+1);
%lambda0 = 6;
tmp_lambda = tmp_lambda.*tmp_lambda/lambda0;
d_lambda = sum(tmp_lambda);
% misfit
misfit = d_v+d_lambda;
end
