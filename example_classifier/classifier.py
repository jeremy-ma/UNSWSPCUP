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
from sklearn.cross_validation import train_test_split, cross_val_score
from sklearn.naive_bayes import GaussianNB
import matplotlib.pyplot as plt
from sklearn.grid_search import GridSearchCV
from sklearn.cross_validation import StratifiedKFold
from matplotlib.backends.backend_pdf import PdfPages

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
    cvScores = cross_val_score(classifier, trainFeatures, trainLabels, cv=10)
    results['CV_Accuracy_Stdev'] = (cvScores.mean(),cvScores.std())
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



def featureImportance():
    trainFeatures, trainLabels, testFeatures, testLabels,_,_ = helper.loadData('trainTestData.mat')
    X = trainFeatures
    y = trainLabels
    forest = ExtraTreesClassifier(n_estimators=2000,
                              random_state=0)

    indexToENFFeatureNum = {x:"{0}-{1}".format(x/11+1,x%11+1) for x in xrange(88)}
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
    axis_font = {'fontname':'Arial', 'size':'16'}
    plt.xlabel("(ENF Signal)-(Feature Index)")
    plt.ylabel("Relative Feature Importance")

    plt.bar(range(10), importances[indices[0:10]],
           color="r", yerr=std[indices[0:10]], align="center")
    indices = [indexToENFFeatureNum[i] for i in indices[0:10]]
    plt.xticks(range(10), indices[0:10])
    plt.xlim([-1, 10])
    #plt.show()
    plt.savefig('feature_importance.eps')
    #pp = PdfPages('featureImportance.pdf')
    #pp.savefig(plt)

def parameterSearch():
    trainFeatures, trainLabels, testFeatures, testLabels,_,_ = helper.loadData('trainTestData.mat')


    for i in xrange(10):
        clf = GridSearchCV(ExtraTreesClassifier(n_estimators=1000),
                           param_grid={'bootstrap':[False],'min_samples_split':[1,2,3,4,5]}, cv=10)
        clf.fit(trainFeatures,trainLabels)

        print clf.best_params_
        print clf.best_score_
        print clf.grid_scores_

def testENFChoices():
    enfchoices = [[0],[0,1,2,3],[4],[4,5,6,7],[0,4],[0,1,2,3,4,5,6,7]]

    testAccuracies = [0 for i in xrange(len(enfchoices))]
    for j in xrange(len(enfchoices)):
        trainFeatures, trainLabels, testFeatures, testLabels,_,_ = helper.loadData('trainTestData.mat')
        enfsignals = enfchoices[j]
        enfsignals = [index for x in enfsignals for index in range(x*11,x*11+11)]
        trainFeatures = trainFeatures[:,enfsignals]
        testFeatures = testFeatures[:,enfsignals]

        print trainFeatures.shape

        print "Training classifier..."
        #classifier = RandomForestClassifier(n_estimators=2000, oob_score=True, n_jobs=-1)
        classifier = ExtraTreesClassifier(n_estimators=2000)
        results = evaluate(classifier, trainFeatures,trainLabels,testFeatures,testLabels)
        print results
        testAccuracies[j] = results['testAccuracy']


    print testAccuracies

def testPracticeSet():
    trainFeatures, trainLabels, testFeatures, testLabels,_,_ = helper.loadData('trainTestData.mat')
    classifier = ExtraTreesClassifier(n_estimators=2000, random_state=3)
    results = evaluate(classifier,trainFeatures,trainLabels,testFeatures,testLabels)
    print results

if __name__ == '__main__':
    #testPracticeSet()
    featureImportance()