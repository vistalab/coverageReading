%% compare category selective rois
close all; clear all; clc; 
bookKeeping; 

%% modify here
% pick 2 rois to compare
roisToCompare = {
%     'lh_mFus_Face_rl'     %: mid fusiform. medial or on the OTS.
%     'lh_pFus_Face_rl'     %: posterior fusiform. anterior or on the pTCS.
     'lh_iOG_Face_rl'      %: posterior of the pTCS
%     'lh_FFA_Face_rl'      %: combine mFus and pFus
%     'lh_Ventral_Face_rl'  %: everything on the ventral surface
%     'rh_mFus_Face_rl'     %: mid fusiform. medial or on the OTS.
%     'rh_pFus_Face_rl'     %: posterior fusiform. anterior or on the pTCS.
%     'rh_iOG_Face_rl'      %: posterior of the pTCS
%     'rh_FFA_Face_rl'      %: combine mFus and pFus
%     'rh_Ventral_Face_rl'  %: everything on the ventral surface
    'lh_VWFA_rl'          % : on the inferior temporal sulcus (iTS), posterior of
%                             %       the mid-fusiform suclus. also sometimes on posterior fusiform
%                             %       gyrus. the iTS kind of curves upwards and is L-shaped
%     'lh_OWFA_rl'          % : anything stemming from confluent fovea
%     'lh_Ventral_Words_rl' %: combine VWFA and OWFA  
%     'rh_VWFA_rl'          % : on the inferior temporal sulcus (iTS), posterior of
%                             %       the mid-fusiform suclus. also sometimes on posterior fusiform
%                             %       gyrus. the iTS kind of curves upwards and is L-shaped
%     'rh_OWFA_rl'          % : anything stemming from confluent fovea
%     'rh_Ventral_Words_rl' %: combine VWFA and OWFA 
}; 

% pick the stimulus type 
rmFileType = 'Words'; 

% subjects to observe
subsToSee = 1:8; 

% contour level threshold
contourLevel = 0.8; 


% thresholds on roi and plotting
h.threshco      = .15;              % minimum of co
h.threshecc     = [.5 12];          % range of ecc
h.threshsigma   = [0 12];           % range of sigma
h.minvoxelcount = 5;                % minimum number of voxels in roi
% parameters for making prf coverage
vfc.fieldRange      = 12;                       % radius of stimulus
vfc.method          = 'maximum profile';        % method for doing coverage.  another choice is density
vfc.weight          = 'variance explained';     % 'fixed'
vfc.nboot           = 100;                      % number of bootstraps
% more vfc definitions that we won't likely change
vfc.cothresh        = h.threshco;        
vfc.eccthresh       = h.threshecc; 
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment 
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.normalizeRange  = true;                     % set max value to 1
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.verbose         = 1;                        % print stuff or not
vfc.newfig          = -1;                       % any value greater than -1 will result in a plot


% save
extSave = 'png';
dirSave = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';

%% store the data in R1 and R2
% also initialize some things

numSubs = length(subsToSee); 

% paths of rm file
list_pathRmFile = fullfile(list_sessionPath, 'Gray', rmFileType, ['retModel-' rmFileType]);  

% paths of roi 
list_pathRoi_1    = fullfile(list_anatPath,'ROIs',[roisToCompare{1} '.mat']); 
list_pathRoi_2    = fullfile(list_anatPath,'ROIs',[roisToCompare{2} '.mat']);

% M structs
R1 = ff_rmRoiStructAcrossSubs(list_sessionPath, list_pathRoi_1, list_pathRmFile, list_sub, subsToSee); 
R2 = ff_rmRoiStructAcrossSubs(list_sessionPath, list_pathRoi_2, list_pathRmFile, list_sub, subsToSee); 

% number of voxels in each roi for each subject
size1 = zeros(1, numSubs); 
size2 = zeros(1, numSubs); 

% roi cov areas
roiCovAreas = zeros(2, numSubs); 

% x and y that pass threshold
x1s = []; 
y1s = []; 
x2s = []; 
y2s = []; 

% effective sigmas
sig1 = []; 
sig2 = []; 

%% see if there is correlation in size (num voxels) between the 2 rois --------------------------------


for ii = 1:numSubs
    ind = subsToSee(ii); 
    
    % grab the number of voxels in each subject's roi
    size1(ii) = length(R1{ind}.co); 
    size2(ii) = length(R2{ind}.co); 
    
end

% linear regression
p   = polyfit(size1, size2, 1); 
x1  = linspace(0, 1000); 
y1  = p(1)*x1 + p(2);
%  compute correlation coefficient
ypred   = p(1)*size1 + p(2);
yresid  = ypred - size2; 
SSresid = sum(yresid.^2); 
SStotal = (length(size2)-1)  * var(size2); 
rsq = 1 - SSresid/SStotal; 

plot(size1,size2,'.k','MarkerSize',8)
hold on
plot(x1,y1)
xlabel(roisToCompare{1},'FontWeight','Bold')
ylabel(roisToCompare{2},'FontWeight','Bold')
title({['Number of voxels in ROI'],...
    ['y = ' num2str(p(1)) '*x + ' num2str(p(2)) '. R^2 = ' num2str(rsq)]},...
    'FontWeight','Bold')
grid on

%% see if there is correlation in coverage area between the 2 rois ---------------------------------
% the function rmPlotCoveragefromROImatfile returns a struct called data
% which holds thresholded data (by co, ecc, sigma)

for ii = 1:numSubs
    
    % ROI 1
    % get the 128 x 128 coverage map
    [rf, ~, ~, ~, data]  = rmPlotCoveragefromROImatfile(R1{ii}, vfc);
    % calculate how much of the map is about a certain contour level
    covArea                 = ff_coverageArea(contourLevel, vfc, rf); 
    % store the area
    roiCovAreas(1,ii)       = covArea; 
    % store the size of the roi (number of voxels that pass the threshold)
    size1(ii) = length(data.subx0); 
    % store the x and y and sigma values that pass threshold
    x1s = [x1s, data.subx0];
    y1s = [y1s, data.subx0];
    % store the effective sigmas that pass threshold
    sig1 = [sig1, data.subSize]; 
    
    % ROI 2
    % get the 128 x 128 coverage map
    [rf, ~, ~, ~, data] = rmPlotCoveragefromROImatfile(R2{ii}, vfc);
    % calculate how much of the map is about a certain contour level
    covArea             = ff_coverageArea(contourLevel, vfc, rf); 
    % store the area
    roiCovAreas(2,ii)   = covArea; 
    % store the size of the roi (number of voxels that pass the threshold)
    size1(ii) = length(data.subx0); 
    % store the x and y values that pass threshold
    x2s = [x2s, data.subx0];
    y2s = [y2s, data.subx0];
    % store the effective sigmas that pass threshold
    sig2 = [sig2, data.subSize]; 
    

end

% linear regression
area1 = roiCovAreas(1,:); 
area2 = roiCovAreas(2,:); 

% linear regression
p   = polyfit(area1, area2, 1); 
x1  = linspace(0, 0.5); 
y1  = p(1)*x1 + p(2);
%  compute correlation coefficient
ypred   = p(1)*area1 + p(2);
yresid  = ypred - area2; 
SSresid = sum(yresid.^2); 
SStotal = (length(area2)-1)  * var(area2); 
rsq = 1 - SSresid/SStotal; 

figure()
plot(area1,area2,'.k','MarkerSize',8)
hold on
plot(x1,y1,'LineWidth',1.75)

title({['Area >' num2str(contourLevel) ' Contour Level'], ...
    ['y = ' num2str(p(1)) '*x + ' num2str(p(2)) '. R^2 = ' num2str(rsq)]}, ...
    'FontWeight','Bold')
grid on


xlabel(roisToCompare{1},'FontWeight','Bold')
ylabel(roisToCompare{2},'FontWeight','Bold')

%% line plots: eccentricities for different rois
close all; 
numBins = 10; 
color1  = [0 .8 .8]; 
color2  = [.8 .8 0];

% [TH,R] = CART2POL(X,Y)
[~, ecc1]   = cart2pol(x1s, y1s); 
[~, ecc2]   = cart2pol(x2s, y2s); 

% get bin counts
[counts1, histcenters1] = hist(ecc1, numBins);
[counts2, histcenters2] = hist(ecc2, numBins);

% normalize by total number of roi voxels across subjects
counts1 = counts1./sum(counts1); 
counts2 = counts2./sum(counts2); 

% bootstrap to get 


% plot
figure();
plot(histcenters1, counts1,'-o', 'MarkerSize',7, 'LineWidth', 2, ...
    'Color', color1, 'MarkerFaceColor', color1)
hold on
plot(histcenters2, counts2,'-o', 'MarkerSize',7, 'LineWidth', 2, ...
    'Color', color2, 'MarkerFaceColor', color2)
grid on
xlabel('Eccentricity (vis ang deg)')
ylabel('Proportion')
title('All subjects - Eccentricity Centers')
legend({roisToCompare{1},roisToCompare{2}})


%% line plots: sigmas (effective) for different rois
numBins = 10; 
color1  = [0 .8 .8]; 
color2  = [.8 .8 0];

% get bin counts
[counts1, histcenters1] = hist(sig1, numBins);
[counts2, histcenters2] = hist(sig2, numBins);

% proportion
counts1 = counts1./sum(counts1);
counts2 = counts2./sum(counts2); 

% plot
figure();
plot(histcenters1, counts1,'-o', 'MarkerSize',7, 'LineWidth', 2, ...
    'Color', color1, 'MarkerFaceColor', color1)
hold on
plot(histcenters2, counts2,'-o', 'MarkerSize',7, 'LineWidth', 2, ...
    'Color', color2, 'MarkerFaceColor', color2)
grid on
xlabel('Effective sigma. (vis ang deg)')
ylabel('Proportion')
titleName = 'All subjects. prf sizes'; 
title(titleName)
legend({roisToCompare{1},roisToCompare{2}})

saveas(gcf, fullfile(dirSave, [titleName '.' extSave]), extSave)

