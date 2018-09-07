%% rmField vs. rmField
clear all; close all; clc;
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%%
list_path = list_sessionRet; 
list_subInds = [1:20];

list_roiNames = {
    'WangAtlas_V1v_left'
    'WangAtlas_V2v_left'
    'WangAtlas_V3v_left'
    'WangAtlas_hV4_left'
    'WangAtlas_VO1_left'
    'lVOTRC'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LhV4_rl'
%     'lVOTRC'
%     'RV2d_rl'
%     'RV3d_rl'
%     'RV3ab_rl'
%     'RIPS0_rl'
%     'RIPS1_rl'
    };
list_dtNames = {
%     'WordSmall'
%     'Words_Hebrew'
%     'Checkers'
%     'Words'
%     'FalseFont'
    'Words'
    'Checkers'
    };
list_rmNames = {
%     'retModel-Words-oval.mat'
%     'retModel-Words_Hebrew-css.mat'
%     'retModel-Checkers-css.mat'
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

list_colors = list_colorsPerSub; 

% vfc threshold
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2;

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), size (sigma1)
% 'numvoxels' for number of voxels in roi
rmFieldX = 'ecc'; 
rmFieldY = 'sigma';
rmFieldXDescript = 'eccentricity';
rmFieldYDescript = 'size';

% histogram maximum
% Might want to change around if we want the axes to be comparable to
% another population
% histMax = vfc.fieldRange; 
maxValueX = 15; 
maxValueY = 15; 

% do we want to plot line
plot_bestFitLine = true; 
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

%% bootstrap across subjects
% fit  a line to each subject and store

% get the data in easy-to-use state
for kk = 1:numRms
    
    for jj = 1:numRois
        subCellPairwise = cell(numSubs, 2);
        for ii = 1:numSubs
            rmroi = rmroiCell{ii,jj,kk}; 
            subCellPairwise{ii,1} = eval(['rmroi.' rmFieldX])
            subCellPairwise{ii,2} = eval(['rmroi.' rmFieldY])
        end    
    end   
end

%% heat map ---------------------------------------------------------------
close all; 

axisLimsX = [0 maxValueX]; 
axisLimsY = [0 maxValueY];
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
        ff_histogramHeat(ldatax, ldatay, maxValueX, maxValueY, numHistBins)    
        xlabel(rmFieldXDescript)
        ylabel(rmFieldYDescript)
        
        % bootstrap across subjects
        plotOnCurFig = 0; 
        [ci, meanSlope, slopes] =  ...
            ff_bootstrapAcrossSubs(subCellPairwise, plotOnCurFig, maxValueX)
        
        titleName = {
            [rmFieldY  ' by ' rmFieldX]
            [roiName '. ' dtName]            
            ['slope: ' num2str(meanSlope)];
            ['ci: ' num2str(ci')];    
            };
        title(titleName, 'fontweight', 'bold')
       
    end
end
