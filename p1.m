c1 = [0 0]; % means
s1 = [1 1]; % variances
t1 = 0;
c2 = [4 0]; % means
s2 = [1 1]; % variances
t2 = 0;

[xgrid, ygrid, G1, G2] = plot_contour(c1, s1, t1, c2, s2, t2);
figure(1);
contour(xgrid, ygrid, G1)
hold on
contour(xgrid, ygrid, G2)
hold on
x = [2, 2];
y = [-10, 10];
plot(x, y);

c1 = [0 0]; % means
s1 = [1 2]; % variances
t1 = 0;
c2 = [4 3]; % means
s2 = [1 1]; % variances
t2 = 0;

[xgrid, ygrid, G1, G2] = plot_contour(c1, s1, t1, c2, s2, t2);
figure(2);
contour(xgrid, ygrid, G1)
hold on
contour(xgrid, ygrid, G2)
hold on
ezplot('y-6-(sqrt(2)*sqrt(8*x-7))');
ezplot('y-6+(sqrt(2)*sqrt(8*x-7))');

c1 = [0 0]; % means
s1 = [1 2]; % variances
t1 = 0;
c2 = [0.5 0]; % means
s2 = [1 1]; % variances
t2 = 0;

[xgrid, ygrid, G1, G2] = plot_contour(c1, s1, t1, c2, s2, t2);
figure(3);
contour(xgrid, ygrid, G1)
hold on
contour(xgrid, ygrid, G2)
hold on
ezplot('y-sqrt(x-0.25)');
ezplot('y+sqrt(x-0.25)');

c1 = [0 0]; % means
s1 = [1 2]; % variances
t1 = 0;
c2 = [4 0]; % means
s2 = [2 1]; % variances
t2 = 0;

[xgrid, ygrid, G1, G2] = plot_contour(c1, s1, t1, c2, s2, t2);
figure(4);
contour(xgrid, ygrid, G1)
hold on
contour(xgrid, ygrid, G2)
hold on
ezplot('y-sqrt((0.5*x.^2)+4*x-8)');
ezplot('y+sqrt((0.5*x.^2)+4*x-8)');