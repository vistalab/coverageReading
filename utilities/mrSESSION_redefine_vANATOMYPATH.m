%% when switching to iMac, the global vANATOMY path references a soft link
% and iMac has problems with soft links
% So redefine and give absolute path of everyone's anatomy
% And re save the session
% use the saveSession command so that a backup will be saved
clear all; close all; clc; 
bookKeeping;

%% vANATOMYPATHs that have been changed
% list_sessionRet. except for subs 1 and 3
% list_sessionHebrewRet. no problems


%% modify here
% the sessions to do this for
% list_sessionRet
% list_sessionPath
% list_sessionLocPath
% list_sessionDtiQmri
% list_sessionDiffusionRun1
% list_sessionDiffusionRun2
% list_sessionHebrewRet
% list_sessionSizeRet
% list_sessionTiledLoc
% list_sessionTestRetest
% list_sessionAfq
list_session = list_sessionRet; 

% subjects to do this for
list_subInds = [1:2 4:38];

%% do things
numSessions = length(list_session); 

for ii = list_subInds
   
    %% anatomy and vista directoryes
    dirVista = list_session{ii};
    dirAnatomy = list_anatomy{ii};
    
    %% do things if the vista session and anatomy direcotry exist
    if exist(dirVista, 'dir') & exist(dirAnatomy, 'dir')
        
        clear dataTYPES mrSESSION vANATOMYPATH

        % move and load
        chdir(dirVista);
        mrGlobals; 
        load mrSESSION; 
        
        % the current vANATOMYPATH
        display(['old vANATOMYPATH: ' vANATOMYPATH]);
        
        % change it over and save the session
        vANATOMYPATH = fullfile(dirAnatomy, 't1.nii.gz');
        display(['new vANATOMYPATH: ' vANATOMYPATH]);
        saveSession; 
        
        
    else
        display(['dirVista or dirAnatomy does not exist for sub ' num2str(ii)])
    end
    
end

