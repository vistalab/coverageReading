%% keep plotting the 0.8 contour for a group average
% this will give us a confidence interval
clear all; close all; clc; 
bookKeeping; 

%% modify here

% the group we want to sample over, as indicated by bookKeeping
fullGroupInd = [1:4, 6:12];

% number in the the subgroup
numInGroup = 6; 

% number of iterations
numIterations = 18; 

% rois we're interested in
list_roiNames = {
    'CV1_rl'
    };

% rm types
list_rmNames = {
    'Checkers';
    'Words';
    'FalseFont';
    };

% contour level
contourLevel = 0.8;

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.2;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% path of rmroi struct
rmroiPath = '/biac4/wandell/data/reading_prf/forAnalysis/rmrois/';

% save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/contours/CI';


%% calculate and definte things
% number of rois
numRois = length(list_roiNames);

% number of stim types
numRms = length(list_rmNames); 

% initialize the figure where we keep adding contour lines
contourFig = figure; 


%%
for jj = 1:numRois
    
    % this roi
    roiName = list_roiNames{jj};
    
    % load the rmroi
    % should load a variable called rmroi
    load(fullfile(rmroiPath, ['rmroi_' roiName(1:end-3) '.mat']))

    for kk = 1:numRms
        
        % this rm
        rmName = list_rmNames{kk};
        
        % initialize the matrix that will store all the contours
        allContours = zeros(vfc.nSamples, vfc.nSamples, numIterations);
        
        for ss = 1:numIterations

            % get the indices of a random subset of size numInGroup
            ind = randsample(fullGroupInd, numInGroup);

            % get the group average of this subset
            RM = rmroi(kk, ind);
            contourAvgInvert = ff_rmPlotCoverageGroup(RM, vfc);
            
            % get the contour info by plotting the contour
            [contourPoints, fh] = contourf(contourAvgInvert, [0 contourLevel 1]);
            
            % round, and cut values greater than vfc.nSamples (glitch)
            tem1 = round(contourPoints);
            
            
            % cut out the first 3 values. some weird thing happening with
            % matlab's contour function
            tem2 = tem1(:,3:end);
            tem2a = tem2(1,:);
            tem2b = tem2(2,:);
            % find columns that have a value greater than vfc.nSamples
             tem3 = find(tem2a > vfc.nSamples);
             tem4 = find(tem2b > vfc.nSamples);
             indOver = [tem3, tem4];
             
            
            % remove the nans and store it
            cpr = [];
            cpr(1,:) = tem2a(~isnan(tem2a));
            cpr(2,:) = tem2b(~isnan(tem2b));
            % get rid of columns with values greater than vfc.nSamokes
            cpr(:, indOver) = [];


            numPoints = size(cpr,2);
            % cprs (contour points rounded scaled) is now a 2 x numpoints
            % vector where the first row is cartesian x and the second row
            % is cartesian y. Let's transfrom this into a vfc.nSamples x
            % vfc.nSamples matrix
            for nn = 1:numPoints
                allContours(cpr(1,nn), cpr(2,nn),ss) = 1;
            end          
        end
        
        %% format the plot
        close all; 
        figure; 
        
        % compute the average contours
        contourAvg = mean(allContours,3);
        contourAvgInvert = 1 - contourAvg;
        
        % to make the black outer circle thing
        c = makecircle(128);  
        % to make the polar angle plot
        inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);

        contourAvgInvert = contourAvgInvert.*c; % make black outer circle
        % imagesc(inc,inc',contourAvgInvert); 
        imagesc(inc,inc',contourAvgInvert');

        % add polar grid on top
        p.ringTicks = (1:3)/3*vfc.fieldRange;
        p.color = 'w';
        polarPlot([], p);
        
        colormap gray
        % title
        titleName = [roiName '. ' rmName];
        title(titleName)
        
        % save
        saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png')
        saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig')
        
        
        close all; 
      
        
    end
end
    
    