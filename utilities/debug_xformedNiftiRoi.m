%% trying things
% make script-ify later


% path of the roi nifti
pathRoiNii = '/sni-storage/wandell/data/reading_prf/mv/dti_qmri/ROIs/LV1_rl.nii.gz';

% subject's t1
pathT1 = '/biac4/wandell/data/anatomy/vitelli/t1.nii.gz';

% naming: what to append onto roi name
% for now assume that it will be saved in the same directory as the
% original nifi
nameAppend = '_t1Header';

% new xform matrix
% matXform = [1 0 0; 0 1 0; 0 0 1; 0 0 0];


%% do things

% read in the anatomy nifti
niiT1 = readFileNifti(pathT1);

% read in the nifti
niiRoi = readFileNifti(pathRoiNii);

% copy over roi with the t1 template
niiRoiNew = niiT1; 

% change the name
[d,n,e] = fileparts(pathRoiNii);
[~,n,~] = fileparts(n);
niiRoiNew.fname = fullfile(d, [n nameAppend '.nii.gz']); 

% change the data field
niiRoiNew.data = niiRoi.data; 

% changing the xyz and time units -- this does not work
% the more methodological thing to do will be to copy over the t1 header
% entirely, outside of fname and the data
% niiRoiNew.xyz_units = 'mm';
% niiRoiNew.time_units = 'sec';

% change some of the fields
% niiRoiNew.qto_xyz = matXform; 
% niiRoiNew.qto_ijk = matXform;
% niiRoiNew.sto_xyz = matXform;
% niiRoiNew.sto_ijk = matXform;

% save the nifti
writeFileNifti(niiRoiNew)