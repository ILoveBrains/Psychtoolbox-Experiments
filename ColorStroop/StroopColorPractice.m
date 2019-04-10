function StroopColorPractice(subnum,famnum,EEGisOn,debugMode,fromGUI)
%% Notes
% Created by Erik Arnold for IDD lab
% March 2017
% ErikArnold@psych.umass.edu
Screen('Preference', 'SkipSyncTests', 1);
%% Finds the filepath of the function and changes to that directory
%Method of getting the GUI dir
if fromGUI == 1
    filepathGUI = which ('ExperimentGUI.m');
    % Delete the last 6 letters from the path
    filepathGUI = filepathGUI(1:length(filepathGUI)-16);
    %Set the GUI Dir for end of script
    guidir = filepathGUI;
    %Get the active matlab script file
    tmp = matlab.desktop.editor.getActive;
    %Change to that path
    cd(fileparts(tmp.Filename))
end    
%% Inits
rng('shuffle');
%Behavioral file to write to
fid = sprintf('%dColorStroop%d.txt',famnum,subnum);
% Make calls to randi actually psudo random
if debugMode == 1
    %Makes the screen partially transparent and that the screen flipping
    %wont crash the session
    Screen('Preference', 'SkipSyncTests', 1);
    PsychDebugWindowConfiguration;
end    
%% Init Screen and keyboard prefrences
screens = Screen('Screens');
screenNumber = max(screens);
deviceIndex = [];
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
KbName('UnifyKeyNames');
%Total Trials
nTrials = 60;
%% Colors (RGB values)
yellow = [255,255,0];
red = [255,0,0];
green = [0,255,0];
blue = [0,0,255];
purple = [204,0,204];
colors = {yellow,red,green,blue,purple};
ccolo = randperm(5);
ccoun = 1;
%Words
words = {'yellow','red','green','blue','purple'};
wcolo = randperm(5);
wcoun = 1;
%% Instructions
Inst = imread('CStroopInst.jpg');
InstText = Screen('MakeTexture',w,Inst);
%Draw instructions to the screen
Screen('DrawTexture',w,InstText);
Screen('Flip',w)   
KbWait(2);
%% MAKE SURE TO CHECK FOR THE KEYBOARD BEING USED! IT TAKES THE ARGUMENT OF INPUT DEVICE TO WORK
cBlock = 1;
nTrialPerBlockCounter = 1;
qq = KbName('q');
ww = KbName('w');
ee = KbName('e');
rr = KbName('r');
tt = KbName('t');

for q = 1:nTrials
    switch cBlock
        case 1
            congru = 1;
            incongru = 0;
        case 2
            congru = 0;
            incongru = 1;
        case 3 
            congru = 0;
            incongru = 0;
    end        
    
    if congru == 1
        %Congruent Trial
        RandWordOrd = randperm(5);
        RandColorOrd = randperm(5);
        Screen('DrawText',w,words{wcoun},960,500,colors{ccoun})
        Screen('Flip',w);    
    elseif incongru == 1  
        %Incongruent
        if wcolo(wcoun) == ccolo(ccoun)
           if wcolo(wcoun)>1
               wcolo(wcoun) = wcolo(wcoun)-1;
           else
               wcolo(wcoun) = wcolo(wcoun) +1;
           end
        end   
        Screen('DrawText',w,words{wcolo(wcoun)},960,500,colors{ccolo(ccoun)})
        Screen('Flip',w);
    else
        Screen('DrawText',w,words{wcolo(wcoun)},960,500,colors{ccolo(ccoun)})
        Screen('Flip',w);   
    end
    %Put in responce from keyboard
    %% KBCheck loop for input (Taken from WCST)
    % KEYCODES Q=20,W=26,E=8,R=21 T=23
    
    duration = 8;
    StartSecs = GetSecs;
    while GetSecs < StartSecs + duration
        restrictedKeys = [81 87 69 82 84];
        [keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            %answerGiven = KbName(keyCode);
            %disp(find(keyCode));
            answerKeyCode = find(keyCode);
            
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
                % Correct or incorrect
                switch answerKeyCode
                    case 81
                      pick = 'yellow';
                    case 87
                      pick = 'red';
                    case 69
                      pick = 'green';
                    case 82
                      pick = 'blue';
                    case 84
                      pick = 'purple';
               end
               switch ccolo(ccoun)
                   case 1
                       corans = 'yellow';
                   case 2
                       corans = 'red';
                   case 3
                       corans =  'green';
                   case 4
                       corans = 'blue';
                   case 5
                       corans = 'purple';
               end
               if isequal(corans,pick)
                   correct = 1;
               else
                   correct = 0;
               end
               break 
            end

        end
    end
    %% END OF KBcheck  
    % Blank Screen fill
    Screen('Flip',w);
    % Inter stim interval (2 seconds)
    WaitSecs(2);
    ccoun = ccoun + 1;
    wcoun = wcoun + 1;
    %Reset the counter
    nTrialPerBlockCounter = nTrialPerBlockCounter + 1;
    if nTrialPerBlockCounter == 30
        cBlock = cBlock + 1;
        nTrialPerBlockCounter = 1;
        if cBlock == 2
            break
        end    
    end    
    if ccoun == 6
        disp('Reset ccoun')
        ccoun = 1;
        ccolo = randperm(5);
    end    
    if wcoun == 6
        disp('Reset wcoun')
        wcoun = 1;
        wcolo = randperm(5);
    end       
end 
if fromGUI == 1
    cd(guidir);
end
ListenChar(0)
ShowCursor() 
    