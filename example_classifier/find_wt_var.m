function feature_v = find_wt_var(enf, feature_v, lvl, wname)
    
    if ~exist('lvl','var')
        lvl = 4;
    end
    if ~exist('wname','var')
        wname = 'db1';
    end
    
    c_var = zeros(size(enf,2),lvl+1);
    for i=1:size(enf,2)
        [c,l] = wavedec(enf(:,i),lvl,wname);
        start_ind = [0; l(2:end-1)] + 1;
        end_ind = l(2:end);
        for j=1:lvl+1
            c_var(i,j) = log(var(c(start_ind(j):end_ind(j))));
        end
    end
    feature_v = [feature_v c_var];
end