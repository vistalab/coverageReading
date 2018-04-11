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
%     'WordSmall'
%     'Words_Hebrew'
    'Checkers'
    'Words'
%     'FalseFont'
%     'Checkers'
    };
list_rmNames = {
%     'retModel-WordSmall-css.mat'
%     'retModel-Words_Hebrew-css.mat'
    'retModel-Checkers-css.mat'
    'retModel-Words-css.mat'
%     'retModel-FalseFont-css.mat'
%     'retModel-Checkers-css.mat'
    };

list_colors = list_colorsPerSub; 

% vfc threshold
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2;

% histogram maximum
% Might want to change around if we want the axes to be comparable to
% another population
% histMax = vfc.fieldRange; 
histMax = 15; 

% do we want to plot line
plot_bestFitLine = true; 
plot_heatMap = true; 

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

%% plotting
% scatter plot color by subject

% close all; 
% markerSize = 4; 
% markerType = 'o';
% 
% for kk = 1:numRms
%     
%     dtName = list_dtNames{kk};
%     
%     for jj = 1:numRois
% 
%         roiName = list_roiNames{jj};
% 
%         figure; hold on; 
%         
%         for ii = 1:numSubs
% 
%             subInd = list_subInds(ii);
%             thisColor = list_colors(subInd,:); 
%             rmroi = rmroiCell{ii,jj,kk}; 
%     
%             if ~isempty(rmroi)
%                 % cartesian to polar coordinates
%                 [theta,ecc] = cart2pol(rmroi.x0,rmroi.y0); 
%                 sze = rmroi.sigma1; % TODO check var name
% 
%                 % plot the points
%                 p = plot(ecc, sze, markerType, 'Color', thisColor, ...
%                     'MarkerSize', markerSize, 'MarkerFaceColor',thisColor, ...
%                     'MarkerEdgeColor', [1 1 1]);
% 
%                 % plot the best fitting line
%                 coeffs = polyfit(ecc, sze, 1);
%                 lin = linspace(0, vfc.eccthresh(2)); 
%                 y = coeffs(2) + lin*coeffs(1); 
% 
%                 if plot_bestFitLine
%                     plot(lin,y, '-','Color', thisColor, 'LineWidth',2.5); 
%                 end
%             end
%         end
% 
%         grid on; 
%         xlabel('Ecc. (Vis Ang Deg)')
%         ylabel('Size. (Vis Ang Deg)')
%         axis([0 15 0 15])
% 
%         % title
%         titleName = ['Size vs Eccentricity. ' roiName '. ' dtName];
%         title(titleName, 'FontSize', 14, 'FontWeight', 'Bold')
% 
%     end
% end

%% heat map ---------------------------------------------------------------

axisLims = [0 histMax];
numHistBins = 50; 

for jj = 1:numRois
    roiName = list_roiNames{jj};
    
    for kk = 1:numRms
        dtName = list_dtNames{kk};
        
        % linearize the data
        rmroiSubs = rmroiCell(:,jj,kk);
        ldataEcc = ff_rmroiLinearize(rmroiSubs, 'ecc');
        ldataSigma1 = ff_rmroiLinearize(rmroiSubs, 'sigma');
        
        % plotting
        figure; hold on; 
        
        
        Ctrs = cell(1,2); 
        % Ctrs{1} = linspace(0,vfc.fieldRange, numHistBins); 
        % Ctrs{2} = linspace(0,vfc.fieldRange, numHistBins); 
        Ctrs{1} = linspace(0,histMax, numHistBins); 
        Ctrs{2} = linspace(0,histMax, numHistBins); 
        
        hist3([ldataEcc' ldataSigma1'],'Ctrs', Ctrs)
        set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')

        % Fit a line to the data
        coeffsGroup = polyfit(ldataEcc, ldataSigma1,1);
        linGroup = linspace(0, vfc.eccthresh(2));
        yGroup = coeffsGroup(2) + linGroup * coeffsGroup(1);
        
        % identityLine goes above everything else so that it can be seen
        maxZ = max(get(gca, 'ZLim'));
        maxX = max(get(gca, 'Xlim'));
        % plot3(linspace(0, maxX, 50), linspace(0, maxX, 50), maxZ*ones(1,50), ...
        %     '--', 'Color', [0 0 1], 'LineWidth',2)
        
        % plot the fitted line above everything else
        plot3(linGroup, yGroup, maxZ*ones(1,length(linGroup)), ...
            '-', 'Color', [.8 0 .2], 'LineWidth',2 )
                

        
        axis square;         
        colormap(cmapValuesHist); 
        colorbar;
        caxis([0 maxZ/5]);

        set(gca, 'xlim', axisLims);
        set(gca, 'ylim', axisLims);
        
        xlabel('pRF eccentricty')
        ylabel('pRF size')
        
        titleName = {
            ['Size by Ecc. ' roiName '. ' dtName]
            ['y = ' num2str(coeffsGroup(1)) 'x + ' num2str(coeffsGroup(2))]
            };
        title(titleName, 'fontweight', 'bold')
       
    end
end
