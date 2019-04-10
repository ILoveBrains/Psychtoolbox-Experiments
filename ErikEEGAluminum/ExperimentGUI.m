function varargout = ExperimentGUI(varargin)
% EXPERIMENTGUI MATLAB code for ExperimentGUI.fig
%      EXPERIMENTGUI, by itself, creates a new EXPERIMENTGUI or raises the existing
%      singleton*.
%
%      H = EXPERIMENTGUI returns the handle to a new EXPERIMENTGUI or the handle to
%      the existing singleton*.
%
%      EXPERIMENTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMENTGUI.M with the given input arguments.
%
%      EXPERIMENTGUI('Property','Value',...) creates a new EXPERIMENTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExperimentGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExperimentGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExperimentGUI

% Last Modified by GUIDE v2.5 28-Jun-2017 11:10:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExperimentGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ExperimentGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ExperimentGUI is made visible.
function ExperimentGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExperimentGUI (see VARARGIN)

% Choose default command line output for ExperimentGUI
handles.output = hObject;
handles.directoryinfo.start = cd;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExperimentGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ExperimentGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function subnum_Callback(hObject, eventdata, handles)
% hObject    handle to subnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subnum as text
%        str2double(get(hObject,'String')) returns contents of subnum as a double

subnum = str2double(get(hObject,'String'));
% Must be a number (Error Checking)
if isnan(subnum)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.partinfo.subnum = subnum;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function subnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function famnum_Callback(hObject, eventdata, handles)
% hObject    handle to famnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of famnum as text
%        str2double(get(hObject,'String')) returns contents of famnum as a double
famnum = str2double(get(hObject,'String'));
if isnan(famnum)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.partinfo.famnum = famnum;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function famnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to famnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EEGisOn_Callback(hObject, eventdata, handles)
% hObject    handle to EEGisOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EEGisOn as text
%        str2double(get(hObject,'String')) returns contents of EEGisOn as a double

EEGisOn= str2double(get(hObject,'String'));
if isnan(EEGisOn)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.partinfo.EEGisOn = EEGisOn;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function EEGisOn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGisOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ColorStroop.
function ColorStroop_Callback(hObject, eventdata, handles)
% hObject    handle to ColorStroop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
debugMode = handles.partinfo.Debug;
cd ../
cd ColorStroop
StroopColor(subnum,famnum,EEGisOn,debugMode)
cd(handles.directoryinfo.start);

% --- Executes on button press in WCST.
function WCST_Callback(hObject, eventdata, handles)
% hObject    handle to WCST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
debugMode = handles.partinfo.Debug;
cd ../
cd WCST
WCST(subnum,famnum,EEGisOn)
cd(handles.directoryinfo.start);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FruitStroop.
function FruitStroop_Callback(hObject, eventdata, handles)
% hObject    handle to FruitStroop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
debugMode = handles.partinfo.Debug;
cd ../
cd FruitStroop
FrootStroop(subnum,famnum,EEGisOn)
cd(handles.directoryinfo.start);

% --- Executes on button press in DCCS.
function DCCS_Callback(hObject, eventdata, handles)
% hObject    handle to DCCS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
debugMode = handles.partinfo.Debug;
cd ../
cd DCCS
DCCS(subnum,famnum,EEGisOn,debugMode)
cd(handles.directoryinfo.start);

% --- Executes on button press in LessIsMore.
function LessIsMore_Callback(hObject, eventdata, handles)
% hObject    handle to LessIsMore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
cd ../
cd LessIsMore
LessIsMore (subnum,famnum,EEGisOn)
cd(handles.directoryinfo.start);

% --- Executes on button press in BearDragon.
function BearDragon_Callback(hObject, eventdata, handles)
% hObject    handle to BearDragon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
debugMode = handles.partinfo.Debug;
cd ../
cd BearDragon
cd(handles.directoryinfo.start);

% --- Executes on button press in DigitSpan.
function DigitSpan_Callback(hObject, eventdata, handles)
% hObject    handle to DigitSpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
child = handles.partinfo.Child;
debugMode = handles.partinfo.Debug;
Forward = handles.partinfo.Forward;
cd ../
cd BackwardDigit
backfordigit (subnum,famnum,child,EEGisOn,debugMode,Forward)
cd(handles.directoryinfo.start);

% --- Executes on button press in DigitSpanChild.
function DigitSpanChild_Callback(hObject, eventdata, handles)
% hObject    handle to DigitSpanChild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Forward = 0;
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
child = handles.partinfo.Child;
debugMode = handles.partinfo.Debug;
Forward = handles.partinfo.Forward;
backfordigit (subnum,famnum,child,EEGisOn,debugMode,Forward)
cd(handles.directoryinfo.start);

% --- Executes on button press in BaselineChild.
function BaselineChild_Callback(hObject, eventdata, handles)
% hObject    handle to BaselineChild (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
debugMode = 0;
subnum = handles.partinfo.subnum;
famnum = handles.partinfo.famnum;
EEGisOn = handles.partinfo.EEGisOn;
cd(handles.directoryinfo.start);

% --- Executes on button press in DigiSpanChildDone.
function DigiSpanChildDone_Callback(hObject, eventdata, handles)
% hObject    handle to DigiSpanChildDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigiSpanChildDone


% --- Executes on button press in FruitStroopDone.
function FruitStroopDone_Callback(hObject, eventdata, handles)
% hObject    handle to FruitStroopDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FruitStroopDone


% --- Executes on button press in DCCSDone.
function DCCSDone_Callback(hObject, eventdata, handles)
% hObject    handle to DCCSDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DCCSDone


% --- Executes on button press in LessIsMoreDone.
function LessIsMoreDone_Callback(hObject, eventdata, handles)
% hObject    handle to LessIsMoreDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LessIsMoreDone


% --- Executes on button press in DigiDone.
function DigiDone_Callback(hObject, eventdata, handles)
% hObject    handle to DigiDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigiDone


% --- Executes on button press in colorstroopDone.
function colorstroopDone_Callback(hObject, eventdata, handles)
% hObject    handle to colorstroopDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of colorstroopDone


% --- Executes on button press in WCSTDone.
function WCSTDone_Callback(hObject, eventdata, handles)
% hObject    handle to WCSTDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WCSTDone


% --- Executes on button press in TowerDone.
function TowerDone_Callback(hObject, eventdata, handles)
% hObject    handle to TowerDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TowerDone


% --- Executes on button press in BearDragonDone.
function BearDragonDone_Callback(hObject, eventdata, handles)
% hObject    handle to BearDragonDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BearDragonDone


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in Debug.
function Debug_Callback(hObject, eventdata, handles)
% hObject    handle to Debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Debug = get(hObject,'Value');
disp(Debug)
handles.partinfo.Debug = Debug;
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Debug


% --- Executes on button press in ForwardDigit.
function ForwardDigit_Callback(hObject, eventdata, handles)
% hObject    handle to ForwardDigit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Forward = get(hObject,'Value');
disp(Forward)
handles.partinfo.Forward = Forward;
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of ForwardDigit

% --- Executes on button press in Child.
function Child_Callback(hObject, eventdata, handles)
% hObject    handle to Child (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Child = get(hObject,'Value');
disp(Child)
handles.partinfo.Child = Child;
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Child
