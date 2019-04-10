function instructionsScreen(instructionsImageFileName)
screens = Screen('Screens');
screenNumber = max(screens);
w=Screen('OpenWindow',screenNumber);
[width, height]=Screen('WindowSize', w);
InstImage = imread(instructionsImageFileName);
InstImageTex = Screen('MakeTexture',w,InstImage);
Screen('DrawTexture',w,InstImageTex);
Screen('Flip',w);
%Wait for KB press to continue from instuctions
KbWait;
%Reset to blank screen
Screen('Flip',w);