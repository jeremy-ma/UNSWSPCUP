%%%%%%%%%%%%%%%%%%%Load recording data%%%%%%%%%%%%%%%%%%%%%%%%%
%make sure you have the slash at the end guys
trainRecordings = getRecordings('../training_data/');
testRecordings = getRecordings('../test_data/');


%%%%%%%%%%%%%%%%%%%ENF Extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0;   %overlap between frames, default 0
nfft = 2^14;       %nfft parameter when applying spectrogram, default 2^14
tolerance = 1.0;   %how much one expects the power frequency to vary from the optimal 50 or 60

weightedEnergyExtractor = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance);

ENFSignalsTrain = getENFSignals(trainRecordings, weightedEnergyExtractor, weightedEnergyExtractor, @signal_type);
ENFSignalsTest = getENFSignals(testRecordings, weightedEnergyExtractor, weightedEnergyExtractor, @signal_type);

%%%%%%%%%%%%%%%%%%% Feature Extraction %%%%%%%%%%%%%%%%%%%%%%%%%

featureExtractors = {@featureMean, @featureLogRange,...
    @featureWaveletParameters, @featureARparameters};

segmentSize = 96;

[trainFeatureVectors, trainLabels, gridLabels, trainRecordingTypes, originalfilenames] = segmentENFAndExtractFeatures(ENFSignalsTrain, featureExtractors, segmentSize);
[testFeatureVectors, ~,~] = segmentENFAndExtractFeatures(ENFSignalsTest, featureExtractors, segmentSize);

%%%%%%%%%%%%%%%%%%% Classifier %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ predicted, accuracy, probabilities ] = SVMClassify(trainFeatureVectors, trainLabels, testFeatureVectors, 8*ones(length(testFeatureVectors),1));

