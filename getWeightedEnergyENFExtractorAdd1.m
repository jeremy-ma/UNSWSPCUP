function [ extractor ] = getWeightedEnergyENFExtractorAdd1(framesize, overlap, nfft, tolerance, numberHarmonic)
    %pass in parameters for weightedEnergyENFExtractor
    
    function [enf, time] = extractorofenf(y,fs)
        outpoints = (length(y)/fs/framesize); 
        y1 = filter_signal_multiharm(y,fs,10,0.1, 4, 0.5);
        fmat1 = quad_interpolate_multipeak_multiharm(y1,fs,10000,9000,40000,50);
        enf = leastcostENF(fmat1);
        time = [1:1:length(enf)];
        x = interp(enf, outpoints);
        x = decimate(x, length(enf));
        enf = x;
    end
    extractor = @extractorofenf;
end

