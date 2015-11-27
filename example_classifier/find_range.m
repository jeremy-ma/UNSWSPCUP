%log(range)
function feature_v = find_range(enf, feature_v)
    
    max_enf = max(enf,[],2);
    min_enf = min(enf,[],2);
    range_enf = log(max_enf - min_enf);
    
    feature_v = [feature_v range_enf];

end