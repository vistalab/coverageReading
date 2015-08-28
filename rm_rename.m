%% removes the "-fFit" at the end of ret model names
% assumes that the ret model is already perfectly named outside of the
% fFit.mat at the end

bookKeeping; 

%% modify here

% do this for which subjects
list_subInds = [1:13];

% which session? {'list_sessionPath'| 'list_sessionRetFaceWord'}
wSession = 'list_sessionPath';

% the string we want to remove at the end
% it will be replaced with .mat
strRemove = '-fFit.mat';


%% end modification section

% string length to remove
strLength = length(strRemove); 

% current directory. return here
dirCurrent = pwd; 

% loop over subjects
for ii = list_subInds
    
    % current subject's vista dir and datatype dir
    list_path = eval(wSession);
    dirVista = list_path{ii};    
    chdir(dirVista);
    
    dirDt = fullfile(dirVista, 'Gray');
    chdir(dirDt);
    
    % get the names of all datatypes
    % these should all be directories in the Gray Folder
    tem = dir(dirDt);
    list_dtNames = tem(3:end);
    
    % loop over the gray datatypes
    for kk = 1:length(list_dtNames)
        
        % current dtName. 
        dtName = list_dtNames(kk).name;
        
        % if it is a directory ...
        if isdir(fullfile(dirVista, 'Gray', dtName))
            
            % move here
            chdir(fullfile(dirVista, 'Gray', dtName));
            
            % list all the files in this datatype
            tem = dir(fullfile(dirDt, dtName));
            list_files = tem(3:end);

            % loop over the fils in this datatype directory
            % if a file ends in *fFit.mat, rename it to 
            for ff = 1:length(list_files)

                % file name
                fName = list_files(ff).name; 

                % if file name ends in *fFit.mat, rename -- remove the fFit part
                if (length(fName) > strLength) && strcmp(strRemove, fName(end-(strLength-1):end))

                    % part of the file name without the *fFit.mat
                    baseName = fName(1:end-strLength);

                    % rename and delete file
                    movefile(fName, [baseName '.mat']);
                end

            end

        end      
    end
    
end

% return to starting place
chdir(dirCurrent)
