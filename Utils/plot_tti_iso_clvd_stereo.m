function fig = plot_tti_iso_clvd_stereo(c11, c33, c44, c66, c13)
%% plot stereographic projection of the amount of isotropic and clvd components
%  for a fault n=(0,0,1) and v=(1,0,0); (ENU system;) on the upper
%  hemisphere
[iso, clvd] = get_tti_iso_clvd_stereo(c11, c33, c44, c66, c13);
%% plot figures
fig = figure; hold on;
set(fig, 'Visible', 'on','Color','white','unit','Normalized','Position',[0.2,0.2,0.5,0.5]);
%% show isotropic component distribution
subplot(1,2,1);
pcolor(xx,yy,iso); cb = colorbar; set(cb, 'Position', [0.4784 0.2965 0.0258 0.4404]);
colormap jet; shading interp; xlim([-1,1]); ylim([-1,1]); axis off; 
axis equal;
% plot contour lines
plot_contour_line(gca);
title('ISO');
%% show clvd component distribution
subplot(1,2,2);
pcolor(xx,yy,clvd);  cb = colorbar; set(cb, 'Position',[0.9175 0.2965 0.0258 0.4404]);
colormap jet; shading interp; xlim([-1,1]); ylim([-1,1]); axis off; 
axis equal;
% plot contour lines
plot_contour_line(gca);
title('CLVD');
end

