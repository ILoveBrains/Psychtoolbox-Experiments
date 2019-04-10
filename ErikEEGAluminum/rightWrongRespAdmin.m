function [corinc,keyCode,missed] = rightWrongRespAdmin(maxT,EEG)
% restrict the keys for a experimental admins responce for correct or
% incorrect. This function is to be used when expecting an oral or
% otherwise behavioral responce to be coded by the experimenter. This
% outputs the "correct or incorrect" responce as a boolian value, and the
% key pressed. This is for the behavioral log of the file. Defaults to a
% incorrect answer

%EEG input is logical, and should be true if you are currently running an
%eeg task and wish to have trigger inputs to the actichamp system

%ESCAPE KEY EXITS LOOP

% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:
KbName('UnifyKeyNames');
moveOn = 0;
tic;
%If no input maxT is given it is set to the default of 10 seconds
%EEG is defaulted to 0 meaning not on and wont send trigger codes
if nargin == 0
    maxT = 10;
    EEG = 0;
end
%Loop for period of time given by maxT input
while moveOn == 0
[keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        %disp(find(keyCode))
        keyCode = find(keyCode);
        if keyCode == 30 || 39
            if keyCode == 30
                corinc = 1;
                missed = 0;
                moveOn = 1;
                if EEG == 1
                    actiTrigger(100)
                end    
                
            end
            if keyCode == 39   
                corinc = 0;
                missed = 0;
                moveOn = 1;
            end
                if EEG == 1
                    actiTrigger(105)
                end  
        end 
        if keyCode == 41
            disp('Pressed Escape to end Keyboard Loop')
            break
        end
    end
    if toc >= maxT
        disp('Reached Max Time Limit for Reponce')
        corinc = 0;
        missed = 1;
        moveOn = 1;
    end
    
end
    
