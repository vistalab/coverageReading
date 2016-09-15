function ff_titleAppend(descript)
%% Adds on to the current title of the current figure an additional 
% get the current title.
% not the most elegant code at the moment ... stealing from ff_dropboxSave
varargin = {}; 
p = inputParser; 
addOptional(p, 'title', get(get(gca, 'title'), 'String')); 
parse(p, varargin{:});
titleName = p.Results.title;

% make the new title
titleName{end+1,1} = descript; 
title(titleName, 'fontweight', 'bold')
end