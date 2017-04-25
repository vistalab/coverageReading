%% pairwise comparisons of 2 rm models

close all; clear all; clc; 
bookKeeping; 

%% modify here

% session list, see bookKeeping.m
list_path = list_sessionRet; 

% list subject index
list_subInds = 1:20% 1:20;
list_subIndsDescript = '1:20';

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
    'lVOTRC-threshByWordModel'
    };

% ret model dts
list_dtNames = {
    'Words1'
    'Words2'
    };

% ret model names
list_rmNames = {
    'retModel-Words1-css.mat'
    'retModel-Words2-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words1 '
    'Words2'
    };

% values to threshold the RM struct by
%   vfc.cothresh
%   vfc.eccthresh
%   vfc.sigthresh
vfc.cothresh = 0; 
vfc.eccthresh = [0 15];
vfc.sigthresh = [0 30];

% colors
list_colors = list_colorsPerSub;

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
list_fieldNames  = {
    'sigma1'
    'ecc'
    'co'
%     'exponent'
    }; 

list_fieldDescripts = {
    'sigma major'
    'eccentricity'
    'varExp'
%     'exponent'
    }; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/rmComparison';

% which plots do we want? lots we can make ...
plot_individualPlotsForIndividuals = 0 ;
plot_fixedEffects = 1; 
plot_subjectMedian = true; 


%% end modification section

% number of subjects
numSubs = length(list_subInds);

% number of rois
numRois = length(list_roiNames);

% number of fields
numFields = length(list_fieldNames);

% rm descriptions
rm1Descript = list_rmDescripts{1}; 
rm2Descript = list_rmDescripts{2}; 

% initialize medians
subjectMedians = zeros(numSubs, numRois, 2, numFields);

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% Threshold and get identical voxels for each subject
% In comparing ret models, the collection of voxels may not be the same
% because of the thresholding. In this cell we redefine the rmroi
rmroiCellSameVox = cell(size(rmroiCell));

for jj = 1:numRois
    for ii = 1:numSubs        
        % get identical voxels for each subject's roi over all ret models
        D = rmroiCell(ii,jj,:);
        rmroiCellSameVox(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
    end
end

%% plot the fixed effects -- combine all voxels over subjects

for jj = 1:numRois
    
    roiName = list_roiNames{jj};

    for ff=1:numFields

        % field name
        fieldName = list_fieldNames{ff};
        fieldNameDescript = list_fieldDescripts{ff}; 
        figure; 
        titleName = [ff_stringRemove(roiName, '_rl') '. ' fieldName];
        title(titleName, 'FontWeight', 'Bold')
        hold on; 
        
        BarData1 = [];
        BarData2 = [];

        for ii = 1:numSubs

            subInd = list_subInds(ii);
            subjectColor = list_colors(subInd,:);

            % rmRois for different ret models
            rmroi1 = rmroiCellSameVox{ii,jj,1}; 
            rmroi2 = rmroiCellSameVox{ii,jj,2};

            % get the data
            x1 = eval(['rmroi1.' fieldName]);
            x2 = eval(['rmroi2.' fieldName]);
            
            % store the medians for the fixed effects plot
            subjectMedians(ii,jj,1,ff) = median(x1);
            subjectMedians(ii,jj,2,ff) = median(x2);

            % concatenate
            BarData1 = [BarData1, x1];
            BarData2 = [BarData2, x2];

            % individual dots
            plot(x1, x2, '.', 'Color',subjectColor); 
            hold on; 

        end % end loop over subjects

        % plot the medians on top so that they are clearly visible
        % Have to loop over subjects because of colors
        for ii = 1:numSubs
            subInd = list_subInds(ii);
            subjectColor = list_colors(subInd,:);
            medx = subjectMedians(ii,jj,1,ff);
            medy = subjectMedians(ii,jj,2,ff);
            plot(medx, medy, 'o', ...
                'MarkerEdgeColor', 'k', ...
                'MarkerFaceColor', subjectColor, ...
                'MarkerSize',10, ...
                'LineWidth', 3.5); 
            
        end % loop over subjects
        
        %% plot properties -- scatter plot with all subjects
        grid on; 
        xlabel(rm1Descript, 'FontWeight', 'Bold')
        ylabel(rm2Descript, 'FontWeight', 'Bold')
        
        % save
        grid on; 
        ff_identityLine(gca, [.5 .5 .5]);
        ff_dropboxSave; 
        
        %% bar plot -- need to functionalize
        rm1 = list_rmDescripts{1};
        rm2 = list_rmDescripts{2};
        differenceDescript = [rm2 ' minus ' rm1];

        figure; 
        numBins = 10; 
        Bar = BarData2 - BarData1;

        [N,X] = hist(Bar,numBins);
        Nnorm = N./sum(N);
        bar(X,Nnorm,  'facecolor', [.5 .5 .5], 'linewidth',2)

        % statistic -- mean or median
        stat = median(Bar);

        % labels
        xlabel(['pRF ' fieldName '. ' differenceDescript])
        ylabel('Count. Normalized')

        % title
        titleName = {
            ['pRF Distribution Normalized. ' fieldNameDescript]
            [ff_stringRemove(roiName, '_rl') '. ' differenceDescript]
            ['n = ' num2str(numSubs)]
            };
        title(titleName, 'fontWeight', 'Bold')

        % plot properties
        grid on;

        % draw a red line at data median or mean
        line([stat stat], get(gca, 'YLim'), 'Color', [.9 .2 .4], 'LineWidth',3)

        % save
        ff_dropboxSave;

    end % loop over fields

end % loop over rois

%% print out and save subject legend
ff_legendSubject(list_subInds)
title(['Legend: ' list_subIndsDescript])
ff_dropboxSave


