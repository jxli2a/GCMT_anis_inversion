function varargout = plot_scatter_by_mag_3d(X, Y, Z, mag, varargin)
%% This script plot evts scatter with size representing magnitude
%  example: plot_scatter_by_mag_3d(evlo, evla, evdp, Mw, 'color', 'k')
%  By Jiaxuan Li  --2019-01-11--
%
% default set
propertyNames.markerfacecolor = 'markerfacecolor';
propertyValues.markerfacecolor = [0.35,0.35,0.35];
propertyNames.marker = 'marker';
propertyValues.marker = 'o';
for n = 1:2:numel(varargin)-1
    propertyname = lower(varargin{n});
    switch propertyname
        case 'markerfacecolor'
            propertyValues.(propertyname) = varargin{n+1};
        case 'marker'
            propertyValues.(propertyname) = varargin{n+1};
        otherwise
            propertyNames.(propertyname) = propertyname;
            propertyValues.(propertyname) = varargin{n+1};
    end
end
mag1 = floor(min(mag));
mag2 = ceil(max(mag));
dmag = 1; magarr = mag1:dmag:mag2;
m0 = 0; m1 = 9;
x = (magarr-m0)/(m1-m0);
% sizemin = 1; sizemax = 10;
% h = @(x) sizemax*x.^(3/2)+sizemin;%sizemax*x.^2+sizemin;
funsize = @(x) 81/4*x.^2+1; % size(x) = a*x^2+b; x(mag) = (mag-m0)/m1; m0 = 0; m1 = 9; let size(x(6)) = 10; size(x(0)) = 1; we ahve a=81/4, b=1;
sizearr = funsize(x);
% plot evts scatter with size representing magnitude
hold on;
count = 0;
for i = 1:numel(magarr)-1
    idx = mag >= magarr(i) & mag < magarr(i+1);
    if sum(idx) == 0, continue; end
    count = count+1;
    hscatter(count) = plot3(X(idx), Y(idx), Z(idx), 'o', 'MarkerSize',sizearr(i), ... 
        'MarkerFaceColor',[0.35,0.35,0.35], 'MarkerEdgeColor',[0.25,0.25,0.25]);
    hlegend(count) = plot3(NaN, NaN, NaN, 'o', 'MarkerSize', sizearr(i), ... 
        'MarkerFaceColor',[0.35,0.35,0.35], 'MarkerEdgeColor',[0.25,0.25,0.25]);
    strings{count} = sprintf('mag %d ~ %d', magarr(i), magarr(i+1));
end
% set properties
propertyfields = fieldnames(propertyNames);
for n = 1:numel(propertyfields)
    thisfield = propertyfields{n};
    for i = 1:numel(hscatter)
        set(hscatter(i),propertyNames.(thisfield),propertyValues.(thisfield));
        set(hlegend(i),propertyNames.(thisfield),propertyValues.(thisfield));
    end
end
[h, icons] = legend(hlegend, strings);
if nargout >= 1
    varargout{1} = hscatter;
end
end