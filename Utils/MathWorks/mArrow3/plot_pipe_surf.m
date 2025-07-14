%% plot pipe and wave
% for David  2018-10-04
clearvars; close all; clc;
phi = linspace(0,2*pi,100);
% pipe
R = 1;
x = R*cos(phi);
y = R*sin(phi);
z = linspace(1,50,20);
Z = repmat(z',size(x));
X = repmat(x, numel(z), 1);
Y = repmat(y, numel(z), 1);
% wave
Rw = 3;
xw = Rw*cos(phi);
yw = Rw*sin(phi);
nz = 50;
zw = linspace(1,50,nz);
Zw = repmat(zw',size(x));
Xw = repmat(xw, numel(zw), 1);
Yw = repmat(yw, numel(zw), 1);
for n = 1:nz
    w = 2*pi/(50/2);
    Xw(n,:) = Xw(n,:)+sqrt(2)*sin(w*zw(n));
    Yw(n,:) = Yw(n,:)+sqrt(2)*sin(w*zw(n));
end
figure;
hold on; grid on;
surf(X,Y,Z, 'facecolor', 'r', 'EdgeColor', 'none','FaceAlpha',0.7);
axis equal;
set(gca,'xlim',[-10,10],'ylim',[-10,10]);
hw = surf(Xw,Yw,Zw, 'FaceColor','b','EdgeColor', 'none', 'FaceAlpha',0.3);
set(gca,'BoxStyle','full');
camlight('right');