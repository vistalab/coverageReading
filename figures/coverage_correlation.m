%% calculate the correlation between 2 coverage maps
% linearize rfcov (128x128 matrix) and compute the correlation between 2
% coverage maps. 
clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 7%[1:20]; 

% Coverage map #1 
roiName_1 = {
    'right_VWFA_rl'
    };
dtName_1 = {
    'Words'
    };
rmName_1 = {
    'retModel-Words-css.mat'
    };

% Coverage map #2
roiName_2 = {
    'left_VWFA_rl'
    };
dtName_2 = {
    'Words'
    };
rmName_2 = {
    'retModel-Words-css.mat'
    };

% Flip
% say for example we want to compare the same roi for different
% hemisphers. Then we have to flip the coverages to make an accurate
% comparison
flipping = true;

% Binarizing
binarized = true;
contourLevel = 0.5;

% vfc parameters
vfc = ff_vfcDefault; 
vfc.cmap = 'hot';
vfc.addCenters = true; 
% vfc.nboot = 0; 

%% define things
numSubs = length(list_subInds);
C = zeros(numSubs,1);

roiName1 = ff_stringRemove(roiName_1{1}, '_rl');
roiName2 = ff_stringRemove(roiName_2{1}, '_rl');

%% define the rmroi cell
rmroiCell_1 = ff_rmroiCell(list_subInds, roiName_1, dtName_1, rmName_1);
rmroiCell_2 = ff_rmroiCell(list_subInds, roiName_2, dtName_2, rmName_2);

%% calculate

for ii = 1:numSubs
    
    close all;
    subInd = list_subInds(ii);
    subInitials = list_sub{subInd};
    
    % get the first coverage map
    rmroi1 = rmroiCell_1{ii}; 
    [rfcov1, fh1] = rmPlotCoveragefromROImatfile(rmroi1,vfc);
    
    % get the second coverage map
    rmroi2 = rmroiCell_2{ii}; 
    [rfcov2, fh2] = rmPlotCoveragefromROImatfile(rmroi2,vfc);
    
    % flip the second one if so desired
    if flipping
       rfcov2 = fliplr(rfcov2);
    end
    
    % if binarized
    if binarized
        rfcov1 = double(rfcov1 > contourLevel);
        rfcov2 = double(rfcov2 > contourLevel);
    end
    
    % assign matrix of zeros if empty
    if (length(rfcov1) == 1)
        rfcov1 = zeros(vfc.nSamples);
    end
    if (length(rfcov2) == 1)
        rfcov2 = zeros(vfc.nSamples);
    end
    
    % linearize, compute correlation, and store
    % cor = dot(rfcov1(:), rfcov2(:)) / (vfc.nSamples ^2)
    x = rfcov1(:)/norm(rfcov1(:),2);
    y = rfcov2(:)/norm(rfcov2(:),2);
    cor = acos(dot(x,y));
    
    % Check that x and y are unit length   
    % cor = norm(rfcov1(:) - rfcov2(:)) / vfc.nSamples; 
    C(ii) = cor; 
    
    %% put into a subplot
    hSubplot = figure; 
    subplotSize = [1,2];
    
    % titles for the individual subplots
    vecTitles = cell(2,1);
    for jj = 1:2
        roiName = eval(['roiName' num2str(jj)]);
        vecTitles{jj} = {[roiName '. ' subInitials], ...
        ['Distance: ' num2str(cor)]}; 
    end
    
    % SUBPLOT
    ff_coverage_subplot(hSubplot, subplotSize, [fh1, fh2] , vecTitles, vfc);

    % SAVE
    figure(hSubplot)
    titleName = ['Coverage distance. ' subInitials '. ' roiName1 ' and ' roiName2];
    ff_dropboxSave('title', titleName);
   
end




