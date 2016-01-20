%% script that will make nifti files of functional roi endpoints
% Example use: we want to see the endpoints of the VOF in relation to
% visual field maps
%
% Run the script dti_makeNiftisFromFiberGroups

clear all; close all; clc; 
bookKeeping;

%% modify here

% subjects we want to do this for. see bookKeeping
list_subInds = [4];

% the fiber groups we're interested, WITHOUT the .mat extension
list_fiberGroups = {
    'L_Arcuate_Posterior'
    };

% Directory where the fiber group rois are stored, in relation to 
% dirDiffusion, the main diffusion directory
dirFibersRel = fullfile('dti96trilin', 'fibers');

% Directory where the nifti will be stored, in relation to dirDiffusion,
% the main diffusion directory
dirNiftisRel = fullfile('niftis');


%% end modification section

% number of fiber groups
numFgs = length(list_fiberGroups); 



%% loop over subjects and fiber groups

for ii = list_subInds
   
    % subject's diffusion directory
    dirDiffusion = list_sessionDtiQmri{ii};
    
    % make the nifti directory if it is not yet made
    dirNiftis = fullfile(dirDiffusion, dirNiftisRel);
    if ~exist(dirNiftis, 'dir')
        mkdir(dirNiftis);
    end
    
    %% load in a nifti image that has the same coordinates as the fibers
    % for example the b0 or t1. 
    % In this case it would be the b0
    % Some amount of hard coding going on here
    templatePath = fullfile(dirDiffusion, 'dti96trilin', 'bin','b0.nii.gz');
    templateImg = readFileNifti(templatePath);
    
    for jj = 1:numFgs
        
        % fiber group name and path
        fgName = list_fiberGroups{jj};
        fgPath = fullfile(dirDiffusion, dirFibersRel, [fgName '.mat']);
        
        % read in the fiber group
        fg = dtiReadFibers(fgPath);
        
        % compute a fiber density image. 
        % Note that if fg contains multiple fiber groups you should pass in just one (eg. fg(19))
        fdImg = dtiComputeFiberDensityNoGUI(fg, templateImg.qto_xyz, size(templateImg.data), 1);
        
        % Smooth the image slightly if desired to make the coloring less patchy. 3-5mm usually looks nice
        fdImg = smooth3(fdImg, 'gaussian', 3);
        
        % Steal the header information from the template image 
        templateImg.data = fdImg;
        
        % name to save as
        templateImg.fname = fullfile(dirNiftis, [fgName '.nii.gz']);
        writeFileNifti(templateImg);
        
    end
    
end

