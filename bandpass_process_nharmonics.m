%--------------------------------------------------------------------
% Bandpass the signal up to the 4th harmonic
% y - raw signal
% fs - raw sampling freq
% ord - order of the filter (tested @ 60)
% Ap - pppassband ripple (tested @ 0.1)
% first_n_harm  - first n harmonics. (tested @ 4) Do not use more than 4.
% bandwidth_hz - one-sided bandwidth in hz (tested @ 0.5)
%--------------------------------------------------------------------
function [ynew, fsnew] = bandpass_process_nharmonics(y, fs, ord, Ap, first_n_harm, bandwidth_hz)
pass_start_hz = 50 - bandwidth_hz;
pass_start_norm = pass_start_hz/(fs/2);
pass_end_hz = first_n_harm*(60+bandwidth_hz);
pass_end_norm = pass_end_hz/(fs/2);

dpass = fdesign.bandpass('N,Fp1,Fp2,Ap', ord, pass_start_norm, pass_end_norm, Ap);
h = design(dpass);

bstop_counter = 1;
for i = 1:first_n_harm
    bstop1 = i*(50+bandwidth_hz)/(fs/2);
    bstop2 = i*(60-bandwidth_hz)/(fs/2);
    dstop(bstop_counter) = fdesign.bandstop('N,Fp1,Fp2,Ap', ord, bstop1, bstop2, Ap);
    dstopsos(bstop_counter) = design(dstop(bstop_counter));
    bstop_counter = bstop_counter + 1;
    if i ~= first_n_harm
        bstop3 = i*(60+bandwidth_hz)/(fs/2);
        bstop4 = (i+1)*(50-bandwidth_hz)/(fs/2);
        dstop(bstop_counter) = fdesign.bandstop('N,Fp1,Fp2,Ap', ord, bstop3, bstop4, Ap);
        dstopsos(bstop_counter) = design(dstop(bstop_counter));
        bstop_counter = bstop_counter + 1;
    end
end

for l = 1:2*first_n_harm - 1
    h = dfilt.cascade(h, dstopsos(l));
end

%fvtool(h);  %uncomment this to see the filter response. 
fsnew = fs;
ynew = filter(h, y);
end

