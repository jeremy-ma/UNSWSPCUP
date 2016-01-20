%%%%%%%%%%%%%%%%%%%Load recording data%%%%%%%%%%%%%%%%%%%%%%%%%

%Input the path to the testing data here. The function expects a folder
%with the testing wav files. The slash at the end is required.
%The ENF from the training recordings has been pre-extracted to save time
%(ENFSignalsTrain.mat)
%If you want to re-extract them, please run mainAllHarmonics.m and edit
%the following line-> trainRecordings = getRecordings('../training_data/');
%to correspond the location of the training set.
%The python file app.py expects files in the testing dataset folder to be
%named Test_1.wav etc.

%%%%%%%%%%%%%%%%EDIT THIS LINE AS APPROPRIATE%%%%%%%%%%%%%%%%%%%%%
testRecordings = getRecordings('Testing_dataset/');

%%%%%%%%%%%%%%%%%%%ENF Extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0.01;   %overlap between frames, default 0
nfft = 2^14;       %nfft parameter when applying spectrogram, default 2^14
tolerance = 1.0;   %how much one expects the power frequency to vary from the optimal 50 or 60

% Extract around fundamental, second and third, fourth harmonic
extractorFundamental = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,1);
extractor2 = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,2);
extractor3 = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,3);
extractor4 = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance,4);

e1 = getSTFTENFextractor(5,0,2^14,1);
e2 = getSTFTENFextractor(5,0,2^14,2);
e3 = getSTFTENFextractor(5,0,2^14,3);
e4 = getSTFTENFextractor(5,0,2^14,4);

extractors = {extractorFundamental, extractor2, extractor3, extractor4, ...
              e1, e2, e3, e4};

ENFSignalsTest = {};
for ii=1:length(extractors)
    ENFSignalsTest{ii} = getENFSignals(testRecordings, extractors{ii}, extractors{ii}, @signal_type);
end

%load pre-extracted training signals
ENFSignalsTrainStruct = load('ENFSignalsTrain.mat');
ENFSignalsTrain = ENFSignalsTrainStruct.ENFSignalsTrain;

%%%%%%%%%%%%%%%%%%% Feature Extraction %%%%%%%%%%%%%%%%%%%%%%%%%

featureExtractors = {@featureMean, @featureLogRange, @featureLogVariance...
    @featureWaveletParameters, @featureARparameters};

trainFeatures = [];
testFeatures = [];

for ii=1:length(extractors)
    segmentSize = length(ENFSignalsTest{ii}(1).enf);
    [trainFeaturesTemp, trainLabels, gridLabels, trainRecordingTypes, trainFileNames] = segmentENFAndExtractFeatures(ENFSignalsTrain{ii}, featureExtractors, segmentSize);
    [testFeaturesTemp, testLabels, testGridLabels, testRecordingTypes, testFileNames] = segmentENFAndExtractFeatures(ENFSignalsTest{ii}, featureExtractors, segmentSize);
    trainFeatures = [trainFeaturesTemp, trainFeatures];
    testFeatures = [testFeaturesTemp, testFeatures];
end
%%%%%%%%%%%%%%%%%%% Classifier %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('trainTestDataTEST.mat','trainFeatures','trainLabels','testFeatures','testLabels',...
    'trainFileNames','testFileNames');

% This should work if you're using system python
[status,cmdout] = system('python app.py','-echo');

% Otherwise manually run your own python, e.g.
% [status, cmdout] = system('C:\Users\Adrian\AppData\Local\Enthought\Canopy\User\Scripts\python app.py');
