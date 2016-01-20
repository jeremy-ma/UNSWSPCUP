function nominalFrequency = getNominalFrequency(signal, fs)
    % Determines whether the given signal is 50Hz or 60Hz
    %  data: n by 1 array of the voltage
    %  fs  : sampling frequency

    L = length(signal);
    nfft = L;            % Normally make this power of 2
    Signal = fft(signal, nfft);
    mag = abs(Signal);
    
    delta = 0.1;
    hz_50 = round(((50 - delta)/fs)*L:((50 + delta)/fs)*L);  % Indices of the spectrum between 49 to 51
    hz_100 = round(((100-delta)/fs)*L:((100+delta)/fs)*L);
    hz_150 = round(((150-delta)/fs)*L:((150+delta)/fs)*L);  % Third harmonic of the above
    hz_200 = round(((200-delta)/fs)*L:((200+delta)/fs)*L);
    
    hz_60 = round(((60-delta)/fs)*L:((60+delta)/fs)*L);  % Indices of the spectrum between 59 to 61
    hz_120 = round(((120-delta)/fs)*L:((120+delta)/fs)*L);
    hz_180 = round(((180-delta)/fs)*L:((180+delta)/fs)*L);
    hz_240 = round(((240-delta)/fs)*L:((240+delta)/fs)*L);
    
    energy50 = sum(mag(hz_50).^2) + sum(mag(hz_100).^2) + sum(mag(hz_150).^2) + sum(mag(hz_200).^2);
    energy60 = sum(mag(hz_60).^2) + sum(mag(hz_120).^2) + sum(mag(hz_180).^2) + sum(mag(hz_240).^2);
    
    if energy50 > energy60
        nominalFrequency = 50;
    else
        nominalFrequency = 60;   
    end
end
