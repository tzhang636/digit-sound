function acc = get_acc(pl, tl)
nex = size(pl, 2);
c = 0;
for i = 1:nex
    if pl(1, i) == tl(1, i)
        c = c + 1;
    end
end
acc = c/nex;
end