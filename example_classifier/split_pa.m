%split the file list into 2, power and audio
function [file_list_p, file_list_a, label_p, label_a] = split_pa(file_list, label, path)

% file_list_p = [];
% file_list_a = [];
% label_p = [];
% label_a = [];

type = zeros(length(file_list),1);

%distinguish between power and audio
%test file label is a numeric matrix, while train file label is char matrix
if ~isnumeric(label)
    type = label(:,1);  %first column of label vector is type (eg. PB01)
else
    for n=1:length(file_list)
        
        [y,fs] = load_file(path, char(file_list(n)));
        type(n) = signal_type(y, fs);
    end
end

%copy file name into 2 vectors
ispower = (type=='P');
file_list_p = file_list(ispower);
file_list_a = file_list(~ispower);

%copy label into 2 vectors
if ~isnumeric(label)
    label_p = label(ispower,2:end);
    label_a = label(~ispower,2:end);
else
    label_p = label(ispower);
    label_a = label(~ispower);
end

end