function [ar_para,ar_err] = find_ar(enf_off, ar_para, ar_err)

    [a,g] = lpc(enf_off,2);
    ar_para = [ar_para; a(:,2:end)];
    g = log(g);
    ar_err = [ar_err; g];

end