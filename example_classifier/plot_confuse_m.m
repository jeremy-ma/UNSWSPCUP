function plot_confuse_m(mat,label,store_fig,title_text)

m_size = size(mat,1);
f = figure('visible','off');
imagesc(mat);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:m_size);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:m_size,...                         %# Change the axes tick marks
        'XTickLabel',cellstr(label),...  %#   and tick labels
        'YTick',1:m_size,...
        'YTickLabel',cellstr(label),...
        'TickLength',[0 0]);

title(title_text)
xlabel('Predicted Label')
ylabel('Actual Label')

saveas(f,fullfile(store_fig,title_text),'jpg');

end