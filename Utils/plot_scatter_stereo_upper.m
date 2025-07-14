function plot_scatter_stereo_upper(dip, azi, varargin)
%% plot stereographic projection on upper hemisphere
%  dip is from up to north
%  azi is from north to east
theta = dip;
phi = azi+pi;
plot_symmetryaxis(theta, phi, varargin{:});
end