% s_maps2niftis.m is a little script for generating niftiis from
% parameter maps so that we view them on freesurfer average
% anatomies


% session directory




% subject directories

% this part is identical to the meshimages code
% datatype
% map
% set thresholds etc
% save out niftii with name
functionals2itkGray(VOLUME{1})

CheckersMeanMap.nii.gz
CheckersMeanMapTrilinear.nii.gz
CheckersPrfCo.nii.gz
CheckersPrfEcc.nii.gz
CheckersPrfPhase.nii.gz
CheckersPrfSize.nii.gz


functionals2itkGray(VOLUME{1}, [], 'CheckersMeanMap')
functionals2itkGray(VOLUME{1}, [], 'CheckersPrfCo')
functionals2itkGray(VOLUME{1}, [], 'CheckersPrfEcc')
functionals2itkGray(VOLUME{1}, [], 'CheckersPrfPhase')
functionals2itkGray(VOLUME{1}, [], 'CheckersPrfSize')

