function plot_cross_section(slab)
%% Usage: plot_cross_section(slab)
%  Input: slab structure
%%
% plot the cross section of the slab, including events projection, slab
% normal, TTI symmetry axis, and slab interface.
% As reply to reviewer #3 for NatureGeosience paper
% By Jiaxuan Li            --2018-05-04--
% Modified By Jiaxuan Li   --2018-05-09-- Add the background tomo model
% Modified By Jiaxuan Li   --2019-01-03-- Make components optional
hold on;
d2km = 111.1949;
km2d = 1/111.1949;
cross = slab.cross;
center = slab.center;
istomo = 0;
%% events
if isfield(cross, 'evtX') && isfield(cross, 'evtY')
    scatter(cross.evtX,cross.evtY,6,'MarkerEdgeColor',[0.5,0.5,0.5],'Marker','o');
end

%% slab interface
% ylimit = get(gca,'ylim');
% ratio = 0.5;
% ylimit(1) = max(-29/d2km-slab.center(3),ylimit(1)-ratio*(ylimit(2)-ylimit(1)));
% ylimit(2) = ylimit(2)+2+ratio*(ylimit(2)-ylimit(1));
% ratio = 0.8;
% xlimit = get(gca,'xlim');
% xlimit(1) = xlimit(1)-ratio*(xlimit(2)-xlimit(1));
% xlimit(2) = xlimit(2)+ratio*(xlimit(2)-xlimit(1));
if isfield(slab, 'interface')
    plot(slab.interface.X,slab.interface.Y,'k-','linewidth',2);
end
xlimit(1) = -2.0; xlimit(2) = 1.0;
ylimit(1) = -180*km2d;
ylimit(2) = +500*km2d;
set(gca,'ylim',ylimit,'xlim',xlimit);
%% tomo model
% load GAP_P4 data
if istomo
    load('GAP_P4.01_17.mat','data');
    ylimit(1) = 0*km2d-center(3);
    ylimit(2) = 800*km2d-center(3);
    xvec = slab.xvec;
    lon1 = center(1)+(xlimit(1))*xvec(1);
    lon2 = center(1)+(xlimit(2))*xvec(1);
    lat1 = center(2)+(xlimit(1))*xvec(2);
    lat2 = center(2)+(xlimit(2))*xvec(2);
    dep1 = (ylimit(1)+center(3))*d2km;
    dep2 = (ylimit(2)+center(3))*d2km;
    dep1 = 0; dep2 = 800;
    [lonq,latq,depq,Dq] = extract_tomo_data(data,lon1,lon2,lat1,lat2,dep1,dep2,0.1,1,'slice');
    lon = lonq(1,:);
    lat = latq(1,:);
    v = [lon;lat]-repmat(center(1:2)',1,numel(lon));
    xval = xvec(1:2)*v;
    yval = depq(:,1)*km2d-center(3);
    idx = xval < xlimit(2) & xval > xlimit(1);
    idy = yval < ylimit(2) & yval > ylimit(1);
    xval = xval(idx);
    yval = yval(idy);
    Dq = Dq(idy,idx);
    h = pcolor(xval,yval,Dq);
    shading flat;
    mymap = [1  0.6  0.00    0
        21  1.00  0.255    0.000
        29  1.0   1.0       1.0
        32.5  1.0   1       1.0
        36  1.0  1    1
        44  0.0  1    1
        64  0.00  0       0.6];
    cmap = create_colormap(mymap);
    colormap(cmap);
    %colorbar('southoutside');
    caxis([-1.5,1.5]);
    uistack(h,'bottom');
end

%% symmetry axis
dx = xlimit(2); dy = -ylimit(1);
dr = min(dx,dy)*0.9*sqrt(2);
dr = 3;
p0 = [0,0,0];
if isfield(cross, 'norX') && isfield(cross, 'norY')
    p2 = p0+dr*[cross.norX,cross.norY,0];
    %arrow(p0,p2,'width',1.5,'length',10,'BaseAngle',45,'TipAngle',20,'Edgecolor','w','Facecolor','b');
    mArrow3_strech(p0,p2,'color','b');
end
if isfield(cross, 'symX') && isfield(cross, 'symY')
    p1 = p0+dr*[cross.symX,cross.symY,0];
    %arrow(p0,p1,'width',1.5,'length',10,'BaseAngle',45,'TipAngle',20,'Edgecolor','w','Facecolor','r');
    mArrow3_strech(p0,p1,'color','r');
end



%% set axes properties
% reset yticklabel
set(gca,'xdir','reverse');
set(gca,'ydir','reverse');
axis equal;
depmin = max(0,floor((ylimit(1)+center(3))*d2km/50)*50);
depmax = ceil((ylimit(2)+center(3))*d2km/50)*50;
depmin = 0; depmax = 300;
dep = depmin:100:depmax;
xtick = -5:2.5:5;
ytick = zeros(numel(dep),1);
yticklabel = cell(numel(dep),1);
for n = 1:numel(dep)
    thisdep = dep(n);
    ytick(n) = thisdep*km2d-center(3);
    yticklabel{n} = num2str(thisdep);
end
set(gca,'ytick',ytick,'yticklabel',yticklabel,'ylim',[depmin,depmax]*km2d-center(3),'xlim',xlimit,'xtick',xtick);
grid on;
box on;
xlabel('X (degree)');
ylabel('Depth (km)');
set(gca,'fontsize',10,'layer','top');
% % region text
% x = xlimit(2)-0.01*(xlimit(2)-xlimit(1));
% y = ylimit(1)+0.1*(ylimit(2)-ylimit(1));
% text(x,y,slab.regionshort,'fontsize',16,'color',[0.2,0.2,0.2]);
end