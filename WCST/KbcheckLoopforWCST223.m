%% KbCheckLoop for WCST
%Works
commandwindow
duration = 8;
StartSecs = GetSecs;
while GetSecs < StartSecs + duration

    [keyIsDown, seconds, keyCode ] = KbCheck;
    if keyIsDown
        %answerGiven = KbName(keyCode);
        disp(find(keyCode))
        answerKeyCode = find(keyCode);
        restrictedKeys = [20 26 8 21];

    if ismember(answerKeyCode,restrictedKeys(:)) == true
        disp(find(keyCode))
        disp('in restricted keys loop')
        return
    end    
    end
end



