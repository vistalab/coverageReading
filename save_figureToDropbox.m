dropboxDir = '~/Dropbox/TRANSFERIMAGES/'
titleName = get(get(gca, 'title'), 'String'); 

if iscell(titleName)
    titleName = ff_cellstring2string(titleName);
end

saveas(gcf, fullfile(dropboxDir, [titleName '.png']), 'png')
saveas(gcf, fullfile(dropboxDir, [titleName '.fig']), 'fig')

