function [ ENFSignals ] = getENFSignals( recordings, ENFExtractor )
    ENFSignals(length(recordings)).enf = 0;
    ENFSignals(length(recordings)).gridID = 0;
    ENFSignals(length(recordings)).recordingType = 0;
    %Gets ENF signals
    for ii=1:length(recordings)
        ENFSignals(ii).enf = ENFExtractor(recordings(ii).data,recordings(ii).fs);
        ENFSignals(ii).gridID = recordings(ii).gridID;
        ENFSignals(ii).recordingType = recordings(ii).recordingType;
        disp(recordings(ii).name);
        disp('extracted');
    end
end

