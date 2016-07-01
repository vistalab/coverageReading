%% script that will clip fibers that are within an ROI
clear all; close all; clc; 
bookKeeping; 


%% modify here

% subjects we want to do this for
list_subInds = 4;

% roi name
% assumes roi is in dirDiffusion/ROIs
roiName = 'rect4_leftParietal';

% roi extension
roiExt = '.mat';

% whole brain fiber group
% path relative to dirDiffusion
fgName = fullfile('dti96trilin', 'fibers', 'fg_mrtrix_50000+rect4_leftParietal.pdb');

%% do work here

% roi name with ext
roiNameWithExt = [roiName roiExt];

for ii = list_subInds
    
    % move
    dirDiffusion = list_sessionDtiQmri{ii};
    chdir(dirDiffusion);
    
    % read in the whole brain fibergroup
    fgPath = fullfile(dirDiffusion, fgName);
    fgData = fgRead(fgPath);
    
    % read in the roi
    % roiData.coords is a numCoords x 3 double
    roiPath = fullfile(dirDiffusion, 'ROIs', roiNameWithExt); 
    roiData = dtiReadRoi(roiPath);
    
    % number of fibers in the fiber group that runs through the roi
    % fgData.fibers{1} is a 3 x lengthFiber double
    numFibers = length(fgData.fibers); 
    
    % number of points in the roi
    numRoiPoints = size(roiData.coords,1);
    
    % create a new fiber group
    % have it be a replica of fgData because fgCreate has other fields that
    % might be causing some bugs
    fgNew = fgData; 
    fgNew.name = ['fibersWithin_' roiName];
    fgNew.fibers = {};     
    
    %% loop over the roi coordinates and the fibers
    % keep the fibers that fall within the roi
    % this is currently slow and painful
    

    % looping across fibers
    for ff = 1:numFibers

        % this fiber
        fiber = fgData.fibers{ff}; 

        % fiber length
        lenFiber = size(fiber,2);

        % intialize new fiber
        newFiber = []; 

        % looping within fibers
        for ww = 1:lenFiber;

            % this fiber coord
            fiberCoord = fiber(:,ww); 
            fiberCoord = fiberCoord(:); 
            
            % looping over roi coordinates
            for rr = 1:numRoiPoints

                % this roi coordinate
                roiCoord = roiData.coords(rr,:); 
                roiCoord = roiCoord(:); 

                % check whether roi and fiber coord are close in space
                % things to consider: roi coords are in integers
                % also, roi coords are not continuous
                % so we do this "close enough" distance check to try to get
                % the fibers that pass through the roi

                if norm(fiberCoord - roiCoord) < 1
                    newFiber = [newFiber fiberCoord];
                end
                
            end

        end

        fgNew.fibers{ff,1} = newFiber; 


    end
        
    

    % save new fiber group - in the same directory that the original one
    % was saved in. do as both mat and pdb
    fgSaveDir = fileparts(fgPath);
    chdir(fgSaveDir);
    fgWrite(fgNew, [], 'mat'); 
    fgWrite(fgNew, [], 'pdb'); 
    
    
end

