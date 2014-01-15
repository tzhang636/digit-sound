function [ztr, zt] = run_pca(tr, t, dim)
rtr = bsxfun(@minus, tr, mean(tr, 2));
rt = bsxfun(@minus, t, mean(tr, 2));
C = rtr * rtr' / size(rtr, 2);
[U, v] = eigs(C, dim);
U = sqrtm(v) \ U';
ztr = U*rtr;
zt = U*rt;
end