
recordings = getRecordings('../raw_data/');

frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0;   %overlap between frames, default 0
nfft = 2^14;       %nfft parameter when applying spectrogram, default 2^14
tolerance = 1.0;    %how much one expects the power frequency to vary from the optimal 50 or 60

weightedEnergyExtractor = getWeightedEnergyENFExtractor(frame_size,overlap_enf,nfft,tolerance);


ENFSignals = getENFSignals(recordings, weightedEnergyExtractor);




% seg_size = 96;      %segment size in number of ENF points, default 96
% overlap_seg = 0;   %overlap between segments, default 0
% 
% features_num = 10;  %number of ENF features
% features_weight = ones(1,features_num); %assign weight to different features (size = 1 x feature_num, eg 1x10)
% train_w = 0.7;  %fraction of data put into training
% 
% %ENF extraction + feature extraction
% enf_power_extractor = @extractenf;     %function handle for ENF extraction 
% enf_audio_extractor = @extractenf;     %function handle for ENF extraction 
% 
% train_data = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
% train_data = train_data.features_extract(enf_power_extractor,enf_audio_extractor,path_train, file_list_train);
% train_data = train_data.labelling(file_label_train);
% 
% test_data = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
% test_data = test_data.features_extract(enf_power_extractor,enf_audio_extractor,path_test, file_list_test);
% test_data = test_data.labelling(num2str(num_test,'%02i'));
% 
% %Features normalisation
% scale_coeff = FeaturesNormClass(train_data.features,features_weight);
% train_data.features_norm = scale_coeff.scaletest(train_data.features);
% test_data.features_norm = scale_coeff.scaletest(test_data.features);
% 
% %Classification
% 
% class_algo = {@SVMClass};
% store_text = {'SVM'};
% store_label = classification(class_algo,store_text,train_data,train_w,test_data,store_fig);