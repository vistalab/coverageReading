%% script that will implements CortexAndFibersMovie.m tutorial

%% TODO. structure of the code is in place. needs clean up though:
% render all the the 20 afq outputs as pdb or mat files into the
% dti96trilin/fibers directory
% remove fiber outliers
% Then specify the names of the fiber groups instead of their indices

% ----------------------
% list_fgNames
% Left Thalamic Radiation
% Right Thalamic Radiation
% Left Corticospinal
% Right Corticospinal
% Left Cingulum Cingulate
% Right Cingulum Cingulate
% Left Cingulum Hippocampus
% Right Cingulum Hippocampus
% Callosum Forceps Major
% Callosum Forceps Minor
% Left IFOF
% Right IFOF
% Left ILF
% Right ILF
% Left SLF
% Right SLF
% Left Uncinate
% Right Uncinate
% Left Arcuate
% Right Arcuate
% L_VOF
% R_VOF

clear all; close all; clc;
bookKeeping;

%% modify here

list_subInds = 4; 

list_path = list_sessionDtiQmri;

list_fgNames = {
    'Left_Arcuate_posterior.pdb'
    'Left ILF.pdb'
    'L_VOF.pdb'
    };

list_colors = [
    [1 .5 0]
    [0 .5 1]
    [0 1 0]
    ];

% how much to shave off the fiber groups so they don't poke through the
% cortex
shave = 1;

% whether we want the mesh projected
cMesh = true; 

% whether we want to remove outliers
removeOutliers = false; 

% save the movie as
movieName = 'Left VOF and ILF and Arcuate';
moveSaveDir = '~/Dropbox/TRANSFERIMAGES/';

%% define things
numFgs = length(list_fgNames);

%% do it
for ii = list_subInds
        
    dirDiffusion = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    segPath = fullfile(dirAnatomy, 't1_class.nii.gz');
    fgDir = fullfile(dirDiffusion, 'dti96trilin','fibers');
    chdir(dirDiffusion);
    
    %% remove the endpoints of the fibers so they don't show through the cortex. also reove outlier fibers
    % not necessary, just prettier
    
    for ff = 1:numFgs
        
        % current fiber group
        fgName = list_fgNames{ff};
        fgPath = fullfile(fgDir, fgName);
        fg = dtiLoadFiberGroup(fgPath);
        
        % remove outliers if so desired
        if removeOutliers
            fg(ff) = AFQ_removeFiberOutliers(fg(ff), 4,100,25);
        end
        
        % number of individual fibers in the fiber group
        numFibers = length(fg(ff).fibers); 
        
        % truncate each fiber in the fiber group
        for f = 1:numFibers
            fg(ff).fibers{f} = fg(ff).fibers{f}(:,shave:end-shave);
        end
        
    end
    
    %% render the fibers and cortex
    for ff = 1:numFgs
        fgColor = list_colors(ff,:);
       
        % render the fibers
        if ff == 1 % create the figure window
            lightH = AFQ_RenderFibers(fg(ff),'color',fgColor,'numfibers',500,'newfig',1);

        else % add to same figure window
            AFQ_RenderFibers(fg(ff),'color',fgColor,'numfibers',500,'newfig',0);           
        end
                
    end
    axis('off');
    
    %% Add a rendering of the cortical surface
    if cMesh
        corticalSurface = AFQ_RenderCorticalSurface(segPath, 'boxfilter', 5, 'newfig', 0);
    end
    
    % Delete the light object and put a new light to the right of the camera
    delete(lightH);
    lightH = camlight('right');

end

%% Make a video showing the cortex and underlying tracts

% These next lines of code perform the specific rotations that I desired
% and capture each rotation as a frame in the video. After each rotation we
% move the light so that it follows the camera and we set the camera view
% angle so that matlab maintains the same camera distance.

% transparent mesh so we can see fibers
alpha(corticalSurface,0.2)

for ii = 1:45
    ii
    % Rotate the camera 5 degrees down
    camorbit(0, -2);
    % Set the view angle so that the image stays the same size
    set(gca,'cameraviewangle',8);
    % Move the light to follow the camera
    camlight(lightH,'right');
    % Capture the current figure window as a frame in the video
    mov(ii)=getframe(gcf);
end

% Now rotate along the diagonal axis
for ii = 46:90
    ii
    camorbit(2,2);
    set(gca,'cameraviewangle',8);
    camlight(lightH,'right');
    mov(ii)=getframe(gcf);
end

% Rotate to see the top of the brain
for ii = 91:135
    ii
    camorbit(0,2);
    set(gca,'cameraviewangle',8);
    camlight(lightH,'right');
    mov(ii)=getframe(gcf);
end

% And rotate back to our starting position
for ii = 136:181
    ii
    camorbit(-2,-2);
    set(gca,'cameraviewangle',8);
    camlight(lightH,'right');
    mov(ii)=getframe(gcf);
end

% Adjust the transparence of the cortex so that the underlying fiber tracts
% begin to appear.

%% Save the movie as a .avi file to be played by any movie program
movie2avi(mov,fullfile(moveSaveDir, [movieName '.avi']),'compression','none','fps',15)
