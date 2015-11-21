%SVM
% 15% data is held up for testing
function svm_train(train_data,Y,test_data,Y_test)
%Y_test exsit only if we know the ground truth of testing data
    
    %normalise vector to [-100,100]
    max_fea = max(train_data, [], 1);
    min_fea = min(train_data, [], 1);
    X = 200 ./ repmat(max_fea-min_fea,length(Y),1) .* (train_data - repmat(min_fea,length(Y),1)) - 100;
    
    %split into 6 groups
    
    t = templateSVM('Standardize',1);
    Mdl = fitcecoc(X,Y,'Holdout',0.15,'Learners',t,'FitPosterior',1);
    CompactSVMModel = Mdl.Trained{1}; % Extract trained, compact classifier
    testInds = test(Mdl.Partition);   % Extract the test indices
    XTest = X(testInds,:);
    YTest = Y(testInds,:);
    [label,~,~,Posterior] = predict(CompactSVMModel,XTest,'Verbose',1);
    table(YTest,label,Posterior,'VariableNames',{'TrueLabel','PredLabel','Posterior'})
%     [label,score] = predict(CompactSVMModel,XTest);
%     table(YTest,label,score(:,2),'VariableNames',{'TrueLabel','PredictedLabel','Score'})
    
%     CVSVMModel = fitcsvm(X,Y,'Holdout',0.15,'Standardize',true);
%     CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
%     testInds = test(CVSVMModel.Partition);   % Extract the test indices
%     XTest = X(testInds,:);
%     YTest = Y(testInds,:);
%     [label,score] = predict(CompactSVMModel,XTest);
%     table(YTest,label,score(:,2),'VariableNames',{'TrueLabel','PredictedLabel','Score'})
% %     [label,score] = resubPredict(SVMModel);

%Calculate probability of sucess
%convert grid letter to number
classname_num = zeros(length(YTest),1);    
label_num = zeros(length(YTest),1);  
for i=1:length(Mdl.ClassNames)
    classname_num(Mdl.ClassNames(i)==YTest)=i;
    label_num(Mdl.ClassNames(i)==label)=i;
end

%record prediction frequency into a matrix
record_m = zeros(length(Mdl.ClassNames));
for i=1:length(classname_num)
    record_m(classname_num(i),label_num(i)) = record_m(classname_num(i),label_num(i)) +1;
end

prob_m = record_m ./ repmat(sum(record_m,2),1,length(Mdl.ClassNames));
accuracy = sum(diag(record_m)) / length(YTest);

end