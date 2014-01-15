function pl = predict(zt, G, nc)
nex = size(zt, 2);
pl = zeros(1, nex);
for i = 1:nex
    bg = -Inf;
    bj = 0;
    for j = 1:nc
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
    pl(1, i) = bj; % predicted label
end
end