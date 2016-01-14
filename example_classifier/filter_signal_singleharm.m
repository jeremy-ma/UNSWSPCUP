function ynew = filter_signal_singleharm(y, fs, fnom, ord, Ap, harmonic, bandwidth_hz)

passband_start_hz = (fnom)*harmonic - bandwidth_hz;
passband_end_hz =  (fnom)*harmonic + bandwidth_hz;
passband_start_norm = passband_start_hz/(fs/2);
passband_end_norm = passband_end_hz/(fs/2);

dpass = fdesign.bandpass('N,Fp1,Fp2,Ap', ord, passband_start_norm, passband_end_norm, Ap);
h = design(dpass);

ynew = filter(h,y);

%fvtool(h);
end
