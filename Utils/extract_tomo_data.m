function [lonq,latq,depq,Dq] = extract_tomo_data(data,lon1,lon2,lat1,lat2,dep1,dep2,delta,d_dep,opt)
%% Usage: [lonq,latq,depq,Dq] = extract_tomo_data(data,lon1,lon2,lat1,lat2,dep1,dep2,delta,d_dep,opt)
%  Extract Cross-section data (vertical) from tomo data block.
%  opt = 'slice'
%  return a slice defined by: [lon1,lat1,dep1], [lon2,lat2,dep1]
%                             [lon1,lat1,dep2], [lon2,lat2,dep2]
%  opt = 'block'
%  return a block
%  By Jiaxuan Li    --2018-05-09--
lon = data(1).lon(:,1);
lat = data(1).lat(1,:);
dlon = lon(2)-lon(1);
dlat = lat(2)-lat(1);
nlayer = numel(data);
dep = zeros(1,nlayer+2);
for n = 2:numel(dep)-1
    dep(n) = (data(n-1).dep1+data(n-1).dep2)/2;
end
dep(1) = data(1).dep1;
dep(end) = data(end).dep2;
ilayer = [1,1:nlayer,nlayer];
% ensure extra interpolation
idx_lon = lon >= min([lon1,lon2])-dlon & lon <= max(([lon1,lon2]))+dlon;
idx_lat = lat >= min([lat1,lat2])-dlat & lat <= max(([lat1,lat2]))+dlat;
lon = lon(idx_lon);
lat = lat(idx_lat);
idx_dep = find(dep >= min([dep1,dep2]) & dep <= max([dep1,dep2]));
idx_dep1 = idx_dep(1); idx_dep2 = idx_dep(end);
if idx_dep1 ~= 1, idx_dep1 = idx_dep1-1; end
if idx_dep2 ~= numel(dep), idx_dep2 = idx_dep2+1; end
dep = dep(idx_dep1:idx_dep2);
ilayer = ilayer(idx_dep1:idx_dep2);
% original block
[latb,lonb,depb] = meshgrid(lat,lon,dep);
D0 = zeros(numel(lon),numel(lat),numel(dep));
for n = 1:numel(ilayer)
    D0(:,:,n) = data(ilayer(n)).dvp(idx_lon,idx_lat);
end
switch opt
    case 'slice'
        % interpolation with higher resolution
        depq = min(dep):d_dep:max(dep);
        if abs(lon1-lon2) >= abs(lat1-lat2)
            lonq = min(lon):delta:max(lon);
            [lonq,depq] = meshgrid(lonq,depq);
            latq = (lat2-lat1)/(lon2-lon1)*(lonq-lon1)+lat1;
        else
            latq = min(lat):delta:max(lat);
            [latq,depq] = meshgrid(latq,depq);
            lonq = (lon2-lon1)/(lat2-lat1)*(latq-lat1)+lon1;
        end
    case 'block'
        lonq = min(lon):delta:max(lon);
        latq = min(lat):delta:max(lat);
        depq = min(dep):d_dep:max(dep);
        [latq,lonq,depq] = meshgrid(latq,lonq,depq);
end
Dq= interp3(latb,lonb,depb,D0,latq,lonq,depq);
Dq(isnan(Dq)) = 0;
end