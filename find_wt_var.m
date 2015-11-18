function wt_var = find_wt_var(enf_off, wt_var)
    lvl = 4;
    c_var = zeros(size(enf_off,2),lvl+1);
    for i=1:size(enf_off,2)
        [c,l] = wavedec(enf_off(:,i),lvl,'db1');
        start_ind = [0; l(2:end-1)] + 1;
        end_ind = l(2:end);
        for j=1:lvl+1
            c_var(i,j) = log(var(c(start_ind(j):end_ind(j))));
        end
    end
    wt_var = [wt_var; c_var];
end