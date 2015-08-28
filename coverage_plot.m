%% assumes a view is with a rm and roi is loaded
% will plot the visual field coverage with predefined values of 
% colormap, bootstrapping steps, etc so we won't have to deal with gui

vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

%%

rmROI = rmGetParamsFromROI(VOLUME{end}); 

% do flipping here because ff_rmPlotCoveragefromROImatfile does flipping
% probably because of some flipping in the saving of the rmroi struct...
% admittedly a mess
rmROI.y0 = -rmROI.y0; 

ff_rmPlotCoveragefromROImatfile(rmROI, vfc, VOLUME{end}); 

% name of the roi. delete the '_rl' at the end of it
tem = rmROI.name; 

if strcmp(tem(end-2:end), '_rl')
    roiName = tem(1:end-3); 
else
    roiName = tem; 
end
title(roiName,'FontSize', 24)