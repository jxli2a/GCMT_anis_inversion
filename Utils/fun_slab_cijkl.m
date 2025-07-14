function slab_cijkl = fun_slab_cijkl(evts,earth_model,eps_range,gamma_range,varargin)
    %% Usage: Read velocity information from './PREM_1s.csv' and find
    %         cijkl fixed value and boundary value used for inversion
    %  By Jiaxuan Li  --2016/03/20--  email: lijiaxuanmail@gmail.com
    %  First run QC_rec_station.m then run find_slab_cijkl.m
    %  Modified:     --2016/05/31--  Directly replcae original file
    %  ------------------------------------------------------------------------
    %  Modified:     --2016/08/18--  Modified from find_slab_cijkl.m
    %  Change the origional script to a function in order to do bootstrap for 
    %  each selected group
    %  Input:  EQ events: evts (struct evt is read from CMT files)
    %          earth model: earth_model (should be in format of prem model from IRIS)
    %          upper bound of eps and gamma: thomsen_range (e.g. thomsen_range = 0.3)
    %  Output: elastic constants: c33, c44, upper bound of c11 and c66 and
    %  range of c13: slab_cijkl = [c33,c44,c11_upper,c66_upper,c13_lower,c13_upper]
    %  Modified:     --2017-12-05--  add delta range options
    %  ------------------------------------------------------------------------
    if nargin >= 5
        delta1 = varargin{1};
        delta2 = varargin{2};
    else
        delta1 = -0.25;
        delta2 =  0.25;
    end
    depth = earth_model(:,2);
    vpv = earth_model(:,4);% the slow one
    vsv = earth_model(:,6);% the slow one
    nlayers = length(depth);
    nevt = length(evts);
    evdp = [evts(:).evdp];
    evdpm = repmat(evdp,nlayers,1);
    depthm = repmat(depth,1,nevt);
    [~,ind] = min(abs(evdpm-depthm));
    vp = vpv(ind);
    vs = vsv(ind);
    c33 = (mean(vp)*1.05)^2;
    c44 = (mean(vs)*1.05)^2;
    c11_upper = c33*(1+eps_range*2);
    c66_upper = c44*(1+gamma_range*2);
    c13_upper = sqrt(2*c33*(c33-c44)*delta2+(c33-c44)^2)-c44;
    c13_lower = sqrt(2*c33*(c33-c44)*delta1+(c33-c44)^2)-c44;
    slab_cijkl = [c33,c44,c11_upper,c66_upper,c13_lower,c13_upper];
end