import scipy.io as sio
import numpy as np
import pdb
from sklearn import svm
from sklearn.metrics import accuracy_score
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier

def loadData(filename='trainTestData.mat'):
	data = sio.loadmat(filename)
	trainFeatures = data['trainFeatureVectors']
	testFeatures = data['testFeatureVectors']
	trainLabels = data['trainLabels']
	testLabels = data['testLabels']
	trainLabels = trainLabels.reshape(len(trainLabels),)
	testLabels = testLabels.reshape(len(testLabels),)

	return (trainFeatures, trainLabels, testFeatures, testLabels)

if __name__ == '__main__':
	trainFeatures,trainLabels,testFeatures,testLabels = loadData()
	#trainFeatures2, trainLabels2, testFeatures2, testLabels2 = loadData('AndrewFeatures/trainTestData.mat')
	#pdb.set_trace()

	"""
	min_max_scaler = preprocessing.MinMaxScaler(feature_range=(-100,100))
	trainFeatures = min_max_scaler.fit_transform(trainFeatures)
	testFeatures = min_max_scaler.transform(testFeatures)
	"""
	classifier = svm.SVC(kernel='rbf', C=1)
	classifier.fit(trainFeatures, trainLabels)
	predicted = classifier.predict(testFeatures)
	print len(predicted)
	print testLabels
	#pdb.set_trace()
	print accuracy_score(testLabels,predicted)




