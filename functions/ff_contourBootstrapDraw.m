function ff_contourBootstrapDraw(RFCov,vfc, data, m)
% ff_contourBootstrapDraw(RFCov,vfc, data, m)
%
% INPUTS
% RFCov: a vfc.nSamples x vfc.nSamples
% vfc: visual field coverage params
% vfc = 
% 
%          ellipsePlot: 0
%         ellipseLevel: 0.9000
%          contourPlot: 0
%         contourLevel: 0.9000
%         contourColor: [0 0 0]
%             prf_size: 1
%           fieldRange: 15
%               method: 'max'
%               newfig: 1
%                nboot: 50
%       normalizeRange: 1
%          smoothSigma: 3
%             cothresh: 0.2000
%            eccthresh: [0 15]
%             nSamples: 128
%           meanThresh: 0
%               weight: 'varexp'
%           weightBeta: 1
%                 cmap: 'gray'
%                clipn: 'fixed'
%          threshByCoh: 1
%           addCenters: 1
%              verbose: 1
%         dualVEthresh: 0
%      backgroundColor: [0.9000 0.9000 0.9000]
%         ellipseColor: [1 0 0]
%     contourBootstrap: 1
%
%
% data: 
%     figHandle: 1
%            co: [1x424 double]
%            ph: [1x424 double]
%         subCo: [1x215 double]
%         subPh: [1x215 double]
%        subEcc: [1x215 double]
%         subx0: [1x215 double]
%         suby0: [1x215 double]
%      subSize1: [1x215 single]
%      subSize2: [1x215 single]
%             X: [128x128 single]
%             Y: [128x128 single]
%       subSize: [1x215 single]
% 
% m: a vfc.nboot x (vfc.nSample^2) matrix


% how many times to bootstrap?
nboot = vfc.nboot; 

% plot the contour (and/or ellipse for each sample)
for nn = 1:nboot
    
    rf = m(nn,:); % rf is 1x16384
    rfcov = reshape(rf, [1 1] .* sqrt(numel(rf))); % 128 x 128
    
    % get the contour info for this 
    [contourMatrix, contourCoordsX, contourCoordsY] = ...
        ff_contourMatrix_makeFromMatrix(rfcov,vfc,vfc.contourLevel);

    % transform so that we can plot it on the polar plot
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    
    % draw! 
    plot(contourX, contourY, ...
        'Marker', 'o', ...
        'MarkerFaceColor', vfc.contourColor, ...
        'MarkerEdgeColor', vfc.contourColor, ...
        'Color', vfc.contourColor, ...
        'MarkerSize', 2, ...
        'LineWidth',1);

    hold on; 
    
end




end