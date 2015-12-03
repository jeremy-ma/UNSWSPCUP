%declare variables

%locate the file for training 
orig_dir = fullfile('..','..','Training_Data150901');
path_train = fullfile('..','..','data');
path_test = fullfile('..','..','Practice_dataset','Practice_dataset');
store_fig = fullfile('..','..','figures');

grid_num = 'all';
record_type = 'P';
record_num = 'all';

% kfold = 5;

frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0;   %overlap between frames, default 0
nfft = 2^14;          %nfft parameter when applying spectrogram, default 2^14
seg_size = 96;      %segment size in number of ENF points, default 96
overlap_seg = 0;   %overlap between segments, default 0

features_num = 10;  
features_weight = ones(1,features_num);        %assign weight to different features (size = 1 x feature_size, eg 1x10)
%%
change_dir(orig_dir, path_train, store_fig);

%train data
[file_list_train, file_tab_train, file_label_train] = list_files(path_train,grid_num,record_type,record_num);
% [features_train,label_concat] = features_extract(path_train, file_list_train, label_train, frame_size, overlap_enf, nfft, seg_size, overlap_seg);
train_data = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
train_data = train_data.features_extract(path_train, file_list_train);
train_data = train_data.labelling(file_label_train);

% [norm_train,grad,intercept] = feature_norm(features_train);
scale_coeff = FeaturesNormClass(train_data.features,features_weight);
train_data.features_norm = scale_coeff.scaletest(train_data.features);

%test data
[file_list_test,num_test] = list_files_test(path_test);
test_data = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
test_data = test_data.features_extract(path_test, file_list_test);
test_data = test_data.labelling(num2str(num_test,'%02i'));

test_data.features_norm = scale_coeff.scaletest(test_data.features);

%SVM
train_w = 0.7;
valid_w = 0.3;
% test_w = 0;
class_algo = {@SVMClass};
store_text = {'SVM'};
classification(class_algo,store_text,train_data,train_w,valid_w,test_data,store_fig);
% SVMobj = SVMClass();
% SVMobj = SVMobj.split_data(train_data,train_w,valid_w);
% SVMobj = SVMobj.training();
% [pred_label,score] = SVMobj.testing(SVMobj.valid_data);
% [SVMobj, merge_label, conf_prob_merge] = SVMobj.merge_seg(pred_label, score, SVMobj.valid_tag);
% SVMobj.confuse(merge_label,store_fig, conf_prob_merge);

% [prob_m, accuracy] = svm_train(train_norm,label_concat,kfold,store_fig);