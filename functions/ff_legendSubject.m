function L = ff_legendSubject(list_subInds)
% L = ff_legendSubject(list_subInds)

bookKeeping; 
list_colors = list_colorsPerSub;

%% define coloring here
textColor = [0 0 0];
legColor = [.9 .9 .9];

%% define things
numSubs = length(list_subInds);
hvec = zeros(numSubs,1);
% list_subInitials = list_sub(list_subInds);
list_subNumbers = list_subNumberString(list_subInds); 

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

L = legend(hvec, list_subNumbers);

%% color things
set(L, 'TextColor',textColor)
set(L, 'Color', legColor)
set(L, 'EdgeColor', textColor)
set(gca, 'Color', legColor)


% comment out this line if legend is doing funky things on other screens
% this is here because the default figure is not large enough to see the
% entire legend
set(gcf, 'position', [440    81   560   713])

end