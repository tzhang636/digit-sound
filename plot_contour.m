function [xgrid, ygrid, G1, G2] = plot_contour(c1, s1, t1, c2, s2, t2)
% find center of plot
c = zeros(1, 2);
c(1) = (c1(1)+c2(1))/2;
c(2) = (c1(2)+c2(2))/2;

% find deviation of plot
d = zeros(1, 2);
d(1) = max(s1(1), s2(1))*4;
d(2) = max(s1(2), s2(2))*4;

% create grids
[xgrid, ygrid] = meshgrid(c(1)-d(1):c(1)+d(1), c(2)-d(2):c(2)+d(2));

% find contour functions
x1 = (((xgrid-c1(1))*cos(t1) - (ygrid-c1(2))*sin(t1))/s1(1)).^2;
y1 = (((xgrid-c1(1))*sin(t1) - (ygrid-c1(2))*cos(t1))/s1(2)).^2;
G1 = exp(-(x1+y1)/2);

x2 = (((xgrid-c2(1))*cos(t2) - (ygrid-c2(2))*sin(t2))/s2(1)).^2;
y2 = (((xgrid-c2(1))*sin(t2) - (ygrid-c2(2))*cos(t2))/s2(2)).^2;
G2 = exp(-(x2+y2)/2);
end