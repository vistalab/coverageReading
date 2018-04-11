%% size vs. eccentricity for all subjects
clear all; close all; clc;
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%%
list_path = list_sessionRet; 
list_subInds = [1:20];

list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
%     'RV2d_rl'
%     'RV3d_rl'
%     'RV3ab_rl'
%     'RIPS0_rl'
%     'RIPS1_rl'
    };
list_dtNames = {
    'Checkers'
%     'WordSmall'
%     'Words_Hebrew'
%     'Checkers'
%     'Words'
%     'FalseFont'
%     'Checkers'
    };
list_rmNames = {
    'retModel-Checkers-css.mat'
%     'retModel-Words_Hebrew-css.mat'
%     'retModel-Checkers-css.mat'
%     'retModel-Words-css.mat'
%     'retModel-FalseFont-css.mat'
%     'retModel-Checkers-css.mat'
    };

list_colors = list_colorsPerSub; 

% vfc threshold
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2;

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), size (sigma1)
% 'numvoxels' for number of voxels in roi
rmFieldX = 'ecc'; 
rmFieldY = 'meanPeaks';
rmFieldXDescript = 'eccentricity';
rmFieldYDescript = 'mean peaks BOLD';

% histogram maximum
% Might want to change around if we want the axes to be comparable to
% another population
% histMax = vfc.fieldRange; 
histMaxX = 15; 
histMaxY = 10; 

% do we want to plot line
plot_bestFitLine = false; 
plot_heatMap = true; 
plot_identityLine = true; 

% colormap for histogram
% TODO: functionalize the blue colormap
cpink = colormap('pink');
c1 = cpink(:,1);
c2 = cpink(:,2);
c3 = cpink(:,3);
cnew = [c3 c1 c1];
cmapValuesHist = colormap(cnew);

%% define and initialize things
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_dtNames);
rmroiParams = cell(numSubs);

%% rmroi struct
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% threshold the rmroi struct

rmroiCell = cell(size(rmroiCellTemp));

for kk = 1:numRms
    for jj = 1:numRois
        for ii = 1:numSubs
            rmroiUnthresh = rmroiCellTemp{ii, jj, kk}; 
                
            if ~isempty(rmroiUnthresh)
                rmroi = ff_thresholdRMData(rmroiUnthresh, vfc);
            else
                rmroi = [];
            end
            
            rmroiCell{ii,jj,kk} = rmroi; 
        end 
    end
end

% size(rmroiCell)

%% heat map ---------------------------------------------------------------
close all; 

axisLimsX = [0 histMaxX]; 
axisLimsY = [0 histMaxY];
numHistBins = 50; 

for jj = 1:numRois
    roiName = list_roiNames{jj};
    
    for kk = 1:numRms
        dtName = list_dtNames{kk};
        
        % linearize the data
        rmroiSubs = rmroiCell(:,jj,kk);
        % ldataEcc = ff_rmroiLinearize(rmroiSubs, 'ecc');
        % ldataSigma1 = ff_rmroiLinearize(rmroiSubs, 'sigma1');
        ldatax = ff_rmroiLinearize(rmroiSubs, rmFieldX); 
        ldatay = ff_rmroiLinearize(rmroiSubs, rmFieldY); 
        
        % plotting
        figure; hold on; 
        
        
        Ctrs = cell(1,2); 
        % Ctrs{1} = linspace(0,vfc.fieldRange, numHistBins); 
        % Ctrs{2} = linspace(0,vfc.fieldRange, numHistBins); 
        Ctrs{1} = linspace(0,histMaxX, numHistBins); 
        Ctrs{2} = linspace(0,histMaxY, numHistBins); 
        
        hist3([ldatax' ldatay'],'Ctrs', Ctrs)
        set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')

        % Fit a line to the data
        coeffsGroup = polyfit(ldatax, ldatay,1);
        linGroup = linspace(0, vfc.eccthresh(2));
        yGroup = coeffsGroup(2) + linGroup * coeffsGroup(1);
        
        % identityLine goes above everything else so that it can be seen
        maxZ = max(get(gca, 'ZLim'));
        maxX = max(get(gca, 'Xlim'));
        % plot3(linspace(0, maxX, 50), linspace(0, maxX, 50), maxZ*ones(1,50), ...
        %     '--', 'Color', [0 0 1], 'LineWidth',2)
        
        % plot the fitted line above everything else
        if plot_bestFitLine
            plot3(linGroup, yGroup, maxZ*ones(1,length(linGroup)), ...
                '-', 'Color', [.8 0 .2], 'LineWidth',2 )
        end
        
        if plot_identityLine
            numidpoints = 100; 
            idpointsX = linspace(0, histMaxX, numidpoints); 
            idpointsY = linspace(0, histMaxY, numidpoints); 
            plot3(idpointsX, idpointsY, maxZ*ones(1,numidpoints), ...
                '--', 'Color', [.6 .6 .6], 'Linewidth',2)
        end
        
        axis square;         
        colormap(cmapValuesHist); 
        colorbar;
        caxis([0 maxZ/5]);

        set(gca, 'xlim', axisLimsX);
        set(gca, 'ylim', axisLimsY);
        
        xlabel(rmFieldXDescript)
        ylabel(rmFieldYDescript)
        
        titleName = {
            ['Size by Ecc. ' roiName '. ' dtName]
            ['y = ' num2str(coeffsGroup(1)) 'x + ' num2str(coeffsGroup(2))]
            };
        title(titleName, 'fontweight', 'bold')
       
    end
end
