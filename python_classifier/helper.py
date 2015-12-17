import os
import re
import signalClass
import scipy.io.wavfile

def loadData(dataDirectory):
    fileNameRegex = r'[a-zA-Z]*_[a-zA-Z]*_([a-zA-Z])_(A|P)[\d]*.wav'
    matcher = re.compile(fileNameRegex)
    signals = []
    #Loads data in the format provided
    for root, subdirs, files in os.walk(dataDirectory):
        for _file in files:
            if '.wav' in _file:
                result = matcher.match(_file)
                if result is None:
                    print "ERROR: Failed to match a wav file to the expected format"
                else:
                    grid = result.group(1)
                    recordingType = result.group(2)
                    samplerate, data = scipy.io.wavfile.read(os.path.join(root, _file))
                    signal = signalClass.Recording(data,samplerate,recordingType,grid)
                    signals.append(signal)
    return signals



                                    

