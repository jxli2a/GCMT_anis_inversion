function fun_generate_eiginvfile(regionnames,theta_range,phi_range,outfilename)
%% generate eig inversion txt file
%  By Jiaxuan Li    --2018-09-10--
if exist(outfilename,'file')
    x = input(sprintf('%s already exist, conintue? (press 1 to continue)\n',outfilename));
    if ~(x == 1)
        return;
    end
end
fid = fopen(outfilename,'w');
for n = 1:numel(regionnames)
    fprintf(fid,'%s\n',regionnames{n});
    fprintf(fid,'%4.1f %4.1f %4.1f %4.1f\n',theta_range(n,1),theta_range(n,2),phi_range(n,1),phi_range(n,2));
end
fclose(fid);
end