%%%%%%%%%%%%%%%%%%%Load recording data%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTE: Alter the following path to point to the folder containing all the
%training data.
trainRecordings = getRecordings('../training_data/');

%%%%%%%%%%%%%%%%%%%ENF Extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0.01;   %overlap between frames, default 0
nfft = 2^14;       %nfft parameter when applying spectrogram, default 2^14
tolerance = 1.0;   %how much one expects the power frequency to vary from the optimal 50 or 60

% Extract around fundamental, second and third harmonic
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

ENFSignalsTrain = {};
for ii=1:length(extractors)
    ENFSignalsTrain{ii} = getENFSignals(trainRecordings, extractors{ii}, extractors{ii}, @signal_type);
end

save('ENFSignalsTrain.mat','ENFSignalsTrain');

