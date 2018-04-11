%% Plot variance explained as function ACPC atneriorness
% useful for knowing whether voxels become less position sensitive as we
% move anteriorly
%
% Wrote this script to respond to reviewers for the FOV paper
% Modified to make more efficient for Vision lunch presentation

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20;
list_paths = list_sessionRet; 

dtName = 'Words';
rmName = 'retModel-Words-css.mat';

roiName = 'lVOTRC'; % lVOTRC-threshByWordModel


%% do the things

for ii = list_subInds

    dirAnatomy = list_anatomy{ii};
    dirVista = list_paths{ii};
    chdir(dirVista);
    subColor = list_colorsPerSub(ii,:);
    subInitials = list_sub{ii};

    %% init gray, load roi
    vw = initHiddenGray; 
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    vw = loadROI(vw, roiPath, [],[],1,0); 

    % the coordinates of the ROI
    % different from voxels ... so many more
    % for now, just run with this
    roiCoords = vw.ROIs.coords; 

    % number of coordinates in this ROI
    numCoords = size(roiCoords,2);

    % initialize things for the subject
    Y = zeros(numCoords,1); 

    %% load the ret model and get the rmroi
    rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
    vw = rmSelect(vw,1,rmPath);
    vw = rmLoadDefault(vw);
    rmroi = rmGetParamsFromROI(vw);

    %% loop over roi coords
    for nn = 1:numCoords

        % make a point ROI in the view ... this should automatically select
        coord = roiCoords(:,nn); 
        vw = makePointROI(vw, coord, 1); 

        %% get acpc coordinates
        % if skipTalFlag is 0, we use talairach coordinages
        % if skipTalFlag is 1, we use the spatial norm
        skipTalFlag = 1; % default is 0
        snc = vol2talairachVolume(vw,skipTalFlag);

        % the y coordinate connects "ac" to "pc"
        % store the y coordinates
        % the more negative the number, the more posterior it is
        Y(nn) = snc(2); 

        % delete the roi so we don't clog up the view
        vw = deleteROI(vw,2);
    end

    %% plotting

    % anteriorness by ecc
    figure; hold on; 

    % loop over coordinates if we want to size each one by sigma
    for cc = 1:numCoords
        thisVarExp = rmroi.co(cc); 
        thisSig = rmroi.sigma(cc);
        if ~isnan(thisSig)
            plot(Y(cc),thisVarExp,'o', 'MarkerSize', thisSig, ...
                'MarkerFaceColor', subColor, 'MarkerEdgeColor', [0 0 0])
        end
    end
    xlabel('MNI coordinate. posterior --> anterior')
    ylabel('Variance explained')
    titleName = {
        'Anteriorness and variance explained'
        [roiName '. Sub: ' subInitials]
        };
    title(titleName, 'fontweight','bold')
    grid on; 

    % save
    % ff_dropboxSave; 
    % close all; 

end % loop over subjects
