%% Plot variance explained as a function voxel anteriorness
% 
% modified figScript_acpcAnteriorVsVarExp_allSubjects.m and made it more
% efficient

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20;
list_paths = list_sessionRet; 

list_roiNames = {
    'RV1_rl'
    'RV2v_rl'
    'RV3v_rl'
    'RhV4_rl'
    'rVOTRC'
    };

dtName = {'Words'};
rmName = {'retModel-Words-css.mat'}; 

vfc = ff_vfcDefault; 
pointColor = [0 .5 .5];

%% do the things
% we want to save the rmroi information (esp anteriorness)
numSubs = length(list_subInds); 
numRois = length(list_roiNames);

%% ff_rmroiCell
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);

%% 
close all; 

for jj = 1:numRois
    
    figure; hold on; 
    roiName = list_roiNames{jj};
    
    for ii = 1:numSubs

        subInd = list_subInds(ii); 
        dirAnatomy = list_anatomy{subInd};
        dirVista = list_paths{subInd};
        chdir(dirVista);
        subInitials = list_sub{subInd};

        %% init gray
        vw = initHiddenGray; 
       
        %% grab an rmroi and get the coords this way
        rmroi = rmroiCell{ii,jj}; 
        if ~isempty(rmroi)
            coords = rmroi.coords; 
        
            %% get acpc coordinates of the ROI that is loaded in the view
            % if skipTalFlag is 0, we use talairach coordinages
            % if skipTalFlag is 1, we use the spatial norm
            skipTalFlag = 1; % default is 0
            ssCoords = ff_vol2talairachVolume(vw,skipTalFlag, coords');

            % ssCoords is numCoords x 3
            % the 2nd column is the anterior coordinate
            ssCoordsAnterior = ssCoords(:,2);


            %% plotting
            rmroi = rmroiCell{ii,jj}; 
            scatter(ssCoordsAnterior, rmroi.co, [], pointColor, 'filled')
        end
        

    end % loop over subjects
    
    alpha(0.05);
    grid on; 

    xlabel('MNI coordinate. posterior --> anterior')
    ylabel(['Variance explained'])
    titleName = {
        'Anteriorness and variance explained'
        roiName
        };
    title(titleName, 'fontweight','bold')
    
    % save as a .fig so that we can make a heat map afterwards
    
end % loop over ROIs
    


