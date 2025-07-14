classdef CMTEvts < handle
    %% Usage:
    %  Description: Defines the CMT events group class
    %  Can show itself in 3-D view.
    %  ------------------------------------------------------------------ %
    %  Initialization:  tg1 = CMTEvts('tonga1','evts_filename') or
    %                   tg1 = CMTEvts('tonga1',tonga1_evts_struct)
    %  Get center:      [evlo,evla,evdp] = tg1.get_center()
    %  Use kmeans to cluster events     varargout: cluster = tg1.get_cluster(ncluster)
    %  ------------------------------------------------------------------ %
    %  Visualization:
    %  Show EQs in 3-D view:                    varargout: handle = tg1.show()
    %  Show EQ center in 3-D view:              varargout: handle = tg1.show_center()
    %  Show inverted TTI symmetry axes:         varargout: handle = tg1.show_tti(tti_struct)
    %                                                                            tti_struct: ('len', 'vec' or 'theta'&'phi' (unit in degree))
    %  Show number label in 3-D view:           varargout: handle = tg1.show_text()
    %  Show PBT distribution                                        tg1.show_PBT()
    %  Show SINGLE field histogram:             varargout: handle = tg1.show_hist(field)
    %  Show Multi-field plot                    varargout: handle = tg1.show_multi(fields)
    %  Show beach balls for one/multi groups    varargout: fig_handle = tg1.show_bbs(ievtlist = 1:n)
    %  Show 2-D fit plane for a group           varargout: handle = tg1.show_fit_2dplane()
    %  Show outlier event                       varargout: [rmlist, rmevt, hrm] = tg1.show_outlier(noutlier)
    %  Show 2-D projection of evts              varargout: handle = show_2d_projection(obj, strike)
    %  ------------------------------------------------------------------ %
    %  By Jiaxuan Li     --2019-01-08--    University of Houston.
    %  2020-03-29 jxli inherit from handle
    
    properties
        evts = [];     % near slab events group
        region = [];   % group name
        color = '[0.05,0.05,0.05]';%'m','c','r','g','b','[0.05,0.75,0.05]','[1,0.5,0]','[0.75,0.15,0.35]'};
    end

    properties (Constant)
        km2d = 1/111.1949;
        d2km = 111.1949;
    end
    
    %% Methods
    methods (Access = public)
        % __init__
        function obj = CMTEvts(region,evts_filename_or_struct)
            % Construct an instance of this class
            if nargin ~= 0
                % given data filename
                if ischar(evts_filename_or_struct)
                    filename = evts_filename_or_struct;
                    if exist(filename,'file')
                        matobj = matfile(filename);
                        details = whos(matobj);
                        names = {details.name};
                        if ismember('near_slab_evt_part',names)
                            load(filename,'near_slab_evt_part');
                            obj.evts = near_slab_evt_part;
                        elseif ismember('evt',names)
                            load(filename,'evt');
                            obj.evts = evt;
                        end
                    else
                        fprintf('No such region in directory %s\n',obj.evts_dir);
                        return;
                    end
                % given data structure
                elseif isstruct(evts_filename_or_struct)
                    obj.evts = evts_filename_or_struct;
                end
                obj.region = region;
            end
        end
        
    %% analysis part
        % filter the events by evla, evlo, evdp, Mw
        function obj = filter(obj, varargin)
            idx = true(1, numel(obj.evts));
            for n = 1:2:numel(varargin)-1
                range = varargin{n+1};
                thisfield = varargin{n};
                switch thisfield
                    case {'evla','evlo','evdp', 'Mw', 'fclvd', 'Var_Red'}
                        if isfield(obj.evts, thisfield)
                            idxtmp = [obj.evts.(thisfield)] >= range(1) & [obj.evts.(thisfield)] <= range(2);
                            idx = idx & idxtmp;
                        else
                            fprintf('Non-existing field\n');
                            return
                        end
                end
            end
            obj.evts = obj.evts(idx);
        end
        
        % add datenum
        function obj = add_datenum(obj, format)
            obj.evts = fun_add_datetime(obj.evts, format);
        end
    
        % get center of this group
        function center = get_center(obj)
            % center = [lon (deg), lat (deg), dep (km)];
            evlo0 = mean([obj.evts.evlo]);
            evla0 = mean([obj.evts.evla]);
            evdp0 = mean([obj.evts.evdp]);
            center = [evlo0, evla0, evdp0];
        end
        
        % get center of this group units all in degree
        function center = get_center_deg(obj)
            % center = [lon (deg), lat (deg), dep (deg)];
            evlo0 = mean([obj.evts.evlo]);
            evla0 = mean([obj.evts.evla]);
            evdp0 = mean([obj.evts.evdp])*obj.km2d;
            center = [evlo0, evla0, evdp0];
        end
        
        % extract SINGLE field data, return an array containing field data
        function data = extract_field(obj,field)
            fields = fieldnames(obj.evts);
            if ismember(field,fields)
                data = [obj.evts.(field)];
            else
                fprintf('Unvalid field\n');
            end
        end
        
        % kmeans methods for clustering
        function [evts_cluster,varargout] = get_cluster(obj,ncluster)
            % igroup: do kmeans for group number: igroup
            % ncluster: number of clusters for kmeans
            evlo = extract_field(obj,'evlo');
            evla = extract_field(obj,'evla');
            evdp = extract_field(obj,'evdp')*obj.km2d;
            rng('default');
            [cluster_idx] = kmeans([evlo',evla',evdp'],ncluster);
            evts_cluster = make_evts_cluster(obj, cluster_idx, ncluster);
            if nargout >= 2
                varargout{1} = cluster_idx;
            end
        end
        
        % DBSCAN method for clustering
        function [evts_cluster, varargout] = get_DBSCAN_cluster(obj, epsilon, minipts)
            evlo = extract_field(obj,'evlo');
            evla = extract_field(obj,'evla');
            evdp = extract_field(obj,'evdp')*obj.km2d;
            X = [evlo(:), evla(:), evdp(:)];
            [cluster_idx, ~] = DBSCAN(X, epsilon, minipts);
            ncluster = numel(unique(cluster_idx))-1;
            evts_cluster = make_evts_cluster(obj, cluster_idx, ncluster);
            noise_cluster = eval([class(obj),'(''empty'', [])']);
            noise_cluster.evts = obj.evts(cluster_idx==0);
            noise_cluster.region = 'noise';
            noise_cluster.color = 'w';
            evts_cluster = [evts_cluster, noise_cluster];
            if nargout >= 2
                varargout{1} = cluster_idx;
            end
        end
        
        % make evts cluster by cluster_idx
        function [evts_cluster] = make_evts_cluster(obj, cluster_idx, ncluster)
            cluster_colors = distinguishable_colors(ncluster);
            evts_cluster(1: ncluster) = eval([class(obj),'(''empty'', [])']);
            for n = 1:ncluster
                evts_cluster(n).evts = obj.evts(cluster_idx==n);
            end
            % sort the events by evlo, evla and evdp;
            centerd = zeros(numel(evts_cluster), 3);
            for n = 1:numel(evts_cluster)
                centerd(n, :) = evts_cluster(n).get_center_deg;
            end
            maxrange = max(centerd)-min(centerd);
            [~, idx1] = sort(maxrange, 'descend');
            [~, idx2] = sortrows(centerd(:, idx1));
            evts_cluster = evts_cluster(idx2);
            for n = 1:numel(evts_cluster)
                evts_cluster(n).color = cluster_colors(n, :);
                evts_cluster(n).region =  [obj.region,'_cluster',num2str(n)];
            end
        end
        
        % get near slab evts
        function obj = get_near_slab_evts(obj, vert, maxdist)
            % original default maxdist = 0.5;
            nevt = numel(obj.evts);
            idx = false(nevt, 1);
            for ievt = 1:nevt
                dist0   = fun_get_dist(obj.evts(ievt),vert);
                if dist0 <= maxdist
                    idx(ievt) = 1;
                end
            end
            obj.evts = obj.evts(idx);
        end
        
        % save evts
        
        %% visulization part
        % show near slab events in 3-D view
        function varargout = show(obj)
            % plot cross section of this group
            hevts = scatter3([obj.evts.evlo],[obj.evts.evla],[obj.evts.evdp], 30,...
                'MarkerEdgeColor','k','MarkerFaceColor',obj.color);
            if nargout >= 1
                varargout{1} = hevts;
            end
        end
        
        % show near slab events in 3-D view with size of marker denoting magnitude
        function varargout = show_by_mag(obj)
            hevts = plot_scatter_by_mag_3d([obj.evts.evlo], [obj.evts.evla], [obj.evts.evdp], [obj.evts.Mw], ... 
                'markerfacecolor',obj.color);
            if nargout >= 1
                varargout{1} = hevts;
            end
        end
        
        % show 2d projection on the vertical plane (normal to slab surface),
        % strike is slab surface's strike
        function varargout = show_2d_projection(obj, strike, varargin)
            center = obj.get_center_deg;
            scatter_color  = [0.35, 0.35, 0.35];
            for n = 1:2:numel(varargin)-1
                propertyName  = varargin{n};
                switch propertyName
                    case 'center'
                        center = varargin{n+1};
                    case 'color'
                        scatter_color = varargin{n+1};
                end
            end
            obj.evts = fun_evt_2d_projection(obj.evts, strike, center);
            hscatter = plot_scatter_by_mag([obj.evts.X], [obj.evts.Y], [obj.evts.Mw], 'color', scatter_color);
            userdata.center = center;
            userdata.strike = strike;
            userdata.scatter_color = scatter_color;
            set(gca,'xdir','reverse','ydir','reverse','Userdata',userdata);
            axis equal;
            obj.set_2d_limit('ylim', [0,300],'xlim', [-2,3 ]);
            xlabel('X (degree)');
            ylabel('Depth (km)');
            varargout{1} = obj;
            if nargout >= 2
                varargout{2} = hscatter;
            end
        end
        
        function set_2d_limit(obj, varargin)
            % set the limit, tick and ticklabel of current axes
            for n = 1:2:numel(varargin)-1
                propertyName  = varargin{n};
                switch(propertyName)
                    case 'xlim'
                        xlimit = varargin{n+1};
                        xtick = xlimit(1):1:xlimit(2);
                        set(gca,'xlim',xlimit,'xtick',xtick);
                    case 'ylim'
                        ylimit = varargin{n+1};
                        userdata = get(gca, 'UserData');
                        depcenter = userdata.center(3);
                        depmin = max(0,floor((ylimit(1))/50)*50);
                        depmax = ceil((ylimit(2))/50)*50;
                        dep    = depmin:50:depmax;
                        ytick = dep*obj.km2d-depcenter;
                        yticklabel = cellstr(num2str(dep(:)));
                        ylimit = ylimit*obj.km2d-depcenter;
                        set(gca,'ytick',ytick,'yticklabel',yticklabel,'ylim',ylimit);
                    %case 'center'
                    %    center = varargin{n+1};
                    %    userdata = get(gca, 'Userdata');
                    %    obj.show_2d_projection(userdata.strike, 'center', center, 'color', userdata.scatter_color);
                        
                end
            end
            grid on; box on;
        end
        
        % show fitting 2-D plane of earthquake cluster
        function varargout = show_fit_2dplane(obj)
            evlo = extract_field(obj,'evlo');
            evla = extract_field(obj,'evla');
            evdp = extract_field(obj,'evdp');
            X = [evlo',evla',evdp'];
            [nvec,~,p] = affine_fit(X);
            x = linspace(min(evlo),max(evlo),40);
            y = linspace(min(evla),max(evla),40);
            [x1,y1] = meshgrid(x,y);
            z1 = -(-p*nvec+nvec(1)*x1+nvec(2)*y1)/nvec(3);
            ind = (z1 >= min(evdp) & z1 <= max(evdp));
            x1(~ind) = NaN;
            y1(~ind) = NaN;
            z1(~ind) = NaN;
            h = surf(x1,y1,z1); set(h,'facecolor','y','facealpha',0.3);
            if nargout >= 1
                varargout{1} = h;
            end
            if nargout >= 2
                varargout{2} = nvec;
            end
        end
        
        % show outlier point
        function [rmlist,varargout] = show_outlier(obj,noutlier)
            evlo = extract_field(obj,'evlo');
            evla = extract_field(obj,'evla');
            evdp = extract_field(obj,'evdp');
            X = [evlo',evla',evdp'];
            [nvec,~,p] = affine_fit(X);
            vec = X-repmat(p,size(X,1),1);
            dist = abs(vec*nvec);
            [~,idx] = sort(dist,'descend');
            regionname = [obj.region,'_outlier'];
            rmlist = idx(1:noutlier);
            outlier = CMTEvts(regionname, obj.evts(rmlist));
            outlier.color = 'r';
            houtlier = outlier.show;
            if nargout >= 2
                varargout{1} = outlier;
            end
            if nargout >= 3
                varargout{2} = houtlier;
            end
        end
        
        % show center of this group in 3-D view
        function varargout = show_center(obj)
            center = get_center(obj);
            hcenter = scatter3(center(1),center(2),center(3), 120,...
                'p','MarkerEdgeColor',obj.color,'MarkerFaceColor','w', ...
                'lineWidth',1.5);
            if nargout >= 1
                varargout{1} = hcenter;
            end
        end
        
        % show number of this group
        function varargout = show_text(obj, number)
            center = get_center(obj);
            thiscolor = obj.color;
            if center(3) > 300
                bcolor = [0.8,0.8,0.8];
            else
                bcolor = 'none';
            end
            xyshift = 0.3; zshift = xyshift*obj.d2km*4;
            htxt = text(center(1)+xyshift,center(2)+xyshift,center(3)-zshift, number,...
                'Color',thiscolor,'backgroundcolor',bcolor,'edgecolor',thiscolor, ...
                'fontsize',18,'lineStyle',':','lineWidth',3,'fontweight', 'bold');
            %set(htxt(n),'backgroundcolor',bcolor)
            if nargout >= 1
                varargout{1} = htxt;
            end
        end
        
        % show inverted TTI symmetry axes
        function varargout = show_tti(obj, tti_struct, varargin)
            center = get_center(obj);
            thiscolor = obj.color;
            % default settings
            stemwidth = 0.08;
            tipwidth = 0.16;
            facealpha = 1.0;
            for n = 1:2:numel(varargin)-1
                switch varargin{n}
                    case 'stemwidth'
                        stemwidth = varargin{n+1};
                    case 'tipwidth'
                        tipwidth = varargin{n+1};
                    case 'facealpha'
                        facealpha = varargin{n+1};
                    otherwise
                        fprintf('Unvalid option\n');
                end
            end
            % given TTI symmetry axis vector
            if isfield(tti_struct,'vec')
                vec = tti_struct.vec;
                % given theta and phi of TTI symmetry axes
                % theta and phi are defined in the system defined in VTI_to_TTI.m
                % 123-xyz-ENU
                % Up direction: theta = 0;   Increase by left hand rotation
                % along 2-axis
                % North direction: phi = 0;  Increase by left hand rotation
                % alonr 3-axis
            elseif isfield(tti_struct,'theta') && isfield(tti_struct,'phi')
                theta = tti_struct.theta;
                phi = tti_struct.phi;
                u = sind(theta)*sind(phi);
                v = sind(theta)*cosd(phi);
                w = cosd(theta);
                vec = [u,v,-obj.d2km*w];
            end
            p1 = center-vec*tti_struct.len;
            p2 = center+vec*tti_struct.len;
            %htti(n) = mArrow3_strech(p1,p2,'color',thiscolor,'stemWidth',0.02,'tipWidth',0.04,'facealpha',1.0,'strech',[1;1;obj.d2km]);
            htti = mArrow3_strech(p1,p2,'color',thiscolor,'stemWidth',stemwidth,'tipWidth',tipwidth, ... 
                'facealpha',facealpha,'strech',[1;1;obj.d2km]);
            if nargout >= 1
                varargout{1} = htti;
            end
        end
        
        % show PBT distribution
        function show_PBT(obj)
            plot_PBT(obj.evts);
        end
        
        % show faults plane nodal lines
        function fig = show_nodal_line(obj, ax, plane_id)
            if ~exist('ax', 'var') || isempty(ax)
                fig = figure;
                ax = gca;
                plot_contour_line(ax);
            end
            if ~exist('plane_id', 'var')
                plane_id = 1;
            end
            axes(ax); hold on; 
            for n = 1:numel(obj.evts)
                switch plane_id
                    case 1
                        strike = obj.evts(n).plane1(1);
                        dip = obj.evts(n).plane1(2);
                    case 2
                        strike = obj.evts(n).plane2(1);
                        dip = obj.evts(n).plane2(2);
                end
                plot_nodal_line(strike, dip);
            end
        end
        
        % show histogram for SINGEL field data
        function varargout = show_hist(obj,field)
            fieldval = extract_field(obj,field);
            hhist = histogram(fieldval);
            grid on; box on;
            xlabel(field, 'Interpreter', 'none');
            ylabel('Number of Earthquakes');
            if nargout >= 1
                varargout{1} = hhist;
            end
        end
        
        % show multi-field cross plot and histogram
        function varargout = show_multi(obj,fields)
            % fields:   fieldnames cell array
            % varargin: idx: group number array
            nfield = numel(fields);
            for ifield = 1:nfield
                thisfield = fields{ifield};
                fieldval = extract_field(obj,thisfield);
                vals.(thisfield) = fieldval;
            end
            fig = figure;
            nax = 0;
            for ncol = 1:nfield
                val1 = vals.(fields{ncol});
                for nrow = 1:nfield
                    nax = nax+1;
                    subplot(nfield,nfield,nax);
                    if nrow == ncol
                        histogram(val1);
                        grid on; box on;
                        axis square;
                    else
                        val2 = vals.(fields{nrow});
                        plot(val2,val1,'ko');
                        grid on; box on;
                        axis square;
                    end
                    if nrow == 1
                        ylabel(fields{ncol}, 'Interpreter', 'none');
                    end
                    if ncol == nfield
                        xlabel(fields{nrow}, 'Interpreter', 'none');
                    end
                end
            end
            if nargout >= 1
                varargout{1} = fig;
            end
        end
        
        % show beach balls for a single group (single figure)
        function varargout = show_bbs(obj,varargin)
            ievtlist = 1:numel(obj.evts);
            if nargin == 2
                ievtlist = varargin{1};
            end
            thisevts = obj.evts(ievtlist);
            nevts = numel(thisevts);
            nrow = ceil(sqrt(nevts))+1;
            ncol = ceil(nevts/nrow);
            %nrow = 9;ncol = 6;
            fig = figure;
            set(fig,'color','white','Unit','pixels','Position',[100,100,800,800*nrow/ncol]);
            [haxes, ~] = tight_subplot(nrow,ncol,[0.02,0.02*ncol/nrow]);
            %haxes = decorate_axes(haxes,pos);
            for nh = 1:numel(haxes)
                axes(haxes(nh));
                axis off;
                if nh <= nevts
                    plot_beach_ball(thisevts(nh).mt);
                    %axis on;
                end
            end
            if nargout >= 1
                varargout{1} = fig;
            end
        end
        
    end
end

