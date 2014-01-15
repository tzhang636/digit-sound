clear all;

m = dir(strcat('./SpeechMusic/music/*.wav'));
s = dir(strcat('./SpeechMusic/speech/*.wav'));

M = {length(m)};
S = {length(s)};

for i = 1:length(m)
    path = strcat('./SpeechMusic/music/', m(i).name);
    [sp, sr] = wavread(path);
    M{i} = log(abs(spectrogram(sp, 1024, 3/4*1024)));
end

for i = 1:length(s)
    path = strcat('./SpeechMusic/speech/', s(i).name);
    [sp, sr] = wavread(path);
    S{i} = log(abs(spectrogram(sp, 1024, 3/4*1024)));
end

spm = wavread('music');
spv = wavread('voice');
mt = log(abs(spectrogram(spm(:, 1), 1024, 3/4*1024))); % first channel
vt = log(abs(spectrogram(spv(:, 1), 1024, 3/4*1024))); % first channel

pt = [mt vt];
ptl = [zeros(1, size(mt, 2)) ones(1, size(vt, 2))];

% run 3 times, each with a different set of training and test data
res = {3};
pbdim = 0;
pbacc = 0;
for r = 1:3
    % create training and test data
    vm = randperm(length(M));
    vs = randperm(length(S));

    trmlen = floor(0.9*length(M));
    trslen = floor(0.9*length(S));

    trm = M(vm(1:trmlen));
    trs = S(vs(1:trslen));
    
    tm = M(vm(trmlen+1:end));
    ts = S(vs(trslen+1:end));

    tr = [trm{:} trs{:}];
    t = [tm{:} ts{:}];

    % create training and test labels
    trl = [zeros(1, size([trm{:}], 2)) ones(1, size([trs{:}], 2))];
    tl = [zeros(1, size([tm{:}], 2)), ones(1, size([ts{:}], 2))];

    bdim = 0;
    bacc = 0;
    for dim = 60:80
        [ztr, zt] = run_pca(tr, t, dim);
        G = train(ztr, trl, 2);
        pl = predict(zt, G, 2);
        acc = get_acc(pl, tl);
        if acc > bacc
            bdim = dim;
            bacc = acc;
        end
        
        [~, pzt] = run_pca(tr, pt, dim);
        ppl = predict(pzt, G, 2);
        pacc = get_acc(ppl, ptl);
        if pacc > pbacc
            pbdim = dim;
            pbacc = pacc;
        end
    end
    res{r} = [bdim, bacc];
end