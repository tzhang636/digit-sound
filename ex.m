clear all;
load('digits-labels.mat');
[pix, ex] = size(d); % 784x10000

tr = zeros(pix, 1000); 
trl = zeros(1, 1000); 
t = zeros(pix, 9000); 
tl = zeros(1, 9000);

ct_tr = zeros(10, 1);
tr_idx = 0;
t_idx = 0;
for i = 1:ex
    label = l(1, i);
    if ct_tr(label+1, 1) < 100
        ct_tr(label+1, 1) = ct_tr(label+1, 1) + 1;
        tr_idx = tr_idx + 1;
        tr(:, tr_idx) = d(:, i);
        trl(1, tr_idx) = label;
    else
        t_idx = t_idx + 1;
        t(:, t_idx) = d(:, i);
        tl(1, t_idx) = label;
    end
end

x = bsxfun(@minus, tr, mean(tr, 2));
C = x * x' / size(x, 2);
[U, v] = eigs(C, 15);
U = sqrtm(v)\U';

ztr = U*bsxfun(@minus, tr, mean(tr, 2));
zt = U*bsxfun(@minus, t, mean(tr, 2));

%rtr = bsxfun(@minus, tr, mean(tr, 2));
%rt = bsxfun(@minus, t, mean(tr, 2));

%utr = pca(rtr.', 'NumComponents', 20);
%ut = pca(rt.', 'NumComponents', 20);

%ztr = utr.' * rtr;
%zt = ut.' * rt;

G = {10, 3};
for i = 1:10
    s = ztr(:, trl == (i-1));
    G{i, 1} = mean(s, 2);
    G{i, 2} = cov(s.');
    G{i, 3} = inv(G{i, 2});
end

for i = 1:10
xm = bsxfun( @minus, zt, G{i, 1});
d = sum(xm .* (G{i, 3} * xm), 1);
ll(i,:) = -.5*d - size(zt,1)*pi*det( G{i,2});
end
% Pick the class that has the highest likelihood
[~, j] = max( ll, [], 1); j = j - 1;

c = 0;
for i = 1:9000
    if j(1, i) == tl(1, i)
        c = c + 1;
    end
end
acc = c/9000;