classdef FeaturesExtractClass
    
properties
    frame_size = 5;
    overlap_enf = 0;
    nfft = 2^14;
    seg_size = 96;
    overlap_seg = 0;

    features
    features_norm
    seg_num
    label_concat
    label_file
end

methods
    %initilisation
    function obj = FeaturesExtractClass(frame_size, overlap_enf, nfft, seg_size, overlap_seg)
        if exist('frame_size','var')
            obj.frame_size = frame_size;
        end
        if exist('overlap_enf','var')
            obj.overlap_enf = overlap_enf;
        end
        if exist('nfft','var')
            obj.nfft = nfft;
        end
        if exist('seg_size','var')
            obj.seg_size = seg_size;
        end
        if exist('overlap_seg','var')
            obj.overlap_seg = overlap_seg;
        end
    end

    %iterate through each file to get ENF, then features
    function obj = features_extract(obj, enf_algo_p, path, file_list)
        for n=1:length(file_list)

            [y,fs] = load_file(path, char(file_list(n)));
            
            

            %spectrogram
            framelength = obj.frame_size * fs;
            [enf, time] = enf_algo_p(y, fs, framelength, obj.overlap_enf, obj.nfft);

            %reshape enf in segments
            enf_reshape = reshape_vec(enf, obj.seg_size, obj.overlap_seg);

            obj.features = feature_extract(obj.features, enf_reshape, obj.seg_size);

            %record number of segments 
            obj.seg_num = [obj.seg_num; size(enf_reshape,1)];
        end
    end
    
    %create labels
    function obj = labelling(obj, label)
%         label_concat = repelem(label,obj.seg_num);
        for i=1:length(label)
            obj.label_file = [obj.label_file; label(i,:)];
            obj.label_concat = [obj.label_concat; repmat(label(i,:),obj.seg_num(i),1)];
        end
    end
end

end