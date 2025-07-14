function varargout = plot_2d_vec_cross_section(strike, vec3d, varargin)
dr = 1.0;
thiscolor = 'm';
stemWidth = 0.025;
for n = 1:numel(varargin)-1
    switch lower(varargin{n})
        case 'color'
            thiscolor = varargin{n+1};
        case 'stemwidth'
            stemWidth = varargin{n+1};
        case 'len'
            dr = varargin{n+1};
    end
end
% 2D-crosssection x vector
xvec = [sind(strike+90),cosd(strike+90),0];
% 2D-crosssection y vector
yvec = [0,0,1];
% projection on 2-D vertical surface
vec2dX = xvec*vec3d';
vec2dY = yvec*vec3d';
vec2dX = vec2dX/sqrt(vec2dX^2+vec2dY^2);
vec2dY = vec2dY/sqrt(vec2dX^2+vec2dY^2);
p0 = [0, 0, 0];
p1 = p0+dr*[vec2dX,vec2dY,0];
hnorm = mArrow3_strech(p0,p1,'color',thiscolor, 'stemWidth', stemWidth);
if nargout >= 1
    varargout{1} = hnorm;
end
end