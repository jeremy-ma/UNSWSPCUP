%SVM
%K-fold Cross validation
function [prob_m, accuracy]=svm_train(X,Y,kfold,store_fig)

rng(1);

%     %SVM
%     t = templateSVM('Standardize',1);
Mdl = fitcecoc(X,Y,'KFold',kfold,'FitPosterior',1);

%     %K-nearest neighbour
%     Mdl = fitcknn(X,Y,'KFold',kfold);

C = zeros(length(Mdl.ClassNames),length(Mdl.ClassNames),kfold);
for i=1:kfold
    TrainMdl = Mdl.Trained{i}; % Extract trained, compact classifier
    testInds = Mdl.Partition.test(i);   % Extract the test indices
    XTest = X(testInds,:);
    YTest = Y(testInds,:);
    [label,~,~,Posterior] = predict(TrainMdl,XTest,'Verbose',1); 
%         [label,score] = predict(TrainMdl,XTest); 

    %calculate confusion matrix
    C(:,:,i) = confusionmat(YTest,label);
    title_text = sprintf('Data Count K=%d run %d',kfold,i);
    plot_confuse_m(C(:,:,i),Mdl.ClassNames,store_fig,title_text);
%         table(YTest,label,score(:,2),'VariableNames',{'TrueLabel','PredictedLabel','Score'})
    t = table(YTest,label,Posterior,'VariableNames',{'TrueLabel','PredLabel','Posterior'});
    writetable(t,fullfile(store_fig,[title_text '.csv']),'Delimiter',',')
end

%probability of confusion matrix
C_tot = sum(C,3);
prob_m = C_tot ./ repmat(sum(C_tot,2),1,length(Mdl.ClassNames));  
title_text = sprintf('Probability K=%d',kfold);
plot_confuse_m(prob_m,Mdl.ClassNames,store_fig,title_text);

accuracy = sum(diag(C_tot)) / sum(Mdl.Partition.TestSize)    


end