classdef AbstractMLClass
    
properties
    Mdl
    
    train_data
    valid_data
    
    train_tag   %tag has full information of the file (each row is a seg)
    valid_tag
    
    train_file  %list of files goes into training/validation (same as train_tag, but each row is a file)
    valid_file
    
    train_label     %label only has the grid letter and type (each row is a seg)
    valid_label
    
    valid_label_merge
    

%     pred_label
%     score
    
    mixAP = 0;   %treat audio and power as the same class?
end

methods
    function obj = AbstractML(mixAP)
        if exist('mixAP','var')
            obj.mixAP = mixAP;
        end
    end
    
    % split_data into train/validation/test set
    function obj = split_data(obj,data,train_w)
%         if train_w + valid_w + test_w ~=1
%             error('train, validation & test data splitting weight should add up to 1')
%         end
        
        %select audio / power from a certain grid
%         tab_grid = tabulate(data.label_concat(:,1:2));
        tab_grid_num = tabulate(data.label_concat); %tabulate the grid type+letter+num, vs # of segments from each file
        file_list_grid = char(tab_grid_num(:,1));
        tab_grid_file = tabulate(file_list_grid(:,1:2));    %tabulate the type+letter vs # of files from each grid
        sel_vec = file_list_grid(:,3:end);  %extract file number (ie remove grid type+letter)
        
        %iterate through all grids
        ptr = 1;    %pointer for distinguishing different grids
        train_ind_concat = [];
        for i=1:size(tab_grid_file,1) %iterate from grid A to I 
            ptr_len = cell2mat(tab_grid_file(i,2)); %length of vector to consider
            seg_weight = data.seg_num(ptr:ptr+ptr_len-1);
            grid_sel = sel_vec(ptr:ptr+ptr_len-1,:);  %section of vector to be considered
            
            %sample the data for training sample
            [grid_num,ind] = datasample(grid_sel,round(length(grid_sel)*train_w),'Replace',false,'Weight',seg_weight);
            file_name = char(sort(cellstr([repmat(tab_grid_file{i,1},size(grid_num,1),1) grid_num])));
            
            obj.train_file = [obj.train_file; file_name];   %record a list of file goes into training
            
            x = ismember(cellstr(data.label_concat),file_name);
            train_ind = find(x);
            obj.train_data = [obj.train_data; data.features_norm(train_ind,:)];
            obj.train_tag = [obj.train_tag; data.label_concat(train_ind,:)];
            
            %store the indices transfered
            train_ind_concat = [train_ind_concat; train_ind];
            
            ptr = ptr + ptr_len;
        end
        
        %put all remain data into validation set
        %remaining files
        x = ~ismember(cellstr(data.label_file),cellstr(obj.train_file));
        valid_ind = find(x);
        obj.valid_file = data.label_file(valid_ind,:);
        
        %remaining segments
        remain_ind = setdiff(1:length(data.label_concat),train_ind_concat);
        obj.valid_data = [obj.valid_data; data.features_norm(remain_ind,:)];
        obj.valid_tag = [obj.valid_tag; data.label_concat(remain_ind,:)];
        
        obj = obj.tag2label();
    end
    
    %convert data tag to label
    function obj = tag2label(obj)
        if obj.mixAP
            obj.train_label = obj.train_tag(:,2);
            obj.valid_label = obj.valid_tag(:,2);
%             obj.test_label = obj.test_tag(:,end-2);
        else
            obj.train_label = obj.train_tag(:,1:2);
            obj.valid_label = obj.valid_tag(:,1:2);
%             obj.test_label = obj.test_tag(:,1:end-2);
        end
    end
    
    function obj = training(obj)
        warning('Please implement your own training function')
    end
    
    function obj = testing(obj,test_data)
        warning('Please implement your own testing function')
    end
    
    function [merge_label, conf_prob_merge] = merge_seg(obj,pred_label,score,file_tag)   %file_tag determine the 
        merge_label = [];
        conf_prob_merge = [];
        tab_file_tag = tabulate(file_tag);
%         label_ind = cumsum(cell2mat(tab_file_tag(:,2)));
        for i=1:size(tab_file_tag)
            %find the index where the current file tag with the list of file tag matches
            x = ismember(cellstr(file_tag),repmat(tab_file_tag{i,1},size(file_tag,1),1));
            merge_ind = find(x);
            [result_label, conf_prob] = obj.label_determine(merge_ind,score);
            merge_label = [merge_label; result_label];
            conf_prob_merge = [conf_prob_merge; conf_prob];
        end
        
    end
    
    %determine 1 single label from a all
    function [result_label, conf_prob] = label_determine(obj,ind,score)
        %Input: scores (m x f matrix)
                %ind (m x 1 vector) - which rows to consider in score matrix
        %Output: result_label (scalar)
        %        conf_prob
        score_sum = sum(score(ind,:),1);
        [~,pos] = max(score_sum);
        result_label = obj.Mdl.ClassNames(pos,:);
        conf_prob = max(score_sum) / sum(score_sum);
        
        %implement "None of the above"
%         result_label(conf_prob < 0.6,:) = 'NN'; %some threshold
        if conf_prob < 0.3
            result_label = 'NN';
        end
    end
    
    %calculate confusion matrix
    function confuse(obj,result_label,store_fig,store_text,conf_prob_merge)
        C = confusionmat(obj.valid_file(:,1:2),result_label);
%         title_text = sprintf('Data Count run');
        title_text = store_text;
        label_ax = [obj.Mdl.ClassNames; 'NN'];   %include 'None of the above' in the class
        plot_confuse_m(C,label_ax,store_fig,title_text);
        t = table(obj.valid_file(:,1:2),result_label,conf_prob_merge,'VariableNames',{'TrueLabel','PredLabel','Probability'});
        writetable(t,fullfile(store_fig,[title_text '.csv']),'Delimiter',',')
    end
    
    function obj = feedback(obj)
        warning('Please implement your own training function')
    end
end
   
end