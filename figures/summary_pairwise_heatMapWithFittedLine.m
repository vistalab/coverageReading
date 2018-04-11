%% pairwise comparisons of 2 rm models
% Split off from summary_pairwise_individual because that code got too long
% This one specifically makes a heatMap and fits the bootstrapped (across subjects)
% mean line

close all; clear all; clc; 
 
%% modify here

% 'rory' | 'rkimle'
bookKeepingOption = 'rkimle';
if strcmp(bookKeepingOption, 'rory')
    bookKeeping_rory; 
elseif strcmp(bookKeepingOption, 'rkimle')
    bookKeeping;
end

% session list, see bookKeeping.m
% list_path = list_sessionRoryFace; 
list_path = list_sessionRet; 

% list subject index
list_subInds = [1:20]%[1:3 5:7] %[31:36 38:44]; % [1:12];
list_subIndsDescript = ' ';

% values to threshold the RM struct by
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2; 
vfc.cothreshceil = 1; 

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
%     'right_FFAFace_rl'
    'WangAtlas_V1v_left'
    'WangAtlas_V2v_left'
    'WangAtlas_V3v_left'
    'WangAtlas_hV4_left'
    'WangAtlas_VO1_left'
    'WangAtlas_VO2_left'
%     'right_FFAFace_rl'
    'lVOTRC'
%     'rVOTRC'
%     'cVOTRC'
%     'WangAtlas_V1d_left'
%     'WangAtlas_V2d_left'
%     'WangAtlas_V3d_left'
%     'WangAtlas_V3A_left'
%     'WangAtlas_V3B_left'
%     'WangAtlas_IPS0_left'
%     'WangAtlas_IPS1_left'
%     'LV1'
%     'LV2v'
%     'LV3v'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'lVOTRC'
    };

% ret model dts
list_dtNames = {
    'Words'
    'Words'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Words.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words CSS'
    'Words linear'
    };

% field to plot. Ex:  
% 'co': variance explained 
% 'ecc': eccentricity 
% 'sigma': effective size 
% 'sigma1': sigma major
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
%     'sigma'       : effective sigma
%     'sigma1'      : sigma major
%     'ecc'         : eccentricity
%     'co'          : variance explained 
%     'exponent'    : exponent
%     'betaScale'   : how much to scale the predicted tseries by
%     'meanMax'     : mean of the top 8 values
%     'meanPeaks'   : mean of the outputs of matlab's meanPeaks
list_fieldNames  = {
    'sigma'
    }; 

list_fieldDescripts = {
    'sigma effective'
    }; 

% which plots do we want? lots we can make ...
plot_fit = true; 

% transparency of the plots
alphaValue = 0.4; 

% colormap for histogram
% cmapValuesHist = colormap('pink');
% cmapValuesHist_tem = colormap('hot');
% cmapValuesHist = cmapValuesHist_tem(2:55, :); 
colormap(zeros(64,3)); % matlab has funky behavior where the size of this influences the size of all future colorbars...
cmapValuesHist = colormap('pink');

% location of the colorbar
% default: 'eastoutside'
% 'southoutside': 
cbarLocation = 'eastoutside';

%% end modification section

numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

% number of fields
numFields = length(list_fieldNames);

% rm descriptions
rm1Descript = list_rmDescripts{1}; 
rm2Descript = list_rmDescripts{2}; 

% initialize structs / matrices for mixed effects
subjectLines = cell(numSubs, numRois, numFields); % because pairwise

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, ...
    'list_path', list_path, 'bookKeeping', bookKeepingOption);

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

close all;

for jj = 1:numRois
    
    roiName = list_roiNames{jj};

    for ff = 1:numFields

        % field-specific properties
        fieldName = list_fieldNames{ff};
        fieldNameDescript = list_fieldDescripts{ff}; 

        if strcmp(fieldName, 'sigma1') 
            maxValue = vfc.sigmaMajthresh(2);
        elseif strcmp(fieldName, 'sigma')
            maxValue = vfc.sigmaEffthresh(2); 
        elseif strcmp(fieldName, 'ecc')
            maxValue = vfc.eccthresh(2); 
        elseif strcmp(fieldName, 'co')
            maxValue = 1; 
        elseif strcmp(fieldName, 'exponent')
            maxValue = 2; 
        elseif strcmp(fieldName, 'meanMax')
            maxValue = 20; 
        elseif strcmp(fieldName, 'meanPeaks')
            maxValue = 10; 
        elseif strcmp(fieldName, 'betaScale')
            maxValue = 5; 
        else
            error('Define the maxValue so we can normalize and fit the beta distribution.');
        end
        
        axisLims = [0 maxValue]; 
        BarData1 = [];
        BarData2 = [];

        for ii = 1:numSubs

            subInd = list_subInds(ii);
            
            % rmRois for different ret models
            rmroi1 = rmroiCellSameVox{ii,jj,1}; 
            rmroi2 = rmroiCellSameVox{ii,jj,2};

             if ~isempty(rmroi1)
                 
                % get the data
                x1 = eval(['rmroi1.' fieldName]);
                x2 = eval(['rmroi2.' fieldName]);

                %% For the mixed effects
                % fit a line for each subject
                % p = polyfit(x1, x2, 1);              
                % subjectLines{ii,jj,ff} = p;                 
                [B, BINT] = regress(x2', x1'); 
                b.slope     = B; 
                b.ci95      = BINT; 
                
                p = polyfit(x1, x2, 1);
                b.pintercept = p(1);
                b.pslope = p(2); 
                
                subjectLines{ii,jj,ff} = b; 
                
                %% concatenate
                BarData1 = [BarData1, x1];
                BarData2 = [BarData2, x2];
           
            end
        end % end loop over subjects
        
        %% mixed effects: fit a line to individual subjects
        slopes = nan(1, numSubs);   
        slopesp = nan(1,numSubs);
        interceptsp = nan(1,numSubs);
        
        for ii = 1:numSubs
            b = subjectLines{ii,jj,ff}; 
            if ~isempty(b)
                slopes(ii) = b.slope; 
            end
        end

        % the calculating
        slopes(isnan(slopes)) = []; 
        
        numbs = 1000; 
        [ci, bootstat] = bootci(numbs, @mean, slopes);
        meanSlope = mean(bootstat); 
        
        
        %% 3d histogram heat map
        figure; hold on; 
        numHistBins = 50; 
        Ctrs = cell(1,2); 

        if strcmp(fieldName, 'sigma1') % sigma major
            Ctrs{1} = linspace(0, vfc.sigmaMajthresh(2), numHistBins); 
            Ctrs{2} = linspace(0, vfc.sigmaMajthresh(2), numHistBins);
        elseif strcmp(fieldName, 'sigma') % effective sigma
            Ctrs{1} = linspace(0, vfc.sigmaEffthresh(2), numHistBins);          
            Ctrs{2} = linspace(0, vfc.sigmaEffthresh(2), numHistBins); 
        elseif strcmp(fieldName, 'ecc')
            Ctrs{1} = linspace(0, vfc.eccthresh(2), numHistBins);          
            Ctrs{2} = linspace(0, vfc.eccthresh(2), numHistBins); 
        elseif strcmp(fieldName, 'co')
            Ctrs{1} = linspace(0, 1, numHistBins); 
            Ctrs{2} = linspace(0, 1, numHistBins);
        elseif strcmp(fieldName, 'exponent')
            Ctrs{1} = linspace(0,2, numHistBins);
            Ctrs{2} = linspace(0,2, numHistBins);
        elseif strcmp(fieldName, 'meanMax')
            Ctrs{1} = linspace(0,20, numHistBins);
            Ctrs{2} = linspace(0,20, numHistBins);
        elseif strcmp(fieldName, 'meanPeaks');f
            Ctrs{1} = linspace(0,10, numHistBins);
            Ctrs{2} = linspace(0,10, numHistBins);
        elseif strcmp(fieldName, 'betaScale')
            Ctrs{1} = linspace(0,5, numHistBins);
            Ctrs{2} = linspace(0,5, numHistBins); 
        else
            error('Need to define bin centers')
        end

        hist3([BarData1' BarData2'],'Ctrs', Ctrs)
        set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')

        % identityLine goes above everything else so that it can be seen
        npoints = 100; 
        maxZ = max(get(gca, 'ZLim'));
        zVec = maxZ*ones(1, npoints); 
        plot3(linspace(0, maxValue, npoints), linspace(0, maxValue, npoints), zVec, ...
            '--', 'Color', [0 0 1], 'LineWidth',2)

        % fitted line goes above everything else
        bx = linspace(0, maxValue, npoints);
        by = bx * meanSlope; 
        bylower = bx * ci(1); 
        byupper = bx * ci(2);
        
        if plot_fit
            plot3(bx, by, zVec, '-', 'Linewidth',3, 'color', [0 1 1])
            plot3(bx, bylower, zVec, '-', 'Linewidth',.1, 'color', [0 .7 .7])
            plot3(bx, byupper, zVec, '-', 'Linewidth',.1, 'color', [0 .7 .7])
        end
            
        axis square;         
        colormap(cmapValuesHist); 
        c = colorbar;
        set(c, 'location', cbarLocation)
        caxis([0 maxZ/5]);

        set(gca, 'xlim', axisLims);
        set(gca, 'ylim', axisLims);

        % axes and title
        xlabel(rm1Descript)
        ylabel(rm2Descript)
        titleName = {
            [ff_stringRemove(roiName, '_rl') '. ' fieldName]; 
            ['slope: ' num2str(meanSlope)];
            ['ci: ' num2str(ci')];            
            };
        title(titleName, 'FontWeight', 'Bold')
      
               
    end % loop over fields

end % loop over rois
