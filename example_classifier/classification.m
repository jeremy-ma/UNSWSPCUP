%Input: algo - cell array of classification algorithms
%       store - array of texts (same length as algo) which helps when storing figures
function classification(algo,store_text,train_data,train_w,valid_w,test_data,store_fig)

%     algo = {@SVMClass @SVMClass};
    trials = 1; %number of runs and tunes before testing it on actual test data

    for i=1:length(algo)
        func_handle = algo{i};
        MdlObj = func_handle();
        
        for j=1:trials
            MdlObj = MdlObj.split_data(train_data,train_w,valid_w);
            MdlObj = MdlObj.training(MdlObj.train_data, MdlObj.train_label);
            [pred_label,score] = MdlObj.testing(MdlObj.valid_data);
            [merge_label, conf_prob_merge] = MdlObj.merge_seg(pred_label, score, MdlObj.valid_tag);
            MdlObj.confuse(merge_label,store_fig,store_text{i},conf_prob_merge);
            MdlObj = MdlObj.feedback();
        end
            
        %apply on actual testing data
        MdlObj = MdlObj.training(train_data.features_norm,train_data.label_concat(:,1:2));
        [pred_label,score] = MdlObj.testing(test_data.features_norm);
        [merge_label, conf_prob_merge] = MdlObj.merge_seg(pred_label,score,test_data.label_file);
        store_label = merge_label(:,2)'
        save(fullfile(store_fig,'SVM.mat'),'store_label');%store predicted label of the test data into a file
    end
end