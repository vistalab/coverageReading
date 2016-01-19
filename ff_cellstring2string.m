function str = ff_cellstring2string(cellstr)
%% converts a cell of strings into a single string
% useful for making plot titles and saving

numElements = length(cellstr); 
str = []; 
separator = '-'; 

for ii = 1:numElements
    
    % iith str element
    tem = [cellstr{ii} separator];

    % append the string
    str = [str tem];
    
end

end