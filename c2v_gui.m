clear all; close all; clc; 
%%%% create the main GUI figure
% GUI position coordinates: 4-element vector: 
% [distance from left, distance from bottom, width, height]. 
% 
% pushbutton, togglebutton, radiobutton, checkbox, edit, text, 
% slider, listbox, popupmenu. Default is pushbutton.
%%%% 
%% modify here

% main figure properties
% distance from left
mainDistFromLeft    = 1200; 
mainDistFromBottom  = 100; 
mainWidth           = 600; 
mainHeight          = 1000; 

%%%%%%%%%% values that change based on scanning institute
% repitition time in seconds, when data is acquired
trOrig      = 2; 

% tr time that we interpolate
trNew       = 1; 

% run functional number that has ret. need to know
% for grabbing the total frame number of a ret scan 
retFuncNum  = 1; 

%%  Define the gui figure, and the size
mainPosition = [mainDistFromLeft mainDistFromBottom mainWidth mainHeight]; 
hFig = figure('Name','Variables for CSS2Vista Conversion','Position',mainPosition); 


%% Parameters that need to be modified each time
% TODO: make a group for these
% directory with mrSESSION - maybe make this a browse eventually
% uicontrol('Style', 'Text')
% gparams.pthsession = uicontrol('Style','Edit','Position',[20 800 600 20])

%% Parameters that remain constant (based on imaging center)
% TODO: make a group fo these
% TR time
uicontrol('Style', 'Text', 'String', 'TR Time (Original)', 'Position', [200 800 100 20])
gparams.trOrig = uicontrol('Style', 'Edit', 'Position', [350 800 100 20])





%%
buttonOK = uicontrol('Style','Pushbutton','String','OK','Position', [20 20 60 20],'Callback', 'OK = 1; uiresume; '); 
uiwait
delete(hFig)