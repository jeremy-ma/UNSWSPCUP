import signalClass
import numpy as np
from scipy import signal
import pdb

def identifyRecordingType(signal):
	pass


def weightedEnergyENFExtractor(recording, nfft, framelength, tolerance):
	assert nfft % 2 == 0
	#pdb.set_trace()
	freqaxis = recording.fs / 2.0 * np.linspace(0.0, 1.0, num=nfft/2)
	#take first half of magnitude spectrum
	magnitude = np.abs(np.fft.fft(recording.data, nfft))[0:(nfft/2 - 1)]

	strength50 = np.sum(np.logical_and(freqaxis>45.0,freqaxis<55.0))
	strength60 = np.sum(np.logical_and(freqaxis>55.0,freqaxis<65.0))

	if strength60 > strength50:
		fnom = 60.0
	else:
		fnom = 50.0

	freqs,times,Sxx = signal.(magnitude, recording.fs, nperseg=framelength, nfft=nfft)

	upperFrequencyLimit = fnom + tolerance
	lowerFrequencyLimit = fnom - tolerance

	upperFrequencyBucket = np.abs(freqs-upperFrequencyLimit).argmin()
	lowerFrequencyBucket = np.abs(freqs-lowerFrequencyLimit).argmin()

	#empty enf vector as long as the spectrogram
	ENF = np.zeros(Sxx.shape[1])

	for n,spectrum in Sxx.T:
		numer = 0.0
		denom = 0.0
		for j in xrange(lowerFrequencyBucket, upperFrequencyBucket + 1):
			numer += spectrum(j) * freqs(j)
			denom += spectrum(j)

	return ENF




