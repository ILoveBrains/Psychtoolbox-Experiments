function backfordigit (subnum,famnum,child,EEGisOn,debugMode,forword,fromGUI)
%Notes
% Goes from forword, if they get 3 number sequences wrong in a row they
% move onto backwards. NEED TO IMPLEMENT BUTTON TO REPEAT THE SEQUENCE FOR
% THE SAME NUMBER OF DIGITS
%%Finds the filepath of the function and changes to that directory
if EEGisOn == 1
    actiTrigger(151)
end   
if fromGUI == 1
% Get the Dir for the GUI so we come back after running this .m file
    guidir = cd;
%Get the active matlab script file
    tmp = matlab.desktop.editor.getActive;
%Change to that path
    cd(fileparts(tmp.Filename))
end
%Behavioral datefile
% 1 if going forword - different datafiles for each
if forword == 1
    whatway = 'Forword';
else
    whatway = 'Backword';
end    
% Headers for the data

datafileheaders = 'Sub fam trial curdigit correct';
%Data file name
datafilename = sprintf('Par%d_Fam%d_%sdigit',subnum,famnum,whatway);
% Appending and creating - never destroying
datafile = fopen(datafilename,'a+');
%Time stamp
fprintf(datafile,'Session Started on %s\n',datetime);
fprintf(datafile,'%s\n',datafileheaders);

%%Create display for blank screen during experiment
screens = Screen('Screens');
screenNumber = max(screens);
deviceIndex = [];
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
Screen('Flip',w);
%Most likely not needed but these are the number strings
numbers = {'1','2','3','4','5','6','7','8','9'};
%% IMPORTANT - SEEDING RNG TO NOT BE RANDOM SO WE CAN USE ANSWER KEY
if forword == 1
    rng(1);
else
    rng(2)
end    
numcor = 0;
totalnumcounter = 1;
% Preload all audio files for later playback
[oneY,oneFS] = audioread('one.wav');
[twoY,twoFS] = audioread('two.wav');
[threeY,threeFS] = audioread('three.wav');
[fourY,fourFS] = audioread('four.wav');
[fiveY,fiveFS] = audioread('five.wav');
[sixY,sixFS] = audioread('six.wav');
[sevenY,sevenFS] = audioread('seven.wav');
[eightY,eightFS] = audioread('eight.wav');
[nineY,nineFS] = audioread('nine.wav');
nTotalTrials = 100;
% Generate the psudo-random number sets
% Added some extra numbers in order to make sure it doesnt crash when they
% go beyond the 3 numbers (currently at 6)
numb.two = randi(9,6,2);
numb.three = randi(9,6,3);
numb.four = randi(9,6,4);
numb.five = randi(9,6,5);
numb.six = randi(9,6,6);
numb.seven = randi(9,6,7);
numb.eight = randi(9,6,8);
numb.nine = randi(9,6,9);
%number count for answer sheet
nc2 = 1;
nc3 = 1;
nc4 = 1;
nc5 = 1;
nc6 = 1;
nc7 = 1;
nc8 = 1;
nc9 = 1;
% Children start at 2 digits and adults at 3
if child == 1
    startdigit = 2;
    %Time between saying the numbers
    nBetween = 1;
else
    startdigit = 3;
    %Time between saying the numbers
    nBetween = 1;
end
curdigit = startdigit;
failcount = 0;
%% Instructions
if forword == 1
    curDirInst = 'ForwardDigitSpanINST.png';
else
    curDirInst = 'BackwardDigitSpanInst.png';
end    
Inst = imread(curDirInst);
InstText = Screen('MakeTexture',w,Inst);
%Draw instructions to the screen
Screen('DrawTexture',w,InstText);
Screen('Flip',w)   
KbWait();

for q = 1:nTotalTrials
    
    switch curdigit
        case 2
            curdispdigit = numb.two(nc2,:);
            nc2 = nc2+1;
        case 3
            curdispdigit = numb.three(nc3,:);
            nc3 = nc3+1;           
        case 4
            curdispdigit = numb.four(nc4,:);
            nc4 = nc4+1;
        case 5
            curdispdigit = numb.five(nc5,:);
            nc5 = nc5+1;    
        case 6
            curdispdigit = numb.six(nc6,:);
            nc6 = nc6+1;              
        case 7
            curdispdigit = numb.seven(nc7,:);
            nc7 = nc7+1;              
        case 8
            curdispdigit = numb.eight(nc8,:);
            nc8 = nc8+1;              
        case 9
            curdispdigit = numb.nine(nc9,:);
            nc9 = nc9+1;              
    end        
    
    LoLength = length(curdispdigit);
    for i = 1:LoLength
        disp(curdispdigit)
        switch curdispdigit(i)
            case 1
                sound(oneY,oneFS)
            case 2
                sound(twoY,twoFS)
            case 3
                sound(threeY,threeFS)
            case 4
                sound(fourY,fourFS)
            case 5
                sound(fiveY,fiveFS)
            case 6
                sound(sixY,sixFS)
            case 7
                sound(sevenY,sevenFS)
            case 8
                sound(eightY,eightFS)
            case 9
                sound(nineY,nineFS)
        end
        WaitSecs(nBetween);
       
    end
    % (MaxTime,is EEG on, Debugmode)
    [corinc,keyCode,missed] = ExpCorInc(10,EEGisOn,0);
    if corinc == 1
        numcor = numcor + 1;
        disp('correct')
        if numcor == 2
            curdigit = curdigit + 1;
            failcount = 0;
        end    
    else
        failcount = failcount + 1;
    end
    if failcount == 2
        sca
        clear
        break
    end
    %Write the trial info to the file
    fprintf(datafile,'%d %d %d %d %d\n',subnum,famnum,curdigit,corinc);
    %If correct they go up one digit
    %If incorrect they repeat the same digit till get it wrong 3 times
end
% Back to the GUI Dir found at the begining of the run
if fromGUI == 1
    cd(guidir);
end   
actiTrigger(152)