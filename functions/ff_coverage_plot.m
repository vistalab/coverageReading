function [RFcov, figHandle, all_models, weight, data] = ff_coverage_plot(vw, vfc)
% INPUTS: 
% 1. VOLUME: a VOLUME (the entire struct)
% 2. vfc: struct with fields indicating how to plot visual field coverage 
% vfc.prf_size        = true; 
% vfc.fieldRange      = 15;
% vfc.method          = 'max';         
% vfc.newfig          = true;                      
% vfc.nboot           = 200;                          
% vfc.normalizeRange  = true;              
% vfc.smoothSigma     = true;                
% vfc.cothresh        = 0.15;         
% vfc.eccthresh       = [0 15]; 
% vfc.nSamples        = 128;            
% vfc.meanThresh      = 0;
% vfc.weight          = 'varexp';  
% vfc.weightBeta      = 0;
% vfc.cmap            = 'hot';						
% vfc.clipn           = 'fixed';                    
% vfc.threshByCoh     = false;                
% vfc.addCenters      = true;                 
% vfc.verbose         = prefsVerboseCheck;
% vfc.dualVEthresh    = 0;


%% assumes a view is with a rm and roi is loaded
% will plot the visual field coverage with predefined values of 
% colormap, bootstrapping steps, etc so we won't have to deal with gui


%%

rmROI = rmGetParamsFromROI(vw); 
[RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rmROI, vfc); 

% name of the roi. delete the '_rl' at the end of it
tem = rmROI.name; 

if strcmp(tem(end-2:end), '_rl')
    roiName = tem(1:end-3); 
else
    roiName = tem; 
end
title(roiName,'FontSize', 24)

end
