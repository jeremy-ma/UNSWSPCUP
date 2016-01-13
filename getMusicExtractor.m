function [ extractor ] = getMusicExtractor(framelength, overlap)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    function[comb_enf, time] = musicExtractor(y,fs)
        nominalFrequency = which_nominal_frequency(y,fs);
        [comb_enf, time] = MUSIC_ENF(y, fs, framelength, overlap, nominalFrequency);
    end

    extractor = @musicExtractor;
end

