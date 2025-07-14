function ptc = get_slab_cross_section(vert,center,srikevec)
% get the slab 2-D cross section x & y coordinates
% (p-center)*strikevec = 0, p = (x,y,z); strikevec = (a,b,nz);
% (x-cx)*a+(y-cy)*b+(z-cz)*nz = 0;
% 2D plane: a*x+b*y+((z-cz)*nz-a*cx-b*cy) = 0;
%           a*x+b*y+c = 0;
% By Jiaxuan Li --2018-05-04--
km2d = 1/111.1949;
z1 = vert(1,3);
a = srikevec(1);
b = srikevec(2);
c = (z1-center(3))*srikevec(3)-a*center(1)-b*center(2);
n = 1;
count = 0;
curdep = 0;

% x = 150:200;
% y = -c/b-a/b*x;
% figure; hold on;
% plot(x,y,'k-');

while n <= size(vert,1)-1
    p1 = vert(n,:);
    z1 = p1(3);
    n = n+1;
    if abs(z1-curdep) <= 1e-6
        v1 = get_val(p1(1),p1(2),a,b,c);
        d1 = get_dist(p1(1),p1(2),a,b,c);
        p2 = vert(n,:);
        v2 = get_val(p2(1),p2(2),a,b,c);
        d2 = get_dist(p2(1),p2(2),a,b,c);
        if v1*v2 <= 0
            count = count+1;
            ptc(count,:) = d2/(d1+d2)*p1+d1/(d1+d2)*p2;
            
            %plot(p1(1),p1(2),'bo');
            %plot(p2(1),p2(2),'ro');
            %plot(ptc(count,1),ptc(count,2),'g*');
            
            curdep = curdep+50*km2d;
            % c = (z1-center(3))*normal(3)-a*center(1)-b*center(2);
        end
    end
end
    function val = get_val(x,y,a,b,c)
        val = a*x+b*y+c;
    end
% distance from point to line
    function dist = get_dist(x,y,a,b,c)
        dist = abs(a*x+b*y+c)/sqrt(a^2+b^2);
    end
end