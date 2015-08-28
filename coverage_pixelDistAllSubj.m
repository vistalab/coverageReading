%% for a given pixel (in the 128 x 128 visual field) computes a statistic 
% of each subject's pixel distribution.
% Will then take the average across subjects, compute error bars on these
% averages.
% Use to compare different rois, or different stimulus types

clc; clear all; close all; 
bookKeeping;

%% modify here

% For 128 pixels and 30 degrees, 1 pix = 0.2344 deg and 1 deg = 4.2667 pix
% note that there is a y flip!
list_pix = {
    8256;   % fovea
    8260;   % 1 deg right horizontal meridian
    8264;   % 2 deg right horizontal meridian
    8269;   % 3 deg right horizontal meridian 
    8273;   % 4 deg right horizontal meridian
    8277;   % 5 deg right horizontal meridian
    8282;   % 6 deg right horizontal meridian
    8286;   % 7 deg right horizontal meridian 
    8290;   % 8 deg right horizontal meridian
    8294;   % 9 deg right horizontal meridian
    8299;   % 10 deg right horizontal meridian
    8319;   % 15 deg right horizontal meridian
    };

% statistic we want to compute over the distrubution
% @mean @ median
% sqr = @(x) x.^2
statFunc = @median;

% description of the statistic, for plotting purposes
statDescript = 'median';

% vfc parameters
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 12]; 
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

% rois we're interested in
list_roiName = {
    'lh_VWFA_rl'
    'LV1_rl'
    };

% number of bins in the histogram
numBins = 10; 

% ret model type, for purposes of plot titles
list_rmName = {
    'Checkers'
    'Words'
    'FalseFont'
    }; 

% colors corresponding to rm types, plotting purposes
list_rmColor = {
    [0 .9 .2];
    [1 0 .1];
    [.1 .1 1];
    };

% contour level of the pRF coverage (which is normalized between 0 and 1)
% not used in pixel distribution, but is in the title for additional info
contourLevel = 0.8; 

% figure size/position. Saving as a png has weird proportions if we don't
% specify this.
% [x y width height]
figPos = [1976 127 1200 520]; 

% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/pixDist'; 
saveExt = 'png';


%% initialize, calculate useful variables

% number of subjects 
numSubs = length(list_sessionPath);

% number of rois
numRois = length(list_roiName);

% number of ret types
numRms = length(list_rmName); 

% number of pixels to compute stats for
numPixs = length(list_pix); 

% initialize pixel count
% numBins x numSubs x numRois x numRms
mPixInfo = zeros(numBins, numSubs, numRois, numRms);

% initialize stat and error bar matrices
mStatSub    = zeros(numSubs, numRois, numRms); 
mStat       = zeros(numRois,numRms);
mError      = zeros(numRois,numRms); 

% all_models. this is the most computationally expensive. so compute it
% once and store it, and we can rerun using different pixNums and statFuncs
s_all_models = cell(numSubs, numRois, numRms); 

%% get the data!

for ii = 1:numSubs
 
    % assumes every subject is included
    % change to directory and load the view
    dirVista = list_sessionPath{ii}; 
    chdir(dirVista); 
    VOLUME{1} = mrVista('3'); 
    
    for kk = 1:numRms;
    % load the ret model
    rmName = list_rmName{kk};
    pathRM = fullfile(dirVista, 'Gray', rmName, ['retModel-' rmName '.mat']);
    VOLUME{1} = rmSelect(VOLUME{1}, 1, pathRM); 

    
        for jj = 1:numRois

            % roi
            roiName = list_roiName{jj};

            % load the roi
            d = fileparts(vANATOMYPATH); 
            pathROI = fullfile(d, 'ROIs', roiName); 
            VOLUME{1} = loadROI(VOLUME{1}, pathROI, [],[], 1, 0); 

            % grab the rm roi struct
            rmROI = rmGetParamsFromROI(VOLUME{1});

            % get the data from plotting coverage
            [rf, figHandle2, all_models, weight, data] = rmPlotCoveragefromROImatfile(rmROI, vfc); 
            s_all_models{ii,jj,kk} = all_models;
            
        end
    end
    
    close all;

end



%% do statistics. make the plots for each pixel number
for pp = 1:numPixs

    pixNum = list_pix{pp};
    
    % transform the pixel number into cartesian coordinates for plotting red dot
    [visAngX, visAngY]  = ff_pixNum2Cart(pixNum, vfc); 
    % also get rad and theta for titles
    [pixTh, pixEcc]    = cart2pol(visAngX, visAngY); 
    
    %% compute the statistic 
    for ii = 1:numSubs
        for jj = 1:numRois
            for kk = 1:numRms

                all_models = s_all_models{ii,jj,kk};

                % calculate the statistic (ie median) on the population
                % where the popuation is a given pixel's dist in each subject
                % and store it 
                mStatSub(ii,jj,kk) = statFunc(all_models(pixNum,:)); 

                % get the pixel information
                % should be a vector of length numVoxels
                % store it ( numBins x numSubs x numRois)
                [counts, binCenters] = hist(all_models(pixNum, :), numBins);
                mPixInfo(:,ii,jj,kk) = counts;

            end
        end    
    end

    %% get the mean of the statistic, compute error bars
    % take the average over subjects and compute error bars 
    % mStatSub = zeros(numSubs, numRois, numRms); 

    for jj = 1:numRois
        for kk = 1:numRms
            tem = mStatSub(:,jj,kk); 

            % take average over all subjects
            mStat(jj,kk) = mean(tem); 
            % standard error
            mError(jj,kk) = std(tem)./sqrt(numSubs); 
        end
    end

    % plotting
    % mStat and mError are numRois x numRms
    close all;
    figure();

    %% left panel: scatter plot with error -------------------------------
    subplot(1,2,1); 
    for kk = 1:numRms
       hold on; 
       errorbar(mStat(:,kk), mError(:,kk),'.', 'MarkerSize', 24, 'Color', list_rmColor{kk})
    end
    ylabel(['Amplitude: ' statDescript])
    set(gca, 'XTickLabel', list_roiName)
    set(gca,'XTick', 1:numRois)
    set(gca, 'YLim', [0 1])
    grid on

    % make sure legend does not interfere with graph
    hleg = legend(list_rmName);
    % Position = [x y width height], where values range between 0 and 1
    % we want to set it so that it is in the right panel
    tem = get(hleg, 'Position');
    tem(1) = 0.5; 
    set(hleg, 'Position', tem);
    
    titleName = {[statDescript ' . Ecc: ' num2str(round(pixEcc)) '. Theta: ' num2str(round(rad2deg(pixTh)))],['Average over all subjects']}; 
    title(titleName, 'FontWeight','Bold')

    %% right panel: visual field location ---------------------------------

    subplot(1,2,2); 
    p.ringTicks = (1:3)/3*vfc.fieldRange;
    polarPlot([], p)
    plot(visAngX, visAngY, '.b', 'MarkerSize', 24, 'MarkerEdgeColor', [1 0 0])
    title({['Visual Field Location'],['Eccentricity: ' num2str(round(pixEcc)) ' deg']}); 
    axis off 

    % change the size of the figure
    set(gcf,'Position', figPos)

    % save
    saveas(gcf,fullfile(saveDir, [titleName{1} '.' saveExt]), saveExt)

end

