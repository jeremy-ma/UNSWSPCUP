function [norm_train,grad,intercept] = feature_norm(train_data)

%normalise vector to [-100,100]
max_fea = max(train_data, [], 1);
min_fea = min(train_data, [], 1);

grad = 200 ./ repmat(max_fea-min_fea,size(train_data,1),1);
intercept = -grad .* repmat(min_fea,size(train_data,1),1) -100;
norm_train = grad .* train_data + intercept;

end