%% keep plotting the 0.8 contour for an individual
% this will give us a confidence interval
clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%% modify here

% the group we want to sample over, as indicated by bookKeeping
list_subInds = [2];

% rois we're interested in
list_roiNames = {
    'LV1_rl'
    };

% rm types
list_rmNames = {
    'Words_Remove_Sweep1'
    'Words_Remove_Sweep2'
    'Words_Remove_Sweep3'
    'Words_Remove_Sweep4'
    'Words_Remove_Sweep5'
    'Words_Remove_Sweep6'
    'Words_Remove_Sweep7'
    'Words_Remove_Sweep8'
    };

% contour level
contourLevel = 0.9;

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
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

% save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/contours/CI';


%% calculate and define things
% number of rois
numRois = length(list_roiNames);

% number of stim types
numRms = length(list_rmNames);

% number of subjects
numSubs = length(list_subInds);

% initialize the figure where we keep adding contour lines
contourFig = figure; 

% initialize the matrix that will store all the contours
allContours = zeros(vfc.nSamples, vfc.nSamples, numRms);

%%
for ii = 1:numSubs
    
    % go to subject's vista dir and intialize the view
    subInd = list_subInds(ii);
    dirVista = list_sessionPath{subInd};
    chdir(dirVista);
    vw = initHiddenGray;
    
    for jj = 1:numRois

        % this roi
        roiName = list_roiNames{jj};
        
        % roiPath
        d = fileparts(vANATOMYPATH);
        roiPath = fullfile(d, 'ROIs', roiName);
        
        % load the roi
        % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
        vw = loadROI(vw, roiPath, 1, [], 1, 0);


        for kk = 1:numRms

            % this rm
            rmName = list_rmNames{kk};
            
            % rm path
            % assumes roiname is appended at the end
            rmPath = fullfile(dirVista, 'Gray', rmName, ['retModel-' rmName '-' roiName '.mat']);
            
            % load the rm
            vw = rmSelect(vw, 1, rmPath);
            vw = rmLoadDefault(vw);

            % plot the coverage
            [RFcov, ~, ~, ~, ~] = ff_coverage_plot(vw, vfc);

            % get the contour info by plotting the contour
            [contourPoints, fh] = contourf(RFcov, [0 contourLevel 1]);

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
                allContours(cpr(1,nn), cpr(2,nn), kk) = 1;
            end 
           
        end

    %% format the plot
    close all; 
    figure; 

    % compute the average contours
    contourAvg = mean(allContours,3);
    contourAvgInvert = 1 - contourAvg;

    % the y axis flip is within the visualization code, so the
    % output matrix still has that flip. so make that flip again
    % here. 
    contourAvgInvert = fliplr(contourAvgInvert);

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
    % subject initial
    subInit = list_sub{subInd};
    % roiName - take off the _rl at the end
    if strcmp(roiName(end-2:end),'_rl')
        roiNamePlot = roiName(1:end-2);
    else
        roiNamePlot = roiName;
    end
    
    titleName = [roiNamePlot '. ' subInit '. Contour Level ' num2str(contourLevel)];
    title(titleName)

    % save
    saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png')
    saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig')


    end
end
    