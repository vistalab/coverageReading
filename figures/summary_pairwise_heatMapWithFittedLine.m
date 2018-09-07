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
% list_subInds = [31:36 38:44]; % Hebrew
list_subInds = [1:20]; %[1:3 5:7] %[31:36 38:44]; % [1:12];
list_subIndsDescript = ' ';

% values to threshold the RM struct by
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2; 
vfc.cothreshceil = 1; 

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
%     'WangAtlas_V1d_left'
%     'WangAtlas_V2d_left'
%     'WangAtlas_V3d_left'
%     'WangAtlas_V3A_left'
%     'WangAtlas_V3B_left'
%     'WangAtlas_IPS0_left'
%     'WangAtlas_IPS0_right'
    'WangAtlas_V1v_right'
    'WangAtlas_V2v_right'
    'WangAtlas_V3v_right'
    'WangAtlas_hV4_right'
    'WangAtlas_VO1_right'
    'rVOTRC'
%     'WangAtlas_VO2_left'
%     'right_FFAFace_rl'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LhV4_rl'
%     'lVOTRC'
%     'rVOTRC'
%     'cVOTRC'
%     'WangAtlas_V1v_right'
%     'WangAtlas_V2v_right'
%     'WangAtlas_V3v_right'
%     'WangAtlas_hV4_right'
%     'WangAtlas_VO1_right'
%     'rVOTRC'
%     'WangAtlas_V1d_left'
%     'WangAtlas_V2d_left'
%     'WangAtlas_V3d_left'
%     'WangAtlas_V3A_left'
%     'WangAtlas_V3B_left'
%     'WangAtlas_IPS0_left'
%     'WangAtlas_IPS1_left'
%     'WangAtlas_LO1'    
%     'WangAtlas_LO2'   
    };

% ret model dts
list_dtNames = {
    'Words'
    'Checkers'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words'
    'Checkers'
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
%     'co'
    'ecc'
%     'sigma'
%     'ph'
    }; 

list_fieldDescripts = {
%     'variance explained'
    'eccentricity'
%     'sigma'
%     'polar angle'
    }; 

% which plots do we want? lots we can make ...
plot_fit = true; % plotting the across-subject bootstrapped line w/ CIs

% transparency of the plots
alphaValue = 0.4; 

% colormap for histogram
% cmapValuesHist = colormap('pink');
% cmapValuesHist_tem = colormap('hot');
% cmapValuesHist = cmapValuesHist_tem(2:55, :); 
colormap(zeros(64,3)); % matlab has funky behavior where the size of this influences the size of all future colorbars...
cmapValuesHist = colormap('pink');
close; 

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

% initialize struct for calculating the percentage of voxels above the
% identity line
percentAbovePooled = zeros(numRois, numFields);
percentAboveSubs = zeros(numSubs, numRois, numFields);
A = cell(numFields*numRois, 5);

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
        elseif strcmp(fieldName, 'x0') || strcmp(fieldName, 'y0')
            maxValue = vfc.fieldRange;
        elseif strcmp(fieldName, 'ph')
            maxValue = 2*pi; 
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

                % shift so that the smallest value is 0
                if strcmp(fieldName, 'ph')
                    x1 = x1 + pi; 
                    x2 = x2 + pi;
                end
                
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
                
                %% the percentage of voxels above the identityLine
                perAbove = sum(x2 > x1) / length(x2);
                percentAboveSubs(ii,jj,ff) = perAbove; 
                
                %% concatenate
                BarData1 = [BarData1, x1];
                BarData2 = [BarData2, x2];
           
            end
        end % end loop over subjects
        
        %% mixed effects: fit a line to individual subjects
        slopes = nan(1, numSubs);   
        slopesp = nan(1,numSubs);
        interceptsp = nan(1,numSubs);
        percents = percentAboveSubs(:,jj,ff);
        
        for ii = 1:numSubs
            b = subjectLines{ii,jj,ff}; 
            if ~isempty(b)
                slopes(ii) = b.slope; 
            end
        end

        % the calculating. nan will cause bootci to error
        slopes(isnan(slopes)) = []; 
        percents(isnan(percents)) = [];
        
        % table things. 
        % (1)roiName (2)fieldName (3) ciLow (4)ciHigh (5)mean
        tind = (jj-1)*numFields + ff; 
        
        
        if numSubs > 1
            numbs = 1000; 
            [ci, bootstat] = bootci(numbs, @mean, slopes);
            meanSlope = mean(bootstat); 
            
            % table things for percent above identityLine
            [ciPer, bootstatPer] = bootci(numbs, @mean, percents);
            A{tind,1} = ff_stringRemove(roiName, '_rl');
            A{tind,2} = fieldName;
            A{tind,3} = ciPer(1);
            A{tind,4} = ciPer(2);
            A{tind,5} = mean(bootstatPer);
            
        else
            meanSlope = nan; 
            ci = nan; 
        end
                
        %% calculations related to the percentage above the identityLine
        percentabove = sum(BarData2 > BarData1) / length(BarData1);
        percentAbovePooled(jj,ff) = percentabove;
        
        % properties related to both types of scatter plots
        % coloring by number of voxels or percentage of voxels
        npoints = 100; 
        
        %% 3d histogram heat map -- absolute number of voxels
        figure; hold on; 
        ff_histogramHeat(BarData1, BarData2, maxValue, maxValue, 50);
        numVoxels = length(BarData1); 

        maxZ = max(get(gca, 'ZLim'));
        zVec = maxZ*ones(1, npoints); 

        % fitted line goes above everything else
        if numSubs > 1 
            bx = linspace(0, maxValue, npoints);
            by = bx * meanSlope; 
            bylower = bx * ci(1); 
            byupper = bx * ci(2);

            if plot_fit
                % fitColor = [1 1 0]; % yellow
                fitColor = [0 1 1]; % cyan
                % fitColor = [0 0 1]; % blue
                plot3(bx, by, zVec, ':', 'Linewidth',3, 'color', fitColor)
                plot3(bx, bylower, zVec, '-', 'Linewidth',.1, 'color', fitColor)
                plot3(bx, byupper, zVec, '-', 'Linewidth',.1, 'color', fitColor)
            end           
        end

        % axes and title
        xlabel(rm1Descript)
        ylabel(rm2Descript)
        titleName = {
            [ff_stringRemove(roiName, '_rl') '. ' fieldName]; 
            ['slope: ' num2str(meanSlope)];
            ['ci: ' num2str(ci')];
            [num2str(numVoxels) ' voxels']
            };
        title(titleName, 'FontWeight', 'Bold')

    end % loop over fields

end % loop over rois

% percent above identityLine, pooled over subjects ... print out the 
% percentAbovePoooled

% Percent above identity line. Bootstrapped across subjects (mixed effects)
{   ['Percent of voxels above identity line. ']
    ['Bootstrapped across subjects']
    [rm2Descript ' vs. ' rm1Descript]
}
T = cell2table(A, 'VariableNames', {'roiName', 'fieldName', 'ciLow', 'ciHigh', 'MeanPercent'});
