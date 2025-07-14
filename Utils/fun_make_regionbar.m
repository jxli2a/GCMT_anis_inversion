function [colors,marks,regions] = fun_make_regionbar(parts)
% By Jiaxuan Li --2017-12-05--
% Make region bar properties for gamma-depth, angle-depth plot
slab{1} = 'aleutians'; slab{2} = 'indonesia'; slab{3} = 'marjapkur';
slab{4} = 'molucca';   slab{5} = 'tonga';     slab{6} = 'vanuatu';
sabbr  = {'AL','IND','MJK','MO','TG','VA'};
scolor = {'r','g','b','m','k','c'};
% for jma plot use
% scolors = {'[0.15,0.15,0.15]','m','c','r','[1,0.5,0]','b', ... 
%     '[0.75,0.15,0.35]','[0.05,0.75,0.05]','g','[0.15,0.35,0.75]','k',};
smarks = {'-d','-.*','-^',':+','--o','-p'};
% smarks = {}
npart  = length(parts);
colors  = cell(1,npart);
marks   = cell(1,npart);
regions = cell(1,npart);
for n = 1:npart
    thispart  = parts{n};
    thisalpha = thispart(isstrprop(thispart,'alpha'));
    thisstr   = thispart(isstrprop(thispart,'digit')); 
    islab     = find(strcmp(slab,thisalpha));
    if ~isempty(islab)
    thisabbr  = [sabbr{islab},thisstr];
    colors{n} = scolor{islab};
    %colors{n} = scolors{n}; % for jma plot use
    marks{n}  = smarks{islab};
    else
        thisabbr = thisstr;
        colors{n} = scolor{3};
        marks{n} = smarks{3};
    end
    regions{n}= thisabbr;
end
end