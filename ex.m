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
for dim = 1:50
    rtr = bsxfun(@minus, tr, mean(tr, 2));
    rt = bsxfun(@minus, t, mean(tr, 2));

    C = rtr * rtr' / size(rtr, 2);
    [U, v] = eigs(C, dim);
    U = sqrtm(v) \ U';

    ztr = U*rtr;
    zt = U*rt;

    G = {10, 3};
    for i = 1:10
        s = ztr(:, trl == (i-1));
        G{i, 1} = mean(s, 2);
        G{i, 2} = cov(s.');
        G{i, 3} = inv(G{i, 2});
    end

    [~, tex] = size(zt);
    pl = zeros(1, tex);
    for i = 1:tex
        bg = -Inf;
        bj = 0;
        for j = 1:10
            a = -zt(:, i).'*G{j, 3}*zt(:, i);
            b = zt(:, i).'*G{j, 3}*G{j, 1};
            c = G{j, 1}.'*G{j, 3}*G{j, 1};
            d = G{j, 1}.'*G{j, 3}*zt(:, i);
            g = 0.5*(a+b-c+d);

            if g > bg
                bg = g;
                bj = j-1;
            end
        end
        pl(1, i) = bj;
    end

    cor = 0;
    for i = 1:tex
        if pl(1, i) == tl(1, i)
            cor = cor + 1;
        end
    end
    acc = cor/tex;
    
    if acc > bacc
        bdim = dim;
        bacc = acc;
    end
end