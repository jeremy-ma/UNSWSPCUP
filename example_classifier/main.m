%declare variables

%locate the file for training 
orig_dir = fullfile('..','..','Training_Data150901');
path = fullfile('..','..','data');
store_fig = fullfile('..','..','figures');

grid_num = 'AC';
record_type = 'P';
record_num = 'all';

kfold = 5;

%%
change_dir(orig_dir, path, store_fig);

[file_list_train, label_train] = list_files(path,grid_num,record_type,record_num);
[features_train,label_concat] = features_extract(path, file_list_train, label_train);

[norm_train,grad,intercept] = feature_norm(features_train);

%SVM
[prob_m, accuracy] = svm_train(norm_train,label_concat,kfold,store_fig);