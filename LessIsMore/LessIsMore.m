function LessIsMore (subnum,famnum,EEGisOn)
%%Finds the filepath of the function and changes to that directory
% Get the Dir for the GUI so we come back after running this .m file
guidir = cd;
%Get the active matlab script file
tmp = matlab.desktop.editor.getActive;
%Change to that path
cd(fileparts(tmp.Filename));
rng('shuffle')
screens = Screen('Screens');
% Draw to the external screen if avaliable
screenNumber = max(screens);
startingDir = cd;
%Get image list and change back to main folder
imageDirectory = sprintf('%s/images',startingDir);
imageList = readtable('IMGfileName.txt');
imageList = table2cell(imageList);
% Back to the GUI Dir found at the begining of the run
cd(guidir);