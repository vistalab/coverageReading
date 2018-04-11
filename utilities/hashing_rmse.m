%% the distrubution of RMSE for two retModels fit to two stimulus types
% assumption that there are 4 tseries we are grabbing:
% dt1, dt2, dt1 prediction, dt2 prediction

clear all; close all; clc
bookKeeping; 


%% modify here
list_subInds = 1;
vfc = ff_vfcDefault; 
list_paths = list_sessionRet; 

% will make a separate graph for each ROI
list_roiNames = {
    'LV2v_rl-threshBy-WordsAndCheckers-co0p5'
    };

% list the two being compared here
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };


%% calculate
numRois = length(list_roiNames);
numSubs = length(list_subInds);
numRms = length(list_rmNames);


%% do things
for jj = 1:numRois
    roiName = list_roiNames{jj};
    
    for ii = 1:numSubs
        
        subInd = list_subInds(ii);
        dirVista = list_paths{subInd};
        dirAnatomy = list_anatomy{subInd};
        chdir(dirVista);
        vw = initHiddenGray; 
        
        % get the roi coordinates for this subject
        roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
        vw = loadROI(vw, roiPath,[],[],1,0); 

        % roiCoords is a 3 x numCoords matrix
        [~, roiCoords] = roiGetAllIndices(vw); 
        
        %% getting time series
        % Get the measured time series
        for kk = 1:numRms
                
            dtName = list_dtNames{kk};
            rmName = list_rmNames{kk};
            vw = viewSet(vw, 'curdt', dtName);
            
            rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
            vw = rmSelect(vw, 1, rmPath); 
            vw = rmLoadDefault(vw); 
            
            
             %% get the predicted time series
             % for debugging purposes
            roiCoords = [110 161 86]';
            [prediction, ~, ~, varexp] = rmPredictedTSeries(vw, roiCoords, [], [], []);
    
            
            %% get the actual time series
            [measuredCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
            measured = measuredCell{1}; 
            clear measuredCell
            
            
            %% hashing 
            voxnum = 1; 
            m1 = measured(:,voxnum); 
            p1 = prediction(:,voxnum);
            
            %%
            figure; hold on; grid on;  
            plot(m1,'-', 'color', [0 0 0],'marker', 'o', ...
                'markerfacecolor', [0 0 0 ], 'markersize',2)
            plot(p1, 'color', [0 0 1], 'linewidth',2)
            
            v1 = ff_varExp(m1,p1);
            varexpvox = varexp(voxnum);
            
            theCoord = roiCoords(:, voxnum)
            titleName = {
                ['coord: ' num2str(theCoord')]
                [dtName]
                ['Varexp: ' num2str(varexpvox)]
                };
            title(titleName, 'fontweight', 'bold')
            
            % varexp_allRl = ff_varExp(measured, prediction)
            
        end
          
    end
    
end



