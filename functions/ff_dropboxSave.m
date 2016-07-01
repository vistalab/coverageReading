function ff_dropboxSave(varargin)

%% Grabs the current figure and saves it to dropbox
% If there are no inputs, grabs the figure title and uses this as the
% filename
% Otherwise: ff_dropboxSave('title', 'theTitleNameThatYouWant')

%% If no inputs, grabs the current figure title and saves it to dropbox
% filename is title name
% saves both the .png and .fig file

dropboxDir = '/home/rkimle/Dropbox/TRANSFERIMAGES/';

%% input parser
p = inputParser; 
addOptional(p, 'title', get(get(gca, 'title'), 'String')); 
parse(p, varargin{:});
titleName = p.Results.title; 

%%

if iscell(titleName)
    titleName = ff_cellstring2string(titleName); 
end

saveas(gcf, fullfile(dropboxDir, [titleName '.png']), 'png')
saveas(gcf, fullfile(dropboxDir, [titleName '.fig']), 'fig')

end

