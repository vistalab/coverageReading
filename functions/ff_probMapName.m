function probMapName = ff_probMapName(roiName, stimType, modelType, contourLevel)
% ff_probMapName(roiName, stimType, modelType, subsInRoi, contourLevel);
% standardized naming scheme for probabilistic coverage maps

probMapName = [roiName '_' stimType '_' modelType '_' 'contour' ff_dec2str(contourLevel)];

end