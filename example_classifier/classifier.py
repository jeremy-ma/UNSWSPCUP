import scipy.io as sio
import numpy as np
import pdb
from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import train_test_split



def loadData(filename='trainTestData.mat'):
    data = sio.loadmat(filename)
    try:
        trainFeatures = data['trainFeatureVectors']
        testFeatures = data['testFeatureVectors']
    except:
        trainFeatures = data['trainFeatures']
        testFeatures = data['testFeatures']

    trainLabels = data['trainLabels']
    testLabels = data['testLabels']
    trainLabels = trainLabels.reshape(len(trainLabels),)
    testLabels = testLabels.reshape(len(testLabels),)

    return (trainFeatures, trainLabels, testFeatures, testLabels)

def evaluate(classifier,trainFeatures,trainLabels,testFeatures,testLabels):
    results = {}
    classifier.fit(trainFeatures, trainLabels)
    results['predicted'] = classifier.predict(testFeatures)
    results['testAccuracy'] = accuracy_score(testLabels, results['predicted'])
    results['classifier'] = classifier
    results['confusion'] = confusion_matrix(testLabels, results['predicted'])
    results['probability'] = classifier.predict_proba(testFeatures)
    try:
        results['trainAccuracy'] = classifier.oob_score_
    except:
        results['trainAccuracy'] = accuracy_score(trainLabels, classifier.predict(trainFeatures))

    return results

def makeUnknown(label, newUnknownLabels):
    if label in newUnknownLabels:
        return ord('N') - ord('A')
    
    return label

def testUnknown(trainFeatures, trainLabels, testFeatures, testLabels, newUnknownLabels=[0,1]):
    unknownTraining = []
    unknownFeatures = []
    for label in newUnknownLabels:
        rowsToMakeUnknown = [i for i,l in enumerate(trainLabels) if l == label]
        unknownFeatures.append(trainFeatures[rowsToMakeUnknown])
        trainFeatures = np.delete(trainFeatures, rowsToMakeUnknown, axis=0)
        trainLabels = np.delete(trainLabels, rowsToMakeUnknown, axis=0)

    unknownFeatures = np.concatenate(unknownFeatures)
    #pdb.set_trace()
    testFeatures = np.concatenate((testFeatures, unknownFeatures))
    testLabels = list(testLabels)
    testLabels = [makeUnknown(label, newUnknownLabels) for label in testLabels]
    testLabels.extend([ord('N') - ord('A') for _ in xrange(unknownFeatures.shape[0])])
    testLabels = np.array(testLabels)

    return (trainFeatures, trainLabels, testFeatures, testLabels)

if __name__ == '__main__':
    trainFeatures,trainLabels,testFeatures,testLabels = loadData('trainTestData.mat')
    #trainFeatures,trainLabels,testFeatures,testLabels  = loadData('AndrewFeatures/trainTestData.mat')
    #trainFeatures2, trainLabels2, testFeatures2, testLabels2 = loadData('AndrewFeatures/trainTestData.mat')
    #pdb.set_trace()
    #trainFeatures, trainLabels, testFeatures, testLabels = testUnknown(trainFeatures, trainLabels, testFeatures, testLabels,
    #                                                       newUnknownLabels=[0,1])
    
    #pdb.set_trace()
    #min_max_scaler = preprocessing.MinMaxScaler(feature_range=(-10,10))
    #trainFeatures = min_max_scaler.fit_transform(trainFeatures)
    #testFeatures = min_max_scaler.transform(testFeatures)
    print trainFeatures.shape

    classifier = svm.SVC(kernel='rbf', C=7, probability=True)
    classifier = RandomForestClassifier(n_estimators=1000, oob_score = True)

    results = evaluate(classifier, trainFeatures,trainLabels,testFeatures,testLabels)
    print results

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
    classifier.fit(np.concatenate([trainFeatures, testFeatures]), np.concatenate([trainLabels,testLabels]))

    print classifier.oob_score_




