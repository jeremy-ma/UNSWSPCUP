%extract mean as a feature
function [feature_v, mean_enf] = find_mean(enf, feature_v)

mean_enf = mean(enf,2);

feature_v = [feature_v mean_enf];

% figure
% plot(time,expected_val)

end