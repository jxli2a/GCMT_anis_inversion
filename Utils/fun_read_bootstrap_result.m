function [result, fig, varargout] = fun_read_bootstrap_result(result_dir)
%% Read bootstrap result from result folder of a specific region
r2d = 180/pi;
files = dir(fullfile(result_dir,'*.mat'));
filenames = sort_nat({files(:).name});
nfile = length(files);
% read thomsen parameters from bootstrap results
eps_arr   = zeros(1,nfile);
gamma_arr = zeros(1,nfile);
delta_arr = zeros(1,nfile);
misfit_arr = zeros(1,nfile);

C33_arr = zeros(1, nfile);
C44_arr = zeros(1, nfile);
for i = 1:nfile
    filename = fullfile(result_dir,filenames{i});
    in_data  = load(filename);
    optim_sort    = in_data.optim_sort;
    misfit_arr(i) = optim_sort(1,2);
    eps_arr(i)    = optim_sort(1,10);
    gamma_arr(i)  = optim_sort(1,11);
    delta_arr(i)  = optim_sort(1,12);
    
% ------
    C11_arr(i) = optim_sort(1, 5);
    C33_arr(i) = optim_sort(1, 6);
    C44_arr(i) = optim_sort(1, 7);
    C66_arr(i) = optim_sort(1, 8);
    C13_arr(i) = optim_sort(1, 9);
end
%sigma_arr = C33_arr./C44_arr.*(eps_arr-delta_arr);
sigma_arr = (eps_arr-delta_arr);
% ------

eps_mean   = mean(eps_arr);   eps_err   = std(eps_arr);
gamma_mean = mean(gamma_arr); gamma_err = std(gamma_arr);
delta_mean = mean(delta_arr); delta_err = std(delta_arr);
result.thomsen = [eps_mean, gamma_mean, delta_mean];
result.thomsen_err = [eps_err, gamma_err, delta_err];
% *********************************
%result.theta = optim_sort(1,3)*r2d;
%result.phi = optim_sort(1,4)*r2d;
% *********************************
result.theta = optim_sort(1,3);
result.phi = optim_sort(1,4);
% ------
if exist('params', 'var')
    result.params = params;
end
% ------
% plot histogram for bootstrap samples's eps, gamma, delta
fig = figure;
set(fig,'Position',[33 48 662 742]);
histogram(gamma_arr,10);
xlabel('gamma');ylabel('Number of Bootstrap Samples');
% XX = sprintf('%s: eps=%5.4f�%5.4f, gamma=%5.4f�%5.4f, delta=%5.4f�%5.4f', ...
%     region_name,eps_mean,eps_err,gamma_mean,gamma_err,delta_mean,delta_err);
XX = sprintf('gamma=%3.2f%s%3.2f',gamma_mean,char(177),gamma_err);
title(XX);

if nargout >= 3
    varargout{1} = {eps_arr, gamma_arr, delta_arr, sigma_arr, C11_arr,C33_arr,C44_arr,C66_arr,C13_arr};
end
end