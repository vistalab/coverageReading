%% create the dice coefficient matrix
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInds = 1:20;
roiName = {'lVOTRC-threshByWordModel'};

vfc = ff_vfcDefault;
vfc.cothresh = 0; 
contourLevel = 0.5; 

% Specify the retinotopy model
% the first one will go on the row
% the second one will go on the column

list_dtNames = {
    'Words1'
    'Words2'
    };

list_rmNames = {
    'retModel-Words1-css.mat'
    'retModel-Words2-css.mat'
    };



%% get rmroicell
rmroiCell = ff_rmroiCell(subInds, roiName, list_dtNames, list_rmNames); 

%% initialize and calculate
numSubs = length(subInds);
diceMatrix = zeros(numSubs, numSubs); 

rfcovCell = cell(numSubs,2); 

%% get each subject's RFcov matrix for each of the ret models
% do it upfront because this is time-consuming for all-pairwise comparisons

for ii = 1:numSubs
    RFcov1 = rmPlotCoveragefromROImatfile(rmroiCell{ii, 1, 1}, vfc); 
    RFcov2 = rmPlotCoveragefromROImatfile(rmroiCell{ii, 1, 2}, vfc); 
    
    rfcovCell{ii, 1} = RFcov1; 
    rfcovCell{ii, 2} = RFcov2; 
end

%% calculate all pairwise comparisons

for rr = 1:numSubs
    for cc = 1:numSubs       
        dc = ff_coverage_diceCoefficient(rfcovCell{rr,1}, rfcovCell{cc,2}, contourLevel, contourLevel); 
        diceMatrix(rr,cc) = dc; 
    end
end

%% subsets of the matrix
% the diagonal elements
diceDiag = diag(diceMatrix);
diceDiagNonNans = diceDiag(~isnan(diceDiag));

% the non diagonal elements (upper and lower)
% assign nans to the diagonal. then linearize and remove the nans
diceNonDiag = diceMatrix; 
for ii = 1:numSubs
    diceNonDiag(ii,ii) = nan; 
end
l_diceNonDiag = diceNonDiag(:);
l_diceNonDiag(isnan(diceNonDiag)) = []; 

% lower triangular, not including 
diceLowerTriangle = diceMatrix; 
for ii = 1:numSubs
    for jj = 1:numSubs
        % assign nan to the upper diagonal
        if ii < jj
            diceLowerTriangle(ii,jj) = nan; 
        end
    end
end
l_diceLowerTriangle = diceLowerTriangle(:) ;
l_diceLowerTriangle(isnan(diceLowerTriangle)) = []; 


%% visualize the matrix
figure; 
imagesc(diceMatrix)

% color bar
colorbar
caxis([0 1])


% title
titleName = {
    ['Dice coefficient matrix. ' ff_stringRemove(roiName{1}, '_rl')];
    ['Row: ' list_dtNames{1}];
    ['Column: ' list_dtNames{2}];
};
title(titleName, 'fontweight', 'bold')

%% get some representative numbers

% average of the diagonal
avgDiag = mean(diceDiagNonNans)
stdDiag = std(diceDiagNonNans)
steDiag = stdDiag / sqrt(length(diceDiagNonNans))

% average of lower triangle
avgTriangularLower = mean(l_diceLowerTriangle)
stdTriangularLower = std(l_diceLowerTriangle)
steTriangularLower = stdTriangularLower / sqrt(length(l_diceLowerTriangle))

% average of nonDiagonal elements
avgNonDiagonal = mean(l_diceNonDiag)
stdNonDiagonal = std(l_diceNonDiag)
steNonDiagonal = stdNonDiagonal/ sqrt(length(l_diceNonDiag))
medNonDiagonal = median(l_diceNonDiag)
rangeNonDiagonal = range(l_diceNonDiag)

%% save
ff_dropboxSave

%% average within-subject dice coefficient. 
% subject 15 and 18 are either missing a FOV for one of the two runs

diceDiagNonNansNonZeros = diceDiagNonNans; 
diceDiagNonNansNonZeros(diceDiagNonNansNonZeros == 0) = [];

avgWithinSubjectDice = mean(diceDiagNonNansNonZeros)

%% average between subject dice coefficient
