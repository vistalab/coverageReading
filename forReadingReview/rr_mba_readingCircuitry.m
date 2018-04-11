%% Use MBA to render the reading circuitry
clear all; close all; clc; 

%% modify here

% path to the anatomy
dirAnatomy = '/biac4/wandell/data/anatomy/dames';
pathT1 = fullfile(dirAnatomy, 't1.nii.gz');

fgLoc = fullfile(dirAnatomy, 'ROIsFiberGroups');
list_fgNames = {
    'Left SLF_cleaned.pdb'
    'Left ILF_cleaned.pdb'
    'Left Arcuate_cleaned.pdb'
    'L_VOF_cleaned.pdb'
    };

% some colors
% [0.5373    0.4980    0.1882] % gold   
% [0.4431    0.4471    0.4078] % silver
%     [0.1333    0.3333    0.6471]
%     [0.6471    0.5882    0.1333]
%     [0.7686    0.1569    0.3608]
%     [0.0784    0.4196    0.1176]
list_fgColors = [
    [0.1333    0.3333    0.6471]
    [0.6471    0.5882    0.1333]
    [0.7686    0.1569    0.3608]
    [0.0784    0.4196    0.1176]
    ];


% the amount to downsample the fibers (exlcuding VOF)
samp = 2;
cmap = 'gray'; 
alphaValue = 1; 
fiberRadius = .6; % 0.35 default

% doc mrAnatXformGetSlices
displaySlices = false; 
slices     = {[-10 0 0],[0 0 -14]};
% slices     = {[-10 0 0],[0 -40 0],[0 0 -14]};
%  slices     = {[18 0 0 ]}

%% define things
numFgs = length(list_fgNames);

%% Visualize the fiber group with anatomy

if displaySlices
    t1 = niftiRead(pathT1);
    fh = figure('name','vertical parietal tract','color','k'); hold on

    for ii = 1:length(slices)
        h  = mbaDisplayBrainSlice(t1, slices{ii}, gca, cmap, 1, alphaValue);
    end
else
    fh = figure; 
end


%% loop through and display fibers
for ff = 1:numFgs
    % read in the fiber group
    fgName = list_fgNames{ff};
    fgPath = fullfile(fgLoc, fgName);
    fg = fgRead(fgPath);
    fgColor = list_fgColors(ff,:); 
    
%     % we shouldn't down sample the VOF ... but downsample the other fibers
%     % to speed up the code
%     if strfind(fgName,'VOF')
%         theFibers = fg.fibers;
%     else
%         theFibers = fg(1).fibers(1:samp:end);
%     end
        
    [fh, lh] = mbaDisplayConnectome(fg(1).fibers(1:samp:end), fh, fgColor, 'single', [], [], fiberRadius); 
    hold on; 
 
end

view(-80,30)
delete(lh)
lh = camlight('left');
axis off

% comment this out if we want a black background
set(gcf, 'color', 'white')