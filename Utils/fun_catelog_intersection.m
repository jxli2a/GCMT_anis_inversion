function [idx1, idx2] = fun_catelog_intersection(datenum1, datenum2, varargin)
% find intersection between two catalogs by time (datenum)
if numel(varargin) >= 1
    time_eps = varargin{1};
else
    time_delta = 1/3600/24;
    time_eps = time_delta*1;
end
count = 0;
for n = 1:numel(datenum1)
    thisdatenum = datenum1(n);
    [time_error, m] = min(abs(thisdatenum-datenum2));
    if time_error <= time_eps
        fprintf('Find matched events, %d, %d\n',n,m);
        count = count+1;
        idx1(count) = n;
        idx2(count) = m;
    end
end
end