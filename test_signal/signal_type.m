function [result] = signal_type(x, fs)
% Determines whether a given signal is of type Audio or Power
%   x: n by 1 array, the waveform
%   fs: sampling frequency
%

    L = length(x);
    nfft = L;     % Normally make this power of 2
    X = fft(x, nfft);
    Px = abs(X); % /(nfft*L);
    % f = fs*(0:nfft/2-1)/nfft;  % frequency axis
    
    hz_50 = (49/fs)*L:(51/fs)*L;  % Indices of the spectrum between 49 to 51
    % This is to handle grid D with the weird second harmonic
    hz_150 = (149/fs)*L:(151/fs)*L;  % Third harmonic of the above
    
    hz_60 = (59/fs)*L:(61/fs)*L;  % Indices of the spectrum between 59 to 61
    
    % energy
    totalEnergy = sum(Px.^2);
    % energy in the relevant frequencies
    energy50 = sum(Px(hz_50).^2) + sum(Px(hz_150).^2);
    energy60 = sum(Px(hz_60).^2);
    
    feature = max(energy50/totalEnergy, energy60/totalEnergy);
    
    if feature >  0.2283   % Found from experiments.m
        result = 'P';
    else
        result = 'A';
    end

end

