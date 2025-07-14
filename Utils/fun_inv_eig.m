function results = fun_inv_eig(mts,params)
%% Usage:
% Input moment tensor is defined in voigt coordinate
% invert for tti cijkl using eig method
% By Jiaxuan Li  --2018-09-11--
region_name = params.region_name;
grid_interval = params.grid_interval;
num_rand = params.num_rand;
syn_count = params.syn_count;
thl = params.theta(1);
thu = params.theta(2);
phl = params.phi(1);
phu = params.phi(2);

d2r = pi/180;
r2d = 180/pi;

th_array = (thl:grid_interval:thu)*d2r;
ph_array = (phl:grid_interval:phu)*d2r;
ntheta = numel(th_array);
nphi = numel(ph_array);

% cijkl
slab_cijkl = params.slab_cijkl;
c33_fix = slab_cijkl(1);
c44_fix = slab_cijkl(2);
c11_upper = slab_cijkl(3);
c66_upper = slab_cijkl(4);
c13_lower = slab_cijkl(5);
c13_upper = slab_cijkl(6);

% obs moment tensors
[v1,v2,v3,lambda] = fun_mt_eigen(mts);
fclvd = lambda(2,:)./max(abs(lambda));
nevt = size(mts,2);

% Produce random synthetic faults
d_syn = fun_makedsyn(syn_count);

% Eigenvalues and eigenvectors of synthetic moment tensors for isotropic case:
eps = 0; gamma = 0; delta = 0;
[c11,c33,c44,c66,c13] = thomsen_to_cijkl(c33_fix,c44_fix,eps,gamma,delta);
Ct = VTI_to_TTI(c11,c33,c44,c66,c13,0,0);
Bt = C_to_B_s(Ct);
m_syn = Bt*d_syn;
[v1syn_iso,v2syn_iso,v3syn_iso,lambdasyn_iso] = fun_mt_eigen(m_syn);

%% Calculate misfit values for isotropic case
misfit_iso = 0;
for m  = 1:nevt
    % Eigenvalues and eigenvectors of observed moment tensors
    v1obs = repmat(v1(:,m),1,syn_count);
    v2obs = repmat(v2(:,m),1,syn_count);
    v3obs = repmat(v3(:,m),1,syn_count);
    lambdaobs = repmat(lambda(:,m),1,syn_count);
    % Misfit Function: d_v+d_lambda
    misfitdelta = fun_misfit_eigvec(v1syn_iso,v2syn_iso,v3syn_iso,lambdasyn_iso,v1obs,v2obs,v3obs,lambdaobs,fclvd(m));
    % Find best fit mt_syn for each observed mt
    fmin = min(misfitdelta);
    misfit_iso = misfit_iso + fmin;
end
misfit_iso = misfit_iso/nevt;

% v1syn = zeros(3,syn_count);
% v2syn = zeros(3,syn_count);
% v3syn = zeros(3,syn_count);
% lambdasyn = zeros(3,syn_count);
misfit_array = zeros(num_rand,12);
count = 1;
optim = zeros(ntheta*nphi*10,12);
%% Grid search for angle and random search for thomsen parameters
for i = 1:ntheta
    tic
    for j = 1:nphi
        theta = th_array(i);
        phi = ph_array(j);
        for k = 1:num_rand
            % load eigenvalues and eigenvectors of synthetic moment
            % tensors from cell matrix  (Vavrycuk for tonga: c11,c33: 90~130;  c44,c66:15~50;  c13:20~65;)
            c33 = c33_fix;
            c11 = c33_fix+(c11_upper-c33)*rand(1);
            c13 = c13_lower+(c13_upper-c13_lower)*rand(1);
            c44 = c44_fix;
            c66 = c44_fix+(c66_upper-c44)*rand(1);
            % Calculate Bt in VTI Medium
            Ct = VTI_to_TTI(c11,c33,c44,c66,c13,theta,phi);
            Bt = C_to_B_s(Ct);
            % Calculate synthetic moment tensors m_syn
            m_syn = Bt*d_syn;
            [v1syn,v2syn,v3syn,lambdasyn] = fun_mt_eigen(m_syn);
            misfit = 0;
            for m  = 1:nevt
                %% Eigenvalues and eigenvectors of observed moment tensors
                v1obs = repmat(v1(:,m),1,syn_count);
                v2obs = repmat(v2(:,m),1,syn_count);
                v3obs = repmat(v3(:,m),1,syn_count);
                lambdaobs = repmat(lambda(:,m),1,syn_count);
                %% Misfit Function d_v+d_lambda
                misfitdelta = fun_misfit_eigvec(v1syn,v2syn,v3syn,lambdasyn,v1obs,v2obs,v3obs,lambdaobs,fclvd(m));
                [fmin,~] = min(misfitdelta);
                misfit = misfit + fmin;
            end
            misfit = misfit/nevt;
            misfit = misfit/misfit_iso;
            [eps,gamma,delta] = cijkl_to_thomsen(c11,c33,c44,c66,c13);
            misfit_array(k,:) = [k,misfit,theta,phi,c11,c33,c44,c66,c13,eps,gamma,delta];
        end
        infos = sortrows(misfit_array,2);
        optim(count:count+9,:) = infos(1:10,:);
        count = count + 10;
    end
    elapse_time = toc;
    fprintf('->(Region: %s), theta: %4.1f, phi: %4.1f, elapsed time: %5.2f\n',region_name,theta*r2d,phi*r2d,elapse_time);
end
optim_sort = sortrows(optim,2);
optim_sort(:,3:4) = optim_sort(:,3:4)*r2d;
% symmetry axis angle
theta0 = optim_sort(1,3);
phi0   = optim_sort(1,4);
% return results
results.params = params;
results.optim_sort = optim_sort;
results.misfit_iso = misfit_iso;
results.theta0 = theta0;
results.phi0 = phi0;
end