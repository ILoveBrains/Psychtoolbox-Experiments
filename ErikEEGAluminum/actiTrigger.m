function actiTrigger (eventCode)
% Send a trigger to the Actichamp EEG system during recording
% Then Clearing the channel to allow for another trigger
% this function should take around 0.002 seconds to complete
% Functionality requires Mex-File Plug-in for Fast MATLAB Port I/O ...
% Located at http://apps.usd.edu/coglab/psyc770/IO64.html
    
    % Send EEG Trigger/event Code
    outp(hex2dec('D050'),eventCode);
    %Clear Channel
    WaitSecs(0.001);
    outp(hex2dec('D050'),0);
    WaitSecs(0.001);
end    