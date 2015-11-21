%copy all datasets from website to a single
%eg. if data located in (sub)folder 'Training_Data150901' is the parent
%directory, target_dir = '..\Training_Data150901'
function change_dir(orig_dir, des_dir, store_fig)

    if ~exist(des_dir, 'dir')
        mkdir(des_dir);
    end
    copy_wav(orig_dir, des_dir)

    %create directory to store figures
    if ~exist(store_fig, 'dir')
        mkdir(store_fig);
    end
end