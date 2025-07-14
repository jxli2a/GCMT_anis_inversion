clearvars; close all; clc;
addpath(genpath(fullfile(pwd,'Utils')));
addpath(genpath(fullfile(pwd,'MyClass')));
%%
data_dir = fullfile(pwd,'Data','GCMT','evts_all_final');
earth_model_path = fullfile(pwd,'/Data/earth_model');
earth_model = csvread(fullfile(earth_model_path,'PREM_1s.csv'));
%%
cmt_list = cell(1, 8);
for i = 1:8
    name = ['tonga', num2str(i)];
    slab_evts = load(fullfile(data_dir, [name, '.mat']));
    cmt = CMTEvtsInv(name, slab_evts.near_slab_evt_part);
    cmt.inv_det;
    cmt_list{i} = cmt;
    cmt.show;
end
%%
colors = distinguishable_colors(8);
slab = Slab1998('tonga');
fig_slab = slab.show;
hold on;
for i = 1:8
    cmt = cmt_list{i};
    cmt.color=colors(i, :);
    cmt.show;
    tti = cmt.get_tti_struct;
    cmt.show_tti(tti);
end