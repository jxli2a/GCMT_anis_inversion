function poolobj = parfor_init(ncore)
poolobj = gcp('nocreate'); 
delete(poolobj);
nmachinecore = feature('numcores');
ncore = min([ncore, nmachinecore]);
poolobj = parpool(ncore);
end