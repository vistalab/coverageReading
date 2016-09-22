%% make a directory in the shared anatomy directory to store connectomes
% to make it easier to keep track of

clear all; close all; clc; 
bookKeeping; 

%%

for ii = 1:length(list_sub)
    
    dirAnatomy = list_anatomy{ii};
    chdir(dirAnatomy);
    dirToMake = fullfile(dirAnatomy, 'ROIsMifs');
    
    if ~exist(dirToMake)
        mkdir(dirToMake)
    end
    
end