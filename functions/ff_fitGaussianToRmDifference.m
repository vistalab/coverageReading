function normParams = ff_fitGaussianToRmDifference(rmroiCell, list_fieldNames, vfc)
error('this functon pools all the voxels across subjects. comment out this line if that is fine')
%% Fit a Gaussian (mean, sigma) to the difference of 2 ret models
% GIVEN THE SAME VOXELS
%
% INPUTS
%
%
% OUTPUTS
% The return of the histfit function
%
%
% PSEUDOCODE
% - Gets the same voxels based on the vfc thresh
% - Linearizes the data across the subjects for each field
% - Fits a Gaussian to the difference

%% useful
numSubs = size(rmroiCell,1); 
numRois = size(rmroiCell,2);
numFields = length(list_fieldNames);

% initialized the cell struct of linearized data
LDataDiff = cell(numFields, numRois); 

% initialize the results
normParams = cell(numFields, numRois);


%% Get the same voxels based on the vfc thresh

rmroiCellSameVox = cell(size(rmroiCell));
for ii = 1:numSubs
    for jj = 1:numRois
        rmroiCellSub = rmroiCell(ii,jj,:); 
        sameVox = ff_rmroiGetSameVoxels(rmroiCellSub, vfc); 
        rmroiCellSameVox(ii,jj,:) = sameVox;         
    end    
end


%% linearize the data across ROIs and rmFields
for jj = 1:numRois
    
    for ff = 1:numFields
        
        %%
       fieldName = list_fieldNames{ff};

       rmroiSubjects1 = rmroiCellSameVox(:,jj,1);
       rmroiSubjects2 = rmroiCellSameVox(:,jj,2);
       
       [ldata1, mu1, ste1] = ff_rmroiLinearize(rmroiSubjects1, fieldName); 
       [ldata2, mu2, ste2] = ff_rmroiLinearize(rmroiSubjects2, fieldName); 
       
       ldataDiff = ldata2 - ldata1; 
       LDataDiff{ff,jj} = ldataDiff; 

    end
end

%% Use histfit to fit the gaussian
for jj = 1:numRois
    for ff = 1:numFields
        
        %%
        fieldName = list_fieldNames{ff};
        
        % get the data
        ldataDiff = LDataDiff{ff,jj}; 

        
        % fit the histogram
        nBins = 10; 
        [muhat,sighat,muci,sigci] = normfit(ldataDiff, .95);
        
        % store fitParams in struct and store struct in result
        f.muhat = muhat; 
        f.sighat = sighat; 
        f.muci = muci; 
        f.sigci = sigci; 
        
        normParams{ff,jj} = f;         
        % sanity check -- plot the difference histogram
        % histfit(ldataDiff)
        
    end
end
