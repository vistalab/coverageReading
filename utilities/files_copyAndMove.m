% moves params and images mat files for retinotopy into subject's Stimuli
% folders

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = [32 35];

% session list
list_path = list_sessionHebrewRet_resize; 

% absolute paths of things we want copied over
list_thingsToCopy = {
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_hebrew_delayStart8secs.mat'
    };

% path, relative to subject's dirVista, that we want things copied into
dirCopyInto = fullfile('Stimuli'); 

%%

% loop over subjects
for ii = list_subInds
    
    % move to dirVista
    dirVista = list_path{ii};
    chdir(dirVista);
    
    dirToMove = fullfile(dirVista, dirCopyInto);
    chdir(dirToMove)
    
    % copy things over
    for jj = 1:length(list_thingsToCopy)
        pathThingToCopy = list_thingsToCopy{jj};
        copyfile(pathThingToCopy,dirToMove);
    end
    
end
