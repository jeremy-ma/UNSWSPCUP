function [ enf ] = STFTENFextractor( y, fs, fnom )
    order = 10;    
    A_stop1 = 20;		% Attenuation in the first stopband = 60 dB
    F_stop1 = fnom-1.5;		% Edge of the stopband = 8400 Hz
    F_pass1 = fnom-.75;	% Edge of the passband = 10800 Hz
    F_pass2 = fnom+.75;	% Closing edge of the passband = 15600 Hz
    F_stop2 = fnom+1.5;	% Edge of the second stopband = 18000 Hz
    A_stop2 = 20;		% Attenuation in the second stopband = 60 dB
    A_pass = 1;		% Amount of ripple allowed in the passband = 1 dB
    designSpecs = ...
       fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
		F_stop1, F_pass1, F_pass2, F_stop2, A_stop1, A_pass, ...
		A_stop2, fs);
    filterobj = design(designSpecs,'cheby2');
    y = filter(y,filterobj);
    
end

