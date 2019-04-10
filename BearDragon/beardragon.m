% Bear Dragon - Like Simon Says, coded by the experimenter in the room with
% the child
% CURRENT VERSION USES STOCK VIDEOS UNDER CRATIVE COMMONS FOR PROOF OF
% CONCEPT

%CREATE LIST OF VIDEOS TO PLAY
% ORDER OF VIDEOS RANDOMIZED
% READ LIST VIDEO FILES
%
function beardragon (subnum,famnum,EEGisOn,debugMode)

%%Finds the filepath of the function and changes to that directory
% Get the Dir for the GUI so we come back after running this .m file
guidir = cd;
%Get the active matlab script file
tmp = matlab.desktop.editor.getActive;
%Change to that path
cd(fileparts(tmp.Filename));

[movie movieduration fps imgw imgh] = Screen('OpenMovie', win, moviename);

        % Start playback of movie. This will start
        % the realtime playback clock and playback of audio tracks, if any.
        % Play 'movie', at a playbackrate = 1, with endless loop=1 and
        % 1.0 == 100% audio volume.
        Screen('PlayMovie', movie, rate, 1, 1.0);
        
        % Start playback of movie. This will start
        % the realtime playback clock and playback of audio tracks, if any.
        % Play 'movie', at a playbackrate = 1, with endless loop=1 and
        % 1.0 == 100% audio volume.
        Screen('PlayMovie', movie, rate, 1, 1.0);
        % Valid texture returned?
        if tex < 0
            % No, and there won't be any in the future, due to some
            % error. Abort playback loop:
            
        end

        if tex == 0
            % No new frame in polling wait (blocking == 0). Just sleep
            % a bit and then retry.
            WaitSecs('YieldSecs', 0.005);
            
        end

        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex, [], [], [], [], [], [], shader);

        DrawFormattedText(win, ['Movie: ' moviename ], 'center', 20, 0);
        if coolstuff
            DrawFormattedText(win, ['Original URL: ' url '\n\n' credits], 'center', 60, 0);
        end

        % Update display:
        Screen('Flip', win);

        % Release texture:
        Screen('Close', tex);

        % Framecounter:
        i=i+1;
        
        
% Back to the GUI Dir found at the begining of the run
cd(guidir);
        