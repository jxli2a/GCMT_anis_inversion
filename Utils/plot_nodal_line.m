function plot_nodal_line(strike,dip,varargin)
% plot the nodal line of fault's low hemisphere stereographic projection
% input angles are in degrees
% SEU(S-1,E-2,U-3,right hand system) system
% 2017-10-05 By Jiaxuan Li
% % 
color = 'k';
linewidth = 1.2;
for n = 1:2:numel(varargin)-1
    name = varargin{n};
    switch name
        case 'linewidth'
            linewidth = varargin{n+1};
        case 'color'
            color = varargin{n+1};
        otherwise
            error('Invalid option');
    end
end
d2r = pi/180;
phi = strike*d2r; theta = dip*d2r;
t = linspace(-pi/2,pi/2,100);
x = -sin(t); y = cos(t); z = zeros(1,100);
Cir = [x;y;z]; % half unit circle on S-E plane
% Rs: left hand rotation matrix around s axis
Rs = [1,0,0
      0,cos(theta),sin(theta)
      0,-sin(theta),cos(theta)];
% Ru: left hand rotation matrix around u axis
Ru = [cos(phi),sin(phi),0
      -sin(phi),cos(phi),0
      0,0,1];
Cir = Ru*(Rs*Cir);
%figure;scatter3(Cir(1,:),Cir(2,:),Cir(3,:));axis equal;xlabel('x');
%figure;hold on;axis equal;
%plot(cos(0:0.01:2*pi),sin(0:0.01:2*pi),'k-','linewidth',1.5);
%plot(Cir(1,:),Cir(2,:),'k-','linewidth',1.5);
X = Cir(2,:); Y = -Cir(1,:); Z = Cir(3,:);
t = atan2(sqrt(X.^2+Y.^2),1-Z);
p = atan2(Y,X);
plot(tan(t).*cos(p),tan(t).*sin(p),'-','linewidth',linewidth, 'color', color);
end