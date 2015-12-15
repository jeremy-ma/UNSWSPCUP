%log(range)
function feature_v = featureLogRange(enf)
    
    max_enf = max(enf,[],2);
    min_enf = min(enf,[],2);
    range_enf = log(max_enf - min_enf);
    
    feature_v = range_enf;

end