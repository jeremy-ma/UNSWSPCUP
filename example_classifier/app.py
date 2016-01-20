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
from collections import Counter
import re



def writeResults(results, testFiles,outputFile='results.txt'):
    #sort test files based on number
    regex = re.compile(r'[a-zA-Z]+_(?P<filenum>\d+)\.{0,1}\w*')

    allResults = {}
    simpleResults = {}
    tableResults = {}
    with open(outputFile,'wb') as fi:
        for i, label in enumerate(results['predicted']):
            filename = testFiles[i]
            match = regex.match(filename)
            filenum = int(match.group('filenum'))
            predictedLabelChar = chr(label + ord('A'))
            if predictedLabelChar != 'N':
                #include probability
                probability = results['probability'][i][label]
                assert probability == np.max(results['probability'][i])
                assert label == np.argmax(results['probability'][i])
            else:
                probability = 'N/A'

            allResults[filenum] = "Test{0} {1} Confidence:{2}\n".format(filenum, predictedLabelChar, probability)
            simpleResults[filenum] = predictedLabelChar
            tableResults[filenum] = "Test{0} & {1} & {2} \\\\\n".format(filenum, predictedLabelChar, probability)

        toWrite = sorted(list(allResults.iteritems()))
        for num, rowStr in toWrite:
            fi.write(rowStr)

    with open('Simple'+outputFile,'wb') as fi:
        toWrite = sorted(list(simpleResults.iteritems()))
        outputString = ''
        for _, label in toWrite:
            outputString += label
        fi.write(outputString)



if __name__=='__main__':

    trainFeatures, trainLabels, testFeatures, testLabels,trainFiles,testFiles = helper.loadData('trainTestDataTEST.mat')

    print "Loaded Files...."
    testFiles = [x[0] for x in testFiles[0]]
    clf = ExtraTreesClassifier(n_estimators=2000,bootstrap=False,random_state=3)

    print "Training Classifier..."

    results = classifier.evaluate(clf, trainFeatures,trainLabels,testFeatures,testLabels)

    sortedResults = sorted(zip(testFiles,results['predicted']))


    print "Outputting Predictions..."
    print sortedResults
    print sorted(results['predicted'])

    counts= Counter(sorted(results['predicted']))
    print ['G{0}:{1}'.format(grid,count) for grid, count in counts.iteritems()]

    print "Writing Results to Results.txt"
    writeResults(results,testFiles,'Results.txt')

    #['G0:9', 'G1:12', 'G2:7', 'G3:8', 'G4:9', 'G5:7', 'G6:9', 'G7:9', 'G8:14', 'G13:16']