%% visualizes the difference in 2 coverage maps as a map
% Assumptions
% That Userdata has the following fields: vfc and rf

% CURRENTLY NOT THE MOST INTUITIVE WHEN VISUALIZED
% The difference can be positive or negative
% Need a color map that helps make sense of this

%% modify here

% path to fig 1
pathfig1 = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/contours/CI/left_VWFA. Group. Contour Level 0.9. Words. css.fig';

% path to fig 2
pathfig2 = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/contours/CI/left_VWFA. Group. Contour Level 0.9. FalseFont. css.fig';

% description
descript = 'Words minus FalseFont';

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.2;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = true;
vfc.cmap            = 'gray';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

%% end modification section

fig1 = openfig(pathfig1);
fig1_userdata = get(gcf, 'userdata');

fig2 = openfig(pathfig2);
fig2_userdata = get(gcf, 'userdata');

% difference of 2 rfs
rf_diff = fig1_userdata.rf - fig2_userdata.rf; 

%% plot the new coverage map
% MAKE THIS A FUNCTION: coverage plot from 128 x 128 matrix

close all; 

figure; 

% flip about the x axis
rf = flipud(rf_diff);

% to make the black outer circle thing
c = makecircle(vfc.nSamples);  

% to make the polar angle plot
inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);

% make black outer circle
rf = rf.*c; 
imagesc(inc,inc',rf); 

% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = 'w';
polarPlot([], p);

% colormap
colorbar;
colormap(vfc.cmap)

% title
titleName = descript; 
title(titleName)