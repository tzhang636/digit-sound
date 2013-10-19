load('digits-labels.mat');
[pix, ex] = size(d); % 784 pixels by 10000 examples

%m = reshape(d(:,20), 28, 28); % reshape example 20 to a 28x28 image
%n = l(1, 20); % get label of example 20

ct_tr = zeros(10, 1);
tr = zeros(10, pix, 100); % for each digit 0-9, collect 100 training examples
ct_t = 0;
t = zeros(pix, ex-10*100); % 10000 - 1000 = 9000 test examples
t_l = zeros(1, ex-10*100);

% extract 100 training examples for each digit 0-9
% keep the remaining 9000 as test examples
for i = 1:ex
    label = l(1, i); % label ranges from 0-9
    if ct_tr(label+1, 1) < 100
        ct_tr(label+1, 1) = ct_tr(label+1, 1) + 1; 
        tr(label+1, :, ct_tr(label+1, 1)) = d(:, i);
    else
        ct_t = ct_t + 1;
        t(:, ct_t) = d(:, i);
        t_l(1, ct_t) = l(1, i);
    end
end

% construct gaussian model for each digit class
G = {10, 2};
for i = 1:10
    tr_data = squeeze(tr(i, :, :)); % 784 pixels by 100 examples
    U = pca(tr_data.', 'NumComponents', 99); % 784 pixels by 99 features
    Z = U.' * tr_data; % 99 features by 100 examples
    
    G{i, 1} = mean(Z, 2); % vector of means for each feature
    G{i, 2} = cov(Z.'); % covariance matrix for features
end

% apply pca to test data
U_t = pca(t.', 'NumComponents', 99);
Z_t = U.' * t;

% find the digit class with the highest probability for each test example
[t_pix, t_ex] = size(t);
ps = zeros(t_ex, 1);
p = zeros(10, t_ex);
for j = 1:10
    p(j, :) = mvnpdf(Z_t.', G{j, 1}.', G{j, 2});
end

for i = 1:t_ex
    ps(i, 1) = find(p(:, i) == max(p(:, i))) - 1;
end

% evaluate accuracy of the predictions
c = 0;
for i = 1:t_ex
    if ps(i, 1) == t_l(1, i)
        c = c + 1;
    end
end
acc = c/t_ex;