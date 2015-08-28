%% applies the canonical xform to the functional MUX scans
% save this script in each vista session

% [ni,canXform] = niftiApplyCannonicalXform(ni, canXform, phaseDir)
% % Reorient NIFTI data and metadata fields according to a simple xform 


%% modify here

% directory with the mrVista session. Usually this script is saved right in
% that directory. 
dirVista  = pwd;

% nifti files we want to xform
listToXform = {
    fullfile(dirVista, '5_1_fMRI_Ret_knk','9727_5_1.nii.gz')
    fullfile(dirVista, '6_1_fMRI_Ret_knk','9727_6_1.nii.gz')
    fullfile(dirVista, '8_1_fMRI_Ret_knk','9727_8_1.nii.gz')
    fullfile(dirVista, '9_1_fMRI_Ret_knk','9727_9_1.nii.gz')
    fullfile(dirVista, '10_1_fMRI_Ret_bars', '9727_10_1.nii.gz')
    fullfile(dirVista, '11_1_fMRI_Ret_bars', '9727_11_1.nii.gz')
    fullfile(dirVista, '12_1_fMRI_Ret_bars', '9727_12_1.nii.gz')
    };
% listToXform = {fullfile(dirVista, '4_1_T1_high_res_inplane_Ret_knk','9727_4_1.nii.gz')};

% name of the new functional, with ext
% newName = 'func_xform.nii.gz'; 
newName = 'inplane_xform.nii.gz'; 

%% 

for ii = 1:length(listToXform)
    
    % read in the pre xformed nifti file
    niPre = readFileNifti(listToXform{ii});
    
    % apply the canonical xform to it
    nii = niftiApplyCannonicalXform(niPre); 
    
    % rename
    d = fileparts(niPre.fname); 
    nii.fname = fullfile(d,newName); 
    
    % save as a new nift
    writeFileNifti(nii); 
    
end
