function [v] = c2v_init(varargin)
% initializes css2vista parameters that most likely do not change based on
% the institute
% INPUTS
% 1. center:    imaging center. Current choices are: 
%               'CNILarge' : large field of view (16 deg) at Stanford CNI
%               'CNISmall' : small field of view (6 deg) at Stanford CNI
%               If no value is specified, will default to 'CNILarge'.
% OUTPUTS
% 2. v:         a structure with various fields
%               TODO: fill these in                

if naragin == 0
    imageCenter = 'CNILarge'; 
end

if naragin == 1
    imageCenter = varargin{1}; 
end

%% parameters relevant to CNILarge
if strcmp(imageCenter,'CNILarge')
    % TR of data acquisition
    v.trOrig                = 2;
    
    % TR that interpolate the time series to
    v.trNew                 = 1; 
    
    % radius of the vield of view that the subject sees.
    % in units of visual angle degrees. 
    v.fieldSize             = 16; 
    
    % distance between subject and screen, in cm
    % CNISmall: 277cm | CNILarge: 41 
    v.visualDist            = 41; 
    
    % height of the screen, in cm
    % CNISmall: 58.6 | CNILarge 30
    v.cmScrHeight           = 30;
    
    % width of the screen, in cm
    % large tv: 103.8 | hemi circle: 48 
    v.cmScrWidth            = 48; 
    
    % num pixels in the vertical direction
    % CNISmall: 1080 | CNILarge: 1200 | rl macair: 900 
    v.numPixHeight          = 1200; 
    
    % num pixels in the horizontal direction
    % large tv: 1920 | hemi circle: 1920 | macair: 1440
    v.numPixWidth           = 1920; 

    
    % even with the same stimulus movie, css results are flipped over the
    % y-axis as compared to vista results. 
    % not an ideal solution, but for now, have css results  match that of vista -
    % indicate whether this entails flipping over y-axis
    v.flipPhaseOverYAxis    = 1; 

    % what transformation needs to be made to kendricks results, which are
    % saved in a 80 x 80 x 36 matrix. could be a multitude of orientations. 
    % the way to figure this out is to look at the meanvol field of kendrick's
    % results, see how it is flipped with respect to the T1-weighted anatomy
    % 0 - no transformation needs to be made
    % 1 - 90 degrees clockwise and flipped across the y axis
    % 2 = 90 degrees clockwise
    % TODO: must be a better way to do this. 
    v.flipMap = 0; 

    
    
    v.numPixStimNative      = 768;   % TODO: should be able to get rid of this ...
    


    % there is an element of hardcoding in here ... TODO: fix this
    v.mapNameR2             = 'knkR2';

end

%% parameters relevant for all imaging centers
% pths and directories where we want the tranformed prf parameters to be stored
pth.css2vistaFileDir    = [pth.session '/Gray/' v.dtName '/'];
pth.css2vistaFileName   = ['retmodel-knk2vista-' datestr(now,'yyyy-mm-dd')] ; 

% the wrapped variable mat file has all the parameters that are input into
% the knk function analyzePRF. a copy of these variables are also saved in
% the converted vista ret model file. Here we specify
% what/where we want the wrapped variable, with the .mat extension
% TODO: get rid of this eventually
pth.knkWrapped = [pth.session 'Gray/' v.dtName '/knkwrapped_rl20141026.mat'];

% this will change if <results> output from analyzePRF returns
% different fields
v.mapList               = {'ang', 'ecc', 'expt','rfsize','R2','meanvol'};




end

%% params that need the user to fill in:
% pth.session
% pth.outputParams
% v.knkStim 
% pth.Data 
% pth.stimulus
% v.dtName
% v.retFuncNum   
% pth.css2vistaFileDir
% pth.css2vistaFileName
% pth.knkWrapped 
% pth.knkResultsSave



