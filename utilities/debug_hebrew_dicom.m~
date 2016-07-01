%% hebrew dicom testing
clear all; close all; clc; 

%% Subject 2 

dirDicom = '/sni-storage/wandell/data/reading_prf/heb_pilot02/RetAndLoc/Dicoms/Series20160503_214328_580000';
nameDicom = 'MR011015015.dcm.dcm';

pathDicom = fullfile(dirDicom, nameDicom);

INFO = dicominfo(pathDicom);
IMG = dicomread(pathDicom);
imagesc(IMG)

axis off; 
title('Subject 2', 'FontWeight', 'Bold');
ff_dropboxSave


%% Subject 4. Functional

dirDicom = '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc/Ret_Hebrew1/dicom/';
nameDicom = 'MR008060060.dcm.dcm';

pathDicom = fullfile(dirDicom, nameDicom);

INFO = dicominfo(pathDicom);
IMG = dicomread(pathDicom);
imagesc(IMG)

colormap gray

axis off; 
title('Subject 4. Functional', 'FontWeight', 'Bold');
ff_dropboxSave

%% Subject 4. Inplane

dirDicom = '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc/T1Fl2d_tra/dicom/';
baseNamePre = 'MR0070010';
baseNameEnd = '.dcm.dcm';

for ii = 1:36
    
    if ii > 9
        nameDicom = [baseNamePre num2str(ii) baseNameEnd];
    else
        nameDicom = [baseNamePre '0' num2str(ii) baseNameEnd];
    end
    

    pathDicom = fullfile(dirDicom, nameDicom);

    INFO = dicominfo(pathDicom);
    IMG = dicomread(pathDicom);
    imagesc(IMG)

    axis off; 
    title({'Subject 4. Inplane', nameDicom}, 'FontWeight', 'Bold');
    ff_dropboxSave
    
end

%% A good subject. Dicom header -- inplane
% Sub20 

pathDicom = '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet/dicoms/inplane/inplane.dcm'
INFO = dicominfo(pathDicom);
IMG = dicomread(pathDicom);
imagesc(IMG)

%% A good subject. Dicom header -- functional ret
% Sub20 

pathDicom = '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet/dicoms/retKnk/MR.1.2.840.113619.2.353.4120.7575399.14382.1448472683.124.dcm'
INFO = dicominfo(pathDicom);
IMG = dicomread(pathDicom);
imagesc(IMG)

