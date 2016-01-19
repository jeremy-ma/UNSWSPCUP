function [ extractor ] = getWeightedEnergyENFExtractor(framesize, overlap, nfft, tolerance, numberHarmonic)
    
%pass in parameters for weightedEnergyENFExtractor
    function [enf, time] = extractenf(y, fs)

        framelength = framesize * fs;
        overlapLength = overlap * fs;
        if isempty(nfft)
            nfft = max(256,2^(ceil(log2(length(y)))));
        end

        %frequency axis for the FFT
%         freqaxis = (fs/2)*linspace(0,1,(nfft/2));

        %fourier transform of the signal and half since symmetrical about fs/2:
%         x = abs(fft(y, nfft));
%         x = x(1:(nfft/2));

        fnom = getNominalFrequency(y,fs) * numberHarmonic;

        [sxx,fAxisSpectro,time] = spectrogram(y, framelength, overlapLength, nfft, fs);

        upperFrequencyLimit = fnom + tolerance;
        lowerFrequencyLimit = fnom - tolerance;

        [~,upperFrequencyBucket] = min(abs(fAxisSpectro-upperFrequencyLimit));
        [~,lowerFrequencyBucket] = min(abs(fAxisSpectro-lowerFrequencyLimit));

        enf = zeros(1,length(time));
        for nn=1:length(time)
            numer = 0.0;
            denom = 0.0;
            for jj=lowerFrequencyBucket:upperFrequencyBucket
                numer = numer + abs(sxx(jj,nn)) * fAxisSpectro(jj);
                denom = denom + abs(sxx(jj,nn));
            end
            if denom ~= 0
                enf(nn) = numer / denom;
            else
                enf(nn) = 0;
            end
        end
    end
    %return the parametrized function
    extractor = @extractenf;
end

