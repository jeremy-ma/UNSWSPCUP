function [features] = featureWaveletParameters(enf)
    % normalise by mean
    enf = enf - mean(enf);
    lvl = 4;
    [decomposition, sizes] = wavedec(enf,lvl,'db1');
    features = zeros(1,lvl+1);
    startIndex = 1;
    for k=1:(lvl+1)
        %get the log variances of each of the wavelet decomposition bits
        logVar = log(var(decomposition(startIndex:(startIndex + sizes(k) - 1))));
        if isinf(logVar)
            disp('zero wavelet decomposition')
        end
        features(k) = logVar;
        startIndex = startIndex + sizes(k);
    end
end