% init parameters for inversion
function params = init_param(varargin)
% default parameters for inversion
params.grid_interval = 10;
params.num_rand  = 1000;
params.eps_range   = 0.4;
params.gamma_range = 0.4;
params.min_delta = -0.25;
params.max_delta = 0.25;
params.slab_cijkl = [];
params.region_name = '';
% parameters for eig method
params.theta = [0, 90]; % theta range
params.phi   = [0, 360]; % phi range
params.syn_count = 200;      % number of synthetic faults for eig method
params.bs_seq = [];        % bootstrap sequence
nparam = 0;
% create placeholder for param is input option is 'init'
if nargin == 1
    if strcmp(varargin{1}, 'init')
        names = fieldnames(params);
        for n = 1:numel(names)
            params.(names{n}) = [];
        end
    else
        fprintf('Unvalid option\n');
    end
% otherwise, set parameters according to the input arguments
else
    for n = 1:2:numel(varargin)-1
        nparam = nparam+1;
        propertynames{nparam} = varargin{n};
        propertyvals{nparam}  = varargin{n+1};
    end
end
for n = 1:nparam
    thisfield = propertynames{n};
    if isfield(params,thisfield)
        params.(thisfield) = propertyvals{n};
    else
        fprintf('Unvalid parameters for inversion\n');
        return;
    end
end
end