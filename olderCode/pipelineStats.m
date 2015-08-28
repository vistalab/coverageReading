%% quantify existing trends
clear all; close all; clc; 
%% modify here
% directory where the S struct is stored
listDirVista = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';          % rl
    '/sni-storage/wandell/data/reading_prf/ad/20150120_ret/';           % ad
    };

% all of the <S> mat files that we load from each subject's session directory must
% have rois in this order (each column pertaining to an roi):
listRoisComment = {
    'leftVWFA';     % 1
    'LV1';          % 2
    'LV2d';         % 3
    'LV2v';         % 4
    'leftpFus';      % 5
    'rightVWFA';    % 6
    'RV1';          % 7
    'RV2d';         % 8
    'RV2v';         % 9
    'rightpFus';     % 10
    };

% radius of the the field of view, units of visual angle degrees
fieldRadius = 16; 

% color of each roi, for plotting purposes
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

listCondsColor = {
    [.5 .8 .5];     % checkers
    [.8 .4 .4];     % words
    [.4 .4 .8];     % false fonts
    };

% all of the <S> mat files that we load from each subject's session directory must
% have stimulus conditions in this order (each row corresponding to a
% condition)
listCondsComment = {
    'Checkers';
    'Words'; 
    'FalseFont'
    };

% the conditions we want to analyze
analyzeConds = {
    1;
    2;
    };

% % index of the ROI in S
analyzeRois = {
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

% parameters for making prf coverage
% some of these thresholds are already in place, by virtue of thresholding
% the rm struct (Sth)

vfc.cothresh        = 0.1;                      % minimum of co       
vfc.eccthresh       = [.2 14];                  % range of ecc
vfc.fieldRange      = 16;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.weight          = 'variance explained';
vfc.method          = 'max';                    % method for doing coverage.  another choice is density
vfc.newfig          = 0;                        % any value greater than -1 will result in a plot
vfc.nboot           = 0;                        % number of bootstraps
vfc.normalizeRange  = true;                     % set max value to 1
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  so takes the 
                                                % median of all sigmas within

vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = 1;                        % print stuff or not
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;


% save directory
dirSave = '/biac4/wandell/data/reading_prf/coverageReading/forAnalysis/reading/';


%%%%%%%% combine all subjects data
allRois     = length(listRoisComment); 
allConds    = length(listCondsComment); 
numRois     = length(analyzeRois);
numSubs     = length(listDirVista); 
numConds    = length(analyzeConds); 
condx       = analyzeRois{1}; % x axis
condy       = analyzeRois{2}; % y axis
maxEccPlot  = 12;  

% SS is a 1xnumsubs cell
% each element of SS is S: a 3xnumRoi cell
% each element of S is a struct, with rmParamsFromAnRoi
% same for SSth
SS = cell(1,numSubs);

for ii = 1:numSubs
    load([listDirVista{ii} 'S.mat'])
    SS{ii} = S; 
    clear S; 
end


SSth = cell(1,numSubs);
for ii = 1:numSubs
    load([listDirVista{ii} 'Sth.mat'])
    SSth{ii} = Sth; 
    clear Sth; 
end


%% variance explained %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% word-selective areas have greater variance explained when shown words as
% compared to checkers. opposite effect is seen in V1. 

% co_CheckerWords is a 1xnumRois cell where each element is a  
% 2xnumVoxels matrix (all voxels combined across subjects)
% first row is co when shown checkers
% second row is co when shown words
% third row is co when shown words
% the roi pertaining to each cell of co_CheckerWords is as follows:
% leftvwfa, LV1, rightvwfa, RV1

allVox_co       = ff_rmRoisCombineAllSubs_field(SS,'co'); 
allVox_coth     = ff_rmRoisCombineAllSubs_field(SSth,'co');  

for jj = 1:numRois
    
    % preliminary plottings
    % unthresholded data
    roiInd = analyzeRois{jj};
    
    figure()
    plot(allVox_co{condx,roiInd}, allVox_co{condy, roiInd},'k.' )
    title([listRoisComment{roiInd} '. all voxels'])
    xlabel(listCondsComment{condx}); 
    ylabel(listCondsComment{condy}); 
    identityLine

end


%%  plot semi-transparent dots
dotSize = 2; 

for jj = 1:numRois
    roiInd = analyzeRois{jj};     
    figure(); 

    % individual dots
    % plot(co_xy{jj}(1,:),co_xy{jj}(2,:),'.','color',[.5 .5 .5],'alpha',.8 )
    ff_scatter_patches(allVox_co{condx,jj}, allVox_co{condy,jj}, dotSize, 'FaceColor',[.5 .5 .5], ...
        'FaceAlpha',0.4,'EdgeColor','none');
    set(gca,'Xlim',[0 1])
    set(gca,'Ylim',[0 1])
    hold on
    
    
    identityLine
    title(['Variance Explained in ' listRoisComment{roiInd}],'FontWeight','bold')

end

% end variance explained %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prf coverage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the averaged coverage map for each type of stimuli for each roi
RF          = cell(allConds, numRois); 
RF_mean     = cell(allConds, numRois); 
RF_nan      = numSubs*ones(allConds, numRois); 


for jj = 1:numRois
    for kk = 1:allConds
        RF{kk,jj} = zeros(128,128, numSubs); 
        RF_mean{kk,jj} = zeros(128,128); 
    end
    
end


% get the RFcov for each subject ... 
for jj = 1:numRois
    roiInd = analyzeRois{jj}; 
    for kk = 1:allConds
        for ii = 1:numSubs
            if ~isempty(SSth{ii}{kk, roiInd})
                [rf, figHandle, all_models, weight, data]  = rmPlotCoveragefromROImatfile(SSth{ii}{kk, roiInd}, vfc);
                figure()

                % check that rf isn't all nans. 
                % if it is ...
                % decrease the number of subjects we have to average over
                % and replace nans with zeros so as to not break the code
                if sum(sum(isnan(rf))) ~= 0
                    RF_nan(kk,jj) = RF_nan(kk,jj) - 1; 
                    rf = zeros(128,128); 
                end
                
                % flip rf over the y-axis because the output of rmPlotCoveragefromROImatfile  
                % seems to be flipped from what is actually plotted
                rf = flipud(rf); 

                % additionally, rf is not normalized , do that here
                if max(rf(:)) ~= 0
                    rf = rf./max(rf(:)); 
                end
                
                % store it in RF
                RF{kk,jj}(:,:,ii) = rf; 
                close

            else
                RF{kk,jj}(:,:,ii) = zeros(128,128); 
            end
        end
    end
end

% and average them together ...
% not an simple average because have to take into account that some
% subjects have nans
for jj = 1:numRois
    for kk = 1:allConds
        
        RF_mean{kk,jj} = sum(RF{kk,jj},3)/RF_nan(kk,jj);
     
    end
end


% plot the average coveraged
figure();
% to make the black outer circle thing
c = makecircle(128);  
% to make the polar angle plot
inc = linspace(-16,16, 128);

for jj = 1:numRois
    roiInd = analyzeRois{jj}; 
    
    for kk = 1:allConds

        subplot(allConds,numRois,(kk-1)*numRois+jj)
        im = (RF_mean{kk,jj}); 
        im = im./max(im(:)); 
        im = im.*c; % make black outer circle
        imagesc(inc,inc',im); 

        % add polar grid on top
        p.ringTicks = (1:3)/3*vfc.fieldRange;
        p.color = 'w';
        polarPlot([], p);

        colormap hot;
        title(sprintf([listRoisComment{roiInd} '\n  ' listCondsComment{kk}]), 'FontSize', 14);
        colormap hot; axis square; axis off

    end

end

% save(gcf, [dirSave 'coveragesAverages_allRois_4'], 'png')
%% end plot coverages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% eccentricity distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% eccentricity distribution 
% for comparing across rois

EccCenters  = cell(allConds,numRois); 
EccValues   = cell(allConds,numRois); 
hEccRaw = figure; 
hEccPro = figure; 

allVox_ecc      = ff_rmRoisCombineAllSubs_field(SS,'ecc'); 
allVox_eccTh    = ff_rmRoisCombineAllSubs_field(SSth,'ecc'); 

for kk = 1:3       
    for jj = 1:numRois       
        roiInd = analyzeRois{jj}; 
        
        [evalues, ecenters] = hist(allVox_eccTh{kk,jj}, 20); 
        EccValues{kk,jj}     = evalues; 
        EccCenters{kk,jj}    = ecenters;  

        % plot proportion
        figure(hEccPro)
        grid on
        subplot(1,3,kk)
        hold on
        plot(ecenters, evalues./sum(evalues), ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{kk}],'Fontweight','bold')
        xlabel('Eccentricity (vis ang deg)')
        ylabel('Proportion')
        axis([0 15 0 0.3])
        legend(listRoisComment)
        
        % plot raw values
        figure(hEccRaw)
        grid on
        subplot(1,3,kk)
        hold on
        plot(ecenters, evalues, ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{kk}], 'Fontweight','bold')
        xlabel('Eccentricity (vis ang deg)')
        ylabel('Num Voxels')
        legend(listRoisComment)


    end

end
% end eccentricity distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% size distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SigmaCenters  = cell(allConds,numRois); 
SigmaValues   = cell(allConds,numRois); 

hSigRaw = figure; 
hSigPro = figure; 

allVox_sigma      = ff_rmRoisCombineAllSubs_field(SS,'sigma1'); 
allVox_sigmaTh    = ff_rmRoisCombineAllSubs_field(SSth,'sigma1'); 

for kk = 1:allConds
    
    for jj = 1:numRois       
        roiInd = analyzeRois{jj}; 

        [SigmaValues{kk,jj}, SigmaCenters{kk,jj}] = hist(allVox_sigmaTh{kk,jj}, 20); 
        svalues = SigmaValues{kk,jj}; 
        scenters = SigmaCenters{kk,jj}; 
        
        % plot proportion
        figure(hSigPro)
        grid on
        subplot(1,3,kk)
        
        hold on
        plot(scenters, svalues./sum(svalues), ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{kk}],'fontweight','bold')
        xlabel('pRF Size (visual angle deg)')
        ylabel('Proportion')
        axis([0 15 0 0.4])
        legend(listRoisComment)
        
        % plot raw values
        figure(hSigRaw)
        grid on
        subplot(1,3,kk)
        hold on
        plot(scenters, svalues, ':.', 'MarkerSize', 18, 'color', listRoiColor{jj})
        title([listCondsComment{kk}],'fontweight','bold')
        xlabel('pRF Size (visual angle deg)')
        ylabel('Num Voxels')
        legend(listRoisComment)

    end

end


% end size distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plot size as a function of eccentricity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; 
set(gcf, 'name', 'Size vs Ecc')

for jj = 1:numRois
    roiInd = analyzeRois{jj};
    
    for kk = 1:allConds
        
        subplot(allConds, numRois, (kk-1)*numRois + jj)
        ff_scatter_patches(allVox_eccTh{kk,jj}, allVox_sigmaTh{kk,jj},'FaceColor',[.5 .5 .5], ...
        'FaceAlpha',0.4,'EdgeColor','none')
        xlabel('Eccentricity - vis ang deg')
        ylabel('pRF size - vis ang deg')
        axis([0 15 0 15])
        title([listCondsComment{kk} '. ' listRoisComment{roiInd}],'Fontweight','bold')
        identityLine
    
    end
    
end
% end sizeVecc %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plot centers in specific rois with transparency

% gather x0 and y0 across all subjects
allVox_x0th       = ff_rmRoisCombineAllSubs_field(SSth,'x0'); 
allVox_y0th       = ff_rmRoisCombineAllSubs_field(SSth,'y0'); 

dotSize = 2; 

for jj = 1:numRois
    roiInd = analyzeRois{jj}; 
    
    figure(); 
    for kk = 2%:numConds
        condInd = analyzeConds{kk}; 
        
        ff_scatter_patches(allVox_x0th{condInd, roiInd}, allVox_y0th{condInd,roiInd}, dotSize, ...
            'FaceAlpha', 0.4, 'FaceColor', listCondsColor{kk}, 'EdgeColor', 'none'); 
        hold on
    end
    title(['pRF centers. ' listRoisComment{roiInd}], 'FontWeight', 'Bold')
    % TODO: un hard code this
    axis([-maxEccPlot maxEccPlot -maxEccPlot maxEccPlot])
    axis square
    box on
    
    p.ringTicks = (1:3)/3*maxEccPlot;
    p.color = 'w';
    polarPlot([], p);
    
    
end

%% plot mean variance explained using pool voxels over all subjects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V = allVox_co; 

% of varianced explained in an specific roi for a specific stimulus for a
% specific subject
varExpPerRoi        = zeros(numRois, 3); 
% we want to plot this matrix along the x-axis
% assign x-axis values
varExpPerRoi_x      = zeros(size(varExpPerRoi)); 
varExpPerRoi_std    = zeros(size(varExpPerRoi));

for jj = 1:numRois
   roiInd = analyzeRois{jj}; 
   
   for kk = 1:length(listCondsComment)

       temCo = V{kk,roiInd}; 
       % mean variance explained
       varExpPerRoi(roiInd,kk) = mean(temCo);

       % assigning values to make plot later
       % varExpPerRoi_x(jj,kk) = (jj-1)*3 + kk; 
       varExpPerRoi_x(roiInd,kk) = jj;
       
       % std of variance explained
       varExpPerRoi_std(roiInd,kk) = std(temCo);
       
   end
   
end


% make a string for the x axis plot
xlabs = cell(1, numRois); 
for jj = 1:numRois
    roiInd      = analyzeRois{jj}; 
    xlabs{jj}   = listRoisComment{roiInd};
end

%%% plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

figure()
for kk = 1:3
    temx    = varExpPerRoi_x(:,kk); 
    temy    = varExpPerRoi(:,kk); 
    temstd  = varExpPerRoi_std(:,kk); 
    % errorbar(temx, temy, temstd,'.', 'color', listCondColor{kk}, 'MarkerSize', 24)
    plot(temx, temy,'.', 'color', listCondsColor{kk}, 'MarkerSize', 24)
    hold on
end
grid on
set(gca,'XLim',[0 numRois + 1])
set(gca,'Xtick',1:numRois)
set(gca,'Xticklabel', xlabs)

ylabel('Mean Variance Explained (%)')
title('Mean Variance Explained','Fontweight','Bold')
legend({'Checkers','Words','False'})

%% plot beta parameters 

allVox_beta       = ff_rmRoisCombineAllSubs_field(SS,'beta'); 
allVox_betath     = ff_rmRoisCombineAllSubs_field(SSth,'beta');  

for jj = 1:numRois
    
    % preliminary plottings
    % unthresholded data
    roiInd = analyzeRois{jj};
    
    figure()
    plot(allVox_beta{condx,roiInd}, allVox_beta{condy, roiInd},'k.' )
    title([listRoisComment{roiInd} '. all voxels'])
    xlabel(listCondsComment{condx}); 
    ylabel(listCondsComment{condy}); 
    identityLine

end

%% plot beta as semi-transparent 
dotSize = 2; 

for jj = 1:numRois
    roiInd  = analyzeRois{jj};    
    roiName = listRoisComment{roiInd}; 
    figure(); 

    % individual dots
    ff_scatter_patches(allVox_beta_equal{condx,jj}, allVox_beta_equal{condy,jj}, dotSize, 'FaceColor',[.5 .5 .5], ...
        'FaceAlpha',0.4,'EdgeColor','none');
    set(gca,'Xlim',[0 1])
    set(gca,'Ylim',[0 1])
    hold on
    
    xlabel(listCondsComment{condx})
    ylabel(listCondsComment{condy})
    identityLine
    title(['Amplitude in ' roiName],'FontWeight','bold')
    
    
end

%% plot pRF size


allVox_sigma1       = ff_rmRoisCombineAllSubs_field(SS,'sigma1'); 
allVox_sigma1th     = ff_rmRoisCombineAllSubs_field(SSth,'sigma1');  

for jj = 1:numRois
    
    % preliminary plottings
    % unthresholded data
    roiInd = analyzeRois{jj};
    
    figure()
    plot(allVox_sigma1{condx,roiInd}, allVox_sigma1{condy, roiInd},'k.' )
    title([listRoisComment{roiInd} '. all voxels'])
    xlabel(listCondsComment{condx}); 
    ylabel(listCondsComment{condy}); 
    identityLine

end