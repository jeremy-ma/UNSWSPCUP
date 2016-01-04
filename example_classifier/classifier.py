import scipy.io as sio
import numpy as np
import pdb
from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier


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

	return results

if __name__ == '__main__':
	trainFeatures,trainLabels,testFeatures,testLabels = loadData('trainTestData.mat')
	#trainFeatures,trainLabels,testFeatures,testLabels  = loadData('AndrewFeatures/trainTestData.mat')
	#trainFeatures2, trainLabels2, testFeatures2, testLabels2 = loadData('AndrewFeatures/trainTestData.mat')
	#pdb.set_trace()

	
	#min_max_scaler = preprocessing.MinMaxScaler(feature_range=(-10,10))
	#trainFeatures = min_max_scaler.fit_transform(trainFeatures)
	#testFeatures = min_max_scaler.transform(testFeatures)
	
	classifier = svm.SVC(kernel='rbf', C=7, probability=True)
	classifier = RandomForestClassifier(n_estimators=1000)

	results = evaluate(classifier, trainFeatures,trainLabels,testFeatures,testLabels)

	print results['probability'][testLabels==13]
	print results['probability'][testLabels==results['predicted']]
	print results['testAccuracy']
	#print results



