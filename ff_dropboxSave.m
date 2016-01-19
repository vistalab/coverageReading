function ff_dropboxSave()

%% grabs the current figure and its title and saves it to dropbox
% filename is title name
% saves both the .png and .fig file

dropboxDir = '/home/rkimle/Dropbox/TRANSFERIMAGES/';
titleName = get(get(gca, 'title'), 'String'); 

if iscell(titleName)
    titleName = ff_cellstring2string(titleName); 
end

saveas(gcf, fullfile(dropboxDir, [titleName '.png']), 'png')
saveas(gcf, fullfile(dropboxDir, [titleName '.fig']), 'fig')

end

