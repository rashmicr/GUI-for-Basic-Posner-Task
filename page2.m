function varargout = page2(varargin)
% PAGE2 MATLAB code for page2.fig
%      PAGE2, by itself, creates a new PAGE2 or raises the existing
%      singleton*.
%
%      H = PAGE2 returns the handle to a new PAGE2 or the handle to
%      the existing singleton*.
%
%      PAGE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAGE2.M with the given input arguments.
%
%      PAGE2('Property','Value',...) creates a new PAGE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before page2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to page2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help page2

% Last Modified by GUIDE v2.5 29-Mar-2005 17:34:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @page2_OpeningFcn, ...
                   'gui_OutputFcn',  @page2_OutputFcn, ...
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


% --- Executes just before page2 is made visible.
function page2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to page2 (see VARARGIN)

% Choose default command line output for page2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
a=imread('cue.png');
imshow(a);
axes(handles.axes3);


% UIWAIT makes page2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = page2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
b=imread('triangle.png');
axes(handles.axes2);
imshow(b);
for m = 0:4
    for n = 0:4
        axes(handles.axes1);
        title('Posner Cueing task');
        rectangle('Position', [120*m 120*n 120 120], 'FaceColor','w','EdgeColor','w'); % Divide it into a grid
    end
end
hold on
prompt = {'Enter number of trials:','Enter subject name to save data'};
dlg_title = 'Input for data collection';
num_lines = 1;
def = {'',''};
DataCollect = newid(prompt,dlg_title,num_lines,def);
sg = msgbox('Keep your eyes fixed at center of the screen. Press a key as soon as you see the red triangle');
uiwait(sg)
[X, Y] = meshgrid(1:5,1:5); % Create the necessary arrays to select from during random trials
X = (X-1)*120+65;
Y = X(1,:);
X = [0 120*(1:3)];
if isempty(DataCollect)==1;
    tt=20;
else
    tt=str2num(cell2mat(DataCollect(1)));
end
for p = 1:tt % Total number of trials is set here to 90
    x_m = randi(4,1); % Indices for x
    y_m = randi(4,1); % Indices for y
    x = Y(1,x_m); % Retrieve x coordinate of target
    y = Y(1,y_m); % Retrieve y coordinate of target
    RT(p,1) = x; % Record x coord
    RT(p,2) = y; % Record y coord
    if randi(2,1) > 1 % A valid cue, 50% chance of occuring
        r = rectangle('Position',[X(1,x_m) X(1,x_m) 120 120],'FaceColor','g'); % Draw the cue in the same grid position as the target
        RT(p,5) = 1; % Record that this trial was a valid cue, represented by the number 1
        RT(p,6) = x; % Record x coord of target
        RT(p,7) = y; % Record y coord of target
    else % Invalid cue
        x_n = X(1,randi(4,1)); % Generate a random position for the cue 
        y_n = X(1,randi(4,1));
        r = rectangle('Position',[x_n y_n 120 120], 'FaceColor', 'g'); % Draw the cue
        RT(p,5) = 0; % Record that this trial was an invalid cue, represented by the number 0
        RT(p,6) = x_n; % Record x coord of target
        RT(p,7) = y_n; % Record y coord of target
    end    
    if randi(2,1) > 1 % Long delay, 50% chance
        pause(0.3) % Delay of 0.3 seconds before showing the target
        RT(p,4) = 0.3; % Record the delay
        delete(r); % Remove the cue
    else % Short delay
        pause(0.1) % Delay of 0.1 seconds
        RT(p,4) = 0.1;
        delete(r);
    end
    
    S = scatter(x,y,'^','r','MarkerFaceColor','r'); % Draw the target
    tic; % Start measuring time
    k = waitforbuttonpress; % Await user input
    RT(p,3) = toc; % Record the time taken to react to the target
    delete(S); % Remove the target
    
end
responsetime=mean(RT(:,3));
set(handles.edit1,'String',num2str(responsetime));
col_header={'Initial Target X coordinate','initial Target Y Coordinate','Response time','Delay','Cue Type','X Coordinate of target','y Coordinate of target'};
msgbox('Successfully completed the trial');
RT_valid = RT((RT(:,5)>0),5);
RT_invalid = RT((RT(:,5)==0),5);
figure;
bar([numel(RT_valid) numel(RT_invalid)],'c');
set(gca,'xticklabel',{'valid','invalid'});
ylim([0 tt]);
xlim([0 3]);
title('Valid and Invalid cues');
ylabel('Total trials');
xlabel('Cue Type');
data = ['./' 'Posner Task' '-' DataCollect(2) '-' date '.mat'];
data1 = ['./' 'Posner Task' '-' DataCollect(2) '-' date '.xls'];
save(strjoin(data), 'RT' );
xlswrite(strjoin(data1),RT,'sheet1','A2');
xlswrite(strjoin(data1),col_header,'sheet1','A1');







function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
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
display(guiposner);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
