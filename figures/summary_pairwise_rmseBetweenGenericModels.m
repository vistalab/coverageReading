%% Cross-model validation.
% For a given rfParam, and 2 stimulus patterns
% Compute the predicted time series given the stimulus pattern
% And compute the variance explained between the prediction and the actual
% Plot the pairwise computation

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [1:9];
vfc = ff_vfcDefault; 

list_roiNames = {
%     'lVOTRC-threshBy-WordsAndCheckers-co0p2'
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
%     'WangAtlas_V1v_left'
%     'WangAtlas_V2v_left'
%     'WangAtlas_V3v_left'
%     'WangAtlas_hV4_left'
    };

% the two ret models being compared
list_dtNames = {
    'Words'
    'Words'
    };
list_rmNames = {
    'retModel-Words.mat'
    'retModel-Words-oval.mat'
%     'retModel-Words.mat'
%     'retModel-Words-oval.mat'
    };
list_dtDescripts = {
    'Circular Gaussian (Words linear)'
    'Elliptical Gaussian (Words linear)'
%     'Linear. circular model'
%     'Linear. oval model'
    };
list_nFrames = [
    144 %96;
    144 %144;
    ];

%% calculate
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numDts = length(list_dtNames);

dtDescript1 = list_dtDescripts{1};
dtDescript2 = list_dtDescripts{2};

%% initialize
predictionCrossCell = cell(numSubs, numRois, numDts);
predictionCell = cell(numSubs, numRois, numDts);

%% do things
% get the info. the outputs are numSubs x numRois x numRms
[tSeriesCell, rfParamsCell, stimParamsCell, allNumVoxels] = ... 
      ff_tSeriesAndRfParamsCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% this is where we assume there are only 2 dts
for ii = 1:numSubs
    for jj = 1:numRois
        
        rfParams1 = rfParamsCell{ii,jj,1}; 
        rfParams2 = rfParamsCell{ii,jj,2}; 
        stimParams1 = stimParamsCell{ii,jj,1};
        stimParams2 = stimParamsCell{ii,jj,2};
        
        if ~isempty(rfParams2)
            % what the crossed prediction would look like
            predictionCross1 = ff_predictionCross(rfParams2, stimParams1);
            predictionCross2 = ff_predictionCross(rfParams1, stimParams2);
            
             % what the straightfoward predicted tseries would look like
            prediction1 = ff_predictionCross(rfParams1, stimParams1);
            prediction2 = ff_predictionCross(rfParams2, stimParams2);
        else
            predictionCross1 = [];
            predictionCross2 = []; 
            prediction1 = [];
            prediction2 = []; 
       end         
        
        % store in matrix
        predictionCrossCell{ii,jj,1} = predictionCross1; 
        predictionCrossCell{ii,jj,2} = predictionCross2;            
        predictionCell{ii,jj,1} = prediction1; 
        predictionCell{ii,jj,2} = prediction2; 
         
    end
end

%% Linearize across subjects
% transforms cells that are numSubs x numRois x numRms into
% numRois x numRms
LTSeries            = ff_linearizeCell(tSeriesCell, allNumVoxels, list_nFrames);
LPredictionCross    = ff_linearizeCell(predictionCrossCell, allNumVoxels, list_nFrames);
LPrediction         = ff_linearizeCell(predictionCell, allNumVoxels, list_nFrames);

%% Plotting the distribution of variance explained
% Cross-model and regular

for jj = 1:numRois
    
    roiName = list_roiNames{jj};
    
    % assumptions here that there are two models.
    measured1 = LTSeries{jj,1}; 
    measured2 = LTSeries{jj,2};
    predictedCross1 = LPredictionCross{jj,1};
    predictedCross2 = LPredictionCross{jj,2};
    predicted1 = LPrediction{jj,1};
    predicted2 = LPrediction{jj,2};

    % initiate
    numVoxels = size(measured1, 2);  

    % cross-validated and non-cross-validated variance explained     
    varexpCross1 = ff_varExp(measured1, predictedCross1); 
    varexpCross2 = ff_varExp(measured2, predictedCross2); 
    varexpCross = [varexpCross1 varexpCross2];
    varexp1 = ff_varExp(measured1, predicted1);
    varexp2 = ff_varExp(measured2, predicted2);

    % if wanting to plot histograms, see the commented-out code labeled
    % * plotting histograms *
    
    %% plotting cross-model validated variance explained
 
    ff_scatterHeated(varexp1, varexpCross1, [0 1])
    xlabel([dtDescript1 ' time series'])
    ylabel([dtDescript2 ' time series'])
    titleName = {
        'Cross-model variance explained with'
        [dtDescript1 ' pRF parameters']
        [roiName]
    };
    title(titleName, 'fontweight', 'bold')

    ff_scatterHeated(varexpCross2, varexp2, [0 1])
    xlabel([dtDescript1 ' time series'])
    ylabel([dtDescript2 ' time series'])
    titleName = {
        'Cross-model variance explained with'
        [dtDescript2 ' pRF parameters']
        [roiName]
    };
    title(titleName, 'fontweight', 'bold')
   

end


%% * plotting histograms *
%  %% plotting regular variance explained
%     % retModel 1
%     figure; 
%     binCenters = [0:0.05:1];
%     hist(varexp1, binCenters)
%     xlim([0 1])
%     grid on; 
%     alpha(0.5)
% 
%     xlabel('Variance explained', 'Fontweight', 'bold')
%     ylabel('Number of voxels', 'Fontweight', 'bold')
% 
%     titleName = {
%         ' variance explained for: '
%         [dtName1]
%         roiName
%         };
%     title(titleName)
%     
%     % retModel 2
%     figure; 
%     binCenters = [0:0.05:1];
%     hist(varexp2, binCenters)
%     xlim([0 1])
%     grid on; 
%     alpha(0.5)
% 
%     xlabel('Variance explained', 'Fontweight', 'bold')
%     ylabel('Number of voxels', 'Fontweight', 'bold')
% 
%     titleName = {
%         ' variance explained for: '
%         [dtName2]
%         roiName
%         };
%     title(titleName)
%     
%     
%     %% plotting cross-validated variance explained
%     figure; 
%     hist(varexpCross, binCenters)
%     xlim([0 1])
%     grid on; 
%     alpha(0.5)
%     xlabel('Cross-model variance explained', 'Fontweight', 'bold')
%     
%      titleName = {
%         'Cross-model variance explained for: '
%         [dtName1 ' and ' dtName2]
%         roiName
%         };
%     title(titleName)
%     
