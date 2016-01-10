import scipy.io as sio
import numpy as np
import pdb
from sklearn import svm
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn import preprocessing
from sklearn.ensemble import AdaBoostClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier

from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis

def loadData(filename='trainTestData.mat'):
	data = sio.loadmat(filename)
	try:
		trainFeatures = data['trainFeatures_norm']
		testFeatures = data['testFeatures_norm']
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
	classifier = classifier.fit(trainFeatures, trainLabels)
	results['predicted'] = classifier.predict(testFeatures)
	results['testAccuracy'] = accuracy_score(testLabels, results['predicted'])
	results['classifier'] = classifier
	results['confusion'] = confusion_matrix(testLabels, results['predicted'])
	results['probability'] = classifier.predict_proba(testFeatures)

	return results

def evaluate_oneclass(classifier,trainFeatures,trainLabels,testFeatures,testLabels):
	results = {}
	classifier = classifier.fit(trainFeatures)
	results['predicted'] = classifier.predict(testFeatures)
	results['testAccuracy'] = accuracy_score(testLabels, results['predicted'])
	results['classifier'] = classifier
	results['confusion'] = confusion_matrix(testLabels, results['predicted'])
	results['distance'] = classifier.decision_function(testFeatures)
	# pdb.set_trace()
	# results['probability'] = classifier.predict_proba(testFeatures)

	return results

#translate multiclass labels into binary class (1 or -1) for one-vs-all
def label2binary(labels,grid_num):
	labels_binary = labels.copy()
	labels_binary.dtype = 'int8'
	for i in range(0,len(labels_binary)):
		# pdb.set_trace()
		if labels_binary[i] == grid_num:
			labels_binary[i] = 1
		else:
			labels_binary[i] = -1
	return labels_binary

if __name__ == '__main__':

	#classification for known grids
	trainFeatures,trainLabels,testFeatures,testLabels= loadData('trainTestData.mat')
	classifier = RandomForestClassifier(n_estimators=1000)
	results_known = evaluate(classifier, trainFeatures,trainLabels,testFeatures,testLabels)
	# print results_known['confusion']

	trainFeatures,trainLabels,testFeatures,testLabels= loadData('trainTestData_norm.mat')
	# pdb.set_trace()

	#one-vs-all 9 times
	for gamma_val in [1]:
		for nu_val in [1]:
			predicted_array = np.empty([9,len(testLabels)])
			print nu_val, gamma_val
			for i in range(0,9):
				#trim down training data to one class
				trainFeatures_one = trainFeatures[trainLabels==i]

				testLabels_binary = label2binary(testLabels,i)
				# pdb.set_trace()

				# classifier = svm.OneClassSVM(nu=nu_val,kernel="sigmoid",gamma=gamma_val)	#92%, normalised
				classifier = svm.OneClassSVM(nu=0.1,kernel="poly",degree=3, gamma=0.1)	#nu<=0.1, gamma<=0.1
				# classifier = svm.OneClassSVM(nu=0.1, kernel="rbf", gamma=0.01)	#83%, 
				# classifier = svm.OneClassSVM(nu=nu_val,kernel="rbf",gamma=gamma_val) # norm nu=1e-3,gamma=1e-5

				results = evaluate_oneclass(classifier, trainFeatures_one,trainLabels,testFeatures,testLabels_binary)
				predicted_array[i] = results['predicted']
			
			# print predicted_array
			testLabels_unknown = -label2binary(testLabels,13)		#label unknown as -1, the rest as 1
			# pdb.set_trace()
			# print predicted_array.max(0)[testLabels==13]
			predicted_binary = predicted_array.max(0)
			confusion_binary = confusion_matrix(testLabels_unknown, predicted_binary)
			testAccuracy_binary = accuracy_score(testLabels_unknown, predicted_binary)
			print confusion_binary, testAccuracy_binary
			
			#combine both parts
			predicted_combine = results_known['predicted'].copy()
			# pdb.set_trace()
			predicted_combine[predicted_binary==-1] = 13
			confusion_combine = confusion_matrix(testLabels, predicted_combine)
			testAccuracy_combine = accuracy_score(testLabels, predicted_combine)
			
			print confusion_combine, testAccuracy_combine
