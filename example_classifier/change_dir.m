%copy all datasets from website to a single
%eg. if data located in (sub)folder 'Training_Data150901' is the parent
%directory, target_dir = '..\Training_Data150901'
function change_dir(target_dir)

    des_dir = fullfile('Train_Data');
    if ~exist(des_dir, 'dir')
        mkdir(des_dir);
    end

    copy_wav(target_dir, des_dir)

end