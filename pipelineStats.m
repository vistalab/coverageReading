%% quantify existing trends
clear all; close all; clc; 
%% modify here
% directory where the S struct is stored
listDirVista = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';      % rl
    '/biac4/wandell/data/reading_prf/lb/20150107_1730/';            % lb
    '/biac4/wandell/data/reading_prf/ak/20150106_1802/';            % ak
    '/biac4/wandell/data/reading_prf/jg/20150113_1947/';            % jg
    };

% index of the ROI in S
listRoisInd = {
    1;
    2;
    3;
    4;
    5;
    6;
    7;
    8;
    9;
    10;
    };

% color of each roi
listRoiColor = {
    [0 .2 1];
    [1 0 .5];
    [.5 .5 .5];
    [.4 .2 0];
    [.2 .8 1];
    [0 .5 .2];
    [.6 0 1];
    [.5 1 .5];
    [.7 .2 .5];
    [.4 .4 .9];
    };

listRoisComment = {
    'leftVWFA';     % 1
    'LV1';          % 2
    'LV2d';         % 3
    'LV2v';         % 4
    'leftFFA';      % 5
    'rightVWFA';    % 6
    'RV1';          % 7
    'RV2d';         % 8
    'RV2v';         % 9
    'rightFFA';     % 10
    };

% condition number. 
% 1: checkers
% 2: words
% 3: false font
condx = 1; 
condy = 2; 

listCondsComment = {
    'Checkers';
    'Words'; 
    'FalseFont'
    };

% varExp bin size
varExpBinSize = 0.1; 

% when reporting roi statistics, how many points to plot before shaving off
distPlotUntil  = 15; 

% threshold values of the rm model
h.threshco      = 0.1;          % minimum of co
h.threshecc     = [.2 16];      % range of ecc
h.threshsigma   = [0 16];       % range of sigma
h.minvoxelcount = 0;            % minimum number of voxels in roi

% parameters for making prf coverage
vfc.fieldRange      = 16;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.method          = 'max';                    % method for doing coverage.  another choice is density
vfc.newfig          = 0;                        % any value greater than -1 will result in a plot
vfc.nboot           = 0;                        % number of bootstraps
vfc.normalizeRange  = true;                     % set max value to 1
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  so takes the 
                                                % median of all sigmas within
vfc.cothresh        = h.threshco;        
vfc.eccthresh       = h.threshecc; 
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment
vfc.weight          = 'variance explained';
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = 1;                        % print stuff or not
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;

% set font size
set(0,'DefaultTextFontSize',14)

% save directory
dirSave = '/biac4/wandell/data/reading_prf/coverageReading/forAnalysis/reading/';


%% combine all subjects data
numRois = length(listRoisInd);
numSubs = length(listDirVista); 
numBins = length(0:varExpBinSize:1)-1; 

% SS is a 1xnumsubs cell
% each element of SS is S: a 3xnumRoi cell
% each element of S is a struct, with rmParamsFromAnRoi
SS = cell(1,numSubs);

for ii = 1:numSubs
    load([listDirVista{ii} 'S.mat'])
    SS{ii} = S; 
    clear S; 
end



%% variance explained %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% word-selective areas have greater variance explained when shown words as
% compared to checkers. opposite effect is seen in V1. 

%% VarExp_CheckerWords is a 1x4 cell where each element is a  
% 2xnumVoxels matrix (all voxels combined across subjects)
% first row is varExp when shown checkers
% second row is varExp when shown words
% the roi pertaining to each cell of VarExp_CheckerWords is as follows:
% leftvwfa, LV1, rightvwfa, RV1
VarExp_xy = cell(1,numRois); 

for jj = 1:numRois
    roiInd = listRoisInd{jj}; 
    
    for ii = 1:numSubs      
        temx    = SS{ii}{condx, roiInd}.co; 
        temy    = SS{ii}{condy, roiInd}.co; 
        temxy   = [temx; temy]; 
        VarExp_xy{jj} = [VarExp_xy{jj}, temxy];
    end
    
    
    % preliminary plotting
    figure()
    plot(VarExp_xy{jj}(1,:),VarExp_xy{jj}(2,:),'k.' )
    title([listRoisComment{jj} '. all voxels'])
    identityLine
end

clear temx temy temxy

%% bin with respect to x-axis
% arrange in order by value on the x-axis

VarExp_xyOrdered    = cell(1,numRois);
numInBin            = cell(1,numRois);
varExpYMean         = cell(1,numRois);
varExpYSte          = cell(1,numRois);
varExpCenters       = cell(1,numRois);

for jj = 1:numRois
    VarExp_xyOrdered{jj} = sortrows(VarExp_xy{jj}')'; 
    
    % the number of elements in each bin
    % so we know the corresponding y-elements to average over
    % because values are in ascending order with respect to the x-value
    [numInBin{jj}, varExpCenters{jj}] = hist(VarExp_xyOrdered{jj}(1,:), numBins); 

    temy        = VarExp_xyOrdered{jj}(2,:); 
    temcount    = 1; 
    for kk = 1:numBins
        temstart    = temcount; 
        temend      = temstart + numInBin{jj}(kk) - 1; 
        % mean of the kkth bin
        varExpYMean{jj}(kk) = mean(temy(temstart:temend)); 
        % standard error of the kkth bin
        varExpYSte{jj}(kk) = std(temy(temstart:temend))/sqrt(numInBin{jj}(kk)); 
        
        temcount    = temend + 1; 
    end
    
end

%%  plot with error bars and with transparent dots
% for jj = 1:numRois
%     roiInd = listRoisInd{jj};     
%     figure(); 
%     set(gcf,'color','w')
% 
%     % individual dots
%     % plot(VarExp_xy{jj}(1,:),VarExp_xy{jj}(2,:),'.','color',[.5 .5 .5],'alpha',.8 )
%     scatter_patches(VarExp_xy{jj}(1,:),VarExp_xy{jj}(2,:),2,'FaceColor',[.5 .5 .5], ...
%         'FaceAlpha',0.4,'EdgeColor','none','MarkerSize',.1);
%     set(gca,'Xlim',[0 1])
%     set(gca,'Ylim',[0 1])
%     hold on
%     % mean of the bin
%     errorbar(varExpCenters{jj}, varExpYMean{jj}, varExpYSte{jj},'.','color',[0 .6 1],'MarkerSize',24)
%     
%     identityLine
%     title(['Variance Explained in ' listRoisComment{roiInd}], 'FontSize', 14, 'FontWeight','bold')
%     xlabel(listCondsComment{condx}, 'FontSize', 14)
%     ylabel(listCondsComment{condy}, 'FontSize', 14)
% end

%% end variance explained %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prf coverage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the averaged coverage map for each type of stimuli

RFX         = cell(1,numRois); 
RFY         = cell(1,numRois); 
RFZ         = cell(1,numRois);
RFX_mean    = cell(1,numRois); 
RFY_mean    = cell(1,numRois);
RFZ_mean    = cell(1,numRois);

for jj = 1:numRois
    RFX{jj}         = zeros(128,128,numSubs); 
    RFY{jj}         = zeros(128,128,numSubs); 
    RFZ{jj}         = zeros(128,128,numSubs); 
    RFX_mean{jj}    = zeros(128,128); 
    RFY_mean{jj}    = zeros(128,128); 
    RFZ_mean{jj}    = zeros(128,128);
end


% get the RFcov for each subject and average them all together
for jj = 1:numRois
    roiInd = listRoisInd{jj}; 
    for ii = 1:numSubs
        [RFX{jj}(:,:,ii),~,~,~,~] = rmPlotCoveragefromROImatfile(SS{ii}{1, roiInd}, vfc); 
        close; 
        [RFY{jj}(:,:,ii),~,~,~,~] = rmPlotCoveragefromROImatfile(SS{ii}{2, roiInd}, vfc); 
        close; 
        [RFZ{jj}(:,:,ii),~,~,~,~] = rmPlotCoveragefromROImatfile(SS{ii}{3, roiInd}, vfc); 
        close; 
    end
    
    RFX_mean{jj} = mean(RFX{jj},3);
    RFY_mean{jj} = mean(RFY{jj},3);    
    RFZ_mean{jj} = mean(RFZ{jj},3);
end

%% plot the average coveraged
figure();
c = makecircle(128);

for jj = 1:numRois
    roiInd = listRoisInd{jj}; 

    subplot(3,numRois,jj)
    im = (RFX_mean{jj}); 
    im = im./max(im(:)); 
    im(c==0) = 0; % make black outer circle
    imagesc(im); 
    colormap hot;
    title(sprintf([listRoisComment{jj} '\n  ' listCondsComment{1}]), 'FontSize', 14);
    colormap hot; axis square; axis off
  
    subplot(3,numRois,jj+numRois)
    im = (RFY_mean{jj}); 
    im = im./max(im(:)); 
    im(c==0) = 0; % make black outer circle
    imagesc(im); 
    colormap hot; 
    title(sprintf([listRoisComment{jj} '\n ' listCondsComment{2}]), 'FontSize', 14);
    colormap hot; axis square; axis off

    subplot(3,numRois,jj+2*numRois)
    im = (RFZ_mean{jj}); 
    im = im./max(im(:)); 
    im(c==0) = 0; % make black outer circle
    imagesc(im); 
    colormap hot;
    title(sprintf([listRoisComment{jj} '\n ' listCondsComment{3}]), 'FontSize', 14);
    colormap hot; axis square; axis off

end
set(gcf,'color','w')
% save(gcf, [dirSave 'coveragesAverages_allRois_4'], 'png')
%% end plot coverages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% eccentricity distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eccentricity distribution 
% for comparing across rois

Ecc         = cell(1,numRois); 
EccCenters  = cell(1,numRois); 
EccValues   = cell(1,numRois); 

hSigRaw = figure; set(gcf,'color','white')
hSigPro = figure; set(gcf,'color','white')
for cc = 1:3
    
    
    for jj = 1:numRois       
        roiInd = listRoisInd{jj}; 

        for ii = 1:numSubs      
            temx    = SS{ii}{cc, roiInd}.ecc; 
            Ecc{jj} = [Ecc{jj}, temx];
        end

        % plot proportion
        figure(hSigPro)
        grid on
        subplot(1,3,cc)
        [EccValues{jj}, EccCenters{jj}] = hist(Ecc{jj}, 20); 
        hold on
        plot(EccCenters{jj}(1:distPlotUntil), EccValues{jj}(1:distPlotUntil)./sum(EccValues{jj}(1:distPlotUntil)), ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{cc}],'FontSize',14)
        xlabel('Eccentricity (vis ang deg)', 'FontSize', 14)
        ylabel('Proportion', 'FontSize', 14)
        axis([0 15 0 0.3])
        legend(listRoisComment)
         % save(gcf, [dirSave 'DistEccPro'],'png')
        
        % plot raw values
        figure(hSigRaw)
        grid on
        subplot(1,3,cc)
        [EccValues{jj}, EccCenters{jj}] = hist(Ecc{jj}, 20); 
        hold on
        plot(EccCenters{jj}(1:distPlotUntil), EccValues{jj}(1:distPlotUntil), ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{cc}],'FontSize',14)
        xlabel('Eccentricity (vis ang deg)', 'FontSize', 14)
        ylabel('Num Voxels', 'FontSize', 14)
        axis([0 15 0 8000])
        legend(listRoisComment)
        % save(gcf, [dirSave 'DistEccRaw'],'png')

    end

end
%% end eccentricity distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% size distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sigma         = cell(1,numRois); 
SigmaCenters  = cell(1,numRois); 
SigmaValues   = cell(1,numRois); 

hSigRaw = figure; set(gcf,'color','white')
hSigPro = figure; set(gcf,'color','white')
for cc = 1
    
    
    for jj = 1:numRois       
        roiInd = listRoisInd{jj}; 

        for ii = 1:numSubs      
            temx    = SS{ii}{cc, roiInd}.sigma1; 
            Sigma{jj} = [Sigma{jj}, temx];
        end

        plot proportion
        figure(hSigPro)
        grid on
        subplot(1,3,cc)
        [SigmaValues{jj}, SigmaCenters{jj}] = hist(Sigma{jj}, 20); 
        hold on
        plot(SigmaCenters{jj}(1:distPlotUntil), SigmaValues{jj}(1:distPlotUntil)./sum(SigmaValues{jj}(1:distPlotUntil)), ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{cc}],'FontSize',14)
        xlabel('pRF Size (visual angle deg)', 'FontSize', 14)
        ylabel('Proportion', 'FontSize', 14)
        axis([0 15 0 0.7])
        legend(listRoisComment)
         save(gcf, [dirSave 'DistSizePro'],'png')
        
        plot raw values
        figure(hSigRaw)
        grid on
        subplot(1,3,cc)
        [SigmaValues{jj}, SigmaCenters{jj}] = hist(Sigma{jj}, 20); 
        hold on
        plot(SigmaCenters{jj}(1:distPlotUntil), SigmaValues{jj}(1:distPlotUntil), ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{cc}],'FontSize',14)
        xlabel('pRF Size (visual angle deg)', 'FontSize', 14)
        ylabel('Num Voxels', 'FontSize', 14)
        axis([0 15 0 15000])
        legend(listRoisComment)
        save(gcf, [dirSave 'DistSizeRaw'],'png')

    end

end


% end size distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



