%% define rois based on MNI coordinates

close all; clc; clear all; 
bookKeeping;

%% modify here

list_subInds = 18;

list_mniCoords = [
%      [-42, -57, -6];
%     [-45,-57,-12];
    [0 0 0]
    ];

list_mniNames = {
%     'VWFA_mni_-42_-57_-6';
%     'VWFA_mni_-45_-57_-12';
    'center of the brain'
    };


%% define things
list_path = list_sessionRet; 



%% do things

for ii = list_subInds
    
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    
    chdir(dirVista);
    vw = initHiddenGray; 
    vw = loadAnat(vw);
    
    for mm = 1:length(list_mniNames)
       
        mniCoords = list_mniCoords(mm,:);
        mniName = list_mniNames{mm};
        
        % VOLUME{end} = findTalairachVolume(VOLUME{end}, 'mni', [-42, -54,-12]);
        % this loads the ROI into the view
        vw = findTalairachVolume(vw, 'mni', mniCoords);

        % get the full roi struct, the number of the selected roi (the mni we just created)
        % and the roi struct of this selected roi
        roiStruct = viewGet(vw, 'roistruct');
        roiNum = viewGet(vw, 'curRoi');
        ROI = roiStruct(roiNum); 
        
        % rename the roi
        ROI.name = mniName; 
        
        % save the roi
        [vw, status, forceSave] = saveROI(vw, ROI, 0, 1);
        
    end
    
end

