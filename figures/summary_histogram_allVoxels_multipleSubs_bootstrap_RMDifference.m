%% TODO FINISH

%% plot pRF distributions over many subjects (sizes, centers, varExp)
% but subjects have different roi sizes, so we take numSamples with
% replacement each subject nboot times

clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 1:20%1:20;
list_path = list_sessionRet; 

list_roiNames = {
    'left_VWFA_rl'
    };

list_dtNames = {
    'Words'
    'Checkers'
    };

list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% number of samples to take in each subject
numSamples = 200;

% prf field
fieldToEval = 'co';
numBins = 10;

% vfc threshold
vfc = ff_vfcDefault();

% use the same voxels?
useSameVoxels = false; 

%% define things
numSubs = length(list_subInds);
D = zeros(numSamples, numSubs);

%% get the rmroi cell
rmroiCell_tem = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);
rmroiCell_tem = squeeze(rmroiCell_tem);
rmroiCell = cell(size(rmroiCell_tem));

%% threshold the rmroi cell
% justification: the variance explained of the voxels we include in the
% coverage plot

if useSameVoxels

    for ii = 1:numSubs
        rmroiSub = rmroiCell_tem(ii,:);
        rmroiCellSameVox = ff_rmroiGetSameVoxels(rmroiSub, vfc);
        rmroiCell(ii,:) = rmroiCellSameVox;
    end
    
else
    
    rmroiCell = rmroiCell_tem; 
end

% rmroiCellSameVox = ff_rmroiGetSameVoxels(rmroiCell, vfc)

%%

for ii = 1:numSubs
   
    rmroi_1 = rmroiCell{ii,1};
    rmroi_2 = rmroiCell{ii,2};
    
    r1 = eval(['rmroi_1.' fieldToEval]);
    r2 = eval(['rmroi_2.' fieldToEval]);
    dif = r1 - r2; 
    
    % sample 200 and fill in D
    samp = datasample(dif, numSamples)';
    D(:,ii) = samp; 
    
    
end


   
%% plotting
% HISTOGRAM
close all; 
figure; 

% linearize
D_lin = D(:);
dataMedian = median(D_lin)

% N is position of bar centers

[N,X] = hist(D_lin,numBins);
Nnorm = N./sum(N);
bar(X,Nnorm,  'facecolor', [.5 .5 .5], 'linewidth',2)

% labels
xlabel(['pRF ' fieldToEval])
ylabel('Count. Normalized')

if strcmp(fieldToEval,'co')
    set(gca, 'xlim', [-1 1]);
end

% red line at distribution median
line([dataMedian dataMedian], get(gca,'ylim'), 'Color', [.8 .2 .2], 'linewidth',3)

% title
titleName = {
    ['pRF Distribution Normalized. ' fieldToEval]
    [ff_stringRemove(list_roiNames{1}, '_rl') '. Stim: ' list_dtNames{1} ' minus ' list_dtNames{2}]
    ['n = ' num2str(numSubs)]
    };
title(titleName, 'fontWeight', 'Bold')

% plot properties
grid on;

% save
ff_dropboxSave;


