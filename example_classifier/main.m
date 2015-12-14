%declare variables

%location of directories
orig_dir = fullfile('..','..','Training_Data150901');
path_train = fullfile('..','..','data');
path_test = fullfile('..','..','Practice_dataset','Practice_dataset');
store_result = fullfile('..','..','result');

grid_num = 'all';
record_type = 'all';
record_num = 'all';


frame_size = 5;    %size of a frame (ENF point) in seconds, default 5
overlap_enf = 0;   %overlap between frames, default 0
nfft = 2^14;          %nfft parameter when applying spectrogram, default 2^14
seg_size = 96;      %segment size in number of ENF points, default 96
overlap_seg = 0;   %overlap between segments, default 0

enf_algo_p = @extractenf;     %function handle for power ENF extraction 
enf_algo_a = @extractenf;     %function handle for audio ENF extraction 

features_num = 10;  %number of ENF features
features_weight = ones(1,features_num); %assign weight to different features (size = 1 x feature_size, eg 1x10)
train_w = 0.7;  %fraction of data put into training

class_algo = {@SVMClass};

prefix = 'Rosstest';    %saving data

%%
change_dir(orig_dir, path_train, store_result);

%create file list
[file_list_train, file_tab_train, file_label_train] = list_files(path_train,grid_num,record_type,record_num);
[file_list_test,file_label_test] = list_files_test(path_test);

%distinguish between power and audio
[file_list_train_p, file_list_train_a, file_label_p, file_label_a] = split_pa(file_list_train, file_label_train, path_train);
[file_list_test_p, file_list_test_a, label_test_p, label_test_a] = split_pa(file_list_test,file_label_test,path_test);

%% power
store_label_p = [];
if ~isempty(file_list_train_p)
    %ENF extraction + feature extraction
    disp('ENF & feature extraction - power train data')
    train_data_p = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
    train_data_p = train_data_p.features_extract(enf_algo_p, path_train, file_list_train_p);
    train_data_p = train_data_p.labelling(file_label_p);

    disp('ENF & feature extraction - power test data')
    test_data_p = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
    test_data_p = test_data_p.features_extract(enf_algo_p, path_test, file_list_test_p);
    test_data_p = test_data_p.labelling(num2str(label_test_p,'%02i'));

    %Features normalisation
    disp('Features normalisation on power')
    scale_coeff_p = FeaturesNormClass(train_data_p.features,features_weight);
    train_data_p.features_norm = scale_coeff_p.scaletest(train_data_p.features);
    test_data_p.features_norm = scale_coeff_p.scaletest(test_data_p.features);

    %Classification
    disp('Classification on power')
    store_text_p = {'SVM_p'};
    store_label_p = classification(class_algo,store_text_p,train_data_p,train_w,test_data_p,store_result);
end

%% audio
store_label_a = [];
if ~isempty(file_list_train_a)
    disp('ENF & feature extraction - audio train data')
    train_data_a = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
    train_data_a = train_data_a.features_extract(enf_algo_a, path_train, file_list_train_a);
    train_data_a = train_data_a.labelling(file_label_a);

    disp('ENF & feature extraction - audio test data')
    test_data_a = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg);
    test_data_a = test_data_a.features_extract(enf_algo_a, path_test, file_list_test_a);
    test_data_a = test_data_a.labelling(num2str(label_test_a,'%02i'));

    disp('Features normalisation on audio')
    scale_coeff_a = FeaturesNormClass(train_data_a.features,features_weight);
    train_data_a.features_norm = scale_coeff_a.scaletest(train_data_a.features);
    test_data_a.features_norm = scale_coeff_a.scaletest(test_data_a.features);

    disp('Classification on audio')
    store_text_a = {'SVM_a'};
    store_label_a = classification(class_algo,store_text_a,train_data_a,train_w,test_data_a,store_result);

end

%% compare with the truth value (practice data)
disp('compare with the truth value (practice data)')
[accuracy_p, accuracy_a, truth_p, truth_a] = truth(store_label_p, store_label_a, label_test_p, label_test_a);
if ~isempty(truth_p)
    [C_p,order] = confusionmat(truth_p(:,3),truth_p(:,4),'order',['A':'I' 'N']');
    f_p = plot_confuse_m(C_p, order, store_result,'SVM_p');
end
if ~isempty(truth_a)
    [C_a,order] = confusionmat(truth_a(:,3),truth_a(:,4),'order',['A':'I' 'N']');
    f_a = plot_confuse_m(C_a, order, store_result,'SVM_a');
end

%% save results
t = datestr(now,'yyyy-MM-dd_HH-mm-ss');
save(fullfile(store_result,[prefix '_' t '.mat']));  % store parameters
if exist('f_p','var')
    saveas(f_p,fullfile(store_result,[prefix '_' t '_SVM_p']),'jpg');
end
if exist('f_a','var')
    saveas(f_a,fullfile(store_result,[prefix '_' t '_SVM_a']),'jpg');
end