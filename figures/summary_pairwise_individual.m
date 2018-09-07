%% pairwise comparisons of 2 rm models
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
list_path = list_sessionRet; 

% list subject index
list_subInds = 1:20; %[31:36 38:44]%; 1:12 %[1:3 5:7]; 
list_subIndsDescript = ' ';

% values to threshold the RM struct by
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2;
vfc.cothreshceil = 1; 

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LhV4_rl'
%     'lVOTRC'
%     'WangAtlas_V1v_left'
%     'WangAtlas_V2v_left'
%     'WangAtlas_V3v_left'
%     'WangAtlas_hV4_left'
%     'WangAtlas_VO1_left'
    'lVOTRC'
%     'WangAtlas_VO2.mat'
%     'WangAtlas_VO2_left.mat'
%     'temporalblob'
%     'Benson_V1_lessThan_20'
%     'Benson_V1_greaterThan_20'
%     'LV2d_rl'
%     'LV3d_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'   
%     'LV1-threshBy-WordsOrCheckers-co0p2'
%     'lVOTRC-threshBy-Checkers-co0p2'
%     'lVOTRC-threshBy-Words_HebrewOrWords_English-co0p05.mat'
%     'WangAtlas_V1'
%     'WangAtlas_hV4'
%     'lVOTRC-threshBy-CheckersAndCheckersTestRetest-co0p2'
    };

% ret model dts
list_dtNames = {
    'Words'
    'Checkers'
%     'NoScaling'
%     'ScaleFactor2'
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

% HOW TO COLOR. 
%    list_colors = list_colorsPerSub;  
%    Color each voxel by the subject
% 
%    list_colors = repmat([.8 0 .2], length(list_sub),1);
%    Every voxel gets the same color
%
%    list_colors = [];
%    Color the voxel by the difference in theta. 
list_colors = list_colorsPerSub;
% colorMethod. 'bySubject' | 'uniform' | 'byThetaShift'
colorMethod = 'bySubject'; 

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
list_fieldNames  = {
%     'co'
%     'sigma2'
    'ecc'
%     'co'
%     'exponent'
    }; 

list_fieldDescripts = {
%     'varExp'
%     'sigma minor'
    'eccentricity'
%     'varExp'
%     'exponent'
    }; 

% if list_colors is empty and we color by the theta difference, specify
% color range and values here.
%
% the range over which color bar
cmapRange = [0 pi]; 

% the colorbar values
% cmapValues = cool_hotCmap(0,128);
% cmapValues = hsvCmap(0,128);
cmapValues = flipud(jetCmap(0,128));

% which plots do we want? lots we can make ...
plot_scatter = true; 
plot_heat = false; 
plot_fitFixed = false; % fit a line to the pooled voxels
plot_fitMixed = true; % bootstrapped CI from the line fit to individual subjects

% transparency of the plots
alphaValue = 0.4; 

% colormap for histogram
cmapValuesHist = colormap('pink');

%% end modification section

numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

% number of fields
numFields = length(list_fieldNames);

% rm descriptions
rm1Descript = list_rmDescripts{1}; 
rm2Descript = list_rmDescripts{2}; 

% initialize structs / matrices for mexcied effects
subjectMedians = zeros(numSubs, numRois, 2, numFields);
subjectLines_regress = cell(numSubs, numRois, numFields); 
subjectLines_poly = cell(numSubs, numRois, numFields);

% initialize struct used for hypothesis testing
hypothesis = cell(numRois, numFields);

% initialize for counting voxels
voxelsPerSub = zeros(numSubs, numRois, numRms); 
voxelsPerSubNoThresh = zeros(size(voxelsPerSub)); 

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

% counting voxels
for ii = 1:numSubs
    for jj = 1:numRois
        for kk = 1:numRms
            
            rmUnthresh = rmroiCell{ii,jj,kk};
            rm = rmroiCellSameVox{ii,jj,kk};
            
            numVoxUnthresh = length(rmUnthresh.co);
            numVox = length(rm.co);
            
            voxelsPerSubNoThresh(ii,jj,kk) =  numVoxUnthresh;
            voxelsPerSub(ii,jj,kk) =  numVox;
            
        end
    end       
end

%% plot the fixed effects -- combine all voxels over subjects
close all;

for jj = 1:numRois
    
    %%
    roiName = list_roiNames{jj};

    for ff = 1:numFields

        % field-specific properties
        fieldName = list_fieldNames{ff};
        fieldNameDescript = list_fieldDescripts{ff}; 

        if strcmp(fieldName, 'sigma1') || strcmp(fieldName, 'sigma2')
            maxValue = vfc.sigmaMajthresh(2);
        elseif strcmp(fieldName, 'sigma')
            maxValue = vfc.sigmaEffthresh(2); 
        elseif strcmp(fieldName, 'ecc')
            maxValue = vfc.eccthresh(2); 
        elseif strcmp(fieldName, 'co')
            maxValue = 1; 
        elseif strcmp(fieldName, 'exponent')
            maxValue = 2; 
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
                % the medians
                subjectMedians(ii,jj,1,ff) = median(x1);
                subjectMedians(ii,jj,2,ff) = median(x2);
                
                % fit a line for each subject
                p = polyfit(x1, x2, 1);              
                [B, BINT] = regress(x2', x1'); 
                b.slope     = B; 
                b.ci95      = BINT; 
                subjectLines_regress{ii,jj,ff} = b; 
                subjectLines_poly{ii,jj,ff} = p; 
                              
                %% concatenate
                BarData1 = [BarData1, x1];
                BarData2 = [BarData2, x2];

                % theta values if we want to color by theta difference                    
                % how to color 
                switch colorMethod
                    case 'bySubject'
                        voxelColor = list_colors(subInd,:);
                    case 'byThetaShift'
                        fieldDiffOver = abs(rmroi2.ph - rmroi1.ph);
                        ldata = ff_polarAngleBetween0AndPi(fieldDiffOver);
                        voxelColor = ff_colormapForValues(ldata, cmapValues, cmapRange);
                        colormap(cmapValues);
                        colorbar;
                        caxis(cmapRange)
                    case 'uniform'
                        voxelColor = repmat([.8 0 .1], length(x1),1); 
                end
                
                xp = linspace(0, maxValue); 
                if plot_scatter
                    if ii == 1
                        figure; hold on; 
                    end
                    % individual dots
                    scatter(x1, x2, 100*ones(1,length(x1)), voxelColor, 'filled', ...
                        'linewidth',1)
                    alpha(alphaValue);
                    hold on;
                    
                    % plot the line for each subject
                    % sanity checking ... and comparing regress vs. poly
                    yp = b.slope * xp;
                    plot(xp, yp, 'color', voxelColor)
                    
                    
                end
            end
        end % end loop over subjects
        
        % plot properties -- scatter plot with all subjects
        if plot_scatter
            grid on; 
            xlabel(rm1Descript, 'FontSize', 14)
            ylabel(rm2Descript, 'FontSize', 14)
            set(gca,'fontweight', 'bold')
            axis([0 maxValue 0 maxValue])
            axis square

            % identity
            ff_identityLine(gca, [.5 .5 .5]);  

            titleName = {
                [roiName '. ' fieldNameDescript]
            };
            title(titleName, 'fontweight', 'bold')
        end
          
        %% 3d histogram heat map
        if plot_heat
            figure; hold on; 
            numHistBins = 50; 
            Ctrs = cell(1,2); 

            if strcmp(fieldName, 'sigma1') || strcmp(fieldName, 'sigma2') % sigmas
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
            else
                error('Need to define bin centers')
            end

            hist3([BarData1' BarData2'],'Ctrs', Ctrs)
            set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')

            % identityLine goes above everything else so that it can be seen
            maxZ = max(get(gca, 'ZLim'));
            maxX = max(get(gca, 'Xlim'));
            plot3(linspace(0, maxX, 50), linspace(0, maxX, 50), maxZ*ones(1,50), ...
                '--', 'Color', [0 0 1], 'LineWidth',2)
            
            axis square;         
            colormap(cmapValuesHist); 
            colorbar;
            caxis([0 maxZ/5]);

            set(gca, 'xlim', [0 maxValue]);
            set(gca, 'ylim', [0 maxValue]);
            
            % axes and title
            xlabel(rm1Descript)
            ylabel(rm2Descript)
            titleName = {
                [ff_stringRemove(roiName, '_rl') '. ' fieldNameDescript] 
                };
            title(titleName, 'FontWeight', 'Bold')
        end
        
        
        %% mixed effects: fit a line to individual subjects
        if plot_fitMixed
            slopes = zeros(1, numSubs); 
            figure; hold on;
            bx = linspace(0, maxValue); 
            
            for ii = 1:numSubs
                b = subjectLines_regress{ii,jj,ff}; 
                slopes(ii) = b.slope;                                             
            end
            
            % the calculating
            [ci, bootstat] = bootci(1000, @mean, slopes);
            
            % the plotting 
            scatter(BarData1, BarData2, 'filled', ...
                'markerfacecolor', [0.65, 0.47, 0.52]); 
            alpha(0.3); 
            axis([0 maxValue 0 maxValue]); 
            ff_identityLine(gca, [.5 .5 .5])
            
            meanSlope = mean(bootstat); 
            plot(bx, meanSlope* bx, 'r-', 'Linewidth',2)
            plot(bx, bx*ci(1), 'r-', 'Linewidth',.5)
            plot(bx, bx*ci(2), 'r-', 'Linewidth',.5)
            

            grid on; 
            axis square; 
            xlabel(rm1Descript, 'fontweight', 'bold')
            ylabel(rm2Descript, 'fontweight', 'bold')
            
            titleName = {
                'Mixed effects. Slope subject mean'
                roiName
                ['slope: ' num2str(meanSlope)]
                ['ci: (' num2str(ci') ')']
                };
            title(titleName, 'fontweight', 'bold')
            
        end
        
        %% fixed effects: fitting a line to the pooled data
        if plot_fitFixed
            ppooled = polyfit(BarData1, BarData2, 1); 
            pooledx = linspace(0, maxValue); 
            pooledy = polyval(ppooled, pooledx);

            [B, BINT] = regress(BarData2', BarData1'); 
            bx = linspace(0, maxValue); 
            by = bx * B; 
            bylower = bx * BINT(1); 
            byupper = bx * BINT(2); 

            figure; hold on; 
            scatter(BarData1, BarData2, 'filled'); alpha(0.3); 
            axis([axisLims axisLims]); 

            % identity line
            ff_identityLine(gca, [.5 .5 .5]); 

            % plot the fitted line
            % plot(pooledx, pooledy, 'r-') % the fit from polyfit
            plot(bx, by, 'r-', 'linewidth',2)

            % plot the confidence interval of the fitted line
            plot(bx, bylower, '-')
            plot(bx, byupper, '-')

            titleName = {
                'Line fit to pooled data'
                [ff_stringRemove(roiName, '_rl') '. ' fieldNameDescript]
                ['slope: ' num2str(B)]
                ['ci: (' num2str(BINT) ')']
                };
            title(titleName, 'fontweight', 'bold')
            
            axis square; 
            xlabel(rm1Descript, 'fontweight', 'bold')
            ylabel(rm2Descript, 'fontweight', 'bold')
            grid on;

        end
        
    end % loop over fields

end % loop over rois


