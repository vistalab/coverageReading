function porOver =  ff_areaRFsOverlap(x1,y1,sig1,x2,y2,sig2)
%% porOver =  ff_areaRFsOverlap(x1,y1,sig1,x2,y2,sig2)
% Assuming circular Gaussians
% How much of RF1 is contained in RF2?
% Positive numbers: RF1 is smaller than RF2
% Negative numbers: RF1 is larger than RF2
% 1: RF1 is completely within RF2
% 0: RF1 and RF2 are completely non overlapping
% -1: RF2 is completely within RF1

t = 0:0.01:2*pi; 

X1tem = x1 + sig1*cos(t); 
Y1tem = y1 + sig1*sin(t);
X2tem = x2 + sig2*cos(t);
Y2tem = y2 + sig2*sin(t);

% calculating the overlap
area1 = polyarea(X1tem, Y1tem); % area of rm1
area2 = polyarea(X2tem, Y2tem); % area of rm2
if area1 <= area2
    areaInd = 1; 
else
    areaInd = -1;
end

% polygon points of the intersection
if ~ispolycw(X1tem, Y1tem)
    [X1tem, Y1tem] = poly2cw(X1tem, Y1tem);
else
end
if ~ispolycw(X2tem, Y2tem)
     [X2tem, Y2tem] = poly2cw(X2tem, Y2tem);
else
end
[Xint, Yint] = polybool('intersection', X1tem, Y1tem, X2tem, Y2tem);

% area of the intersection
areaint = polyarea(Xint, Yint); 

% ratio of the intersection to the first rm1
if areaInd == 1
    porOver = areaint / area1;
elseif areaInd == -1
    porOver = - areaint / area2;
end

% % plotting
% close all; 
% figure; hold on;
% plot(X1tem, Y1tem, 'color', 'r')
% plot(X2tem, Y2tem, 'color', 'b')
% axis equal;
% plot(Xint, Yint, 'color', 'k', 'linewidth',2);

end
