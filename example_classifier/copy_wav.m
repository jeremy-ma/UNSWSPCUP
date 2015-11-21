%copy .wav file to desired directory
function copy_wav(target_dir, des_dir)
    list = dir(target_dir);
    
    for i=3:length(list)
        if list(i).isdir
            copy_wav(fullfile(target_dir,list(i).name), des_dir)
        else
            [pathstr,name,ext] = fileparts(list(i).name);
            if strcmp(ext,'.wav') && ~exist(fullfile(des_dir,list(i).name),'file')
                copyfile(fullfile(target_dir,list(i).name), des_dir)
            end
        end
    end
end