function newRmroi = ff_rmroiSelectByIndices(rmroi, indxMaster)
error('outdated function use ff_rmroi_subset !!!!')

% newRmroi = ff_rmroiSelectByIndices(rmroi, indxMaster); 

% These are the fields that must be changed
%      coords: [3x483 single]
%     indices: [483x1 double]
%          co: [1x483 double]
%      sigma1: [1x483 double]
%      sigma2: [1x483 double]
%       theta: [1x483 double]
%        beta: [483x4 double]
%          x0: [1x483 double]
%          y0: [1x483 double]
%       sigma: [1x483 double]
%          ph: [1x483 double]
%         ecc: [1x483 double]

% fields where indices are in the columns
list_fieldNamesCol = {
    'coords'
    'co'
    'sigma1'
    'sigma2'
    'theta'
    'x0'
    'y0'
    'sigma'
    'ph'
    'ecc'
    };


% For almost all the fields, the indices correspond to the column number.
% For the fields listed here, indices correspond to row number
list_fieldNamesRow = {
    'indices'
    'beta'
    };


numFieldsCol = length(list_fieldNamesCol); 
numFieldsRow = length(list_fieldNamesRow); 

newRmroi = rmroi; 

%%

for ff = 1:numFieldsCol
    fieldName = list_fieldNamesCol{ff};
    data = eval(['rmroi.' fieldName]);
    
    newData = data(:, indxMaster);
    eval(['newRmroi.' fieldName '= newData;']);  
end

for ff = 1:numFieldsRow
    fieldName = list_fieldNamesRow{ff};
    data = eval(['rmroi.' fieldName]);
    
    newData = data(indxMaster,:);
    eval(['newRmroi.' fieldName '= newData;']);  
end

end