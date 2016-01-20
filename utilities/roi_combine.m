%% manipulate rois: e.g., combine them into a new one
close all; clear all;  clc; 
bookKeeping; 

%% modify here

% session list
list_path = list_sessionRet; 

% subjects to do this for
list_subInds = [20:22]; 

roisToCombine = {
    'left_VWFA_rl'
    'right_VWFA_rl';
}; 
roiNewName  = 'combined_VWFA_rl'; 
roiNewColor = 'w'; 
roiAction   = 'Union';  


% -- combine mFus_Face and pFus_Face and iOG into Ventral_Face
% roisToCombine = {
%     'lh_mFus_Face_rl'; 
%     'lh_pFus_Face_rl'; 
%     'lh_iOG_Face_rl';
% }; 
% roiNewName  = 'lh_FacesVentral_rl'; 
% roiNewColor = 'm'; 
% roiAction   = 'Union';  


%%

% number of subjects to perform this operation on
numSubs = length(list_sessionPath); 

% number of rois to combine
numRois = length(roisToCombine); 

for ii =  list_subInds
    
    % move to subject directory and open their gray view
    chdir(list_path{ii})
    vw = initHiddenGray; 
    
    % subject's shared anatomy file
    d = fileparts(vANATOMYPATH);
    
    % load rois into the view
    % [vw, ok] = loadROI(vw, filename, select, clr, absPathFlag, local)
    % will assume that roi path is absolute, in the shared directory
    for jj = 1:numRois
        pathRoi = fullfile(d, 'ROIs', roisToCombine{jj}); 
        vw = loadROI(vw, pathRoi, [], [], 1, 0); 
    end

    % grab the roi struct
    rois = viewGet(vw,'ROIs');

    % combine the rois   
    % first find starting ROI (selected ROI):
    coords = rois(1).coords;
    
    for r=2:size((rois),2)
        if ~isempty(rois(r).coords)
            coords = combineCoords(coords,rois(r).coords,roiAction);
        end
    end

    % now add new ROI:
    ROI.color    = roiNewColor;
    ROI.coords   = coords;
    ROI.name     = roiNewName;
    ROI.viewType = vw.viewType;
    ROI          = sortFields(ROI);  
    vw = addROI(vw,ROI);

    % save the new roi
    %  [vw, status, forceSave] = saveROI(vw, ROI, local, forceSave)
    vw = saveROI(vw, ROI, 0, 1); 

    close all; 
end

