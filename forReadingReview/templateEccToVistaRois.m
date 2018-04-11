%% Define ROIs based on the (Benson's) template eccentricities
% Useful if for example we want to look at the time series of voxels in
% visual cortex that have ecc > 20 degrees, say.
clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = 1:8; 

templateName_ecc = 'rt_sub000_scanner.template_eccen.nii.gz';
templateName_areas = 'rt_sub000_scanner.template_areas.nii.gz';

% some assumptions here.
% eccentricity cut-off. 2 ROIs will be made. one greater than this
% eccentricity and one less than this eccentricity. 
eccCutoff = 20; 

% Assumptions here. 
% Benson template has 3 rois: V1, V2, V3
% We make a new nifti that has 1,2,3,4,5,6. 
% 1: V1, less than cutoff
% 2: V1, greater than cutoff
% 3: V2, less than cutoff
% etc. 
%
% Naming scheme: 
% Benson_V1_eccGreaterThan_20
% Benson_V1_eccLessThan_20
list_roiNames = {
    ['Benson_V1_lessThan_' num2str(eccCutoff)]
    ['Benson_V1_greaterThan_' num2str(eccCutoff)]
    ['Benson_V2_lessThan_' num2str(eccCutoff)]
    ['Benson_V2_greaterThan_' num2str(eccCutoff)]
    ['Benson_V3_lessThan_' num2str(eccCutoff)]
    ['Benson_V3_greaterThan_' num2str(eccCutoff)]
    };

%% useful
numSubs = length(list_subInds);
numRois = length(list_roiNames);

%% loop over subjects
for ii = 1:numSubs
    
    subInd = list_subInds(ii); 
    dirVista = list_sessionRet{subInd};
    templateLoc = fullfile(fileparts(dirVista), 'retTemplate', 'output');
    
    %% initialize vista session
    chdir(dirVista)
    vw = initHiddenGray;
    dirAnatomy = list_anatomy{subInd};

    %% read in the niftis
    templatePath_ecc = fullfile(templateLoc, templateName_ecc);
    niiEcc = readFileNifti(templatePath_ecc);

    templatePath_areas = fullfile(templateLoc, templateName_areas);
    niiAreas = readFileNifti(templatePath_areas);

    %% define the ROIs with respect to the cutoff
    % initialize the new nifti
    niiNew = niiAreas; 
    niiNew.data = single(zeros(size(niiAreas.data)));

    %% loop over ROIs
    for jj = 1:3

       % binary matrix. elements corresponding to the cutoffs
       indKeepGreater = (niiAreas.data == jj & niiEcc.data > eccCutoff); 
       indKeepLess = (niiAreas.data == jj & niiEcc.data <= eccCutoff);    

       % the indices corresponding to: 
       % greater than or less than 
       % and the visual area
       indKeepLess_visArea = (jj*2 -1)
       indKeepGreater_visArea = (jj*2)

       niiNew.data(indKeepLess) = indKeepLess_visArea; 
       niiNew.data(indKeepGreater) = indKeepGreater_visArea; 

    end

    % write the nifti
    indLoc = fullfile(dirAnatomy, 'ROIsNiftis');
    indName = ['Benson_areaIndices_eccCutoff_' num2str(eccCutoff) '.nii.gz'];
    niiNewPath = fullfile(indLoc, indName);
    niiNew.fname = niiNewPath; 
    writeFileNifti(niiNew);

    %% write the rois
    display('Current number of ROIs in the view: ');
    viewGet(vw, 'numRois')
    vw = nifti2ROI(vw,niiNewPath);

    % name the ROIs
    for jj = 1:numRois
        thisRoiName = list_roiNames{jj}
        vw = viewSet(vw, 'curroi', jj);
        vw = viewSet(vw, 'roiname', thisRoiName);
    end

    % Save the ROIs
    local = false; forceSave = true;
    saveAllROIs(vw, local, forceSave);
    
end
