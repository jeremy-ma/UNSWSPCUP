%SVM
% 15% data is held up for testing
function svm_train(train_data,Y,test_data,Y_test)
%Y_test exsit only if we know the ground truth of testing data
    
    %normalise vector to [-100,100]
    max_fea = max(train_data, [], 1);
    min_fea = min(train_data, [], 1);
    X = 200 ./ repmat(max_fea-min_fea,length(Y),1) .* (train_data - repmat(min_fea,length(Y),1)) - 100;
    
    t = templateSVM('Standardize',1);
    Mdl = fitcecoc(X,Y,'Holdout',0.15,'Learners',t,'FitPosterior',1);
    CompactSVMModel = Mdl.Trained{1}; % Extract trained, compact classifier
    testInds = test(Mdl.Partition);   % Extract the test indices
    XTest = X(testInds,:);
    YTest = Y(testInds,:);
%     [label,~,~,Posterior] = predict(CompactSVMModel,XTest,'Verbose',1);
%     table(YTest,label,Posterior,'VariableNames',{'TrueLabel','PredLabel','Posterior'})
    [label,score] = predict(CompactSVMModel,XTest);
    table(YTest,label,score(:,2),'VariableNames',{'TrueLabel','PredictedLabel','Score'})
    
%     CVSVMModel = fitcsvm(X,Y,'Holdout',0.15,'Standardize',true);
%     rng(1);
%     CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
%     testInds = test(CVSVMModel.Partition);   % Extract the test indices
%     XTest = X(testInds,:);
%     YTest = Y(testInds,:);
%     [label,score] = predict(CompactSVMModel,XTest);
%     table(YTest,label,score(:,2),'VariableNames',{'TrueLabel','PredictedLabel','Score'})
% %     [label,score] = resubPredict(SVMModel);

end