function varargout = panelTool(varargin)
% PANELTOOL MATLAB code for panelTool.fig
%      PANELTOOL, by itself, creates a new PANELTOOL or raises the existing
%      singleton*.
%
%      H = PANELTOOL returns the handle to a new PANELTOOL or the handle to
%      the existing singleton*.
%
%      PANELTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANELTOOL.M with the given input arguments.
%
%      PANELTOOL('Property','Value',...) creates a new PANELTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before panelTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to panelTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help panelTool

% Last Modified by GUIDE v2.5 15-Apr-2016 16:51:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @panelTool_OpeningFcn, ...
    'gui_OutputFcn',  @panelTool_OutputFcn, ...
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


% --- Executes just before panelTool is made visible.
function panelTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to panelTool (see VARARGIN)

% Choose default command line output for panelTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global inicFolder dirImg originalUSCrop nroFrameSelected PathName;
global activeUser inicFolderFile currentFolder;
currentFolder = pwd;
functionality_folder = strcat(currentFolder,filesep,'functionality');
GUI_folder = strcat(currentFolder,filesep,'GUIfunctions');
addpath(functionality_folder)
addpath(GUI_folder)
inicFolderFile = strcat(currentFolder,filesep,'luf.wll');
contentConfigFile = fileread(inicFolderFile);
contentConfigFile = strsplit(contentConfigFile,'\n');
inicFolder = contentConfigFile{1};
activeUser = contentConfigFile{2};
set(handles.editUser, 'String', activeUser);
Details;
scriptDisableAllButtons;
scriptCheckBoxes0;
set(handles.text6, 'visible', 'off');
set(handles.text7, 'visible', 'off');

% --- Outputs from this function are returned to the command line.
function varargout = panelTool_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

function checkboxLIAnterior_Callback(hObject, eventdata, handles)
function checkboxLIPosterior_Callback(hObject, eventdata, handles)
function checkboxDiamLimits_Callback(hObject, eventdata, handles)
function checkboxZoom_Callback(hObject, eventdata, handles)
function checkboxLI_Callback(hObject, eventdata, handles)
function checkboxMA_Callback(hObject, eventdata, handles)
function checkboxLimitsIntima_Callback(hObject, eventdata, handles)
function checkboxEdgeIntima_Callback(hObject, eventdata, handles)
function pushbuttonReady_Callback(hObject, eventdata, handles)

function pushbuttonOK_Callback(hObject, eventdata, handles)
scriptPushOK;

function pushbuttonRedo_Callback(hObject, eventdata, handles)
scriptPushRedo;

% --- Executes on button press in pushbuttonAbrir.
function pushbuttonAbrir_Callback(hObject, eventdata, handles)
scriptOpenCarotida;

function editUser_Callback(hObject, eventdata, handles)
global activeUser;
activeUser=get(handles.editUser, 'String');

function editUser_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbuttonExport_Callback(hObject, eventdata, handles)
scriptExportarGUI;
scriptCheckBoxes0;
set(handles.pushbuttonExport, 'Enable', 'off');
stepPipe = 1;
set(handles.textDetails,'String','');
imshow(imread(strcat(dirImg,'_Sztajzel.png')));


function pushbuttonOK_KeyPressFcn(hObject, eventdata, handles)
key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    pushbuttonOK_Callback(hObject, eventdata, handles)
end

function pushbuttonExport_KeyPressFcn(hObject, eventdata, handles)
key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    pushbuttonExport_Callback(hObject, eventdata, handles)
end
