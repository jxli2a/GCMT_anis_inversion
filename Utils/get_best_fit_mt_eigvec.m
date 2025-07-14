function best_fit_pair = get_best_fit_mt_eigvec(c11,c33,c44,c66,c13,theta,phi,evts)
%% Usage: get_best_fit_mt_eigvec(c11,c33,c44,c66,c13,theta,phi,evts)
%  Input evts should have moment tensor in CMT format;
%  Output evts are defined in voigt notation in ESU coordinate system
%  Modified: 2016/07/29 find best fit moment tensors using eigen values and
%  eigen vectors.
%  --2016-07-29--   By Jiaxuan Li     Email: lijiaxuanmail@gmail.com
%  --2017-04-05--   Use sorted eigenvalue
%  --2017-09-05--   Make program more clear
%  --2018-09-12--   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load observed moment tensors
nevt = length(evts);
mts_obs = zeros(6,nevt);
for m = 1:nevt
    mts_obs(:,m) = fun_preprocess_mt(evts(m).mt,1);
end
[v1,v2,v3,lambda] = fun_mt_eigen(mts_obs);

%% Synthetic
Ct = VTI_to_TTI(c11,c33,c44,c66,c13,theta,phi);
Bt = C_to_B_s(Ct);
% make synthetic faults and Calculate Synthetic moment tensors: mt_syn
syn_count = 20000;
[d_syn,d_plane] = fun_makedsyn(syn_count);
% make synthetic moment tensors using synthetic faults and inverted cijkl, theta, phi
m_syn = Bt*d_syn;
[v1syn,v2syn,v3syn,lambdasyn] = fun_mt_eigen(m_syn);

misfit = 0;
for m  = 1:nevt
    v1obs = repmat(v1(:,m),1,syn_count);
    v2obs = repmat(v2(:,m),1,syn_count);
    v3obs = repmat(v3(:,m),1,syn_count);
    lambdaobs = repmat(lambda(:,m),1,syn_count);
    % Misfit Function: d_v+d_lambda
    delta = fun_misfit_eigvec(v1syn,v2syn,v3syn,lambdasyn,v1obs,v2obs,v3obs,lambdaobs);
    % Find best fit mt_syn for each observed mt
    [fmin,pos] = min(delta);
    misfit = misfit + fmin;
    best_fit_pair(m).mt_obs = mts_obs(:,m);
    best_fit_pair(m).mt_syn = m_syn(:,pos);
    best_fit_pair(m).plane1 = d_syn(:,pos); 
    % keep full moment tensor 2019-12-05
    best_fit_pair(m).mt_full = Ct*d_syn(:, pos);
    % keep focal mechanism: [strike, dip, rake]  2024-08-18
    best_fit_pair(m).fm = d_plane(:, pos);
end 
end