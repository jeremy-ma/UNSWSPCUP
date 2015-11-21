%input: file_list = list of .wav file names, 
%       label = if label is input, assume it's training set
%output:features 
%       label (if its training)

function [features,label_concat] = features_extract(path, file_list, label)

%ENF extraction from each file
mean_concat = [];
range_concat = [];
wt_var = [];
ar_para = [];
ar_err = [];
label_concat = [];

for n=1:length(file_list)
    
    [y,fs] = load_file(path, char(file_list(n)));
    
    %spectrogram
    frame_size = 5; %seconds
    framelength = frame_size * fs;
    overlap = 0;
    nfft = 2^14;
    [enf, time] = extractenf(y, fs, framelength, overlap, nfft);

    %reshape enf in segment
    seg_size = 96; % number of samples consider as 1 segment
    enf = enf(1: length(enf) - mod(length(enf),seg_size));
    enf_reshape = reshape(enf,[],seg_size);
    
    %FEATURE EXTRACTION
    
    %(Index 1)find mean ENF of the signal over time
    [mean_enf, mean_concat] = find_mean(enf_reshape, mean_concat);
    
    %offset to 0
    enf_off = (enf_reshape - repmat(mean_enf,1,seg_size))'; 
    
    %(Index 2)find log(range) of ENF
    range_concat = find_range(enf_reshape, range_concat);

    %(Index 3-7) variance after wavlet decomposition
    wt_var = find_wt_var(enf_off, wt_var);
    
    %(Index 8-10) AR parameters, error variance
    [ar_para,ar_err] = find_ar(enf_off, ar_para, ar_err);
   
    if nargin == 3
        % create label vector
        label_vec = repmat(label(n),length(mean_enf),1);
        label_concat = [label_concat; label_vec];
    end
end

% features = [mean_concat range_concat ar_para];
features = [mean_concat range_concat wt_var ar_para ar_err];

end