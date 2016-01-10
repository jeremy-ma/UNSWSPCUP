
fs = 1000; 

%y{i} is a cell array of the audio files
%t{i} is a cell arrat of the truth data 
for i = 1: length(audiofiles)
    figure;
    subplot(4,2,1);
    plot(t{i});
    title('This is the truth data');
    
    [ynew, fsnew] = filter_signal_multiharm(y{i}, 1000, 60, 0.1, 4, 0.5);
    freqmat = quad_interpolate_multipeak_multiharm(ynew, fsnew, 10000, 9000, 40000, 150);
    path = leastcostENF(freqmat);
    subplot(4,2,2)
    plot(path);
    title('ExtractAud Multiharm');
    
    [enf1, ~] = extractenf(y{i},fs,10,2^14,1,9000,0.5);
    [enf2, ~] = extractenf(y{i}, fs,10,2^14,2,9000,0.5);
    [enf3, ~] = extractenf(y{i},fs,10,2^14,3,9000,0.5);
    
    subplot(4,2,3);
    plot(enf1);
    title('1st Harmonic - weightedEnergy');    
    subplot(4,2,5);
    plot(enf2);
    title('2nd Harmonic - weightedEnergy');
    subplot(4,2,7);
    plot(enf3);
    title('3rd Harmonic - weightedEnergy');
    
    [enf1, ~] = extractor_singleharm(y{i},fs,1);
    [enf2, ~] = extractor_singleharm(y{i},fs,2);
    [enf3, ~] = extractor_singleharm(y{i},fs,3);
    subplot(4,2,4)
    plot(enf1);
    title('1st Harmonic - quadratic interpolate');
    subplot(4,2,6)
    plot(enf2);
    title('2nd Harmonic - quadratic interpolate');
    subplot(4,2,8);
    plot(enf3);
    title('3rd Harmonic - quadratic interpolate');
    
    outputname = strcat('file', outname{i});
    print(fullfile('C:\Users\Andrew\Desktop\Unsorted\UNSW Signal Processing Cup\primary_data',outputname), '-djpeg');
    close all
end

