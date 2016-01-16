function [ extractor ] = getWeightedEnergyENFExtractorAdd1(framesize, ~, ~, ~, ~)
    %pass in parameters for weightedEnergyENFExtractor
    
    function [enf, time] = extractorofenf(y,fs)
        outpoints = (length(y)/fs/framesize); %calculates how many enfpoints in output 
        y1 = filter_signal_multiharm(y,fs,10,0.1, 4, 0.5); %arguements: y, fs, filterorder, passbandripple(in db), how many harmonics to combine, tolerance
        fmat1 = quad_interpolate_multipeak_multiharm(y1,fs,10000,9000,40000,50); %arguments: y,fs,framessize (10s), overlap(9s), (nfftpoints = 4xframelength as per paper, number of peaks to consider)
        enf = leastcostENF(fmat1); %leastcost path 
        time = [1:1:length(enf)];
        x = interp(enf, outpoints);
        x = decimate(x, length(enf));
        enf = x;
    end
    extractor = @extractorofenf;
end

