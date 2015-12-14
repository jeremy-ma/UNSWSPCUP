function feature_v = featureARparameters(enf)
    enf = enf - mean(enf);
    order = 2;
    [a,g] = lpc(enf,order);
    g = log(g);
    feature_v = [a(:,order:end) g];
end