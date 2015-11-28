classdef FeaturesNormClass
    
properties
    grad
    intercept

end

methods
    function obj = FeaturesNormClass(train_data,weight)
        
        %check the size of weight vector
        diff_size = size(train_data,2) - length(weight);
        if diff_size>0
            warning('weight of the last %d featues are undefined, default to 1', diff_size)
            weight = [weight ones(1,diff_size)];
        elseif diff_size<0
            warning('last %d numbers of weight has no features to assign to', -diff_size)
            weight = weight(1:end+diff_size);
        end
            
        max_fea = max(train_data, [], 1);
        min_fea = min(train_data, [], 1);
        
        scale = 100 * weight;
        
        obj.grad = 2*scale ./ (max_fea-min_fea);
        obj.intercept = -obj.grad .* min_fea - scale;
    end
    
    %scale the testing data
    function norm_data = scaletest(obj,data)
        norm_data = repmat(obj.grad,size(data,1),1) .* data + repmat(obj.intercept,size(data,1),1);
    end
end

end