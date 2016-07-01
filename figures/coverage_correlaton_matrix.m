%% correlation matrix between coverages
% linearize rfcov (128x128 matrix) 16384
% and stack on top of one another

clear all; close all; clc; 
bookKeeping;

%% modify here

% title of the correlation matrix
titleName = 'Matrix of angle differences. VWFA left and right. Reordered.'

list_subInds = [1:6 8:20]%[1:20]; 

% ASSUMPTION
% stacking based on rois
list_roiNames = {
    'left_VWFA_rl'
    'right_VWFA_rl'
    };
list_dtNames = {
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    };


% Flip
% say for example we want to compare the same roi for different
% hemisphers. Then we have to flip the coverages to make an accurate
% comparison.
% corresponds to the roi
list_flipping = {
    false;
    false;
    };

% Binarizing
binarized = false;
contourLevel = 0.5;

% reorder?
reorder = true;

% vfc parameters
vfc = ff_vfcDefault; 
vfc.cmap = 'hot';
vfc.addCenters = true; 

%% define things
numSubs = length(list_subInds);
numRois = length(list_roiNames);
M = zeros(numSubs * numRois, vfc.nSamples^2);

%% define the rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% make the big matrix

% size(rmroiCell) = 20  2
for jj = 1:numRois
    
    flipping = list_flipping{jj};
    
    for ii = 1:numSubs

        rmroi = rmroiCell{ii,jj};
        rfcov = rmPlotCoveragefromROImatfile(rmroi, vfc);
        % flipping
        if flipping
            rfcov = fliplr(rfcov);
        end
        
        % linearize the coverage
        rfcov_l = rfcov(:); 
        
        % normalize the vector to have length one
        rfcov_l = rfcov_l / norm(rfcov_l); 
        
        rowInd = (jj-1)*numSubs + ii; 
        M(rowInd, :) = rfcov_l;

    end
end

close all; 

%% dot product
% Geometrically, the dot product of two vectors equals the product of their
% euclidean norms and the cosine of the angle between them. 
% Since we've normalized the vectors, we are left with the cosine of the
% angle between the two vectors. cosine will range between -1 and 1. 
% acos is in radians and will range from 0 to pi. 
% 0 means there is no difference in the angles
% pi/2 means there 90 deg difference
% pi means there is 180 deg difference

% the elements on the diagonal should be 1 but sometimes they are very very 
% slightly bigger than 1 (for reasons still to be determined).
% this results in imaginary values when we take acos. so we divide by the
% max in the matrix
dotted = M * M'; 
angleDifference_cos = dotted ./ max(dotted(:));
angleDifference = acos(angleDifference_cos);

%% reorder if so desired

angleDifference_reordered = zeros(size(angleDifference));

if reorder
    % take a numSubs x numSubs square
    mat = angleDifference(1:numSubs, 1:numSubs);
%     mat = angleDifference([(numRois-1)*numSubs + [1:numSubs]], [(numRois-1)*numSubs + [1:numSubs]]);
    
    % for a given square matrix, will return the order of the reordered rows
    % where the ordering is based on some aspect of the visualization.

    % We want to reorder so that the colors are more similar.
    % Subjects that are more similar to all the others will have a lower value
    % sum in both the columns and the rows. Note that the matrix is
    % symmetric
    subEval = sum(mat,2);
    [subEvalOrder, index] = sortrows(subEval);
    
    % redefine the entire angleDifference matrix
    for rr = 1:numRois
        for cc = 1:numRois
            
            rowInds = (rr-1)*numSubs + [1:numSubs];
            colInds = (cc-1)*numSubs + [1:numSubs];
            
            matTem1 = angleDifference(rowInds, colInds);
            matTem2 = matTem1(index, :);
            matNew = matTem2(:,index');
            angleDifference_reordered(rowInds, colInds) = matNew; 
        end
    end   
    
else
    index = 1:numSubs; 
    angleDifference_reordered = angleDifference;    
end

% print out list of subject order
list_sub_included = list_sub(list_subInds);
list_sub_order = list_sub_included(index);

%% visualize
close all; 
imagesc(angleDifference_reordered); 
c = colorbar; 

% axis and label
axis square;
ha = gca;
set(ha,'XTick', [])
set(ha,'YTick',1:numSubs)
set(ha,'YTickLabel', list_sub_order)
set(ha,'FontSize',8)

% title
title(titleName, 'fontweight', 'bold','fontsize',12)

% save
ff_dropboxSave

