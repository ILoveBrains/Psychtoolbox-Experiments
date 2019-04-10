function WCST(subnum,famnum,EEGisOn,fromGUI)
%% Notes
% Created by Erik Arnold for IDD lab
% 
%   input by button press from controller
%
%   What counterbalances? 
%
%   Negitive and positive sound and visual feedback
%   
%% Code for triggering: outp(hex2dec('D050'),ERPcode)
% D050 is the code on Kirbys computer for the serialport
% Screen presentation trigger 110; Responce trigger 240;
%% Questions for task
% When to change the rules (How many correct/incorrect to change rules;
% Same in adults and children?)
% When to shuffle? Do they go through the whole deck before shuffling?
% What are the difference in dificulties between kids and adults

% During the explanation we should play the correct and incorrect sounds and symbols if
% we are attempting to get an ERN

%Finds the GUI directory for changing after exp
if EEGisOn == 1
    actiTrigger(38)
end    
filepathGUI = which ('ExperimentGUI.m');
% Delete the last 6 letters from the path
filepathGUI = filepathGUI(1:length(filepathGUI)-16);
%Change to the correct directory to run the script
if fromGUI == 1
% Get the Dir for the GUI so we come back after running this .m file
    guidir = cd;
%Get the active matlab script file
    tmp = matlab.desktop.editor.getActive;
%Change to that path
    cd(fileparts(tmp.Filename))
end    
%% Inits
%----------------------------------------
% Make calls to randi actually psudo random
rng('shuffle');
%As function says
%Makes Screen Transparent
PsychDebugWindowConfiguration

%HideCursor()
%ListenChar(2)
% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:
KbName('UnifyKeyNames');
% Get the screen numbers
screens = Screen('Screens');
% Draw to the external screen if avaliable
screenNumber = max(screens);

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
datafileheaders = 'Sub fam trials cardbottom topcardpick rule responce correct date time';
datafilename = sprintf('Par%d_Fam%d_WCST',subnum,famnum);
datafile = fopen(datafilename,'a+');
fprintf(datafile,'Session Started on %s\n',datetime);
fprintf(datafile,'%s\n',datafileheaders);
%Load the audio and visual feedback files
correct = 0;
[cY, cFs] = audioread('correct.wav');
correctimgfile = sprintf('%s/correct.png',startingDir);
[iY, iFs] = audioread('incorrect.wav');
incorrectimgfile = sprintf('%s/incorrect.png',startingDir);
correctimg = imread(correctimgfile);
incorrectimg = imread(incorrectimgfile);

cardlist = readtable('cardlist.txt');
cardlist = table2cell(cardlist);
%% 
%% Rules to sort by
%----------------------------------------
changeRulesEvery = 6;
% Number of shapes, Color, Shape
% Shapes (1 = Circle, 2 = Star, 3 = Square, 4 = Plus)
% Colors (1 = Red, 2 = Green, 3 = Blue, 4 = Yellow
% Number of shapes are 1-4
shapes = {'circle','star','cross','triangle'};
colors = {'red','green','blue','yellow'};
numbers = [1,2,3,4];
numberOfBlocks = 1;
%The order of the changing rules

%Randomly assigned non-repeating base card selection
shapePick = randperm(4);
colorPick = randperm(4);
%top cards randomly assigned shape and color FILENAMES
cardFID1 = sprintf('%s/%s%s%d.png',char(imageDirectory),char(colors(1)),char(shapes(1)),numbers(1));
cardFID2 = sprintf('%s/%s%s%d.png',char(imageDirectory),char(colors(2)),char(shapes(2)),numbers(2));
cardFID3 = sprintf('%s/%s%s%d.png',char(imageDirectory),char(colors(3)),char(shapes(3)),numbers(3));
cardFID4 = sprintf('%s/%s%s%d.png',char(imageDirectory),char(colors(4)),char(shapes(4)),numbers(4));


card1Info = [colors(1),shapes(1),numbers(1)];
card2Info = [colors(2),shapes(2),numbers(2)];
card3Info = [colors(3),shapes(3),numbers(3)];
card4Info = [colors(4),shapes(4),numbers(4)];

%% Screen Setup
%----------------------------------------
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
%% Area to draw cards
%----------------------------------------
%   Size of cards 300W 450H
%   Bounding box of cards: (Y values for all cards)
%   1   y 75, y 525, x 150, x 450     
%   2   y 75, y 525, x 600, x 900
%   3   y 75, y 525, x 1250,x 1350
%   4   y 75, y 525, x 1500, x 1800
%   CurrentCard y 750, x 825, y 1200, x 1125

%The size of the card images
baseRect = [0 0 300 450];
% Get the centre coordinate of the window THIS ASSUMES A 1920x1200
% resolution
cardpos1 = [150, 75, 450, 525];
cardpos2 = [600, 75, 900, 525];
cardpos3 = [1050, 75, 1350, 525];
cardpos4 = [1500, 75, 1800, 525];
CCpos = [825, 750, 1125, 1200];

ruleOrder = randperm(3);

%% SHOW THE CORRECT AND INCORRECT IMAGE AND SOUNDS THROUGH EXAMPLES MAYBE ADD A PRACTICE ROUND


%% Task ADULT
%----------------------------------------
%Init the cards at the top of screen
%These MakeTextures stay static through out the task

CardImg1 = imread(cardFID1);
CardImg2 = imread(cardFID2);
CardImg3 = imread(cardFID3);
CardImg4 = imread(cardFID4);

Card1 = Screen('MakeTexture',w,CardImg1);
Card2 = Screen('MakeTexture',w,CardImg2);
Card3 = Screen('MakeTexture',w,CardImg3);
Card4 = Screen('MakeTexture',w,CardImg4);
correctimgtex = Screen('MakeTexture',w,correctimg);
incorrectimgtex = Screen('MakeTexture',w,incorrectimg);
%Randomize deck order
deckOrder = randperm(64);
%deckOrder = transpose(deckOrder);
% Attempt the experiment
nTrial = 1;
nCC = 1;
nTotalTrial = 64;
%Trails with current rule set
nCR = 1;
RuleCycle = 1;
%%disp('line 132')
answerKeyCode = 0;
%instructionsScreen('WCSTINST.jpg')
%% Instructions
Inst = imread('WCSTINST.jpg');
InstText = Screen('MakeTexture',w,Inst);
%Draw instructions to the screen
Screen('DrawTexture',w,InstText);
Screen('Flip',w)   
KbWait();
actiTrigger (121)
try
    %%disp('line 134')
    %CC = imread(imageList(deckOrder(nCC)));
    %Current Card filename for sorting


    Screen('DrawTexture',w,Card1,[],cardpos1);
    Screen('DrawTexture',w,Card2,[],cardpos2);
    Screen('DrawTexture',w,Card3,[],cardpos3);
    Screen('DrawTexture',w,Card4,[],cardpos4);
    %Screen('Flip',w);
    % Works upto here 2/5/17 3rd card is not sized properly and they
    % all need to come down somwhat from the top
    for q = 1:nTotalTrial
        [keyIsDown, seconds, keyCode ] = KbCheck;
        if keyCode == 41
            break
        end    
        %%disp('in the for loop')
        correct = 0;
        cRule = ruleOrder(RuleCycle);
        cardtoread = sprintf('%s/%s',char(imageDirectory),char(imageList(deckOrder(nCC))));
        CC = imread(cardtoread);
        CurCar = Screen('MakeTexture',w,CC);


        %Does not use the exact same cards as the ones currently at the
        %top. Not sure if break will work how I want it though, may
        %have to come up with different idea
        %Has to loop through to make sure it doesn't match a different
        %card

        Screen('DrawTexture',w,CurCar,[],CCpos);
        Screen('DrawTexture',w,Card1,[],cardpos1);
        Screen('DrawTexture',w,Card2,[],cardpos2);
        Screen('DrawTexture',w,Card3,[],cardpos3);
        Screen('DrawTexture',w,Card4,[],cardpos4);
        Screen('Flip',w);
        %Screen Presentation trigger
        topcardpick = 'none';
        if EEGisOn == 1
            outp(hex2dec('D050'),110);
            WaitSecs(0.01);
            %Clear Channel
            outp(hex2dec('D050'),0);
            WaitSecs(0.01);
        end
        % Create a while loop to wait for one of the 4 buttons to be
        % pressed

        % Check if the answer is correct by checking the current card
        % againsnt the current rule set


        %Create que for the answer via the button box

% 
%             switch cRule
%                 case 1
%                     %Color
%                     if colors(inputFromCont) == cardlist(deckOrder(nCC),1)
%                       correct = 1;
%                     else
%                       correct = 0;
%                     end
%                     
%                 case 2
%                     %Shape
%                     if shapes(inputFromCont) == cardlist(deckOrder(nCC),2)
%                         correct = 1;
%                     else
%                         correct = 0;
%                     end
%                 case 3
%                     %Number
%                     if numbers(inputFromCont) == cardlist(deckOrder(nCC),3)
%                     correct = 1;
%                     else
%                     correct = 0;
%                     end
%             end    

        %% Participant Responce
        %Loop waiting for responce
        %Make the while loop only last for  duration
        
        duration = 8;
        StartSecs = GetSecs;
        tic;
        while GetSecs < StartSecs + duration
            
            [keyIsDown, seconds, keyCode ] = KbCheck;
            if keyIsDown
                %answerGiven = KbName(keyCode);
                disp(find(keyCode))
                answerKeyCode = find(keyCode);
                restrictedKeys = [49 50 51 52];
            %only accepts anwer from the restricted key list
                if ismember(answerKeyCode,restrictedKeys(:)) == true
                    disp(find(keyCode))
                    %Responce press code send to EEG recording
                    if EEGisOn == 1
                        outp(hex2dec('D050'),240);
                        WaitSecs(0.1);
                        %Clear Channel
                        outp(hex2dec('D050'),0);
                        WaitSecs(0.1);
                        %disp('in restricted keys loop')
                    end    
                    switch answerKeyCode
                        case 49
                          %disp('in switch')
                            topcardpick = {char(colors(1)),char(shapes(1)),numbers(1)};
                            disp(cRule)
                        case 50
                          %disp('in switch')
                            topcardpick = {char(colors(2)),char(shapes(2)),numbers(2)};
                            disp(cRule)
                        case 51
                            %disp('in switch')
                            topcardpick = {char(colors(3)),char(shapes(3)),numbers(3)};
                            disp(cRule)
                        case 52
                            %disp('in switch')
                            topcardpick = {char(colors(4)),char(shapes(4)),numbers(4)};
                            disp(cRule)
                    end
                   break 
                end
            
            end
        end
        resptime = toc;
        if answerKeyCode ~= 49||50||51||52
            correct = 0;
            
        %% Check for Accuracy
        %disp(cRule)
        end
        if isequal(topcardpick(cRule),cardlist(deckOrder(nCC),cRule))
            correct = 1;
        else
            correct = 0;
        end    
        %% Feedback
        if correct == 1
            %Send Trigger

        %%display Correct and play correct sound
            %draw and %display the checkmark
            Screen('DrawTexture',w,correctimgtex);
            Screen('Flip',w);
            % Plays the sound not sure about timing
            sound(cY,cFs)
            WaitSecs(2)
            nCR = nCR+1;
            [keyIsDown, seconds, keyCode ] = KbCheck;
            if keyCode == KbName('ESCAPE')
                break
            end 
        else
            %send trigger
        %%display false and play false sound
            %draw and %display the incorrect X
            Screen('DrawTexture',w,incorrectimgtex);
            Screen('Flip',w);
            % Plays the sound not sure about timing
            sound(iY,iFs)
            [keyIsDown, seconds, keyCode ] = KbCheck;
            if keyCode == KbName('ESCAPE')
                break
            end 
            WaitSecs(2)
        end
        %Resuffle if it uses all 64 cards
        
        %% WRITE INFO TO FILE
        % Variables needed to write
        % Sub fam trials cardbottom topcardpick rule responce correct
        % Var Names Corisponding to these
        % subnum famnum nTrial cardtoread topcardpick cRule answerKeyCode
        % correct
        splitDir = strsplit(cardtoread,'/');
        CardPunc = strsplit(splitDir{length(splitDir)},'.');
        JustCard = CardPunc{1};
        if strcmp(topcardpick,'none')
            
        else    
            splitDir = strsplit(cardtoread,'/');
            CardPunc = strsplit(splitDir{length(splitDir)},'.');
            topcardpick = CardPunc{1};    
        end    
        disp(JustCard)
        stingToWrite = sprintf('%d %d %d %s %s %d %d %d %s %s %d',subnum,famnum,nTrial,char(JustCard),topcardpick,char(cRule),answerKeyCode,correct,datetime,resptime);
        fprintf(datafile,'%s\n',stingToWrite);
        if nCC == 64
           nCC = 1;
        else
            nCC = nCC + 1;
        end
        if RuleCycle == 3 && nCR == 6
           
            RuleCycle = 1;
            nCR = 1;
            ruleOrder = randperm(3);
        end    
        if nCR == changeRulesEvery
            nCR = 1;
            RuleCycle = RuleCycle + 1;
        end    
        %Increase trial and card count by one
        
        %disp(nCR)
        nTrial = nTrial+1;
    end
    cd(guidir);
    ListenChar(0)
    ShowCursor()
    sca
catch
    cd(guidir);
    psychrethrow(psychlasterror);
    ShowCursor;
    sca
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
actiTrigger (122)
cd(guidir);
ListenChar(0)
ShowCursor()
sca


