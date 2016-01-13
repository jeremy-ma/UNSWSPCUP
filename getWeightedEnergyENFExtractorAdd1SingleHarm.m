function [ extractor ] = getWeightedEnergyENFExtractorAdd1SingleHarm(framesize, overlap, nfft, tolerance, numberHarmonic)
    %pass in parameters for weightedEnergyENFExtractor
    
    function [enf, time] = extractorofenfsing(y,fs)
        outpoints = (length(y)/fs/framesize); 
        fnom = which_nominal_frequency(y,fs);
        y1 = filter_signal_singleharm(y,fs, fnom, 10,0.1,numberHarmonic,tolerance);
        fmat1 = quad_interpolate_multipeak_singleharm(y1, fs, 10000, 9000, 40000, 50);
        enf = leastcostENF(fmat1);
        time = [1:1:length(enf)];
        x = interp(enf, outpoints);
        x = decimate(x, length(enf));
        enf = x;
    end
    extractor = @extractorofenfsing;
end

