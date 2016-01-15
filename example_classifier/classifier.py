import scipy.io as sio
import numpy as np
import pdb
import helper
from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, VotingClassifier, ExtraTreesClassifier, GradientBoostingClassifier
from sklearn.cross_validation import train_test_split
from sklearn.naive_bayes import GaussianNB
import matplotlib.pyplot as plt
from sklearn.grid_search import GridSearchCV


def evaluate(classifier,trainFeatures,trainLabels,testFeatures,testLabels):
    results = {}
    classifier.fit(trainFeatures, trainLabels)
    onevsAll = trainOneVsAll(trainFeatures, trainLabels)
    predictions = classifier.predict(testFeatures)
    #oneClassSVM =  svm.OneClassSVM(kernel='rbf')
    #oneClassSVM.fit(trainFeatures)

    for i, prediction in enumerate(predictions):
        features = testFeatures[i].reshape(1,-1)
        probabilities = classifier.predict_proba(features)
        #outlier = onevsAll[prediction].predict(features)[0]
        outlier = probabilityVoteOneVsAll(onevsAll,classifier,features)
        #outlier = vidhyaProbabilityOutlier(classifier,features)

        #outlier = oneClassSVM.predict(features)
        if outlier == True:
            predictions[i] = helper.UNKNOWN
            #print "#############################################"
            #print onevsAll[prediction].predict_proba(features)[0]
            #print testLabels[i]
    
    results['predicted'] = predictions
    results['testAccuracy'] = accuracy_score(testLabels, results['predicted'])
    results['classifier'] = classifier
    results['confusion'] = confusion_matrix(testLabels, results['predicted'],[0,1,2,3,4,5,6,7,8,helper.UNKNOWN])
    results['probability'] = classifier.predict_proba(testFeatures)
    try:
        results['trainAccuracy'] = classifier.oob_score_
    except:
        results['trainAccuracy'] = accuracy_score(trainLabels, classifier.predict(trainFeatures))

    return results

def trainOneVsAll(trainFeatures, trainLabels):
    labels = set(trainLabels)
    classifiers = {}
    for label in labels:
        #clf = svm.SVC(kernel='rbf', probability=True, class_weight={False:0.9, True:0.1})
        #clf = svm.SVC(kernel='poly',degree=3,probability=True, class_weight={False:0.9, True:0.1})
        #clf = RandomForestClassifier(n_estimators=1000,class_weight={False:0.9, True:0.01})
        #clf = ExtraTreesClassifier(n_estimators=1000, class_weight='balanced')
        clf = svm.SVC(kernel='rbf', probability=True, class_weight={False:0.9, True:0.1})

        #param_grid=[{'C':[0.1,1,10,100,1000,10000],'gamma': [1.0,0.1,0.01,0.001, 0.0001,0.0001], 'kernel': ['rbf']}],
        binaryLabels = trainLabels != label
        """
        gridSearchClf = GridSearchCV(svm.SVC(kernel='rbf', probability=True),
            param_grid=[{'class_weight':[{False:0.9,True:0.1},'balanced',{False:0.8,True:0.1},{False:8.0/9.0,True:1.0/9.0}],
                         'kernel':['rbf']}], cv=10)
        binaryLabels = trainLabels != label
        gridSearchClf.fit(trainFeatures, binaryLabels)
        print label
        print gridSearchClf.grid_scores_
        print gridSearchClf.best_params_
        print gridSearchClf.best_score_
        classifiers[label] = gridSearchClf.best_estimator_
        """
        clf.fit(trainFeatures, binaryLabels)
        classifiers[label] = clf

    return classifiers

# return true if an outlier
def simpleVoteOneVsAll(classifiers, mainClassifier, features):
    truescore = 0
    falsescore = 0
    probabilities = mainClassifier.predict_proba(features)[0]
    labelToIndex = {label:index for (index, label) in enumerate(mainClassifier.classes_)}
    for label, classifier in classifiers.iteritems():
        if classifier.predict(features)[0] == True:
            truescore += probabilities[labelToIndex[label]]
        else:
            falsescore += probabilities[labelToIndex[label]]

    return truescore > falsescore

# return true if an outlier, incorporate probability into the vote
def probabilityVoteOneVsAll(classifiers, mainClassifier, features):
    truescore = 0
    falsescore = 0
    probabilities = mainClassifier.predict_proba(features)[0]
    labelToIndex = {label:index for (index, label) in enumerate(mainClassifier.classes_)}
    for label, classifier in classifiers.iteritems():
        oneVsAllprobabilities = classifier.predict_proba(features)[0]
        labelToIndexOneVsAll = {label:index for (index,label) in enumerate(classifier.classes_)}
        truescore += probabilities[labelToIndex[label]] * oneVsAllprobabilities[labelToIndexOneVsAll[True]] * 0.1
        falsescore += probabilities[labelToIndex[label]] * oneVsAllprobabilities[labelToIndexOneVsAll[False]] * 0.9

    return truescore > falsescore

def vidhyaProbabilityOutlier(mainClassifier, features):

    probabilities = mainClassifier.predict_proba(features)[0]
    probabilityIn = sum(probabilities) * 0.9
    probabilityOut = 1-probabilityIn

    return probabilityOut > 0.5



def featureImportance(X,y):
    forest = ExtraTreesClassifier(n_estimators=2000,
                              random_state=0)

    forest.fit(X, y)
    importances = forest.feature_importances_
    std = np.std([tree.feature_importances_ for tree in forest.estimators_],
                 axis=0)
    indices = np.argsort(importances)[::-1]

    # Print the feature ranking
    print("Feature ranking:")

    for f in range(X.shape[1]):
        print("%d. feature %d (%f)" % (f + 1, indices[f], importances[indices[f]]))

    # Plot the feature importances of the forest
    plt.figure()
    plt.title("Feature importances")
    plt.bar(range(X.shape[1]), importances[indices],
           color="r", yerr=std[indices], align="center")
    plt.xticks(range(X.shape[1]), indices)
    plt.xlim([-1, X.shape[1]])
    plt.show()


if __name__ == '__main__':
    #trainFeatures,trainLabels,testFeatures,testLabels = helper.randomLoadData('trainTestData.mat')
    trainFeatures, trainLabels, testFeatures, testLabels,_,_ = helper.loadData('trainTestData.mat')

    #pdb.set_trace()
    #min_max_scaler = preprocessing.MinMaxScaler(feature_range=(-100,100))
    #trainFeatures = min_max_scaler.fit_transform(trainFeatures)
    #testFeatures = min_max_scaler.transform(testFeatures)

    #normaliser = preprocessing.StandardScaler()
    #trainFeatures = normaliser.fit_transform(trainFeatures)
    #testFeatures = normaliser.transform(testFeatures)

    print trainFeatures.shape

    #classifier = RandomForestClassifier(n_estimators=2000, oob_score = True, min_samples_split=1)
    #classifier = GradientBoostingClassifier(n_estimators=1000)
    classifier = ExtraTreesClassifier(n_estimators=2000, oob_score=True, bootstrap=True)
    results = evaluate(classifier, trainFeatures,trainLabels,testFeatures,testLabels)
    print results
    print results['testAccuracy'], results['trainAccuracy']

    #pdb.set_trace()
    """
    testUnknownLabels = [label==(ord('N')-ord('A')) for label in testLabels]

    unknownClassifier = RandomForestClassifier(n_estimators=10000, oob_score=True, class_weight='balanced')
    #unknownClassifier = AdaBoostClassifier(n_estimators=1000)
    #unknownClassifier = svm.SVC(kernel='rbf', C=10, probability=True)

    unknownTrainFeatures, unknownTestFeatures, unknownTrainLabels, unknownTestLabels = train_test_split(results['probability'], 
                                                                                        testUnknownLabels, test_size=0.33)
    resultsUnknown = evaluate(unknownClassifier, unknownTrainFeatures, unknownTrainLabels, unknownTestFeatures, unknownTestLabels)
    print resultsUnknown
    rows = resultsUnknown['predicted'] == unknownTestLabels
    print resultsUnknown['probability'][rows]
    """

    #featureImportance(trainFeatures,trainLabels)
    #trainFeatures, trainLabels, testFeatures, testLabels = helper.testUnknown( trainFeatures, trainLabels, testFeatures, testLabels,
    #                                                                            newUnknownLabels=[0])

    #results = evaluate(classifier, trainFeatures,trainLabels,testFeatures,testLabels)

