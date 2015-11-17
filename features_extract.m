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
    
    
    %(Index 1)find mean ENF of the signal over time
    mean_enf = find_mean(enf_reshape, time);
    mean_concat = [mean_concat; mean_enf];
    
    %(Index 2)find log(range) of ENF
    range_enf = find_range(enf_reshape);
    range_concat = [range_concat; range_enf];

    enf_off = (enf_reshape - repmat(mean_enf,1,seg_size))'; %offset to 0

    %(Index 3-7) variance after wavlet decomposition
    lvl = 4;
    c_var = zeros(size(enf_off,2),lvl+1);
    for i=1:size(enf_off,2)
        [c,l] = wavedec(enf_off(:,i),lvl,'db1');
%         l_accum = cumsum(l(1:end-1));
        start_ind = [0; l(2:end-1)] + 1;
        end_ind = l(2:end);
        for j=1:lvl+1
            c_var(i,j) = var(c(start_ind(j):end_ind(j)));
        end
    end
    wt_var = [wt_var; c_var];
    
    
    
    %(Index 8-10) AR parameters, error variance
    [a,g] = lpc(enf_off,2);
    ar_para = [ar_para; a(:,2:end)];
    ar_err = [ar_err; g];
   
    
    if nargin == 3
        % create label vector
        label_vec = repmat(label(n),length(mean_enf),1);
        label_concat = [label_concat; label_vec];
    end
end

features = [mean_concat range_concat wt_var ar_para ar_err];

end