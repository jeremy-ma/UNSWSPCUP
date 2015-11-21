function [file,Fs] = load_file(path, filename)

    fullpath = fullfile(pwd,path,filename);
    [file,Fs] = audioread(fullpath);
    
end