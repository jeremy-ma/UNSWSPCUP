%log(range)
function range_concat = find_range(enf, range_concat)
    
    max_enf = max(enf,[],2);
    min_enf = min(enf,[],2);
    range_enf = log(max_enf - min_enf);
    
    range_concat = [range_concat; range_enf];

end