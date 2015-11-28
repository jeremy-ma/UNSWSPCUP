function [file_list, file_tab, label] = list_files(path,grid_num,record_type,record_num)

    if strcmp(grid_num,'all')
        grid_num = 'A':'I';
    end
    if strcmp(record_type,'all')
        record_type = 'AP';
    end
    if strcmp(record_num,'all')
        record_num = '\d*';
    end
    
    list_full = dir(path);
    

    reg_str_part = [ '[' num2str(record_num) ']' '.wav'];
    
    file_list = {};
    label = [];
    file_tab = zeros(9,2); %store number of files into a table (row=grid letter, col=power/audio)
    sample_num = 0;
    for k=1:length(record_type)
        % which grid
        for i=1:length(grid_num)
            reg_str = [grid_num(i) '_' record_type(k) reg_str_part];
            % check with each filename in the directory
            for j=3:length(list_full)
                if ~isempty(regexp(list_full(j).name,reg_str,'match'))
                    sample_num = sample_num +1;
                    file_list{sample_num,1} =  list_full(j).name;
                    num = cell2mat(regexp(list_full(j).name,'\d*','match'));
                    label = [label; [record_type(k) grid_num(i) num]];
                    file_tab(grid_num(i)-'A'+1,k) = file_tab(grid_num(i)-'A'+1,k)+1;
                end
            end
        end
    end
    
    if sample_num==0
        error('find no match files %s', reg_str)
    end
        
%     filename = ['Train_Grid_' grid_num '_' record_type num2str(record_num) '.wav'];
%     fullpath = fullfile(pwd,path,filename);
%     
%     [file,Fs] = audioread(fullpath);
end