clear all;
load('digits-labels.mat');
[pix, ex] = size(d);

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

bdim = 0;
bacc = 0;
for dim = 20:40
    [ztr, zt] = run_pca(tr, t, dim);
    G = train(ztr, trl, 10);
    pl = predict(zt, G, 10);
    acc = get_acc(pl, tl);
    if acc > bacc
        bdim = dim;
        bacc = acc;
    end
end