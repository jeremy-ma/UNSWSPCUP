%script to print out the ENFs

cur_directory = pwd;
training_data_path = 'C:\Users\Andrew\Desktop\Unsorted\UNSW Signal Processing Cup\training_data';

cd(training_data_path);
all_wav = dir('*.wav');

for i = 1:length(all_wav)
    [y,fs] = audioread(all_wav(i).name);
    [enf1, ~] = extractenf(y,fs,10000,2^14,1,9000,0.5);
    [enf2, ~] = extractenf(y,fs,10,2^14,2,9,0.5);
    [enf3, ~] = extractenf(y,fs,10,2^14,3,9,0.5);
    figure
    subplot(3,2,1)
    plot(enf1);
    title('1st Harmonic - weightedEnergy');
    subplot(3,2,3)
    plot(enf2);
    title('2nd Harmonic - weightedEnergy');
    subplot(3,2,5);
    plot(enf3);
    title('3rd Harmonic - weightedEnergy');
    [enf1, ~] = extractor(y,fs,1);
    [enf2, ~] = extractor(y,fs,2);
    [enf3, ~] = extractor(y,fs,3);
    subplot(3,2,2)
    plot(enf1);
    title('1st Harmonic - quadratic interpolate');
    subplot(3,2,4)
    plot(enf2);
    title('2nd Harmonic - quadratic interpolate');
    subplot(3,2,6);
    plot(enf3);
    title('3rd Harmonic - quadratic interpolate');
    
        
   
    
    [~,outputname,~] = fileparts(all_wav(i).name);
    
    print(fullfile('C:\Users\Andrew\Desktop\Unsorted\UNSW Signal Processing Cup\Matlab Figure Outputs\Training ENFs', outputname), '-djpeg');
    close
end






cd(cur_directory);
%clear all;
%clc;