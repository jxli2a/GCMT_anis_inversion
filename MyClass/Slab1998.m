classdef Slab1998
    %% Usage:
    %  A class that defines the slab.
    %  Store the slab contour data by Gudmundsson (1998)
    %  Initialization:  tg = Slab1998('tonga1')
    %  Visulization:
    %  Visualize itself in 3-D view:  tg.show(varargin: opt = 'flat'/'interp')
    %  Only show contour:             tg.show_contour
    %  Show contour from Slab2.0      tg.show_contour_2
    %  Only show interface:           tg.show_interface(varargin: opt = 'flat'/'interp')
    %  Set axes limit and keep aspect ratio:  
    %                                 tg.set_limit(varargin: 'xlim' = array, 'ylim' = array, 'zlim' = array)
    %  Show intersection between vertical crosssecton and slab interface in 3-D view:
    %                                 tg.plot_3D_intersection(center = [lon,lat,dep](Unit: deg))
    %  Show intersection between vertical crosssecton and slab interface in 2-D view on the crosssection plane:
    %                                 tg.plot_2D_intersection(center = [lon,lat,dep](Unit:deg))
    %  Get the strike/dip/normal given a point on the slab:
    %                                 tg.slab_geometry(center = [lon,lat,dep](Unit: deg))
    %  By Jiaxuan Li    --2018-05-11--
    %  Update:   jxli   --2018-09-24-- add show_contour_2()  
    %                                 Hayes, G., 2018, Slab2 - A Comprehensive Subduction Zone Geometry Model: U.S. Geological Survey data release, https://doi.org/10.5066/F7PV6JNV.
    %                                 https://www.sciencebase.gov/catalog/item/5aa1b00ee4b0b1c392e86467
    properties
        vert;
        face;
        name;
        slab2 = [];
        slab_vert_face_dir;
        slab2_dir;
        %[slab_vert_face_dir, slab2_dir] = set_path();
    end

    properties (Constant)
        km2d = 1/111.1949;
        d2km = 111.1949;
    end
    
    methods
        function obj = Slab1998(slabname)
            %Slab1998 Construct an instance of this class
            %
            parent_path = fileparts(fileparts(mfilename('fullpath')));
            obj.slab_vert_face_dir = fullfile(parent_path, 'Data', 'slab_vert_face');
            obj.slab2_dir = fullfile(parent_path, 'Data', 'slab2.0');
            load(fullfile(obj.slab_vert_face_dir,[slabname,'.mat']),'vert','face');
            obj.vert = vert;
            obj.face = face;
            obj.name = slabname;
        end
        
        % show slab contour and slab interface
        function varargout = show(obj,varargin)
            % show itsself in 3-D view
            opt = 'flat';
            if nargin >= 2
                opt = varargin{1};
            end
            hcont = show_contour(obj);
            hsurf = show_interface(obj,opt);
            axis tight;
            format_axes(obj);
            if nargout >= 1
                varargout{1} = hcont;
            end
            if nargout >= 2
                varargout{2} = hsurf;
            end
        end
        
        % show slab contour only
        function varargout = show_contour(obj)
            lon=obj.vert(:,1); lat=obj.vert(:,2); dep=obj.vert(:,3);
            % plot slab surface and contour line
            ctmp = [.4 .4 .4];
            va=.9;
            % contour line
            depmax = max(dep);
            count = 0;
            dep_arr = 0:100:depmax;
            hline = gobjects(numel(dep_arr),1);
            for iz = 1:numel(dep_arr)
                z = dep_arr(iz);
                ind = find (dep == z);
                count = count+1;
                hline(count) = line( lon(ind), lat(ind), dep(ind), 'linestyle','-.','color',ctmp);alpha(va);
            end
            if nargout >= 1
                varargout{1} = hline;
            end
        end
        
        % show slab contour from Slab2.0 dataset
        function varargout = show_contour_2(obj)
            load(fullfile(obj.slab2_dir,[obj.name,'.mat']),'slab');
            h = gobjects(numel(slab.seg),1);
            for n = 1:numel(slab.seg)
                h(n) = plot3(slab.seg(n).lon,slab.seg(n).lat,slab.seg(n).dep,'k-','linewidth',1.0);
            end
            if nargout >= 1
                varargout{1} = h(n);
            end
        end
        
        % show slab interface only
        function varargout = show_interface(obj,varargin)
            opt = 'flat';
            if nargin >= 2
                opt = varargin{1};
            end
            % slab interface
            switch opt
                case 'flat'
                    hp = patch('Faces',obj.face,'Vertices',obj.vert,'FaceVertexCData',.8,'FaceColor','flat');alpha(hp,.5);
                case 'interp'
                    vert_data = make_interp_color(obj);
                    hp = patch('Faces',obj.face,'Vertices',obj.vert,'FaceVertexCData',vert_data,'FaceColor','interp');alpha(hp,.5);
                otherwise
                    fprintf('Unvalid option\n');
                    return;
            end
            shading flat; lighting flat;
            if nargout >= 1
                varargout{1} = hp;
            end
        end
        
        % set the limit of current axes and then reformat it
        function set_limit(obj,varargin)
            for n = 1:2:numel(varargin)-1
                propertyName  = varargin{n};
                propertyValue = varargin{n+1};
                if ~ismember(propertyName,{'xlim','ylim','zlim'})
                    fprintf('Unvalid property: %s\n',propertyName);
                    return;
                end
                set(gca,propertyName,propertyValue);
            end
            format_axes(obj);
        end
        
        % get strike, dip, and normal of the slab for a point located at
        % center
        function [normal_vec,strike,dip] = slab_geometry(obj,center)
            % center unit sould be in degree
            vertd = convert_vert(obj);
            [normal_vec,strike,dip] = get_slab_geometry(vertd,center);
            normal_vec = -normal_vec*sign(normal_vec(3));
            % nvec in SED system
            normal_vec(3) = -normal_vec(3);
        end
        
        % get the intersection points between the slab interface and the
        % vertical 2-D plane containing the normal located at center
        function [pts,varargout] = slab_cross_section(obj,center)
            [~,strike,~] = slab_geometry(obj,center);
            strikevec = [sind(strike),cosd(strike),0];
            vertd = convert_vert(obj);
            pts = get_slab_cross_section(vertd,center,strikevec);
            if nargout == 2
                varargout{1} = strike;
            elseif nargout == 3
                varargout{1} = strike;
                varargout{2} = dip;
            end
        end
        
        % plot intersection in 3-D view
        function varargout = plot_3D_intersection(obj,center)
            pts = slab_cross_section(obj,center);
            % plot3(center(1),center(2),center(3)*obj.d2km,'bp');
            h3D = plot3(pts(:,1),pts(:,2),pts(:,3)*obj.d2km,'b-.','linewidth',0.8);
            if nargout >= 1
                varargout{1} = h3D;
            end
        end
        
        % plot the 2-D cross section: pts
        function varargout = plot_2D_intersection(obj,center)
            [pts,strike] = slab_cross_section(obj,center);
            xvec = [sind(strike+90),cosd(strike+90),0];
            yvec = [0,0,1];
            intervec = pts-repmat(center,size(pts,1),1);
            X = xvec*intervec';
            Y = yvec*intervec';
            h2D = plot(X,Y,'k-','linewidth',2);
            if nargout >= 1
                varargout{1} = h2D;
            end
        end  
        
        % plot normal vector in 2d cross section 
        function varargout = plot_2D_norm(obj, centerd, varargin)
            [nvec, strike, ~] = obj.slab_geometry(centerd);
            nvec(3) = -nvec(3);
            hnorm = plot_2d_vec_cross_section(strike, nvec, varargin{:});
            % nvec in SED system
            nvec(3) = -nvec(3);
            if nargout >= 1
                varargout{1} = hnorm;
                varargout{2} = nvec;
            end
        end
    end
    
    methods(Access = private)
        % format the current axes
        function obj = format_axes(obj)
            xlabel('Lon.(deg)');
            ylabel('Lat.(deg)');
            zlabel('Depth (km)');
            xj = get(gca,'xlim');
            yj = get(gca,'ylim');
            zj = get(gca,'zlim');
            lxj = xj(2) - xj(1); lxj = abs(lxj);
            lyj = yj(2) - yj(1); lyj = abs(lyj);
            lzj = zj(2) - zj(1); lzj = abs(lzj*obj.km2d);
            % depmax = max(obj.vert(:,3));
            depmax = max(zj);
            depmin = min(zj);
            set(gca,'xdir','reverse','ydir','reverse','zdir','reverse');
            set(gca,'zlim',[depmin depmax],'ztick',depmin:100:depmax);
            set(gca,'plotboxaspectratio',[lxj, lyj, lzj]/lxj);
            grid on;
            box on;
            set(gca,'BoxStyle','full');
        end
        
         % make colors for interp option
        function vert_data = make_interp_color(obj)
            dep = obj.vert(:,3);
            npoints = numel(dep);
            cmap = colormap(cool);
            ncolor = size(cmap,1);
            vert_data = zeros(npoints,3);
            dep_min = min(dep);dep_max = max(dep);
            dep_range = linspace(dep_min,dep_max,ncolor);
            for ipoint = 1:npoints
                [~,icolor] = min(abs(dep(ipoint) - dep_range));
                vert_data(ipoint,:) = cmap(icolor ,:);
            end
            
        end
        
        % convert the unit of depth in vert from km to deg
        function vertd = convert_vert(obj)
            vertd = obj.vert;
            vertd(:,3) = vertd(:,3)*obj.km2d;
        end
    end
end

