%% plot contours on an individual level basis
% we will get a CI if we do it for mutliple ret models --
% ASSUMES that the dtname ends in _Remove_Sweep{x}
% Ex: dtName = 'Words' --> 'Words_Remove_Sweep{x}'
% TYPICAL NAMING CONVENTION??
% retModel-{dtName}-{roiName}

% this will give us a confidence interval
% Have the graph be "graded" in shades -- the part where every contour
% covers will be darkest

clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%% modify here

% the group we want to sample over, as indicated by bookKeeping
list_subInds = 1; %[1:4 6:13];

% which session? {'list_sessionPath'| 'list_sessionRetFaceWord'}
wSession = 'list_sessionPath';

% is the prf model only run on a single roi?
% this will change the naming convention of the prf model
prfOnSingleRoi = false; 

% the roi we're interested in
% NOTE
% subInd = 1 can be run on any roi
list_roiNames = {
    'LV1_rl'
    };

% datatype names
list_dtNames = {
    'Checkers'
    'Words'
    'FalseFont'
%     'WordLarge'
%     'WordSmall'
%     'FaceLarge'
%     'FaceSmall'
    };

% contour level
list_contourLevels = [
    .6
    .7
    .8
    .9
    ];

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

% comment out this line if we don't want to directly alter colormap
% newcolormap = 0.3 + 0.6*gray(9);

%% calculate and define things

% number of subjects
numSubs = length(list_subInds);

% initialize the figure where we keep adding contour lines
contourFig = figure; 


%% loop over subjects
for ii = 1:numSubs
    
    % go to subject's vista dir and intialize the view
    subInd = list_subInds(ii);
    list_path = eval(wSession);
    dirVista = list_path{subInd};    
    chdir(dirVista);

    vw = initHiddenGray;
    
    %% loop over rois
    for jj = 1:length(list_roiNames)
    
        % roiname
        roiName = list_roiNames{jj};
        
        % roiPath
        d = fileparts(vANATOMYPATH);
        roiPath = fullfile(d, 'ROIs', roiName);

        % load the roi
        % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
        vw = loadROI(vw, roiPath, 1, [], 1, 0);


        %% loop over the datatypes (usually stimulus types)    
        for kk = 1:length(list_dtNames)

            % initialize the matrix that will store all the contours
            allRFcov = zeros(vfc.nSamples, vfc.nSamples, 8);

            % main dt
            dtName = list_dtNames{kk};

            %% loop over the 8 removed sweeps
            % hardcoding, assumes 8

            for bb = 1:8

                % load the remove sweep ret model
                dtBootstrapName = [dtName '_Remove_Sweep' num2str(bb)];

                % ret model name and path
                if prfOnSingleRoi
                    rmName = ['retModel-' dtBootstrapName '-' roiName '.mat']; 
                else
                    rmName = ['retModel-' dtBootstrapName '.mat'];
                end

                rmPath = fullfile(dirVista, 'Gray', dtBootstrapName, rmName);

                % load the rm
                vw = rmSelect(vw, 1, rmPath);
                vw = rmLoadDefault(vw);

                % plot the coverage
                [RFcov, ~, ~, ~, ~] = ff_coverage_plot(vw, vfc);

                % close it
                close;

                % Store it
                allRFcov(:,:,bb) = double(RFcov);
            end

            %% loop over the contours ---------------------------------------------
        for cc = 1:length(list_contourLevels)

            % this contour level
            contourLevel = list_contourLevels(cc);

            % binary contour matrix for the subject (over all datatypes)
            % Height greater than contourLevel = 1
            % Height less than contourLevel = 0
            % This is so that we can make an image that is like a graded
            % contour
            allContours = allRFcov > contourLevel; 


            %% format the plot
            close all; 
            figure; 

            % compute the average contours
            contourAvg = mean(allContours,3);

            % the y axis flip is within the visualization code, so the
            % output matrix still has that flip. so make that flip again
            % here. 
            contourAvgInvert = flipud(contourAvg);

            % to make the black outer circle thing
            % c = makecircle(128);  
            % to make the polar angle plot
            inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);

            % make black outer circle
            % contourAvgInvert = contourAvgInvert.*c; 
            % imagesc(inc,inc',contourAvgInvert); 

            imagesc(inc,inc',contourAvgInvert);

            % add polar grid on top
            p.ringTicks = (1:3)/3*vfc.fieldRange;
            p.color = 'w';
            polarPlot([], p);

            %% colormap
            colorbar;
            colormap gray;
            if exist('newcolormap', 'var')
                set(gcf, 'colormap', newcolormap)
            end


            %% title
            % subject initial
            subInit = list_sub{subInd};
            % roiName - take off the _rl at the end
            if strcmp(roiName(end-2:end),'_rl')
                roiNamePlot = roiName(1:end-3);
            else
                roiNamePlot = roiName;
            end

            titleName = [roiNamePlot '. ' subInit '. Contour Level ' num2str(contourLevel) '. ' dtName];
            title(titleName)

            %% save
            saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png')
            saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig')
        end


        end
   
    end
    % just in case subject has view window open
    close all; 
end
    