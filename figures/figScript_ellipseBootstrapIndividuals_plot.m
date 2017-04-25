%% The script to make the 3d scatter plot for ellipse parameters
% Some assumptions
% That we use all 20 subjects.
% % Output:   ellipse_t - structure that defines the best fit to an ellipse
%                       a           - sub axis (radius) of the X axis of the non-tilt ellipse
%                       b           - sub axis (radius) of the Y axis of the non-tilt ellipse
%                       phi         - orientation in radians of the ellipse (tilt)
%                       X0          - center at the X axis of the non-tilt ellipse
%                       Y0          - center at the Y axis of the non-tilt ellipse
%                       X0_in       - center at the X axis of the tilted ellipse
%                       Y0_in       - center at the Y axis of the tilted ellipse
%                       long_axis   - size of the long axis of the ellipse
%                       short_axis  - size of the short axis of the ellipse
%                       status      - status of detection of an ellipse

clear all; close all; clc; 
bookKeeping; 

%% modify here
% ellipse params for each bootstrapped sample is stored here
pathEllipseParams = '/sni-storage/wandell/data/reading_prf/SAVE/ellipseParamCell_6_7_11_19.mat';

list_subInds = [6 7 11 19];

%% load
% loads a variable called ellipseParamCell 
load(pathEllipseParams)

%% define and initialize
numSubs = size(ellipseParamCell,1); 
numBoots = size(ellipseParamCell,2);

% each element in this cell vector is a numBoots x 3 matrix
% dim 1: x radius of untilted ellipse
% dim 2: y radius of untilted ellipse
% dim 3: amount of tilt in radians
subjectEllipseParams = cell(1,numSubs);

% subject median ellipse parameter. careful with dimensions
subjectEllipseMedians = zeros(numSubs,3); 

%% now we do the plotting
figure; hold on; 
for ii = 1:numSubs
    
    subInd = list_subInds(ii); 
    subColor = list_colorsPerSub(subInd,:); 
    
    ellipseX = zeros(numBoots,1); 
    ellipseY = zeros(numBoots,1);
    ellipsePhi = zeros(numBoots,1); 
    
    for bb = 1:numBoots
        
        ellipseParam = ellipseParamCell{ii,bb}; 
        
        % storing
        ellipseX(bb) = ellipseParam.a; 
        ellipseY(bb) = ellipseParam.b; 
        ellipsePhi(bb) = ellipseParam.phi; 

        % plotting
        scatter3(ellipseParam.a, ellipseParam.b, ellipseParam.phi,[], subColor, 'filled')
        
    end
    
    %% store the subject's vectorized information
    subParams = [ellipseX, ellipseY, ellipsePhi];
    subjectEllipseParams{ii} = subParams; 
    
    subjectEllipseMedians(ii,:) = median(subParams); 
    
end

% plot properties
grid on; 
xlabel('Radius of the x-axis of the non-tilt ellipse');
ylabel('Radius of the y-axis of the non-tilt ellipse');
zlabel('Orientation in radians of the ellipse (tilt)');

% plot the medians
for ii = 1:numSubs
    subInd = list_subInds(ii);
    subColor = list_colorsPerSub(subInd,:); 
    
    xMed = subjectEllipseMedians(ii,1); 
    yMed = subjectEllipseMedians(ii,2); 
    phiMed = subjectEllipseMedians(ii,3);
    scatter3(xMed,yMed,phiMed,200,...
        'MarkerFaceColor', subColor, 'MarkerEdgeColor', [0 0 0], ...
        'LineWidth',2.5)   
end

%% Distances =============================================================
% subjectEllipseParams is a 1x20 cell vector, where each element is a numBoots x 3 matrix
% subjectEllipseMedians is a 20 x 3 matrix 

% distance matrix
distMatrix = zeros(numSubs);

for ii = 1:numSubs
    
    % median values for this subject
    medValues = subjectEllipseMedians(ii,:); 
    medValuesRep = repmat(medValues,numBoots,1); 
    
    %% for each of the numBoots ellipse params, calculate the distance to
    % the subject median. Then take the mediane euclidean distance
     
    for jj = 1:numSubs
                
        % subject we are comparing to
        compareTo = subjectEllipseParams{jj}; 
        
        % difference between subjectJJ and medianII
        vectorDistance = compareTo - medValuesRep; 
        euclidDistance = sqrt(vectorDistance(:,1).^2 + vectorDistance(:,2).^2 + vectorDistance(:,3).^2);
        
        distMatrix(ii,jj) = mean(euclidDistance); 
        
    end
end

%% plot distances matrix
figure; 
imagesc(distMatrix)
colorbar
title('Median Distance')
ff_dropboxSave