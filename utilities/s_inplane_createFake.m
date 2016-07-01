%% make a fake inplane
% Options:
% 1. From the first volume of a given functional run
% 2. From the average of all the functionals

clear all; close all; clc; 
%% modify here

dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot01/Analyze';

% see comments above as to how to create
inplaneOption = 1; 

% path of the functional run relative to dirVista
funcName = '/Ret_English1/func_xform.nii.gz';

% name of pseudo inplane
inplaneName = 'inplane_pseudo.nii.gz';

% where we want the pseudo inplane to be stored, relative to dirVista
inplaneDir = 'T1';


%% do things

chdir(dirVista);

% load the functional
funcPath = fullfile(dirVista, funcName);
niiFunc = readFileNifti(funcPath);

% initialize a new nifti for the pseudo inplane
% and define accordingly
niiInplane = niiFunc; 
inplanePath = fullfile(dirVista, inplaneDir, inplaneName);
niiInplane.fname = inplanePath

% clear the data field
niiInplane.data = int16(zeros(size(niiFunc.data)));

%% average
if inplaneOption == 1
    tmp = niiFunc.data(:,:,:,1);
    inplaneData = squeeze(tmp);   
elseif inplaneOption ==2
    inplaneData = mean(niiFunc.data,4);    
end

% write and save
niiInplane.data = inplaneData;
writeFileNifti(niiInplane);
