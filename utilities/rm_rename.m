%% removes the "-fFit" at the end of ret model names
% assumes that the ret model is already perfectly named outside of the
% fFit.mat at the end

bookKeeping; 

%% modify here

% do this for which subjects
list_subInds = 14:20; 

% which session? {'list_sessionPath'| 'list_sessionRetFaceWord'}
% list_sessionSizeRet 
list_path = list_sessionRet; % list_sessionPath;

% the string we want to remove at the end
% it will be replaced with strReplace
strRemove = '-fFit.mat';

strReplace = '.mat';

% whether we only want to do this within a single datatype
% specify the empty string if we want to do for ALL datatypes
dtTarget = 'Words_scale1mu0sig1p5'; 


%% end modification section

% string length to remove
strLength = length(strRemove); 

% current directory. return here
dirCurrent = pwd; 

% loop over subjects
for ii = list_subInds
    
    % current subject's vista dir and datatype dir
    dirVista = list_path{ii};    
    chdir(dirVista);
    vw = initHiddenGray; 
    
    dirDt = fullfile(dirVista, 'Gray');
    chdir(dirDt);
    
    

    
    % if this is the empty string, do for all dts
    if ~size(dtTarget)
        
        % get the entire dt struct
        % these should all be directories in the Gray Folder
        tem = dir(dirDt);
        list_dts = tem(3:end);
        
    else
        
        % only get the dt we want
        vw = viewSet(vw, 'curdt', dtTarget); 
        list_dts = viewGet(vw, 'dtstruct');
        
    end
    
    % loop over the gray datatypes
    for kk = 1:length(list_dts)

        % current dtName. 
        dtName = list_dts(kk).name;

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
                    movefile(fName, [baseName strReplace]);
                end

            end

        end      
    end

    
    
end

% return to starting place
chdir(dirCurrent)
