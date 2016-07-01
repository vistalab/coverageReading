%% checks whether ret models are run (and renamed)
% returns subject initials who still need the given ret model run

bookKeeping; clc; 

%% modify here

% dt name
dtName = 'Words2';

% rm nameedit 
rmName = 'retModel-Words2-css.mat'; 

% session list to check
list_path = list_sessionRet; 

%% end modification section

% display to screen
display([rmName '. These subjects still need to be run: ']);

% number of subjects
numSubs = length(list_sub);

% loop over subjects
for ii = 1:numSubs
    
    % dirVista
    dirVista = list_path{ii}; 
    chdir(dirVista); 
    
    % subject initials
    subInitials = list_sub{ii}; 
    
    % full path of ret model
    rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
    
    % check if rm exists
    if ~exist(rmPath, 'file')
        display([subInitials '. ' num2str(ii)])
    end
    
end