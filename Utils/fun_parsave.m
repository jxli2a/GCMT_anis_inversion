function fun_parsave(results,outfilename)
% By Jiaxuan Li    --2018-09-12--
optim_sort = results.optim_sort;
misfit_iso = results.misfit_iso;
slab_cijkl = results.params.slab_cijkl;
params = results.params;
bs_seq = results.params.bs_seq;
theta0 = results.theta0;
phi0 = results.phi0;
save(outfilename,'optim_sort','misfit_iso','bs_seq','slab_cijkl','params','theta0','phi0');
end