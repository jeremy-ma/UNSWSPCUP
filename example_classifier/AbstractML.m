classdef AbstractML
    
properties
    
end

methods
    function obj = AbstractML()
        
    end
    
    % split_data into train/validation/test set
    function obj = split_data(obj,data,file_tab,train_w,valid_w,test_w)
        if train_w + valid_w + test_w ~=1
            error('train, validation & test data splitting weight should add up to 1')
        end
        
        %select power / audio from a certain grid
        tab_grid = tabulate(data.label_concat(:,1:2));
        tab_gridnum = tabulate(data.label_concat);
        for i=1:size(tab_grid,1)
            
        end
    end
    
    function obj = training()
        
    end
    
    function obj = testing()
        
    end
    
    function obj = confuse()
        
    end
end
    
end