%extract test data
%assume we select all files from the directory
function [file_list,file_num] = list_files_test(path)
    
    list_full = dir(path);
    
    reg_str = '\d*';
    
    file_list = {};
    file_num = [];
    for j=3:length(list_full)
        num = str2double(cell2mat(regexp(list_full(j).name,reg_str,'match')));
        file_list{num,1} =  list_full(j).name;  %put files in numerical order
        file_num = [file_num; num];
    end
    file_num = sort(file_num);  %number in the file name (in order)
end