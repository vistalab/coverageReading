%% check that datatypes exist for subjects
bookKeeping; 
clc; 
%% modify here

% session list
list_path = list_sessionRet; 

% dt names to check
dtName = 'Words1';


%% end modification section

% number of subjects
numSubs = length(list_path); 

% initialize print list
printList = {}; 
counter = 0; 

% loop over subjects
for ii = 1:numSubs
    
    dirVista = list_path{ii}; 
    chdir(dirVista); 
    vw = initHiddenGray; 
    subInitials = list_sub{ii};

    % get the number of the datatype. will return 0 if not found
    dtNum = existDataType(dtName);
    if dtNum == 0
        % store initials so we can print out at the end
        counter = counter + 1; 
        printList{counter,1} = [subInitials '. ' num2str(ii)]; 
    end
    
end % loop over subjects

%% display

display([dtName ' does not exist for these subjects'])
printList