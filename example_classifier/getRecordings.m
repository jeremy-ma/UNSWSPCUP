function recordings = getRecordings(dataDirectory)

    wavFileList = subdir(strcat(dataDirectory,'*.wav'));
    regex = '[a-zA-Z]*_[a-zA-Z]*_([a-zA-Z])_(A|P)[\d]*';
    
    recordings(length(wavFileList)).data = 0;
    recordings(length(wavFileList)).fs = 0;
    recordings(length(wavFileList)).gridID = 0;
    recordings(length(wavFileList)).recordingType = 0;
    disp(wavFileList(1).name)
    %create struct array of recordings
    for i=1:length(wavFileList)
        [y,fs] = audioread(wavFileList(i).name);
        recordings(i).data = y;
        recordings(i).fs = fs;
        [~,name,~] = fileparts(wavFileList(i).name);
        disp(name)
        [tokens, match] = regexp(name, regex,'tokens','match');
        if length(match) ~= 0
            % training file
            recordings(i).gridID = tokens{1}(1);
            recordings(i).recordingType = tokens{1}(2);
        else
            disp('unlabelled wav file read')
            recordings(i).gridID = 'UNKNOWN';
            recordings(i).recordingType = 'UNKNOWN';
        end
    end
    
end