function fun_write_axesrange(regions,outfilename)
%% write axes range txt file for eig method inversion
%  By Jiaxuan Li    --2018-09-10--
%
if exist(outfilename,'file')
    x = input(sprintf('%s already exist, conintue? (press 1 to continue)\n',outfilename));
    if ~(x == 1)
        return;
    end
end
fid = fopen(outfilename,'w');
for n = 1:numel(regions)
    fprintf(fid,'%s\n',regions(n).name);
    thl = regions(n).theta(1);
    thu = regions(n).theta(2);
    phl = regions(n).phi(1);
    phu = regions(n).phi(2);
    fprintf(fid,'%4.1f %4.1f %4.1f %4.1f\n',thl,thu,phl,phu);
end
fclose(fid);
end