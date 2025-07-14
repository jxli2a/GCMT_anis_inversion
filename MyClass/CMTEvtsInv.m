classdef CMTEvtsInv < CMTEvts
    %% Usage:
    % Description: Inherit from CMTEvts class
    % Add TTI inversion module
    % By Jiaxuan Li    --2018-09-10--
    properties
        params = [];
        obs = [];    % obs.(mts)in Voigt coordinate system, obs.(clvd, vec)
        syn = [];    % syn.(mts)in Voigt coordinate system, syn.(clvd, vec)
        result = [];
        earth_model_path = []; 
        earth_model = []
        % Inherit from CMTEvts
        % evts = [];     % near slab events group list
        % region = [];   % group name list
        % color = '[0.05,0.05,0.05]' %'m','c','r','g','b','[0.05,0.75,0.05]','[1,0.5,0]','[0.75,0.15,0.35]';
        % km2d = 1/111.1949;
        % d2km = 111.1949;
    end
    methods
        % __init__
        function obj = CMTEvtsInv(region,evts_path_or_struct)
            parent_path = fileparts(fileparts(mfilename('fullpath')));
            obj = obj@CMTEvts(region,evts_path_or_struct);
            %
            obj.earth_model_path = fullfile(parent_path, 'Data','earth_model');
            %
            obj.params = init_param;
            obj.earth_model = csvread(fullfile(obj.earth_model_path,'PREM_1s.csv'));
            if isfield(obj.evts, 'mt')
                obj = preprocess_mt(obj);
            end
        end
        
        % inversion: det method
        function obj = inv_det(obj,varargin)
            % add varargin{1} = slab_cijkl option (2020-03-29, JXL)
            obj = preprocess_mt(obj);
            % use input slab_cijkl
            if numel(varargin) >= 1
                obj.params.slab_cijkl = varargin{1};
            else
                obj = get_slab_cijkl(obj);
            end
            str1 = sprintf('\n==== Inverting for region: %s: \n',obj.region);
            str2 = sprintf('==== grid interval: %d, num_rand: %d;\n', obj.params.grid_interval, obj.params.num_rand);
            str3 = sprintf('==== eps: [0.00, %.2f], gamma: [0.00, %.2f], delta: [%.2f, %.2f];\n', ...
                obj.params.eps_range, obj.params.gamma_range, obj.params.min_delta, obj.params.max_delta);
            str4 = sprintf('==== theta range: [%d, %d], phi range: [%d, %d]\n\n', ...
                obj.params.theta(1), obj.params.theta(2), obj.params.phi(1), obj.params.phi(2));
            fprintf([str1, str2, str3, str4]);
            % inversion
            thisresult = fun_inv_det(obj.obs.mts, obj.params);
            thisresult.thomsen = thisresult.optim_sort(1, 10:12);
            obj.result = thisresult;
        end

        % inversion: eig method
        function obj = inv_eig(obj,varargin)
            % add varargin{1} = slab_cijkl option (2020-03-29, JXL)
            obj = preprocess_mt(obj);
            % use input slab_cijkl
            if numel(varargin) >= 1
                obj.params.slab_cijkl = varargin{1};
            else
                obj = get_slab_cijkl(obj);
            end
            str1 = sprintf('\n==== Inverting for region: %s: \n',obj.region);
            str2 = sprintf('==== grid interval: %d, num_rand: %d;\n', obj.params.grid_interval, obj.params.num_rand);
            str3 = sprintf('==== eps: [0.00, %.2f], gamma: [0.00, %.2f], delta: [%.2f, %.2f];\n', ...
                obj.params.eps_range, obj.params.gamma_range, obj.params.min_delta, obj.params.max_delta);
            str4 = sprintf('==== theta range: [%d, %d], phi range: [%d, %d]\n\n', ...
                obj.params.theta(1), obj.params.theta(2), obj.params.phi(1), obj.params.phi(2));
            fprintf([str1, str2, str3, str4]);
            % inversion
            thisresult = fun_inv_eig(obj.obs.mts, obj.params);
            thisresult.thomsen = thisresult.optim_sort(1, 10:12);
            obj.result = thisresult;
        end
        
        % set parameters for inversion
        function obj = set_param(obj,varargin)
            nparam = 0;
            for n = 2:2:nargin-1
                nparam = nparam+1;
                propertynames{nparam} = varargin{n-1};
                propertyvals{nparam}  = varargin{n};
            end
            for n = 1:nparam
                thisfield = propertynames{n};
                if isfield(obj.params,thisfield)
                    obj.params.(thisfield) = propertyvals{n};
                else
                    fprintf('Unvalid parameters for inversion\n');
                    return;
                end
            end
            % update slab_cijkl
            obj = obj.get_slab_cijkl();
        end
        
        % preprocess moment tensor, normalize and change mt from cmt to voigt coordinate
        function obj = preprocess_mt(obj,varargin)
            thisevts = obj.evts;
            thisnevt = numel(thisevts);
            thismts = zeros(6,thisnevt);
            for m = 1:thisnevt
                thismts(:,m) = fun_preprocess_mt(thisevts(m).mt);
            end
            obj.obs.mts = thismts;
        end
        
        % get slab cijkl
        function obj = get_slab_cijkl(obj,varargin)
            this_slab_cijkl = fun_slab_cijkl(obj.evts,  obj.earth_model, ...
                obj.params.eps_range,  obj.params.gamma_range,  ...
                obj.params.min_delta,  obj.params.max_delta);
            obj.params.slab_cijkl = this_slab_cijkl;
        end
        
        % load bootstrap result from directory
        function obj = load_result_bootstrap(obj, result_dir)
            [thisbootstrap, fig, arr] = fun_read_bootstrap_result(result_dir);
            obj.result.theta0      = thisbootstrap.theta;
            obj.result.phi0        = thisbootstrap.phi;
            obj.result.thomsen     = thisbootstrap.thomsen;
            obj.result.thomsen_err = thisbootstrap.thomsen_err;
        end
        
        % load result from one file
        function obj = load_result(obj, result_file)
            in_result = load(result_file);
            if isfield(in_result, 'optim_sort')
                obj.result.optim_sort = in_result.optim_sort;
                obj.result.theta0 = in_result.optim_sort(1, 3);
                obj.result.phi0 = in_result.optim_sort(1, 4);
                obj.result.thomsen = in_result.optim_sort(1, 10:12);
                obj.result.thomsen_err = [];
            else
                fprintf('Error: No ''optim_sort'' in the result file\n');
                return
            end
            if isfield(in_result, 'params')
                obj.result.params = in_result.params;
            else
                obj.result.params = init_param('init');
                if isfield(in_result, 'slab_cijkl')
                    obj.result.params.slab_cijkl = in_result.slab_cijkl;
                else
                    fprintf('Error: No ''slab_cijkl'' in the result file\n');
                    return
                end
            end
            if isfield(in_result, 'misfit_iso')
                obj.result.misfit_iso = in_result.misfit_iso;
            else
                obj.result.misfit_iso = [];
            end
        end
        
        function save_result(obj, fn)
            if isempty(obj.result), return; end
            fun_parsave(obj.result, fn);
        end

        % get tti struct
        function tti_struct = get_tti_struct(obj)
            tti_struct.theta = obj.result.theta0;
            tti_struct.phi = obj.result.phi0;
            tti_struct.len = 2;
        end
        
        % make best fit synthetic moment tensors
        function obj = get_best_fit_bbs(obj)
            theta0 = obj.result.theta0/180*pi;
            phi0   = obj.result.phi0/180*pi;
            eps    = obj.result.thomsen(1);
            gamma  = obj.result.thomsen(2);
            delta  = obj.result.thomsen(3);
            c33    = obj.result.params.slab_cijkl(1);
            c44    = obj.result.params.slab_cijkl(2);
            [c11,c33,c44,c66,c13] = thomsen_to_cijkl(c33,c44,eps,gamma,delta);
            %Ct = VTI_to_TTI(c11,c33,c44,c66,c13,theta0,phi0);
            % get best fit moment tensor
            best_fit_pair = get_best_fit_mt_eigvec(c11,c33,c44,c66,c13,theta0,phi0,obj.evts);
            obj.syn.mts = [best_fit_pair.mt_syn];
            obj.syn.plane = [best_fit_pair.plane1];
            %obj.syn.mts = Ct*[best_fit_pair.plane1];
            % get clvd and eigen vector
            for m = 1:size(obj.obs.mts, 2)
                [obs_clvd(m), ~, obs_vec(:,:,m)] = fun_mt_decomp(obj.obs.mts(:,m));
                [syn_clvd(m), ~, syn_vec(:,:,m)] = fun_mt_decomp(obj.syn.mts(:,m));
            end
            obj.obs.clvd = obs_clvd;
            obj.obs.vec  = obs_vec;
            obj.syn.clvd = syn_clvd;
            obj.syn.vec  = syn_vec;
            % add full moment tensor infos
            obj.syn.full.mt = [best_fit_pair.mt_full];
            for m = 1:size(obj.obs.mts, 2)
                [iso_tmp(m), clvd_tmp(m), ~] = fun_mt_decomp_new(obj.syn.full.mt(:, m), 'voigt');
            end
            obj.syn.full.clvd = clvd_tmp;
            obj.syn.full.iso = iso_tmp;
        end
        
        %% Visualization Part
        % show misfit results
        function varargout = show_misfit(obj,varargin)
            if isempty(obj.result)
                fprintf('No results avalable for this region: %s',obj.region);
                return;
            end
            thisresult = obj.result;
            thisoptim = sortrows(sortrows(thisresult.optim_sort,4),3);
            [xx,yy,vv] = fun_get_vv(thisoptim);
            fig = figure;
            set(fig, 'Visible', 'on','Color','white','unit','Normalized','Position',[0.2,0.2,0.5,0.5]);
            % plot misfit
            pcolor(xx,yy,vv);colormap jet; shading interp; xlim([-1,1]); ylim([-1,1]); axis off
            axis equal;
            % plot contour lines
            plot_contour_line(gca);
            % polarplot_unit_contour_line(gca, 5, 5);
            % plot tti symmetry axis anngle
            theta0 = obj.result.theta0/180*pi;
            phi0   = obj.result.phi0/180*pi;
            plot_symmetryaxis(theta0,phi0,'Color','white','Marker','o','MarkerSize',30);
            title(obj.region, 'Interpreter', 'none');
            if nargout >= 1
                varargout{1} = fig;
            end
        end
        
        % show 3d tti arrows
        function obj = show_inv_tti(obj,varargin)
            if isempty(obj.result)
                fprintf('No results avalable for this region: %s',obj.region);
                return;
            end
            tti_struct.theta = obj.result.theta0; % Unit: deg
            tti_struct.phi   = obj.result.phi0;   % Unit: deg
            tti_struct.len   = 1.6;
            show_tti(obj,tti_struct);
        end
        
        % show 2d tti arrows in cross sectino plot
        function [htti, symtryvec] = show_inv_tti_2d(obj, strike, varargin)
            symtryvec = obj.get_sym_vec();
            symtryvec(3) = -symtryvec(3);
            htti = plot_2d_vec_cross_section(strike, symtryvec, varargin{:});
            % symtryvec in SED system
            symtryvec(3) = -symtryvec(3);
        end
        
        % get symmetry axis vector
        function symtryvec = get_sym_vec(obj)
            if isempty(obj.result)
                fprintf('No results avalable for this region: %s',obj.region);
                return;
            end
            theta0 = obj.result.theta0; % Unit: deg
            phi0   = obj.result.phi0;   % Unit: deg
            u = sind(theta0)*sind(phi0);
            v = sind(theta0)*cosd(phi0);
            w = cosd(theta0);
            symtryvec = [u,v,w];
        end
        
        % show best fit synthetic beach ball
        function varargout = show_bbs_fit(obj)
            if isempty(obj.syn)
                fprintf('Get best fit bbs first!\n');
            end
            fig = plot_bbs_fit(obj.syn.mts, obj.obs.mts);
            if nargout >= 1
                varargout{1} = fig;
            end
        end
        
        % show fit for the clvd
        function varargout = show_fclvd_fit(obj)
            fig = plot_fclvd_fit(obj.obs.clvd, obj.syn.clvd);
            if nargout >= 1
                varargout{1} = fig;
            end
        end
        
        % show rose plot for P,B,T axis
        function varargout = show_rose(obj)
            obs_vec = obj.obs.vec;
            syn_vec = obj.syn.vec;
            for m = 1:size(obs_vec, 3)
                angle0(m, :) = acos(sum(obs_vec(:,:,m).*syn_vec(:,:,m)))/pi*180;
            end
            angle0(angle0(:)>90) = 180-angle0(angle0(:)>90);
            fig = plot_rose(angle0);
            if nargout >= 1
                varargout{1} = fig;
            end
        end
    end
end

