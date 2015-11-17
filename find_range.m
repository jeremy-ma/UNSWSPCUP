%log(range)
function range_enf = find_range(enf)
    
    max_enf = max(enf,[],2);
    min_enf = min(enf,[],2);
    range_enf = log(max_enf - min_enf);

end