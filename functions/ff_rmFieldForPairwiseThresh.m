function [rm1Field, rm2Field] = ff_rmFieldForPairwiseThresh(rm1, rm2, rmField)

% Thresholding can cause some voxels to drop out
% Problematic when we want to do voxelwise comparisons
% We need to check the indices

% INPUTS
% rm1 and rm2 should be rmroi structs - ALREADY THRESHOLDED
% TODO: more detail about rmroi structs
%
% rmField. options
% co. sigma. ecc


%% indices bookkeeping

% indices of the rm models
voxInd1 = rm1.indices; 
voxInd2 = rm2.indices; 

% shared voxels
% voxIndShared -- voxel values shared between the 2 rmroi structs
% I1 -- indices in the first that match
% I2 -- indices in the second that match
[voxIndShared, I1, I2] = intersect(voxInd1, voxInd2); 


%% grab relevant field 

rm1FieldPRE = eval(['rm1.' rmField]); 
rm2FieldPRE = eval(['rm2.' rmField]); 

rm1Field = rm1FieldPRE(I1); 
rm2Field = rm2FieldPRE(I2); 


end