%% for a Wang template nifti, and a t1 nifti (in the same space and same dimensions!)
% create diffusion rois!
%     'V1v_Wang'   % 01  
%     'V1d_Wang'   % 02
%     'V2v_Wang'   % 03 
%     'V2d_Wang'   % 04  
%     'V3v_Wang'   % 05  
%     'V3d_Wang'   % 06  
%     'hV4_Wang'   % 07 
%     'VO1_Wang'   % 08 
%     'VO2_Wang'   % 09 
%     'PHC1_Wang'  % 10  
%     'PHC2_Wang'  % 11  
%     'MST_Wang'   % 12  
%     'hMT_Wang'   % 13  
%     'LO2_Wang'   % 14  
%     'LO1_Wang'   % 15  
%     'V3b_Wang'   % 16  
%     'V3a_Wang'   % 17  
%     'IPS0_Wang'  % 18  
%     'IPS1_Wang'  % 19  
%     'IPS2_Wang'  % 20   
%     'IPS3_Wang'  % 21  
%     'IPS4_Wang'  % 22  
%     'IPS5_Wang'  % 23  
%     'SPL1_Wang'  % 24  
%     'FEF_Wang'   % 25
% 0: everything else

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subject index
subInd = 40; 

% wData. twhich template values to use. 
% 'round': the rounded values
% 'discrete': the discrete values
% 'ceil': ceiling. Use for Wang atlas
wData = 'discrete';

%% do things

% directory with the template
dirVista = list_sessionRet{subInd}; 
templateLoc = fullfile(fileparts(dirVista),'retTemplate','output'); 

% template nifti
templateName = 'rt_sub000_scanner.wang2015_atlas.nii.gz';
templatePath = fullfile(templateLoc, templateName);

% the anatomy that is the input to the template. 
% important: must be of the same space and resolution
anatomyPath = fullfile(list_anatomy{subInd}, 't1.nii.gz');

% subject's shared anatomy directory
dirAnatomy = list_anatomy{subInd};

% read in the template nifti
% niiTemplate is a nifti file consisting of 0s,1s,2s,3s
niiTemplate = readFileNifti(templatePath);
dataField = niiTemplate.data; 
dataFieldRound = round(dataField); 
dataFieldCeil = ceil(dataField);

switch wData
    case 'round'
        theData = dataFieldRound; 
    case 'discrete'
        theData = dataField; 
    case 'ceil'
        theData = dataFieldCeil; 
end

% make the nifti roi directory if it does not exist
dirSave = fullfile(dirAnatomy, 'ROIsNiftis');
if ~exist(dirSave, 'dir')
    mkdir(dirSave)
end

% Wang atlas numbers correspond to these ROIs:
list_saveNames = {
    'V1v_Wang'   % 01  
	'V1d_Wang'   % 02
    'V2v_Wang'   % 03 
    'V2d_Wang'   % 04  
    'V3v_Wang'   % 05  
    'V3d_Wang'   % 06  
    'hV4_Wang'   % 07 
    'VO1_Wang'   % 08 
    'VO2_Wang'   % 09 
    'PHC1_Wang'  % 10  
    'PHC2_Wang'  % 11  
    'MST_Wang'   % 12  
    'hMT_Wang'   % 13  
    'LO2_Wang'   % 14  
    'LO1_Wang'   % 15  
    'V3b_Wang'   % 16  
    'V3a_Wang'   % 17  
    'IPS0_Wang'  % 18  
    'IPS1_Wang'  % 19  
    'IPS2_Wang'  % 20   
    'IPS3_Wang'  % 21  
    'IPS4_Wang'  % 22  
    'IPS5_Wang'  % 23  
    'SPL1_Wang'  % 24  
    'FEF_Wang'   % 25
    };

%% loop over template rois
numRois = length(list_saveNames); 

% loop through the ROIs and make new niftis
for jj = 1:numRois
    
    saveName = list_saveNames{jj};
   
    %% a new nifti 
    nii = niiTemplate; 
    tmp = (theData == jj);
    newData = single(tmp); 
    
    % the data field is of class single
    nii.data = newData; 
    
    %% save the new nifti
    savePath = fullfile(dirSave, [saveName '.nii.gz']); 
    nii.fname = savePath; 
    writeFileNifti(nii); 
    
end

%%
chdir(dirSave)
