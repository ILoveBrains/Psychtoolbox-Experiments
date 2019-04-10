function DCCS(subnum,famnum,EEGisOn,debugMode,fromGUI)
%% Notes
% Created by Erik Arnold for IDD lab
% March 2017
% ErikArnold@psych.umass.edu

%% SET FROM GUI TO 0

%% Finds the filepath of the function and changes to that directory
if fromGUI == 1
    %Method of getting the GUI dir
    filepathGUI = which ('ExperimentGUI.m');
    % Delete the last 6 letters from the path
    filepathGUI = filepathGUI(1:length(filepathGUI)-15);
    %Set the GUI Dir for end of script
    guidir = filepathGUI;
    %Get the active matlab script file
    tmp = matlab.desktop.editor.getActive;
    %Change to that path
    cd(fileparts(tmp.Filename))
end    
%% Inits
% Make calls to randi actually psudo random
if debugMode == 1
    Screen('Preference', 'SkipSyncTests', 1);
    PsychDebugWindowConfiguration;
end    
% RABBIT/BOAT red/blue
rng('shuffle');
%Specify debugging preferences
screens = Screen('Screens');
screenNumber = max(screens);
deviceIndex = [];
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);

nTotalTrial = 10;
if debugMode == 1
    %Makes Screen Transparent
    PsychDebugWindowConfiguration
else
    HideCursor()
end  
%Inputs are in the command window
%commandwindow
% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:
KbName('UnifyKeyNames');
% Get the screen numbers (For Multi Displays
screens = Screen('Screens');
%Draws to the highest value Screen
screenNumber = max(screens);
deviceIndex = [];
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
startingDir = cd;
%Get image list and change back to main folder
imageDirectory = sprintf('%s/images/cards',startingDir);
imageList = readtable('IMGfileName.txt');
imageList = table2cell(imageList);
cd(startingDir);
%Create datafile name to write to
datafilename = sprintf('Par%d_Fam%d_Child_DCCS.txt',subnum,famnum);
%Load the audio and visual feedback files
correct = 0;
[cY, cFs] = audioread('correct.wav');
correctimgfile = sprintf('%s/images/correct.png',startingDir);
[iY, iFs] = audioread('incorrect.wav');
incorrectimgfile = sprintf('%s/images/incorrect.png',startingDir);
correctimg = imread(correctimgfile);
incorrectimg = imread(incorrectimgfile);
%read the card list for the DCCS
cardlist = readtable('cardlist.txt');
cardlist = table2cell(cardlist);
% WHAT SHAPES ARE WE GOING TO USE, or is it RABBIT/BOAT
shapes = {'RABBIT','BOAT'};
colors = {'RED','BLUE'};
counterbal = randperm(2);    
blueboatimg = imread('BLUE_BOAT.png');
redboatimg = imread('RED_BOAT.png');
bluerabimg = imread('BLUE_RABBIT.png');
redrabimg = imread('RED_RABBIT.png');

if counterbal(1) == 1
    rabimtop = bluerabimg;
    boatimtop = redboatimg;
    rabimbot = redrabimg;
    boatimbot = blueboatimg;
else
    rabimtop = redrabimg;
    boatimtop = blueboatimg;
    rabimbot = bluerabimg;
    boatimbot = redboatimg;
end    
toprabit = Screen('MakeTexture',w,rabimtop);
topboat = Screen('MakeTexture',w,boatimtop);

baseRect = [0 0 400 450];

boatcardpos = [400, 175, 800, 525];
rabcardpos = [1050, 175, 1450, 525];
botcardpos = [760,700,1160,1100];
%Screen Presentation trigger
if EEGisOn == 1
    outp(hex2dec('D050'),110);
    WaitSecs(0.01);
    %Clear Channel
    outp(hex2dec('D050'),0);
    WaitSecs(0.01);
end
botnum = randperm(2);
botnumcount = 1;
inputdevice = 5;
esc = KbName('ESCAPE');
corinc = 0;
keyCode = 0;
missed = 0;
try
    for q = 1:nTotalTrial
        
       
        
        if botnum(1) == 1
            botdraw = Screen('MakeTexture',w,rabimbot);
        else
            botdraw = Screen('MakeTexture',w,boatimbot);
        end    
        Screen('DrawTexture',w,toprabit,[],rabcardpos);
        Screen('DrawTexture',w,topboat,[],boatcardpos);
        Screen('DrawTexture',w,botdraw,[],botcardpos);
        Screen('Flip',w);
        if keyCode == esc
            break
        end    
        %%disp('in the for loop')
        
        duration = 8;
        StartSecs = GetSecs;
        %Code written for RA responce to correct or incorrect (1,0)
        
        [corinc,keyCode,missed] = ExpCorInc(10,EEGisOn,0);
        %WaitSecs(2)
        if botnumcount == 2
            botnum = randperm(2);
           botnumcount = 1;
        end
        botnumcount = botnumcount +1;
        
        
        Screen('Flip',w);
        WaitSecs(2);
    end
actiTrigger (111)    
cd(guidir);
sca     
catch
    psychrethrow(psychlasterror);
    ShowCursor;
    sca
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    
end
% Back to the GUI Dir found at the begining of the run
cd(guidir);
sca
