%% this script is a wrapper for AFQ_RenderFibers
% Randers a fiber group and tract profile in 3d

clear all; close all; clc; 
bookKeeping; 

%% modify here

% index of subject we're interested in. see bookKeeping
list_subInds = [4];

% name of the fiber group we're interested in WITHOUT the extension
fgName = 'L_Arcuate_Posterior';

% directory where fiber group is stored, relative to subject's main
% diffusion file
fgDir = fullfile('dti96trilin', 'fibers');

% extension of the saved fiber group
fgExt = '.pdb';

% where we want the image to be saved
dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/tracts';

%% end modification section
for ii = list_subInds

    % current subject initials
    initials = list_sub{ii};
    
    % move to subject's main diffusion directory
    dirDiffusion = list_sessionDtiQmri{ii};
    chdir(dirDiffusion);
    
    % subject's dt6.mat file path
    dt6Path = fullfile(dirDiffusion, 'dti96trilin', 'dt6.mat');
    dt = dtiLoadDt6(dt6Path);
    
    % full path of the fiber group
    fgPath = fullfile(dirDiffusion, fgDir, [fgName fgExt]);
    
    % read in the fiber group
    fg = fgRead(fgPath);

    %% run it!
    [lightH, fiberMesh, fvc] = AFQ_RenderFibers(fg);

    
    %% edit the figure
    titleName = [fgName '. ' initials];
    title(titleName, 'FontWeight', 'Bold')

    %% save
    saveas(gcf, fullfile(dirSave, [titleName '.png']), 'png')
    saveas(gcf, fullfile(dirSave, [titleName '.fig']), 'fig')
    
end