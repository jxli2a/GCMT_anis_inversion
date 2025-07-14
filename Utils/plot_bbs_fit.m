function fig0 = plot_bbs_fit(mts_syn,mts_obs,varargin)
% plot the observed and synthetic beach balls on the same figure;
% input moment tensor format: voigt
% 2017-10-10  By Jiaxuan Li
% 2017-12-01  plot 2 different fault geometries for 2 beach balls
if nargin >= 3
    plane1 = varargin{1};
    strike1 = plane1(1,:);
    dip1 = plane1(2,:);
    strike2 = strike1; dip2 = dip1;
    if nargin == 4
        plane2 = varargin{2};
        strike2 = plane2(1,:);
        dip2 = plane2(2,:);
    end
end
nevt = size(mts_syn,2);
% beach ball geometry on the figure
col = ceil(sqrt(nevt*2)/2);
row = ceil(nevt/col);

len_col = 1/col; dx = len_col/23; lenx = 10/23*len_col;
len_row = 1/row; dy = len_row/12; leny = 10/12*len_row;

tmp = linspace(0,1-1/col,col);
X = repmat([dx,2*dx+lenx],1,col)+reshape([tmp;tmp],1,2*col);
Y = linspace(0,1-len_row,row)+dy;
[xpos,ypos] = meshgrid(X,Y);ypos = flipud(ypos);

fig0 = figure;
set(fig0,'Unit','Normalized','Position',[0,0,1,1],'color','white');
count = 0;

for nrow = 1:row
    for ncol = 1:col
        count = count+1;
        if count <= nevt
            mt_obs = mts_obs(:,count);
            mt_syn = mts_syn(:,count);
            
            ii = 2*(ncol-1)+1; jj = nrow;
            left1 = xpos(jj,ii); bottom1 = ypos(jj,ii);
            ii = 2*(ncol-1)+2; jj = nrow;
            left2 = xpos(jj,ii); bottom2 = ypos(jj,ii);
            
            axes('Position',[left1,bottom1,lenx,leny]);
            plot_beach_ball(Change_mt_coordinate(mt_obs,-1));
            if nargin >= 3
                plot_nodal_line(strike1(count),dip1(count));
            end
            axes('Position',[left2,bottom2,lenx,leny]);
            plot_beach_ball(Change_mt_coordinate(mt_syn,-1));
            if nargin >= 3
                plot_nodal_line(strike2(count),dip2(count));
            end
        end
    end
end
end