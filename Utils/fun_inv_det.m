function result = fun_inv_det(mts,params)
%% Usage: 
% Input moment tensor is defined in voigt coordinate
% invert for tti cijkl using det method
% By Jiaxuan Li  --2018-09-10--
%%
% inversion parameters: grid search interval and number of random tries at each grid
grid_interval = params.grid_interval;
num_rand = params.num_rand;
nsave = 10; % save number of random combinations for a specific (theta, phi)

r2d = 180/pi;

% cijkl 
slab_cijkl = params.slab_cijkl;


c33_fix = slab_cijkl(1);
c44_fix = slab_cijkl(2);
c11_upper = slab_cijkl(3);
c66_upper = slab_cijkl(4);
c13_lower = slab_cijkl(5);
c13_upper = slab_cijkl(6);

% 
%ntheta = 90/grid_interval+1;
%nphi = 360/grid_interval+1;
misfit_array = zeros(num_rand, 12);
%th1 = linspace(0,pi/2,ntheta);
%ph1 = linspace(0,2*pi,nphi);
th1 = params.theta(1):grid_interval:params.theta(2);
ph1 = params.phi(1):grid_interval:params.phi(2);
th1 = th1/180*pi;
ph1 = ph1/180*pi;
ntheta = numel(th1);
nphi = numel(ph1);
optim  = zeros(ntheta*nphi*10, 12);

% isotropic case:
eps = 0; gamma = 0; delta = 0;
[c11,c33,c44,c66,c13] = thomsen_to_cijkl(c33_fix,c44_fix,eps,gamma,delta);
Ct = VTI_to_TTI(c11,c33,c44,c66,c13,0,0);
Bt = C_to_B_s(Ct);[U,S0,V] = svd(Bt);
[~,fmin_iso,~] = fun_misfit_svd(U,S0,V,mts);
fmin_iso = mean(fmin_iso);

% grid search for tti case
%rng('default');
count = 1;
for i = 1:ntheta
    tic;
    theta = th1(i);
    for j = 1:nphi
        phi = ph1(j);
        for k = 1:num_rand
            %  Vavrycuk for tonga: c11,c33: 90~130;  c44,c66:15~50;  c13:20~65;           
            c33 = c33_fix;
            c11 = c33_fix+(c11_upper-c33)*rand(1);
            c13 = c13_lower+(c13_upper-c13_lower)*rand(1);
            c44 = c44_fix;
            c66 = c44_fix+(c66_upper-c44)*rand(1);
            %c13 = 2*c11-2*c66-c33;
            
            % Calculate Bt in VTI Medium
            Ct = VTI_to_TTI(c11,c33,c44,c66,c13,theta,phi);
            %fmin = fun_misfit_det_test(Ct, mts);
            Bt = C_to_B_s(Ct);
            % Singular Value Decomposition
            [U,S0,V] = svd(Bt);
            [~,fmin,d_scalar] = fun_misfit_svd(U,S0,V,mts);
            % test
            fmin = fmin./d_scalar;
            
            misfit = mean(fmin);
            [eps,gamma,delta] = cijkl_to_thomsen(c11,c33,c44,c66,c13);
            misfit_array(k,:) = [k,misfit,theta,phi,c11,c33,c44,c66,c13,eps,gamma,delta];
        end
        infos = sortrows(misfit_array,2);
        optim(count:count+nsave-1,:) = infos(1:nsave,:);
        count = count + nsave;
    end
    t1 = toc;
    fprintf('For theta = %3.0f, phi = %3.0f. Run time is %3.2f s\n',theta*r2d,phi*r2d,t1);
end
% sorted optim matrix
optim_sort = sortrows(optim,2);
optim_sort(:,3:4) = optim_sort(:,3:4)*r2d;
% symmetry axis angle
theta0 = optim_sort(1,3);
phi0   = optim_sort(1,4);
% return results
result.params = params;
result.optim_sort = optim_sort;
result.misfit_iso = fmin_iso;
result.theta0 = theta0;
result.phi0 = phi0;
result.thomsen = optim_sort(1,10:12);
result.thomsen_err = [];
end

