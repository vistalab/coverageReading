function [dice] = ff_coverage_diceCoefficient(RFcov1, RFcov2, contourLevel1, contourLevel2)
% [dice] = ff_coverage_diceCoefficient(RFcov1, RFcov2, contourLevel1, contourLevel2)
%
% Compare the similarity between two samples using the dice coefficient
% also known as "similarity coefficient" 
% This function will compare the similarity of 2 FOVs, given a contour
% level:
% S = 2|intersection(X,Y)| / |X| + |Y|

%% Create a binary matrix for the two RFcovs
% 1: within the contourLevel, 0: not

RFcov1_binary = RFcov1 >= contourLevel1; 
RFcov2_binary = RFcov2 >= contourLevel2; 

%% Get the coefficient

% number of overlapping pixels
numOverlap = sum(sum(RFcov1_binary & RFcov2_binary)); 

% total number of pixels
numRFcov1 = sum(RFcov1_binary(:)); 
numRFcov2 = sum(RFcov2_binary(:));

% dice coefficient
dice = 2*numOverlap / (numRFcov1 + numRFcov2);

end