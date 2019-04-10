function DCCSTakeTwo(subnum,famnum,EEGisOn,debugMode,fromGUI)
%% Notes
% Created by Erik Arnold for IDD lab
% Sept 2017
% ErikArnold@psych.umass.edu
% This is the second attempt, the stimuli are not randomized anymore, and
% go in a spesific order. This will make sure that there is at least one
% inconguency in each lower card to be sorted with the top cards.

%%Some psychtoolbox setting up
screens = Screen('Screens');
screenNumber = max(screens);
deviceIndex = [];
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
screens = Screen('Screens');
screenNumber = max(screens);
deviceIndex = [];
%Read Image files
redrabbit = imread('DCCS1.png');
blueboat = imread('DCCS2.png');

% Show starting Trigger for DDCS is 110 - End Trig is 111
% actiTrigger is a function written for triggering events in
% ErikEEGAluminum toolbox
if EEGisOn == 1
    actiTrigger (110)
end    

redRabbitTex = Screen('MakeTexture',w,redrabbit);
blueBoatTex = Screen('MakeTexture',w,blueboat);

corinc = 0;
keyCode = 0;
missed = 0;

for q = 1:5
    Screen('Flip',w);
    WaitSecs(1)
    KbWait
    Screen('DrawTexture',w,redRabbitTex);
    Screen('Flip',w);
    WaitSecs(2)
    KbWait
    Screen('Flip',w);
    WaitSecs(2)
    KbWait
    Screen('DrawTexture',w,blueBoatTex);
    Screen('Flip',w);
    WaitSecs(2)
    KbWait
end    
if EEGisOn == 1
    actiTrigger (111)
end   
sca


