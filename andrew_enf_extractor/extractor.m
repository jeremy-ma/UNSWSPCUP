function [enf, time] = extractor(y,fs, harm)

fnom = which_nominal_frequency(y,fs);

%assume numberHarmonic exists and is 1,2 or 3
y1 = filter_signal(y,fs,fnom, 60, 0.1, harm, 0.5);
fmat1 = quad_interpolate_multipeak(y1,fs,10000,0,40000,50);
enf = leastcostENF(fmat1);
time = [1:1:length(enf)];

end