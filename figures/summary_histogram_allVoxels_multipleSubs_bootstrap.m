%% plot pRF distributions over many subjects (sizes, centers, varExp)
% but subjects have different roi sizes, so we take numSamples with
% replacement each subject nboot times

clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 1:20;
list_path = list_sessionRet; 

roiName = 'combined_VWFA_rl';
dtName = 'Words';
rmName = 'retModel-Words-css.mat';

% number of samples to take in each subject
numSamples = 200;


% prf field
% co, ecc, sigma, exponent
fieldToEval = 'ecc';
numBins = 10;

% vfc threshold
vfc = ff_vfcDefault; 

%% define things
numSubs = length(list_subInds);
D = zeros(numSamples, numSubs);
subsToRemove = [];

%% do things

for ii = 1:numSubs

    subInd = list_subInds(ii);
    subInitials = list_sub{subInd};
    dirVista = list_path{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista);
    vw = initHiddenGray;

    % load roi and ret model
    roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
    [vw, roiExists] = loadROI(vw,roiPath, [],[],1,0);

    rmPath = fullfile(dirVista,'Gray', dtName, rmName);
    rmExists = exist(rmPath, 'file');

    if rmExists && roiExists
        vw = rmSelect(vw,1,rmPath);
        vw = rmLoadDefault(vw);

        tem = rmGetParamsFromROI(vw);
        tem.subInitials = subInitials; 
        rmroi = ff_thresholdRMData(tem, vfc);
        subData = eval(['rmroi.' fieldToEval]);
        
        % the sampling! 
        if ~isempty(subData)
            samp = datasample(subData, numSamples);
            D(:,ii) = samp; 
        else
            % NO VOXELS PASS THRESHOLD
            % so do nothing for now.
            % remove these rows of D at the end
            subsToRemove = [subsToRemove, ii];
        end
        
    end % if rm and roi exists

end

% remove rows of D if necessary
if ~isempty(subsToRemove)
    D(:,subsToRemove) = []; 
end

   
%% plotting
close all; 
figure; 

% linearize
D_lin = D(:);

% N is position of bar centers

[N,X] = hist(D_lin,numBins);
Nnorm = N./sum(N);
bar(X,Nnorm,  'facecolor', [.5 .5 .5], 'linewidth',2)

% plot and print median
dataMedian = median(D_lin)
hold on; 
plot([dataMedian dataMedian], get(gca,'ylim'), 'LineWidth', 2.5, 'Color', [.8 .2 .2])

% labels
xlabel(['pRF ' fieldToEval])
ylabel('Count. Normalized')

% title
titleName = {
    ['pRF Distribution Normalized. ' fieldToEval]
    [ff_stringRemove(roiName, '_rl') '. Stim: ' dtName]
    ['n = ' num2str(numSubs)]
    };
title(titleName, 'fontWeight', 'Bold')

% plot properties
grid on;

% save
ff_dropboxSave;




