%declare global variables
% global Fs   %sampling frequency

% Fs = 1000;

%locate the file for training 

orig_dir = fullfile('..','..','Training_Data150901');
path = fullfile('..','..','data');
grid_num = 'all';
record_type = 'P';
record_num = 'all';

change_dir(orig_dir, path);

[file_list_train, label_train] = list_files(path,grid_num,record_type,record_num);
[features_train,label_concat] = features_extract(path, file_list_train, label_train);

% %locate the file for testing
% path = 'Train_Data';
% grid_num = ['A' 'C'];
% record_type = 'P';
% record_num = 4;
% [file_list_test, label_test] = list_files(path,grid_num,record_type,record_num);
% [features_test,label_concat_test] = features_extract(path, file_list_test, label_test);


%SVM
[prob_m, accuracy] = svm_train(features_train,label_concat);