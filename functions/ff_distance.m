function distance = ff_distance(x1, x2)
% euclidean distance between 2 vectors

distance = sqrt(sum((x1-x2).^2));

end