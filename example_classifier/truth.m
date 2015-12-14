%Secret!!!
%determine how accurate is the Practice data 
function [accuracy_p, accuracy_a, truth_p, truth_a] = truth(label_p, label_a, type_p, type_a)

% truth_p = cell(length(type_p),5);  %columns: file number, 
label_p = label_p';
label_a = label_a';

true_file = fullfile('..','..','truth.xls');
[~,truth_m] = xlsread(true_file);

%power
if isempty(label_p)
    accuracy_p = 0;
    truth_p = [];
else
    truth_p(:,1) = num2cell(type_p);
    truth_p(:,2:3) = truth_m(type_p,:);    %considered as power in terms of code execution, even if it isn't in reality 
    truth_p(:,4) = cellstr(label_p);
    truth_p(:,5) = cellstr('T');
    truth_p([truth_p{:,2}]=='A' | [truth_p{:,3}]~=[truth_p{:,4}],5) = cellstr('F'); 

    %print wrong prediction files in a table
    truth_p_wrong = truth_p([truth_p{:,5}]=='F',1:4);
    table(truth_p_wrong(:,1),truth_p_wrong(:,2),truth_p_wrong(:,3),truth_p_wrong(:,4), 'VariableNames',{'Filenumber','Power_Audio','true_label','pred_label'})

    accuracy_p = (size(truth_p,1)-size(truth_p_wrong,1))/size(truth_p,1);
end

%audio
if isempty(label_a)
    accuracy_a = 0;
    truth_a = [];
else
    truth_a(:,1) = num2cell(type_a);
    truth_a(:,2:3) = truth_m(type_a,:);    %considered as power in terms of code execution, even if it isn't in reality 
    truth_a(:,4) = cellstr(label_a);
    truth_a(:,5) = cellstr('T');
    truth_a([truth_a{:,2}]=='P' | [truth_a{:,3}]~=[truth_a{:,4}],5) = cellstr('F'); 

    %print wrong prediction files in a table
    truth_a_wrong = truth_a([truth_a{:,5}]=='F',1:4);
    table(truth_a_wrong(:,1),truth_a_wrong(:,2),truth_a_wrong(:,3),truth_a_wrong(:,4), 'VariableNames',{'Filenumber','Power_Audio','true_label','pred_label'})

    accuracy_a = (size(truth_a,1)-size(truth_a_wrong,1))/size(truth_a,1);
end

end