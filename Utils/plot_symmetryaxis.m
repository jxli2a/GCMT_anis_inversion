function plot_symmetryaxis(theta,phi,varargin)
% plot the TTI symmetry axis on the low hemisphere stereographic projection
% input angles are in radians
% 2017-10-06 By Jiaxuan Li
% Modified 2017-10-15    Add more options
%
% default set
propertyNames.color = 'color';
propertyNames.marker = 'marker';
propertyNames.markersize = 'markersize';
propertyValues.color = 'r';
propertyValues.marker = '^';
propertyValues.markersize = 30;
for n = 1:2:nargin-2
    propertyname = lower(varargin{n});
    switch propertyname
        case 'color'
            propertyValues.(propertyname) = varargin{n+1};
        case 'marker'
            propertyValues.(propertyname) = varargin{n+1};
        case 'markersize'
            propertyValues.(propertyname) = varargin{n+1};
        otherwise
            propertyNames.(propertyname) = propertyname;
            propertyValues.(propertyname) = varargin{n+1};
    end
end
x3 = tan(theta/2) * (-sin(phi));
y3 = tan(theta/2)* (-cos(phi));
h0 = plot(x3,y3);
propertyfields = fieldnames(propertyNames);
for n = 1:numel(propertyfields)
    thisfield = propertyfields{n};
    set(h0,propertyNames.(thisfield),propertyValues.(thisfield));
end
end