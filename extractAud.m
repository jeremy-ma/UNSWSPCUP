function [enf, time] = extractAud(y,fs)

[ynew, fsnew] = bandpass_process_nharmonics(y, fs, 60, 0.1, 4, 0.5);
freqmat = quad_interpolate_multipeak(ynew, fsnew, 10000, 9000, 40000, 15);
path = leastcostENF(freqmat');
time = [1:length(path)];
enf = path;

end
