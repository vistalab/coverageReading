%% For two ret models, compare the "amplitude" of the signal
% where the amplitude is the mean of the max (8) points of the time series

clear all; close all; clc;
bookKeeping; 

%% modify here

list_subInds = [1:20];
list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
    };
vfc = ff_vfcDefault;

list_dtNames = {
    'Words'
    'Checkers'
    };
list_dtNamesDescript = {
    'Words'
    'Checkers'
    };

% how many of the top points we want to take the mean of
numTopAmps = 8; 

% how we want to color the points
% 'uniform': uniform default color for all points
% 'ecc': color by eccentricity
colorMethod = 'uniform'; 

markerColor = [1 1 1]; % [0 .5 .8];
cmap = coolhotCmap(0); % colormap if colorMethod = 'ecc'


%% useful
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numDts = length(list_dtNames);

TSeriesAmp = cell(numRois, numDts);

%% get the data

for jj = 1:numRois
    roiName = list_roiNames{jj};
    
    for kk = 1:numDts        
        dtName = list_dtNames{kk};
        
        MaxMean = []; 
        
        for ii = 1:numSubs
            subInd = list_subInds(ii);
            dirVista = list_sessionRet{subInd};
            dirAnatomy = list_anatomy{subInd};
            chdir(dirVista);
            vw = initHiddenGray; 

            % set the roi and get coordinates
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
            [vw, roiExists] = loadROI(vw, roiPath, 1, [],1,0);
            roiCoords = viewGet(vw, 'roiCoords');
            numCoords = size(roiCoords,2); 
            
            
            % set the dt
            vw = viewSet(vw, 'curdt', dtName);
            
            % get the tSeries if the roi exists
            [tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
            tSeries = tSeriesCell{1}; 
            clear tSeriesCell;

            % apply the metric
            maxMean = ff_tSeries_meanOfMaxPoints(tSeries, numTopAmps);
            MaxMean = [MaxMean maxMean];
        end
       
        TSeriesAmp{jj,kk} = MaxMean;
        
    end
end    

%% do the plotting
% assuming only 2 rms
close all; 
for jj = 1:numRois

    roiName = list_roiNames{jj};
    amp1 = TSeriesAmp{jj,1}; 
    amp2 = TSeriesAmp{jj,2};
    dtDescript1 = list_dtNamesDescript{1};
    dtDescript2 = list_dtNamesDescript{2};
    
    
    figure; hold on; grid on;    
    
    switch colorMethod
        case 'uniform'           
            scatter(amp1, amp2, 'filled')
                %'markeredgecolor', markerColor)
        case 'ecc'
            colorMat = []; % TODO
            scatter(amp1, amp2, [], colorMat);
    end
    
    set(gca, 'color', [0 0 0])
    alpha(0.2)
    ff_identityLine(gca, [.5 .5 .5])
    xlabel([dtDescript1 '. Mean BOLD'])
    ylabel([dtDescript2 '. Mean BOLD'])
    
    titleName = {
        ['Mean BOLD signal']
        ['of the largest ' num2str(numTopAmps) ' time points']
        roiName
    };
    title(titleName, 'fontweight', 'bold')
    
end

