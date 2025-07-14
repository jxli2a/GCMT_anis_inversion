function tti_angles = fun_read_ttiangles(result_dir,region_name,varargin)
%% load tti angle results
%  Output angle in degree
%  By Jiaxuan Li    --2018-09-11--
is_bootstrap = 0;
if nargin >= 3
    is_bootstrap = varargin{1};
end
if is_bootstrap
    filename = fullfile(result_dir,region_name,[region_name,'_1.mat']);
else
    filename = fullfile(result_dir,[region_name,'.mat']);
end
load(filename,'optim_sort');
tti_angles.theta = optim_sort(1,3);
tti_angles.phi = optim_sort(1,4);
end