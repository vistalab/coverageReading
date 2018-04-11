%% Cross-model validation.
% Compare the variance explained of another model's pRF fits

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [1];
vfc = ff_vfcDefault; 

% 
list_roiNames = {
    'LV2v_rl-threshBy-WordsAndCheckers-co0p5'
%     'lVOTRC-threshBy-WordsAndCheckers-co0p2'
%     'lVOTRC'
    };

% the two ret models being compared
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };
list_nFrames = [
    144;
    96;
    ];


%% calculate
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numDts = length(list_dtNames);

dtName1 = list_dtNames{1};
dtName2 = list_dtNames{2};

%% debugging
% rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames)

%% initialize
cellTSeries = cell(numSubs, numRois, numDts); 
cellRfParams = cell(numSubs, numRois, numDts);
cellPredictionCross = cell(numSubs, numRois, numDts);
cellParams = cell(numSubs, numRois, numDts);
allNumVoxels = zeros(numSubs, numRois);

%% do things

for ii = 1:numSubs
    
    clearvars -global  
    
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista)
    vw = initHiddenGray; 
    
    %% 
    for jj = 1:numRois
    
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        
        % delete ROIs to save space and to get correct indices
        vw = deleteAllROIs(vw);  
        vw = loadROI(vw, roiPath, [], [], 1, 0);       
        [~, roiCoords] = roiGetAllIndices(vw);
        
        % the number of voxels
        numVoxels = size(roiCoords,2);
        allNumVoxels(ii,jj) = numVoxels; 
        
        %% 
        
        for kk = 1:numDts
            dtName = list_dtNames{kk};
            rmName = list_rmNames{kk};
            vw = viewSet(vw, 'curdt', dtName);
            
            % grab and store the measured tseries
            if ~isempty(roiCoords)
                [tSeriesTmp, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
                tSeries = tSeriesTmp{1}; 
                clear tSeriesTmp
            else
                tSeries = []; 
            end            
            cellTSeries{ii,jj,kk} = tSeries;
            
            % grab and store the rfParams
            % to do this we need to load the retModel
            rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
            vw = rmSelect(vw, 1, rmPath);
            model = viewGet(vw, 'rmmodel'); 
            params = viewGet(vw, 'rmparams');
            
            if ~isempty(roiCoords)
                rfParams = ff_rfParams(model, params, roiCoords); 
            else
                rfParams = []; 
            end
                       
            cellParams{ii,jj,kk} = params; 
            cellRfParams{ii,jj,kk} = rfParams;
                      
        end  
    end
end

%% this is where we assume there are only 2 dts
for ii = 1:numSubs
    for jj = 1:numRois
        
        rfParams1 = cellRfParams{ii,jj,1}; 
        rfParams2 = cellRfParams{ii,jj,2}; 
        params1 = cellParams{ii,jj,1};
        params2 = cellParams{ii,jj,2};
        
        
        if ~isempty(rfParams1)
            % what the first dt tseries would look like with:
            % second dt rfParams
            % its own (first) stim params
            prediction1      = ff_predictionCross(rfParams1, params1); 
            predictionCross1 = ff_predictionCross(rfParams2, params1);
            
            % what the second dt tseries would look like with:
            % first dt rfParams
            % its own (second) stim params
            prediction2      = ff_predictionCross(rfParams2, params2); 
            predictionCross2 = ff_predictionCross(rfParams1, params2); 
            
        else
            prediction1 = [];
            prediction2 = [];
            predictionCross1 = [];
            predictionCross2 = [];
        end
        
        cellPrediction{ii,jj,1}      = prediction1; 
        cellPrediction{ii,jj,2}      = prediction2; 
        cellPredictionCross{ii,jj,1} = predictionCross1; 
        cellPredictionCross{ii,jj,2} = predictionCross2;
        
    end
end

%% Linearize across subjects
% tSeries and tSeriesCross are numSubs x numRois x numRms
% Make 4 matrices that is the concatenation across subjects
%
for jj = 1:numRois
    
    % initializing
    nFrames1 = list_nFrames(1);
    nFrames2 = list_nFrames(2);
    numVoxelsAcrossSub = sum(allNumVoxels(:,jj,1));
    
    m1 = zeros(nFrames1, numVoxelsAcrossSub); 
    m2 = zeros(nFrames2, numVoxelsAcrossSub);
    pc1 = zeros(nFrames1, numVoxelsAcrossSub);
    pc2 = zeros(nFrames2, numVoxelsAcrossSub);
    
    indStart = 0; 
    indEnd = 0; 
    
    for ii = 1:numSubs
        nVoxels = allNumVoxels(ii,jj,1);
        indStart = indEnd + 1; 
        indEnd = indStart + nVoxels - 1; 
        
        measured1 = cellTSeries{ii,jj,1};
        measured2 = cellTSeries{ii,jj,2};
        predictedCross1 = cellPredictionCross{ii,jj,1};
        predictedCross2 = cellPredictionCross{ii,jj,2};
        predicted1 = cellPrediction{ii,jj,1};
        predicted2 = cellPrediction{ii,jj,2};
        
        m1(:,indStart:indEnd) = measured1; 
        m2(:,indStart:indEnd) = measured2; 
        pc1(:,indStart:indEnd) = predictedCross1; 
        pc2(:,indStart:indEnd) = predictedCross2; 
        p1(:,indStart:indEnd) = predicted1; 
        p2(:,indStart:indEnd) = predicted2; 
              
    end
    
    LTSeries1{jj} = m1; 
    LTSeries2{jj} = m2; 
    LPredictionCross1{jj} = pc1; 
    LPredictionCross2{jj} = pc2; 
    LPrediction1{jj} = p1; 
    LPrediction2{jj} = p2; 
    
end


%% Plotting the cross-validated variance explained
for jj = 1:numRois

    roiName = list_roiNames{jj};
    
    % assumptions here that there are two models.
    measured1 = LTSeries1{jj}; 
    measured2 = LTSeries2{jj};
    predictedCross1 = LPredictionCross1{jj};
    predictedCross2 = LPredictionCross2{jj};

    % initiate
    numVoxels = size(measured1, 2);  
    crossValidated = zeros(1, 2*numVoxels);

    % cross-validated      
    crossValidated(1:numVoxels)         = ff_varExp(measured1, predictedCross1); 
    crossValidated(numVoxels+1:end)     = ff_varExp(measured2, predictedCross2); 

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
    measured1 = LTSeries1{jj}; 
    measured2 = LTSeries2{jj};
    predicted1 = LPrediction1{jj};
    predicted2 = LPrediction2{jj};

    % initiate
    numVoxels = size(measured1, 2);  

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


%% plotting example time series
figure; hold on; 

