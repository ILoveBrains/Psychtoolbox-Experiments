fileid = 'monster.png';
screens = Screen('Screens');
screenNumber = max(screens);
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
a = imread('monster.png');
monstertex = Screen('MakeTexture',w,a);
Screen('DrawTexture',w,monstertex);
Screen('Flip',w);
