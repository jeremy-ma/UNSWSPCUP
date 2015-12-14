function [ featureMatrix, gridLabels, recordingTypes ] = segmentENFAndExtractFeatures(ENFSignals, featureExtractors, segmentSize)

featureMatrix = [];
gridLabels = [];
recordingTypes = [];

for ii=1:length(ENFSignals)
    for jj=1:segmentSize:length(ENFSignals(ii).enf)
        if (jj+segmentSize-1) > length(ENFSignals(ii).enf)
            segment = ENFSignals(ii).enf(jj:end);
        else
            segment = ENFSignals(ii).enf(jj:(jj+segmentSize - 1));
        end
        
        featureVector = [];
        for kk=1:length(featureExtractors)
            extractor = featureExtractors{kk};
            feature = extractor(segment);
            featureVector = [featureVector feature];
        end
            
        featureMatrix = [featureMatrix; featureVector];
        gridLabels = [gridLabels; ENFSignals(ii).gridID];
        recordingTypes = [recordingTypes; ENFSignals(ii).recordingType];
    end
end

end

