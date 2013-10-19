% Load the data
clear all
load digits-labels
%% Split data in training and testing sets
sx = []; sy = []; rx = []; ry = [];
for i = 1:10
% Get samples of the i'th digit and permute their order
j = find( l == (i-1));
j = j(randperm( length( j)));
% Training set is 100 random samples of each digit
rx = [rx d(:,j(1:100))];
ry = [ry l(j(1:100))];
% The rest is testing data
sx = [sx d(:,j(101:end))];
sy = [sy l(j(101:end))];
end
%% Scan through multiple number of components
% Perform dimensionality reduction with PCA
% Remove mean
x = bsxfun( @minus, rx, mean( rx, 2));
% Get covariance
C = x*x'/size( x, 2);
% Get top eigenvectors
[U,v] = eigs( C, 20);
% Form principal components
U = sqrtm( v)\U';
% Get low rank versions of both training and testing data
rxl = U*bsxfun( @minus, rx, mean( rx, 2));
sxl = U*bsxfun( @minus, sx, mean( rx, 2));
% Learn one Gaussian classifier for each image
for i = 1:10
% Collect same digit samples
x = rxl(:, ry == (i-1));
% Estimate Gaussian model for that class
G{i}.m = mean( x, 2);
G{i}.c = cov( x');
G{i}.ic = inv( G{i}.c);
end
% Run on all models
for i = 1:length( G)
% Estimate the log likelihood over all samples
xm = bsxfun( @minus, sxl, G{i}.m);
d = sum( xm .* (G{i}.ic*xm), 1);
ll(i,:) = -.5*d - size(sxl,1)*pi*det( G{i}.c);
end
% Pick the class that has the highest likelihood
[~, j] = max( ll, [], 1); j = j-1;