%% legend that corresponds to subject 
% there is a function version of this script, so we can delete this
% actually

bookKeeping; 
list_colors = list_colorsPerSub;

%% modify here
list_subInds = 31:39; 


%% define things
numSubs = length(list_subInds);
hvec = zeros(numSubs,1);
list_subInitials = list_sub(list_subInds);

%% do things 

figure; hold on; 
for ii = 1:numSubs
    subInd = list_subInds(ii);
    subColor = list_colors(subInd, :); 
    p = plot(0,0, ...
        'Marker', 'o', ...
        'MarkerSize', 10, ...
        'MarkerFaceColor', subColor, ...
        'MarkerEdgeColor', [0 0 0]);
    hvec(ii) = p; 
end

L = legend(hvec, list_subInitials)

