import scipy.io as sio
import numpy as np
import pdb
from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, VotingClassifier
from sklearn.cross_validation import train_test_split
from sklearn.naive_bayes import GaussianNB
from collections import defaultdict
import random


UNKNOWN = ord('N') - ord('A')

def loadData(filename='trainTestData.mat'):
    data = sio.loadmat(filename)
    try:
        trainFeatures = data['trainFeatureVectors']
        testFeatures = data['testFeatureVectors']
    except:
        trainFeatures = data['trainFeatures']
        testFeatures = data['testFeatures']

    trainLabels = np.ravel(data['trainLabels'])
    testLabels = np.ravel(data['testLabels'])
    try:
        trainFiles = data['trainFileNames']
        testFiles = data['testFileNames']
        trainLabels = trainLabels.reshape(len(trainLabels),)
        testLabels = testLabels.reshape(len(testLabels),)
    except:
        trainFiles = []
        testFiles = []

    return (trainFeatures, trainLabels, testFeatures, testLabels, trainFiles, testFiles)



def makeUnknown(label, newUnknownLabels):
    if label in newUnknownLabels:
        return UNKNOWN
    
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
    testFeatures = np.concatenate((testFeatures, unknownFeatures))
    testLabels = list(testLabels)
    testLabels = [makeUnknown(label, newUnknownLabels) for label in testLabels]
    testLabels.extend([UNKNOWN for _ in xrange(unknownFeatures.shape[0])])
    testLabels = np.array(testLabels)

    return (trainFeatures, trainLabels, testFeatures, testLabels)

def shuffle(allFeatures, allLabels, allFiles, testratio):
    #pdb.set_trace()
    fileRowDict = defaultdict(list)
    for i, filename in enumerate(allFiles):
        fileRowDict[filename].append((allFeatures[i],allLabels[i]))
    filelist = fileRowDict.keys()
    random.shuffle(filelist)
    numTest = int(len(filelist) * testratio)

    trainFeatures = []
    trainLabels = []
    testFeatures = []
    testLabels = []
    for i, filename in enumerate(filelist):
        for feature,label in fileRowDict[filename]:
            if i < numTest:
                testFeatures.append(feature)
                testLabels.append(label)
            else:
                trainFeatures.append(feature)
                trainLabels.append(label)

    return np.array(trainFeatures), np.array(trainLabels), np.array(testFeatures), np.array(testLabels)

def randomLoadData(filename='trainTestData.mat', testRatio=0.2):
    trainFeatures, trainLabels, testFeatures, testLabels, trainFiles, testFiles = loadData('trainTestData.mat')
    #decompose weird cell array format
    
    trainFiles = [obj[0] for obj in trainFiles[0]]
    testFiles = [obj[0] for obj in testFiles[0]]
    unknownIndices = [i for i,label in enumerate(testLabels) if label == UNKNOWN]
    unknownFeatures = testFeatures[unknownIndices]
    unknownLabels = testLabels[unknownIndices]
    testFeatures = np.delete(testFeatures,unknownIndices,axis=0)
    testLabels = np.delete(testLabels,unknownIndices)
    testFiles = [filename for i,filename in enumerate(testFiles) if i in unknownIndices]



    trainFeatures,trainLabels, testFeatures,testLabels = shuffle(np.concatenate([trainFeatures,testFeatures]),
                                                                 np.concatenate([trainLabels,testLabels]),
                                                                 trainFiles + testFiles, testRatio)

    testFeatures = np.concatenate([testFeatures,unknownFeatures])
    testLabels = np.concatenate([testLabels,unknownLabels])
    return (trainFeatures,trainLabels,testFeatures,testLabels)

