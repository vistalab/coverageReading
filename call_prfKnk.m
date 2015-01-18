%% script to call css (knk) prf model
% >> results = analyzePRF(stimulus,data,tr,options);
clear all; close all; clc; 

%% modify here
% path where the wrapped variables lives
pathKnkWrapped = '/biac4/wandell/data/reading_prf/rosemary/20140425_1020/rl20140425_knkWrapped_AllBarsAverages.mat'; 

% what to save these results as
pathKnkResultsSave = '/biac4/wandell/data/reading_prf/rosemary/20140425_1020/resultsknk.mat'; 

%% don't modify below here

% load the wrapped variables: 'stimulus', 'data', 'tr', 'options'
load(pathKnkWrapped)

%% run it!
results = analyzePRF(stimulus,data,tr,options);


%% save it!
save(pathKnkResultsSave,'results')


