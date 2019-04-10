function FrootStroop(subnum,famnum,EEGisOn)
%% Notes
% Created by Erik Arnold for IDD lab
%% Finds the filepath of the function and changes to that directory
% Get the Dir for the GUI so we come back after running this .m file
guidir = cd;
%Get the active matlab script file
tmp = matlab.desktop.editor.getActive;
%Change to that path
cd(fileparts(tmp.Filename));
% Make calls to randi actually psudo random
rng('shuffle')
%As function says
%Makes Screen Transparent
%PsychDebugWindowConfiguration
shapes1 = {'apple','banana','orange'};
shapes2 = {'apple','banana','orange'};
screenNumber = max(screens);
deviceIndex = [];
%HideCursor()
%ListenChar(2)
% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:
KbName('UnifyKeyNames');
% Get the screen numbers
screens = Screen('Screens');
% Draw to the external screen if avaliable
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
datafilename = sprintf('Par%d_Fam%d_FruitStroop.txt',subnum,famnum);
% The a+ means that the datafile will only be amended and not overwritten
datafile = fopen(datafilename, 'a+');
%Number of trials
ImgOrd = randperm(6);
ImgOrdResCnt = 1;
nTrial = 100;

w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
%Within Loop per block
    
% Whole experiment loop
for a = 1:nTrial    
    %Trial Loop
    commandwindow
    %MAX DURATION OF TRIAL
    duration = 100;
    StartSecs = GetSecs;
    %Draw Fruit to Screen
    if incongru == 1
        fruitToShow = imageList(ImgOrd);
        curFruit = imread(fruitToShow);
        makeFruitTex = Screen('MakeTexture',w,curFruit);
        Screen('DrawTexture',w,makeFruitTex)
        Screen('Flip',w);
    else
        
    end
    %Loop till set time
    while GetSecs < StartSecs + duration
        [keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            ExpCorInc(duration,EEGisOn)
        end        
    end
   %Incongruent Trials 
   if incongru == 1
       if ImgOrdResCnt == 6
           ImgOrd = randperm(6);
       end

       switch ImgOrd(ImgOrdResCnt)
           case 1
               LargeFruit = 'Apple';
               SmallFruit = 'Banana';
           case 2
               LargeFruit = 'Apple';
               SmallFruit = 'Orange';
           case 3
               LargeFruit = 'Banana';
               SmallFruit = 'Apple';
           case 4
               LargeFruit = 'Banana';
               SmallFruit = 'Orange';
           case 5    
               LargeFruit = 'Orange';
               SmallFruit = 'Apple';
           case 6   
               LargeFruit = 'Orange';
               SmallFruit = 'Banana';
       end
   end    
   %Should this go before or after?
   ImgOrdResCnt = ImgOrdResCnt + 1;   
           
           
           
           
% Back to the GUI Dir found at the begining of the run
cd(guidir);           
end    