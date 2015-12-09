classdef SVMClass < AbstractMLClass
    
methods
    function obj = training(obj,train_data,train_label)
        obj.Mdl = fitcecoc(train_data,train_label,'FitPosterior',1);
    end
    
    function [pred_label,score] = testing(obj, test_data)
        %OUTPUT: (m x n) probability to be at one class
        [pred_label,~,~,Posterior] = predict(obj.Mdl,test_data,'Verbose',1);
        score = Posterior;
    end
    
    function obj = feedback(obj)
        %no parameters has changed
        %TODO
    end
end
    
end