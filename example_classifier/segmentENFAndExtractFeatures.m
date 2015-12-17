function [ featureMatrix, featureLabels, gridLabels, recordingTypes, fileNames ] = segmentENFAndExtractFeatures(ENFSignals, featureExtractors, segmentSize)

featureMatrix = [];
featureLabels = [];
gridLabels = [];
recordingTypes = [];
fileNames = {};
for ii=1:length(ENFSignals)
    for jj=1:segmentSize:length(ENFSignals(ii).enf)
        if (jj+segmentSize-1) > length(ENFSignals(ii).enf)
            %discard segments which are too short
            continue;
            %segment = ENFSignals(ii).enf(jj:end);
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
        
        if length(ENFSignals(ii).gridID) == 1
            featureLabels = [featureLabels; double(ENFSignals(ii).gridID{1})-double('A')];
        else
            featureLabels = [featureLabels; double(ENFSignals(ii).gridID(1))-double('A')];
        end
        gridLabels = [gridLabels; ENFSignals(ii).gridID];
        recordingTypes = [recordingTypes; ENFSignals(ii).recordingType];
        fileNames = {fileNames; ENFSignals(ii).name};
    end
end

end

