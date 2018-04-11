%% Visualize the pRF of a single voxel
% We make a separate function because sometimes we want to distinguish
% between sigma major and effective sigma

close all; clear all; clc; 

%% modify here

% location of the pRF
rm.x0 = 3.6; 
rm.y0 = 8.4;

% size of the pRF
% sigma major and sigma minor respectively
% when they are the same it is a circle
rm.sigma1 = 6.2; 
rm.sigma2 = 6.2; 

vfc = ff_vfcDefault; 
plotOnlyCenters = false; 

%% do it
ff_pRFasCircles(rm, vfc, plotOnlyCenters)