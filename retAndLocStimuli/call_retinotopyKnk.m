%% wrapper script to call <call_retinotopyKnk>
clear all; close all; clc; 
addpath(genpath('/Applications/BrainSoftware/knkutils'))

%% modify here

% subject ID
subID = 'test'; 

% directory where we have the image matrices
imagesDir = '/Users/rosemaryle/matlabExperiments/knkret';

% name of the image matrix. Options:
% English - 'Words_English.mat'
% Hebrew  - 'Words_Hebrew.mat'
imagesName = 'Words_English.mat';

%% end modification section 

% background color
grayval = uint8(127); 

% whether we want the fixation grid. 0 = no, 1 = yes
fixationGrid = 1;

% stimulus starts when this key is detected
triggerkey = 'g';          

% full path of image matrix
pathImages = fullfile(imagesDir, imagesName);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expnum      = 103;
runnum      = 2; 
pathMasks   = '/Users/rosemaryle/matlabExperiments/knkret/maskimages.mat';

% how many frames we want a refresh to last. default: 15. previously: 4. 
% the lower the faster
frameduration = 4;

% directories
% path to directory that contains the stimulus .mat files
stimulusdir = '/Users/rosemaryle/matlabExperiments/knkret/';         

%tweaking (in the cni)
dres    = -.9;              % <dres> (optional) is
                            %   [A B] where this is the desired resolution to imresize the images to (using bicubic interpolation).
                            %     if supplied, the imresize takes place immediately after loading the images in, and this imresized 
                            %     version is what is cached in the output of this function.
                            %  -C where C is the <scfactor> input in ptviewmovie.m
                            %   default is [] which means don't do anything special.  
                            % seems to crash for values >= 1
                            

offset  = [0 -35];        % [X Y] where X and Y are the horizontal and vertical
                           % offsets to apply.  for example, [5 -10] means shift 
                           % 5 pixels to right, shift 10 pixels up.
     
                           
% dres    = [];
% offset  = [0 0];

%%

if exist('pathImages','var')
    load(pathImages); % should load a variable called images
end

if exist('pathImages','var')
    load(pathMasks);
end

% display. currently not sure when/whether we should specify or define it as empty
% ptres = [1024 768 60 32]; 
ptres = [];  % display resolution. [] means to use current display resolution.

% fixation dot
fixationinfo = {uint8([255 0 0; 0 0 0; 0 255 0]) 0.5};  % dot colors and alpha value
fixationsize = 10;         % dot size in pixels
meanchange = 3;            % dot changes occur with this average interval (in seconds)
changeplusminus = 2;       % plus or minus this amount (in seconds)

% trigger
tfun = @() fprintf('STIMULUS STARTED.\n');  % function to call once trigger is detected

% tweaking
% offset = [0 0];
movieflip = [0 0];         % [A B] where A==1 means to flip vertical dimension
                           % and B==1 means to flip horizontal dimension

%%%%%%%%%%%%%%%%%%%%%%%%%% DO NOT EDIT BELOW

% set rand state
rand('state',sum(100*clock));
randn('state',sum(100*clock));

% ask the user what to run
% if ~exist('subjnum','var') 
%   subjnum = input('What is the subj id? ','s')
% end
% expnum = input('What experiment (89=CCW, 90=CW, 91=expand, 92=contract, 93=multibar, 94=wedgeringmash)? ')
% runnum = input('What run number (for filename)? ')

% prepare inputs
trialparams = [];
ptonparams = {ptres,[],0};
iscolor = 1;
soafun = @() round(meanchange*(60/frameduration) + changeplusminus*(2*(rand-.5))*(60/frameduration));

% load specialoverlay
a1 = load(fullfile(stimulusdir,'fixationgrid.mat'));
% assign depending on whether or not we want fixation grid
if fixationGrid
    g = a1.specialoverlay;
    gscale = imresize(g, -dres);
    gridImage = gscale;
else
    gridImage = [];
end


% some prep
if ~exist('images','var')
  images = [];
  maskimages = [];
end
filename = sprintf('%s_subj%d_run%02d_exp%02d.mat',gettimestring,subID,runnum,expnum);
             
[images,maskimages] = ...
  showmulticlass(filename,offset,movieflip,frameduration,fixationinfo,fixationsize,tfun, ...
                 ptonparams,soafun,0,images,expnum,[],grayval,iscolor,[],[],[],dres,triggerkey, ...
                 [],trialparams,[],maskimages,gridImage,stimulusdir);  


% template version
% function [images,maskimages] = showmulticlass(outfile,offset,movieflip,frameduration,fixationinfo,fixationsize, ...
%   triggerfun,ptonparams,soafun,skiptrials,images,setnum,isseq,grayval,iscolor, ...
%   numrep,con,existingfile,dres,triggerkey,framefiles,trialparams,eyelinkfile,maskimages,specialoverlay, ...
%   stimulusdir)

%%%%%%%%%%%%%%%%%%%%%%%%%%

% KK notes:
% - remove performance check at end
% - remove resampling and viewingdistance stuff
% - remove hresgrid and vresgrid stuff
% - hardcode grid and pregenerate
% - trialparams became an internal constant
