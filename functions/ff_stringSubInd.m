function subStringCell = ff_stringSubInd(list_subInds)
% subStringCell = ff_stringSubInd(list_subInds);
% list_subInds is a vector with subject indices
% subStringCell is a cell of size numSub x 1 with subject index converted
% to a string.
% For legend labelling

numSubs = length(list_subInds);
subStringCell = cell(1,numSubs);
for ii = 1:numSubs
   subStringCell{ii} = ['Sub ' num2str(list_subInds(ii))]; 
end

end