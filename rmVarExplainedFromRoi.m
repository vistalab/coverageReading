%% interested in the variance explained for different retinotopic models 
% (because they have different stimuli)
% this script plots the variance explained as a histogram

clear all; close all; clc; 
%% modify here

% directory of roi
dirRoiShared = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
list_roiNames = {
    'leftVWFA'
    'rightVWFA'
    };

% list of sessions
list_sessions = {
    '/biac4/wandell/data/reading_prf/rosemary/20140425_version2';
    '/biac4/wandell/data/reading_prf/rosemary/20140818_1211'
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';
    };

% short description, useful for plotting later
list_comments = {
    'conglomeration bars 1 run';
    'checker bars 4 runs'; 
    'word retinotopy 2 runs';
    };

% list of the corresponding rm files
list_rmFiles = {
    '/biac4/wandell/data/reading_prf/rosemary/20140425_version2/Gray/BarsA/retModel-20140901-203503-fFit.mat'; 
    '/biac4/wandell/data/reading_prf/rosemary/20140818_1211/Gray/AveragesBars/retModel-20140824-011024-fFit.mat'; 
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/Gray/WordRetinotopy/retModel-20141110-194728-fFit.mat';
    };

%% do it!

for ii = 1:length(list_sessions)
    
    % change to the directory, open mrVista
    cd(list_sessions{ii}); 
    vw = mrVista('3'); 
    
    % load the retintopic model
    vw = rmSelect(vw,1,list_rmFiles{ii}); 
    vw = rmLoadDefault(vw); 
    
    for jj = 1:length(list_roiNames)

        % load the rois (automatically selects the one that is just loaded)
        vw = loadROI(vw, [dirRoiShared list_roiNames{jj}], [],[],1,0); 
        
        % get the indices of the roi
        roiInds = viewGet(vw,'roiInds'); 
        
        % rm files store rawrss and rss and compute when needed, according to the formula
        % variance explained = 1 - (model_rss ./ raw_rss).
        % get model_rss and raw_rss from vw.rm
        rss     =  vw.rm.retinotopyModels{1}.rss; 
        rawrss  =  vw.rm.retinotopyModels{1}.rawrss; 
        varExp  = 1 - (rss ./ rawrss);
        
        % histogram of variance explained
        varExpRoi = varExp(roiInds); 
        figure()
        hist(varExpRoi); 
        title(['Variance explained. ' list_comments{ii} ' ' list_roiNames{jj}]); 
        ylabel('Frequency');
        xlabel('Variance Explained')
        saveas(gcf,['~/Pictures/' 'session' num2str(ii) '_roi' num2str(jj)], 'png'); 
        
    end
    


    close all; 
end