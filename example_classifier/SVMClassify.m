function [ predicted, accuracy, probabilities ] = SVMClassify(trainFeatures, trainLabels, testFeatures, testLabels)
    minimums = min(trainFeatures, [], 1);
    ranges = max(trainFeatures, [], 1) - minimums;
    
    trainFeatures = (trainFeatures - repmat(minimums, size(trainFeatures, 1), 1)) ./ repmat(ranges, size(trainFeatures, 1), 1);
    testFeatures = (testFeatures - repmat(minimums, size(testFeatures, 1), 1)) ./ repmat(ranges, size(testFeatures, 1), 1);

    model = svmtrain( trainLabels,trainFeatures,'-c 1 -g 0.07');
    [predicted, accuracy, probabilities] = svmpredict(testLabels,testFeatures,model);

end

