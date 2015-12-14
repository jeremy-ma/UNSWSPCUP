path = fullfile('..','..','Practice_dataset','Practice_dataset');
[file_list,file_num] = list_files_test(path);

for n=1:length(file_list)
    [y,fs]  = load_file(path, char(file_list(n)));
    [s,f,time] = spectrogram(y,fs);
    figure(1)
    imagesc(log(abs(s)))
    file_num(n)
end