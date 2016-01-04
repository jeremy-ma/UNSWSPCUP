%%%%%%%%%%%%%%%%%%%Load recording data%%%%%%%%%%%%%%%%%%%%%%%%%
%make sure you have the slash at the end guys
trainRecordings = getRecordings('../training_data/');
testRecordings = getRecordings('../practice_data/');

%trainRecordings = load('trainRecordings.mat');
%testRecordings = load('testRecordings.mat');

%%%%%%%%%%%%%%%%%%%ENF Extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 1;   %overlap between frames, default 0
nfft = 2^14;       %nfft parameter when applying spectrogram, default 2^14
tolerance = 1.0;   %how much one expects the power frequency to vary from the optimal 50 or 60

extractorFundamental = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,1);
extractor2 = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,2);
extractor3 = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,3);
%weightedEnergyExtractor = getAltExtractENF(frame_size,overlap_enf, nfft);
%musicExtractor = getMusicExtractor(5000,1000);

extractors = {extractorFundamental, extractor2, extractor3};
ENFSignalsTrain = {};
ENFSignalsTest = {};
for ii=1:length(extractors)
    ENFSignalsTrain{ii} = getENFSignals(trainRecordings, extractors{ii}, extractors{ii}, @signal_type);
    ENFSignalsTest{ii} = getENFSignals(testRecordings, extractors{ii}, extractors{ii}, @signal_type);
end

%%%%%%%%%%%%%%%%%%% Feature Extraction %%%%%%%%%%%%%%%%%%%%%%%%%

featureExtractors = {@featureMean, @featureLogRange,...
    @featureWaveletParameters, @featureARparameters};
segmentSize = 120;

trainFeatures = [];
testFeatures = [];

for ii=1:length(extractors)  
    [trainFeaturesTemp, trainLabels, gridLabels, trainRecordingTypes, originalfilenames] = segmentENFAndExtractFeatures(ENFSignalsTrain{ii}, featureExtractors, segmentSize);
    [testFeaturesTemp, testLabels, testGridLabels, testRecordingTypes, testOriginalFileNames] = segmentENFAndExtractFeatures(ENFSignalsTest{ii}, featureExtractors, segmentSize);
    trainFeatures = [trainFeaturesTemp, trainFeatures];
    testFeatures = [testFeaturesTemp, testFeatures];
end

%%%%%%%%%%%%%%%%%%% Classifier %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%testLabels = load('testLabels.mat');

save('trainTestData.mat','trainFeatures','trainLabels','testFeatures','testLabels');
save('ENFSignals.mat','ENFSignalsTest','ENFSignalsTrain');

%[ predicted, accuracy, probabilities ] = SVMClassify(trainFeatureVectors, trainLabels, testFeatureVectors, testLabels);


