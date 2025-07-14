function mt = fun_preprocess_mt(mt,varargin)
%% By Jiaxuan Li  --2018-09-10--
%  remove trace, normalize and change coordinate system for moment tensor 
%%
% default: input mt in cmt coordinate, output mt in voigt coordinate
flag = 1;
if nargin >= 2
    flag = varargin{1};
end
% ensure column vector
mt = mt(:);
% subtract trace
mt(1:3) = mt(1:3)-mean(mt(1:3));
% normalize
mt0 = sqrt((sum(mt(1:3).^2)+2*sum(mt(4:6).^2))/2);
mt = mt/mt0;
% change from cmt to voigt coordinate
mt = Change_mt_coordinate(mt,flag);
end