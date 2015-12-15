function [recordingType] = signal_type(y, fs)
% Determines whether a given signal is of type Audio or Power
%   y : a 1d array
%   recordingType : returns 'P' if power, 'U' if unknown, 'A' if audio
%   created by Adrian Muljadi

    % Take the first 1000 samples
    y = y(1:1024);                   % Just first 1000 will do
    power = sum(y.^2)/length(y);
    %recordingType = 'UNKNOWN';
    if power > 0.05
        recordingType = 'POWER';
    else
        recordingType = 'AUDIO';
    end

end
