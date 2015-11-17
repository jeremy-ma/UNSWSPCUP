%return peak frequency along timeline
function mean_enf = find_mean(enf, time)

mean_enf = mean(enf,2);

% expected_val = sum(repmat(f,1,length(time)) .* abs(s).^2, 1) ./ sum(abs(s).^2);

% figure
% plot(time,expected_val)

end