%% the distrubution of RMSE for two retModels fit to two stimulus types
% assumption that there are 4 tseries we are grabbing:
% dt1, dt2, dt1 prediction, dt2 prediction
% data points are 2x the number of voxels:
% dt1 with dt2 prediction and dt2 with dt1 prediction
%
% The histogram tells us the reliability of the model for stimulus
% dependency across the visual areas
%
% PSEUDOCODE:
% For the two ret models, grab the measured time series and the predicted
% time series. Calculate the varexp between the measurement and the other
% stimulus type prediction

clear all; close all; clc
bookKeeping; 

%% modify here
list_subInds = 1;
vfc = ff_vfcDefault; 
list_paths = list_sessionRet; 

% will make a separate graph for each ROI
list_roiNames = {
    'LV2v_rl-threshBy-Words-co0p5'
%     'WangAtlas_V1v_left-threshBy-WordsAndFalseFont-co0p2'
%     'WangAtlas_V2v_left-threshBy-WordsAndFalseFont-co0p2'    
%     'WangAtlas_V3v_left-threshBy-WordsAndFalseFont-co0p2'
%     'WangAtlas_hV4_left-threshBy-WordsAndFalseFont-co0p2'
%     'lVOTRC-threshBy-WordsAndFalseFont-co0p2'
    };

% list the two being compared here
list_dtNames = {
    'Words'
    'FalseFont'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-FalseFont-css.mat'
    };
list_nFrames = [
    144;
    144;
    ];


% define --------------------------------
numRois = length(list_roiNames);
numSubs = length(list_subInds);
numRms = length(list_rmNames);

dtName1 = list_dtNames{1};
dtName2 = list_dtNames{2};

%% initialize
Measured = cell(numSubs, numRois, numRms); 
Prediction = cell(numSubs, numRois, numRms); 
NumVoxels = zeros(numSubs, numRois, numRms);

% linearized across subjects
Measured1 = cell(numRois); 
Measured2 = cell(numRois);
Prediction1 = cell(numRois);
Prediction2 = cell(numRois);

%% get the data: measured and predicted tseries for the two stimulus types
    
for ii = 1:numSubs

    subInd = list_subInds(ii);
    dirVista = list_paths{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista);
    vw = initHiddenGray; 

    for jj = 1:numRois

        % get the roi coordinates for this subject
        roiName = list_roiNames{jj};
        vw = deleteAllROIs(vw);
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
            [prediction, ~, ~, varexp] = ff_rmPredictedTSeries(vw, roiCoords, [], [], []);
            Prediction{ii,jj,kk} = prediction; 

            %% get the actual time series
            [measuredCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
            measured = measuredCell{1}; 
            clear measuredCell
            Measured{ii,jj,kk} = measured; 

            %% the number of voxels
            numVoxels = size(measured,2);
            NumVoxels(ii,jj,kk) = numVoxels; 

        end  
    end
    
    clearvars -global    
end    


%% Linearize across subjects
% Measured and Predicted are numSubs x numRois x numRms
% Make 4 matrices that is the concatenation across subjects
%
for jj = 1:numRois
    
    % initializing
    nFrames1 = list_nFrames(1);
    nFrames2 = list_nFrames(2);
    numVoxelsAcrossSub = sum(NumVoxels(:,jj,1));
    
    m1 = zeros(nFrames1, numVoxelsAcrossSub); 
    m2 = zeros(nFrames2, numVoxelsAcrossSub);
    p1 = zeros(nFrames2, numVoxelsAcrossSub);
    p2 = zeros(nFrames1, numVoxelsAcrossSub);
    
    indStart = 0; 
    indEnd = 0; 
    
    for ii = 1:numSubs
        nVoxels = NumVoxels(ii,jj,1);
        indStart = indEnd + 1; 
        indEnd = indStart + nVoxels - 1; 
        
        measured1 = Measured{ii,jj,1};
        measured2 = Measured{ii,jj,2};
        predicted1 = Prediction{ii,jj,1};
        predicted2 = Prediction{ii,jj,2};
        
        m1(:,indStart:indEnd) = measured1; 
        m2(:,indStart:indEnd) = measured2; 
        p1(:,indStart:indEnd) = predicted1; 
        p2(:,indStart:indEnd) = predicted2; 
              
    end
    
    Measured1{jj} = measured1; 
    Measured2{jj} = measured2; 
    Prediction1{jj} = predicted1; 
    Prediction2{jj} = predicted2; 
    
end


%% Plotting the cross-validated variance explained
for jj = 1:numRois

    roiName = list_roiNames{jj};
    
    % assumptions here that there are two models.
    measured1 = Measured1{jj}; 
    measured2 = Measured2{jj};
    predicted1 = Prediction1{jj};
    predicted2 = Prediction2{jj};

    % initiate
    numVoxels = size(measured1, 2);  
    crossValidated = zeros(1, 2*numVoxels);

    % cross-validated      
    crossValidated(1:numVoxels)         = ff_varExp(measured1, predicted2); 
    crossValidated(numVoxels+1:end)     = ff_varExp(measured2, predicted1); 

    % percent exceed
    percentExceed = sum(crossValidated > 0.5) / (2*numVoxels)

    %% plotting
    figure; 
    binCenters = [0:0.05:1];
    hist(crossValidated, binCenters)
    xlim([0 1])
    grid on; 
    alpha(0.5)

    xlabel('Variance explained', 'Fontweight', 'bold')
    ylabel('Number of voxels', 'Fontweight', 'bold')

    titleName = {
        'Cross-validated variance explained for: '
        [dtName1 ' and ' dtName2]
        [roiName]
        ['% voxels that exceed 0.5: ' num2str(percentExceed)]
        };
    title(titleName)

end


%% Plotting the distribution of variance explained
% the non-cross-validated one

for jj = 1:numRois


    roiName = list_roiNames{jj};
    
    % assumptions here that there are two models.
    measured1 = Measured1{jj}; 
    measured2 = Measured2{jj};
    predicted1 = Prediction1{jj};
    predicted2 = Prediction2{jj};

    % initiate
    numVoxels = size(measured1, 2);  
    varexp1 = zeros(1, numVoxels);
    varexp2 = zeros(1, numVoxels);

    % cross-validated      
    varexp1 = ff_varExp(measured1, predicted1); 
    varexp2 = ff_varExp(measured2, predicted2); 

    % percent exceed
    percentExceed1 = sum(varexp1 > 0.5) / (numVoxels)
    percentExceed2 = sum(varexp2 > 0.5) / (numVoxels)

    %% plotting
    figure; 
    binCenters = [0:0.05:1];
    hist(varexp1, binCenters)
    xlim([0 1])
    grid on; 
    alpha(0.5)

    xlabel('Variance explained', 'Fontweight', 'bold')
    ylabel('Number of voxels', 'Fontweight', 'bold')

    titleName = {
        ' variance explained for: '
        [dtName1]
        roiName
        ['% voxels that exceed 0.5: ' num2str(percentExceed1)]
        };
    title(titleName)
    
    figure; 
    binCenters = [0:0.05:1];
    hist(varexp2, binCenters)
    xlim([0 1])
    grid on; 
    alpha(0.5)

    xlabel('Variance explained', 'Fontweight', 'bold')
    ylabel('Number of voxels', 'Fontweight', 'bold')

    titleName = {
        ' variance explained for: '
        [dtName2]
        roiName
        ['% voxels that exceed 0.5: ' num2str(percentExceed2)]
        };
    title(titleName)

end


