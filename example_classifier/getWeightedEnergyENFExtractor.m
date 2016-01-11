function [ extractor ] = getWeightedEnergyENFExtractor(framesize, overlap, nfft, tolerance, numberHarmonic)
    
%pass in parameters for weightedEnergyENFExtractor
    function [enf, time] = extractenf(y, fs)

        framelength = framesize * fs;
        overlapLength = overlap * fs;
        if isempty(nfft)
            nfft = max(256,2^(ceil(log2(length(y)))));
        end

        %frequency axis for the FFT
        freqaxis = (fs/2)*linspace(0,1,(nfft/2));

        %fourier transform of the signal and half since symmetrical about fs/2:
        x = abs(fft(y, nfft));
        x = x(1:(nfft/2));

        fnom = which_nominal_frequency(y,fs) * numberHarmonic;

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

%     function [enf, time] = andrew_enf(y,fs)
%         fnom = which_nominal_frequency(y,fs);
%         %assume numberHarmonic exists and is 1,2 or 3
%         y1 = filter_signal(y,fs,fnom, 60, 0.1, numberHarmonic, 0.5);
%         fmat1 = quad_interpolate_multipeak(y1,fs,10000,0,40000,50);
%         enf = leastcostENF(fmat1);
%         time = [1:1:length(enf)];
%     end

    %return the parametrized function
    extractor = @extractenf;
end

