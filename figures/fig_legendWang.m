%% legend that corresponds to subject 
% there is a function version of this script, so we can delete this
% actually

bookKeeping; 
list_colors = list_colorsWangRois;

%% modify here
list_roiInds = 1:25; 

%% define things
numRois = length(list_roiInds);
hvec = zeros(numRois,1);
list_wangRoiNames = list_wangRois(list_roiInds);

%% do things 

figure; hold on; 
for ii = 1:numRois
    roiInd = list_roiInds(ii);
    subColor = list_colors(roiInd, :); 
    p = plot(0,0, ...
        'Marker', 'square', ...
        'MarkerSize', 16, ...
        'MarkerFaceColor', subColor, ...
        'MarkerEdgeColor', [1 1 1], ...
        'Color', [1 1 1]);
    hvec(ii) = p; 
end

L = legend(hvec, list_wangRoiNames)

