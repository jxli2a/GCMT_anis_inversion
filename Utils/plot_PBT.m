function plot_PBT(evts)
%% Usage: plot_PBT(evts)
% This script is used to plot P, B, T axis distribution for evts
% Modified 2016-06-08       plot PBT for a given group of evts
% By Jiaxuan Li Email: lijiaxuanmail@gmail.com
% Modified: 2017-12-05  Jiaxuan Li  Consider legend autoupdate for R2017b
nevt = length(evts);
hold on;
for i = 1:nevt
    mt = Change_mt_coordinate(evts(i).mt,1);
    M = [mt(1) mt(6) mt(5)
        mt(6) mt(2) mt(4)
        mt(5) mt(4) mt(3)];
    [V,D] = eig(M);
    % sorted eigen values from low to high values %
    if ~issorted(diag(D))
        [~,I] = sort(diag(D));
        V = V(:, I);
    end
    % 1 is P axis, 2 is B axis and 3 is T axis
    % define pointing outside is positive (conventinal deinition in elastic mechanics)
    % P axis initial movement is inside,  negtive  eigenvalue
    % T axis initial movement is outside, positive eigenvalue
    V(:,1) = V(:,1)*sign(V(3,1)); 
    V(:,2) = V(:,2)*sign(V(3,2)); 
    V(:,3) = V(:,3)*sign(V(3,3));
    v1 = V(:,1); v2 = V(:,2); v3 = V(:,3);
    theta1 = acos(abs(v1(3))); phi1 = pi-atan2(v1(2),v1(1));
    theta2 = acos(abs(v2(3))); phi2 = pi-atan2(v2(2),v2(1));
    theta3 = acos(abs(v3(3))); phi3 = pi-atan2(v3(2),v3(1));
    x1 = tan(theta1/2) * (-sin(phi1)); y1 = tan(theta1/2)* (-cos(phi1));
    x2 = tan(theta2/2) * (-sin(phi2)); y2 = tan(theta2/2)* (-cos(phi2));
    x3 = tan(theta3/2) * (-sin(phi3)); y3 = tan(theta3/2)* (-cos(phi3));
    plot(x1,y1,'b+',x2,y2,'g^',x3,y3,'ro','Markersize',8);
end
% % ver = version('-release');
% % versionyear = str2double(ver(isstrprop(ver,'alpha')));
% % if versionyear > 2015
% %     legend({'P axis','B axis','T axis'},'AutoUpdate','off');
% % else
% %     legend('P axis','B axis','T axis');
% % end

% Plot a unit circle;
len = 200;
x = zeros(len,1); y = zeros(len,1);
theta = linspace(0,2*pi,len);
for ntheta = 1:len
    theta0 = theta(ntheta);
    x(ntheta) = cos(theta0);
    y(ntheta) = sin(theta0);
end
plot(x,y,'k','Linewidth',1);
axis equal; axis off;
% legend
hp = plot(NaN,NaN,'b+','Markersize',8);
hb = plot(NaN,NaN,'g^','Markersize',8);
ht = plot(NaN,NaN,'ro','Markersize',8);
legend([hp,hb,ht],{'P axis','B axis','T axis'});

ver = version('-release');
versionyear = str2double(ver(isstrprop(ver,'alpha')));
if versionyear > 2015
    legend('AutoUpdate','off');
end
end