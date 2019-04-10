function FruitStroop2 (subnum,famnum,EEGisOn)
%% NOTES

% Update as of 7/17
% image display goes as follows
% Big Fruits
% Just the Small Fruit
% Big Fruits and Little fruits seperated
% Incongruent Mixed
screens = Screen('Screens');
shapesBIG = {'apple','banana','orange'};
shapesSMALL = {'apple','banana','orange'};
deviceIndex = [];
KbName('UnifyKeyNames');
one = KbName('1');
zero = KbName('0');
esc = KbName('ESCAPE');
qq = KbName('q');
ww = KbName('w');
ee = KbName('e');
rr = KbName('r');
tt = KbName('t');
screenNumber = max(screens);
startingDir = cd;
%Get image list and change back to main folder
imageDirectory = sprintf('%s/images/cards',startingDir);
imageList = readtable('IMGfileName.txt');
imageList = table2cell(imageList);
cd(startingDir);
%% Behavioral Data file location and name
datafilename = sprintf('Par%d_Fam%d_FruitStroop.txt',subnum,famnum);
datafile = fopen(datafilename, 'a+');

w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
% Image file names
bigFruitFileName = 'bigfruit.png';
littleFruitFileName = 'littlefruit.png';
bigAndLittle = 'biglilseprate.png';
incongru = 'incongru.png';
bigFruit = imread(bigFruitFileName);
littleFruit = imread(littleFruitFileName);
bigPlusLil = imread(bigAndLittle);
incon = imread(incongru);
bigFruitTex = Screen('MakeTexture',w,bigFruit);
littleFruitTex = Screen('MakeTexture',w,littleFruit);
bigLilTex = Screen('MakeTexture',w,bigPlusLil);
inconTex = Screen('MakeTexture',w,incon);
%Restrict input for KBcheck
%Give a blank screen before we 
actiTrigger (131)
Screen('Flip',w);
KbWait();
%% Start Initial trials
Screen('DrawTexture',w,bigFruitTex);
Screen('Flip',w);
KbWait;
WaitSecs(2);
% Wait Until a keypress to move forword
KbWait;
Screen('Flip',w)
KbWait;
WaitSecs(2);
% Show Little Fruits
Screen('DrawTexture',w,littleFruitTex);
Screen('Flip',w);
% Wait Until a keypress to move forword
KbWait;
WaitSecs(2);
Screen('Flip',w)
WaitSecs(2);
% Show BOTH
Screen('DrawTexture',w,bigLilTex);
Screen('Flip',w);
WaitSecs(2);
%Wait Until a keypress to move forword
KbWait;
Screen('Flip',w)
WaitSecs(2);
for i = 1:10
    Screen('DrawTexture',w,inconTex);
    Screen('Flip',w);
    while GetSecs < StartSecs + duration
        [keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown
            ExpCorInc(duration,EEGisOn)
        end        
    end
end
KbWait;
actiTrigger (132)


