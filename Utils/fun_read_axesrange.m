function regions = fun_read_axesrange(filename)
%% Usage: regions = fun_read_axesrange(filename)
% read in axes range for inversion
% By Jiaxuan Li     2017-09-05
fid = fopen(filename);
tline = fgetl(fid);
i = 1;
while ischar(tline)
    regions(i).name = tline;
    tline = fgetl(fid);
    ranges = sscanf(tline,'%f');
    regions(i).theta = [ranges(1),ranges(2)];
    regions(i).phi   = [ranges(3),ranges(4)];
    tline = fgetl(fid);
    i = i+1;
end
fclose(fid);
end