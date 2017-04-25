%% applies the canonical xform to the functional MUX scans
% save this script in each vista session

% [ni,canXform] = niftiApplyCannonicalXform(ni, canXform, phaseDir)
% % Reorient NIFTI data and metadata fields according to a simple xform 


%% modify here

% directory with the mrVista session. Usually this script is saved right in
% that directory. 
dirVista  = '/sni-storage/wandell/data/reading_prf/heb_pilot16/EnglishLoc';

% nifti files we want to xform
listToXform = {
    fullfile(dirVista, 'prescribeInplane1', 'inplane.nii.gz')
    fullfile(dirVista, 'prescribeInplane2', 'inplane.nii.gz')
%     fullfile(dirVista, 'Localizer_English1/func.nii.gz')
%     fullfile(dirVista, 'Localizer_English2/func.nii.gz')
    };

% name of the new functional, with ext
% newName = 'func_xform.nii.gz'; 
newName = 'inplane_xform.nii.gz'; 

%% 

chdir(dirVista);

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
