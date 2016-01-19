% moves params and images mat files for retinotopy into subject's Stimuli
% folders

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = [20];

% session list
list_path = list_sessionRet; 

% absolute paths of things we want copied over
list_thingsToCopy = {
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep1.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep2.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep3.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep4.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep5.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep6.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep7.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_checkers_RemoveSweep8.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep1.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep2.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep3.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep4.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep5.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep6.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep7.mat'
    '/sni-storage/wandell/data/reading_prf/forAnalysis/knkret/params_knkfull_multibar_RemoveSweep8.mat'
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
