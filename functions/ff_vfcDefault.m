function vfc = ff_vfcDefault()

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = false;                
vfc.cothresh        = 0.2;         
vfc.eccthresh       = [0 15];
vfc.sigthresh       = [0 15];
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = true;
vfc.cmap            = 'jet';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = true;                
vfc.addCenters      = false;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.backgroundColor = [.9 .9 .9]; 
vfc.ellipsePlot     = false; 
vfc.ellipseLevel    = 0.5;
vfc.ellipseColor    = [1 0 0];
vfc.contourPlot     = false; 
vfc.contourLevel    = 0.5; 
vfc.contourColor    = [0 0 0];
vfc.tickLabel       = false; 
vfc.contourBootstrap= false; 

end