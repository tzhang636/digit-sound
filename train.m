function G = train(ztr, ztrl, nc)
G = {nc, 3};
for i = 1:nc
    s = ztr(:, ztrl == (i-1));
    G{i, 1} = mean(s, 2);
    G{i, 2} = cov(s.');
    G{i, 3} = inv(G{i, 2});
end
end