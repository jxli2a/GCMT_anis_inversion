function [dsyn,varargout] = fun_makedsyn(number)
%% Usage: dsyn = fun_makedsyn(number)
% get normalized synthetic d vector with random fault geometry
% By Jiaxuan Li     2017-09-05
rng('default');
dsyn = zeros(6,number);
dplane = zeros(3,number);
for n = 1:number
    dip = 90*rand(1);
    strike = 360*rand(1);
    rake = 360*(rand(1)-0.5);
    thisd = get_fault_geometry(strike,dip,rake);
    dtmp = thisd.*[2,2,2,sqrt(2),sqrt(2),sqrt(2)];
    d0 = sqrt(sum(dtmp.*dtmp/2));
    thisd = thisd./repmat(d0,1,6);
    dsyn(1:6,n) = thisd';
    dplane(1:3,n) = [strike,dip,rake]';
end
if nargout == 2
    varargout{1} = dplane;
end
end