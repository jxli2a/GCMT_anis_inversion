function fig = plot_fclvd_fit(fclvd_all_obs,fclvd_all_syn)
% plot the fclvd of syn mt vs fclvd of obs mt
% plot the best fit line of all points
% 2017-10-11  By Jiaxuan Li
fig = figure; hold on;
set(fig,'Position',[2 48 1075 757],'Color','white');
plot(fclvd_all_obs,fclvd_all_syn,'o','Color',[0 0.4470 0.7410]);
axis equal;
% set tick
lowtick = -0.2; dtick = 0.05; hightick = 0.2;
if max(abs(fclvd_all_obs)) > 0.2, lowtick = -0.5; dtick = 0.1; hightick =0.5; end
set(gca,'ytick',lowtick:dtick:hightick);
set(gca,'xtick',lowtick:dtick:hightick);
grid on; box on;
xlabel('OBS');ylabel('SYN');
title('fclvd Synthetic--Observed');

%% line fit
[~,P] = fit_2D_data(fclvd_all_obs,fclvd_all_syn,'no');
b = P(1); a = P(2);
xx = -2:0.1:2;
yy = b*xx+a;
plot(xx,yy,'r-','Linewidth',1.5);
xlim([lowtick,hightick]);
ylim([lowtick,hightick]);
set(0,'defaultaxesfontsize',16);

%% bootstrap the slope
% rng('default')
% n = length(fclvd_all_obs);
% for i = 1:2000
%     iseq = randi([1,n],1,round(n/10));
%     fclvd_all_obs1 = fclvd_all_obs(iseq);
%     fclvd_all_syn1 = fclvd_all_syn(iseq);
%     [~,Ptmp] = fit_2D_data(fclvd_all_obs1,fclvd_all_syn1,'no');
%     Pseq(i) = Ptmp(1);
% end
% fprintf('mean slope:  %3.2f, std err slope: %3.2f\n',mean(Pseq),std(Pseq));
end