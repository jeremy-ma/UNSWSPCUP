%copy all datasets from website to a single
function change_dir(target_dir)

    des_dir = 'Train_Data';
    if ~exist(des_dir, 'dir')
        mkdir(des_dir);
    end

    copy_wav(target_dir, des_dir)

end