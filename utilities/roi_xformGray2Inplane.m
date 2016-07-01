%% script that will xform to the inplane from the gray view an ROI

clear all; close all; clc;
bookKeeping;

%% modify here
list_subInds = 1:20; 

list_roiNames = {
    'lh_VWFA_rl'
    'lh_VWFA_fullField_rl'
    'left_VWFA_rl'
    };

%% define things

list_path = list_sessionRet;
numRois = length(list_roiNames);


%% do things

for ii = list_subInds
    
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    chdir(dirVista);
    vw = initHiddenGray; 
    ip = initHiddenInplane;
        
    for jj = 1:numRois
        
        % load roi
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
        [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);
        
        %% xform if roi exists
        if roiExists 
            ip=vol2ipCurROI(vw, ip); 
                     
            % must save 
            local = true; 
            saveROI(ip, 'selected', local)
        end
        
        clear roiExists;
        
    end
    
    % close inplane and view
    close all; 

end