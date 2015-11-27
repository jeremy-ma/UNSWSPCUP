function features = feature_extract(features, enf_reshape, seg_size)

    

    %FEATURE EXTRACTION
    feature_v = [];
    
    %(Index 1)find mean ENF of the signal over time
%     [mean_enf, mean_concat] = find_mean(enf_reshape, mean_concat);
    [feature_v, mean_enf] = find_mean(enf_reshape, feature_v);
    
    %offset to 0
    enf_off = (enf_reshape - repmat(mean_enf,1,seg_size))'; 
    
    %(Index 2)find log(range) of ENF
    feature_v = find_range(enf_reshape, feature_v);

    %(Index 3-7) variance after wavlet decomposition
    feature_v = find_wt_var(enf_off, feature_v);
    
    %(Index 8-10) AR parameters, error variance
    feature_v = find_ar(enf_off, feature_v);
   
    %%%%%% INSERT NEW FEATURES HERE %%%%%%
    %INPUT: enf_off: offseted ENF signal
    %       feature_v = feature vector of the signal
    %OUTPUT: feature_v = feature vector of the signal, with new feature extracted
    
    
    %%%%%%
    
    features = [features; feature_v];
end