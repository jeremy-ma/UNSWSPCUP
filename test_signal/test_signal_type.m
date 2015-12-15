% Use this code to test signal_type function against existing data
% Put all the data in the one folder and make sure it's of the format
% [Train_Grid_A_P1]

close all;
clear all;
clc;

path_to_your_data = '../data';


listing = dir(path_to_your_data); % I just put all the data in one folder
listing = listing(3:end); % Get rid of . and ..
fs = 1000
audio = [];
power = [];

numTrials = 0;
numCorrect = 0;
wrongGrid = []

% Find the average power in the files
for file = listing'
    y = audioread(strcat(path_to_your_data, file.name));
    
    buf = strsplit(file.name, '_');  % e.g. buf = {Train Grid A P1}
    type = buf{4}(1);                % Just get the P/A 
    result = signal_type(y, fs);
    if type == result
        numCorrect = numCorrect + 1;
    else
        wrongGrid = [wrongGrid file]
    end
    numTrials = numTrials + 1;
end

fprintf('Accuracy = %f\n', numCorrect/numTrials);