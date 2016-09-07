%% apply a canonical xform to the diffusion data
% there is a coordinate mismatch when we try to transfer functional ROIs to
% diffusion data. Presumably because the diffusion data is not xformed
%
% let's see if this works
% save a copy of this script in each subject's directory

clear all; close all; clc; 
bookKeeping

%% modify here

% subject and subject directory
subInd = 18; 
dirDiffusion = list_sessionDtiQmri{subInd}; 

% directory dt6 lives
% we will xform all the nifti files that this points to (and append _xform)
dirDt6 = fullfile(dirDiffusion, 'dti96trilin_run1_res2');

% name of the new dt6
dt6_newName = 'dt6_xform'; 

%% load the dt6
% adcUnits, files, params, xformVAnatToAcpc

chdir(dirDt6);
load dt6

%% loop through fieldnames
fields = fieldnames(files);
chdir(dirDiffusion)

for ff = 1:length(fields)
    
    % file name
    fieldname = fields{ff};
    fname = eval(['files.' fieldname]); 
    
    %% if the file is a nifti, xform it
    if strcmp(fname(end-6:end), '.nii.gz')
        
        % read in the nifti
        nii = readFileNifti(fname);
        
        % xform
        niiXform = niftiApplyCannonicalXform(nii);
        
        % rename
        [d,n,e] = fileparts(nii.fname);
        [~,n,~] = fileparts(n);
        niiXformNewName = fullfile(d,[n '_xform.nii.gz']);
        niiXform.fname = niiXformNewName;
        
        % write the new nifti
        writeFileNifti(niiXform);
        
        % update the dt6 files variable
        files = setfield(files, fieldname, niiXformNewName);
        
    end
    
end

%% save

chdir(dirDt6)
save([dt6_newName '.mat'], 'adcUnits', 'files', 'params', 'xformVAnatToAcpc')
