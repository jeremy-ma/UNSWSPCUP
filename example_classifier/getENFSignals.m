function [ ENFSignals ] = getENFSignals( recordings, ENFExtractorPower, ENFExtractorAudio, powerAudioClassifier)
    ENFSignals(length(recordings)).enf = 0;
    ENFSignals(length(recordings)).gridID = 0;
    ENFSignals(length(recordings)).recordingType = 0;
    ENFSignals(length(recordings)).name = 0;
    %Gets ENF signals
    for ii=1:length(recordings)
        ENFSignals(ii).name = recordings(ii).name;
        if strcmp(ENFSignals(ii).recordingType,'UNKNOWN') == 0
            ENFSignals(ii).recordingType = powerAudioClassifier(recordings(ii).data, recordings(ii).fs);
        end
        
        if strcmp(ENFSignals(ii).recordingType,'POWER') == 0
            ENFSignals(ii).enf = ENFExtractorPower(recordings(ii).data,recordings(ii).fs);
        elseif strcmp(ENFSignals(ii).recordingType,'AUDIO') == 0
            ENFSignals(ii).enf = ENFExtractorAudio(recordings(ii).data,recordings(ii).fs);
        else
            fprintf('recording %s could not be identified, using audio extractor\n', recordings(ii).name);
            ENFSignals(ii).enf = ENFExtractorAudio(recordings(ii).data,recordings(ii).fs);
        end
        ENFSignals(ii).gridID = recordings(ii).gridID;
        disp(recordings(ii).name);
        disp('extracted');
    end
end

