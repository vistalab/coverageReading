%% checks whether ret models are run (and renamed)
% returns subject initials who still need the given ret model run

bookKeeping; clc; 

%% modify here

% dt name
dtName = 'Original';

% rm nameedit 
pmapName = 'retModel-Words2-css.mat'; 

% session list to check
list_path = list_sessionRet; 

% print exist or not exist
% if true, will print out the subjects names who have the pmap
existPrint = false; 

%% end modification section

% display to screen
if existPrint
    displayStr = [pmapName '. These subjects HAVE the pmap: '];
else
    displayStr = [pmapName '. These subjects DO NOT HAVE the pmap: '];
end
 

display(displayStr);

% number of subjects
numSubs = length(list_sub);

% loop over subjects
for ii = 1:numSubs
    
    % dirVista
    dirVista = list_path{ii}; 
    chdir(dirVista); 
    
    % subject initials
    subInitials = list_sub{ii}; 
    
    % full path of pmap 
    pmapPath = fullfile(dirVista, 'Gray', dtName, pmapName); 
    
    % check if rm exists
    if ~printExist
        if ~exist(pmapPath, 'file')
            display([subInitials '. ' num2str(ii)])
        end
    else
        if exist(pmapPath, 'file')
            display([subInitials '. ' num2str(ii)])
        end
    end
    
end