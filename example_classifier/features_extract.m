%input: file_list = list of .wav file names, 
%       label = if label is input, assume it's training set
%output:features 
%       label (if its training)

function [features,label_concat] = features_extract(path, file_list, label, frame_size, overlap, nfft, seg_size)

if ~exist('frame_size','var')
    frame_size = 5;
end
if ~exist('overlap','var')
    overlap = 0;
end
if ~exist('nfft','var')
    nfft = 2^14;
end
if ~exist('seg_size','var')
    seg_size = 96;
end

%ENF extraction from each file
label_concat = [];
features = [];

for n=1:length(file_list)
    
    [y,fs] = load_file(path, char(file_list(n)));
    
    %spectrogram
%     frame_size = 5; %seconds
    framelength = frame_size * fs;
%     overlap = 0;
%     nfft = 2^14;
    [enf, time] = extractenf(y, fs, framelength, overlap, nfft);

    %reshape enf in segment
%     seg_size = 96; % number of samples consider as 1 segment
    enf = enf(1: length(enf) - mod(length(enf),seg_size));
    enf_reshape = reshape(enf,[],seg_size);
    
    features = feature_extract(features, enf_reshape, seg_size);
    
    if nargin == 3
        % create label vector
        label_vec = repmat(label(n),size(enf_reshape,1),1);
        label_concat = [label_concat; label_vec];
    end
end

% features = [mean_concat range_concat wt_var ar_para ar_err];

end