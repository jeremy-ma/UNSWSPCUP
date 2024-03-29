
%**************************************************************************
% Inputs: [y, fs, framelength, overlap, win_len]
% Outputs: [enf, time]
%**************************************************************************


% This function uses a spectral combining method

% Typically, we split signal into frames, calculate the dominant frequency in
% each frame and then use this to form the ENF

% Alternatively, spectral combining works by splitting the signal into frames
% For each frame and for each harmonic we calculate the deviation from 
% the nominal frequency

% For each frame and for each harmonic we calculate the signal strength
% (with respect to noise)

% We then combine the spectral bands weighted to signal strength

%IMPORTANT - The paper suggests weighting on a frame by frame basis which
%this implementation doesnt do (yet)

function [comb_enf, time] = MUSIC_ENF(y, fs, framelength, overlap, nom_freq)
 
    %Take the spectrogram of the AUDIO/POWER signal
    [S,F,T,P] = spectrogram(y, framelength, overlap, 1000, fs,'yaxis');
     
    %Non-essential spectrogram plot
%     subplot(3,1,1);  
%     surf(F,T,10*log10(abs(P')),'EdgeColor','none');   
%     axis xy; axis tight; colormap(jet); view(0,90);
%     ylabel('Time');
%     xlabel('Frequency (Hz)');

    i = 1;
    while (i < 9)
        %Determine the power of the first 8 harmonics
        base = i*nom_freq;
        %Note: eventually replace sum(sum(...
        harmonic_power(i) = sum(sum(abs(P((base-1:base+1),:))));
        
        i = i + 1;
    end
       
    i = 1;
    temp_enf = [];
    temp_time = [];
    comb_enf = 0;
    while (i < 9)
        %Use PSD to determine harmonic weights 
        harmonic_weight(i) = harmonic_power(i)/sum(harmonic_power);

        %bandpass filter around each harmonic
        [B,A] = butter(4,[(i*nom_freq)-1, (i*nom_freq)+1]/(fs/2));
       
        %Use the rootMUSIC method to figure extract the ENF of
        %each of the bands
        [enf,time] = MUSIC_extract(filter(B,A,y),fs,framelength,overlap);
        temp_enf = [temp_enf;enf];
        temp_time = [temp_time;time];
        
        %Caculate the combined spectrum ENF      
        comb_enf = comb_enf+(temp_enf(i,:)-(i-1)*nom_freq)*harmonic_weight(i);
        i = i + 1;
    end
  
    time = temp_time(1,:);

%     % Display the ENF extraced from the nominal band   
%     subplot(3,1,2);
%     plot(time, temp_enf(1,:));
%     xlabel('Time(sec)');
%     ylabel('Frequency(Hz)');
% 
%     % Display the combined weighted ENF  
%     subplot(3,1,3);
%     plot(time, comb_enf); 
%     xlabel('Time(sec)');
%     ylabel('Frequency(Hz)');
end


function [enf, time] = MUSIC_extract (y, fs, framelength, overlap)
 
corr = 2;

    %split up signal into overlapping frames
    %each column of seg is a different frame
    seg = buffer(y, framelength, overlap);

    enf = [];
    time = [];

    i = 1;
   
    %loops through and for each column (frame)
    while (i < size(seg,2))

        temp = seg(:,i);

        corr = corrmtx(seg(:,i),8,'mod');
        [W,P] = rootmusic(corr, 2);

        %convert from
        W = (W*fs)/(2*pi);

        enf = [enf, W(1)];
        time = [time, (framelength/2+(i-1)*(framelength-overlap))/fs];
        i = i +1;
    end

end