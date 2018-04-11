%% Transparent graph showing the peaks across time for multiple datatypes
% The point being that certain stimulus types have larger peaks than
% others ...

clear all; close all; clc; 
bookKeeping; 


%% modify here
list_subInds = 1:20; 

list_roiNames = {
%     'LV1_rl-threshBy-WordsAndCheckers-co0p5'
%     'LV2v_rl'
%     'LV3v_rl'
     'LhV4_rl'
%     'VOTRC'
    };

list_dtNames = {
    'Words'
    'Checkers'
    };

list_dtColors = [
    [1 0 0]
    [0 0 1]
    ];

%% helpful
numSubs = length(list_subInds);
numDts = length(list_dtNames);
numRois = length(list_roiNames);

PeakInfo = cell(numRois, numDts);

%% get the data in an inefficient loop
for jj = 1:numRois
    
    %% 
    figure; hold on; grid on; 
    roiName = list_roiNames{jj};

    for kk = 1:numDts
        dtName = list_dtNames{kk};
        dtColor = list_dtColors(kk,:);
        
        for ii = 1:numSubs
            
            subInd = list_subInds(ii);
            dirVista = list_sessionRet{subInd};
            dirAnatomy = list_anatomy{subInd};
            chdir(dirVista);
            vw = initHiddenGray;
            
            roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);           
            vw = loadROI(vw, roiPath, [],[],1,0);
            
            % coordinates
            roiCoords = viewGet(vw, 'roiCoords');
            numCoords = size(roiCoords,2);
            
            % time series
            vw = viewSet(vw, 'curdt', dtName);
            [tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
            tSeries = tSeriesCell{1}; 
            clear tSeriesCell;

            % slow but loop over coords and store info about peaks
            for vv = 1:numCoords
                [pks, locs] = findpeaks(tSeries(:,vv), ...
                    'sortstr','descend', ...
                    'nPeaks',8, 'minPeakDistance',3);
                scatter(locs, pks, [], dtColor, 'filled', 'markeredgecolor', 'none')
            end
        end
        
        alpha(0.01)
        titleName = {
            [roiName '. tSeriesPeaks']
            };
        title(titleName, 'fontweight', 'bold')


    end
end

