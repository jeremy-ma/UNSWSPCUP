close all;
clear all;
clc;

listing = dir('../data/'); % I just put all the data in one folder
listing = listing(3:end); % Get rid of . and ..
fs = 1000
audio = [];
power = [];

% Find the average power in the files
for file = listing'
    y = audioread(strcat('../data/', file.name));
    % y = y(1:1024);                   % Just first 1000 will do
    % feature = sum(y.^2)/length(y);
    % feature  = std(y);
    % feature  = max(abs(fft(y)));
    feature = signal_type_x(y, fs);
    
    buf = strsplit(file.name, '_');  % e.g. buf = {Train Grid A P1}
    type = buf{4}(1);                % Just get the P/A 
    if type == 'A'
        audio = [audio feature];
    elseif type == 'P'
        power = [power feature];
    end
end

plot(power, 'ro')
hold on
plot(audio, 'bx')
legend('power','audio')