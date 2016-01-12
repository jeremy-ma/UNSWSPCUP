__author__ = 'jeremyma'
import scipy.io as sio
import numpy as np
import pdb
import helper
import classifier
from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, VotingClassifier, ExtraTreesClassifier, GradientBoostingClassifier
from sklearn.cross_validation import train_test_split
from sklearn.naive_bayes import GaussianNB
import matplotlib.pyplot as plt


if __name__=='__main__':

    trainFeatures, trainLabels, testFeatures, testLabels,trainFiles,testFiles = helper.loadData('trainTestDataTEST.mat')
    testFiles = [x[0] for x in testFiles[0]]
    clf = ExtraTreesClassifier(n_estimators=2000, oob_score=True, bootstrap=True)
    results = classifier.evaluate(clf, trainFeatures,trainLabels,testFeatures,testLabels)

    print results['predicted']
    print testFiles

    sortedResults = sorted(zip(results['predicted'],testFiles))
    print sortedResults
    print sorted(results['predicted'])