import scipy.io as sio
import numpy as np
import pdb
from sklearn import svm
from sklearn.metrics import accuracy_score

def loadData():
	data = sio.loadmat('trainTestData.mat')
	trainFeatures = data['trainFeatureVectors']
	testFeatures = data['testFeatureVectors']
	trainLabels = data['trainLabels']
	testLabels = data['testLabels']
	trainLabels = trainLabels.reshape(len(trainLabels),)
	testLabels = testLabels.reshape(len(testLabels),)

	return (trainFeatures, trainLabels, testFeatures, testLabels)

if __name__ == '__main__':
	trainFeatures,trainLabels,testFeatures,testLabels = loadData()
	classifier = svm.SVC(kernel='linear')
	classifier.fit(trainFeatures, trainLabels)
	predicted = classifier.predict(testFeatures)
	print predicted
	print testLabels
	#pdb.set_trace()
	print accuracy_score(testLabels,predicted)




