function [extractor] = getSTFTENFextractor(frameduration, overlap, nfft,harmonic)
    
    function [enf] = STFTENFextract(y,fs)
        fnom = getNominalFrequency(y,fs) * harmonic;
        framelength = frameduration * fs;
        overlapLength = overlap * fs;
        A_stop1 = 60;		% Attenuation in the first stopband = 60 dB
        F_stop1 = fnom-1.5;		% Edge of the stopband = 8400 Hz
        F_pass1 = fnom-1;	% Edge of the passband = 10800 Hz
        F_pass2 = fnom+1;	% Closing edge of the passband = 15600 Hz
        F_stop2 = fnom+1.5;	% Edge of the second stopband = 18000 Hz
        A_stop2 = 60;		% Attenuation in the second stopband = 60 dB
        A_pass = 1;		% Amount of ripple allowed in the passband = 1 dB
        designSpecs = ...
           fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
            F_stop1, F_pass1, F_pass2, F_stop2, A_stop1, A_pass, ...
            A_stop2, fs);
        filterobj = design(designSpecs,'cheby2');
        y = filter(filterobj,y);
        fnomIndex = round(fnom / (fs/2) * (nfft/2));
        toleranceIndexes = round(3/(fs/2) * (nfft/2));
        [S,F,T] = spectrogram(y, framelength, overlapLength, nfft, fs);
        Smag = log(abs(S));
        [~,maxFreqIndices] = max(Smag(fnomIndex-toleranceIndexes:fnomIndex+toleranceIndexes,:));
        maxFreqIndices = maxFreqIndices + fnomIndex - toleranceIndexes;
        enf = zeros(1,length(T));
        for ii=1:length(T)
            argmax = maxFreqIndices(ii);
    %         p = polyfit([F(argmax-1),F(argmax),F(argmax+1)],...
    %                     [Smag(argmax-1,ii),Smag(argmax,ii),Smag(argmax+1,ii)],2);
            f = F(argmax-5:argmax+5);
            s = Smag(argmax-5:argmax+5,ii);
            [p,~,mu] = polyfit(f,s,2);
            %argmax is -b/2a
            freqEst =  - p(2) / (2*p(1));
            enf(ii) = (freqEst * mu(2)) + mu(1);
        end
        
    end
    extractor = @STFTENFextract;
end

