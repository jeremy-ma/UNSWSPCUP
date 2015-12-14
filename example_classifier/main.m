
recordings = getRecordings('../raw_data/');

frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0;   %overlap between frames, default 0
nfft = 2^14;       %nfft parameter when applying spectrogram, default 2^14
tolerance = 1.0;   %how much one expects the power frequency to vary from the optimal 50 or 60

weightedEnergyExtractor = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance);

ENFSignals = getENFSignals(recordings, weightedEnergyExtractor);

featureExtractors = {@featureMean, @featureLogRange,...
    @featureWaveletParameters, @featureARparameters};

segmentSize = 96;

[featureVectors, labels,recordingTypes] = segmentENFAndExtractFeatures(ENFSignals, featureExtractors, segmentSize);




