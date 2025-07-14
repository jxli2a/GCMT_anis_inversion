function plot_get_range(tt1,tt2,pp1,pp2)
tt = linspace(tt1,tt2,20);
pp = linspace(pp1,pp2,20);
plot(-tan(tt1/2)*sin(pp),-tan(tt1/2)*cos(pp),'r-');
plot(-tan(tt2/2)*sin(pp),-tan(tt2/2)*cos(pp),'r-');
plot(-tan(tt/2)*sin(pp1),-tan(tt/2)*cos(pp1),'r-');
plot(-tan(tt/2)*sin(pp2),-tan(tt/2)*cos(pp2),'r-');
end