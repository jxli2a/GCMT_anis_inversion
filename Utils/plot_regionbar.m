function fig = plot_regionbar(depmin,depmax,yname,yvar,parts)
% By Jiaxuan Li --2017-12-05--
% plot region bar properties for gamma-depth, angle-depth plot
[colors,marks,regions] = fun_make_regionbar(parts);
fig = figure;
set(fig,'Position',[1 48 1115 757],'color','white');
%colors = distinguishable_colors(numel(parts));
for i = 1:length(parts)
    %plot([depmin(i),depmax(i)],[yvar(i),yvar(i)],marks{i},'linewidth',2,'color',colors(i,:),'markersize',8);
    %text((depmax(i)+depmin(i))/2,yvar(i)+0.005,regions{i},'fontsize',20,'color',colors(i,:));
    plot([depmin(i),depmax(i)],[yvar(i),yvar(i)],marks{i},'linewidth',2,'color',colors{i},'markersize',8);
    text((depmax(i)+depmin(i))/2,yvar(i)+0.005,regions{i},'fontsize',20,'color',colors{i});
    hold on;
end
xlabel('Depth (km)');
ylabel(yname);
xlim([100,660]);grid on;
end