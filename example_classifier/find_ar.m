function feature_v = find_ar(enf,feature_v,order)

    if ~exist('order','var')
        order = 2;
    end

    [a,g] = lpc(enf,order);
%     ar_para = [ar_para; a(:,2:end)];
    g = log(g);
%     ar_err = [ar_err; g];

    feature_v = [feature_v a(:,order:end) g];
end