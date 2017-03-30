function varargout = MultiBlood(varargin)
% MULTIBLOOD MATLAB code for MultiBlood.fig
%      MULTIBLOOD, by itself, creates a new MULTIBLOOD or raises the existing
%      singleton*.
%
%      H = MULTIBLOOD returns the handle to a new MULTIBLOOD or the handle to
%      the existing singleton*.
%
%      MULTIBLOOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIBLOOD.M with the given input arguments.
%
%      MULTIBLOOD('Property','Value',...) creates a new MULTIBLOOD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MultiBlood_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MultiBlood_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MultiBlood

% Last Modified by GUIDE v2.5 09-Feb-2017 17:09:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MultiBlood_OpeningFcn, ...
                   'gui_OutputFcn',  @MultiBlood_OutputFcn, ...
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


% --- Executes just before MultiBlood is made visible.
function MultiBlood_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MultiBlood (see VARARGIN)

addpath('Core')
addpath(fullfile('Core','Pole_functions'))
addpath('Mie')
addpath('SB2_Release_200')

% Choose default command line output for MultiBlood
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global Blood
MultiBlood_plot(handles,Blood)

% UIWAIT makes MultiBlood wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MultiBlood_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_Ctot.
function pushbutton_Ctot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Ctot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, pathname] = uigetfile('*.*','Please select Ctot file');
if ~file==0
    dataCtot = load(fullfile(pathname,file));
    
    global Blood
    Blood.TotalPlasma.data.tCtot = dataCtot(:,1);
    Blood.TotalPlasma.data.Ctot  = dataCtot(:,2);
    Blood.TotalPlasma.data.wCtot = dataCtot(:,3);
    
    MultiBlood_plot(handles,Blood)
 
end

% --- Executes on button press in pushbutton_PPf.
function pushbutton_PPf_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PPf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, pathname] = uigetfile('*.*','Please select PPf file');
if ~file==0
    
    dataPPf = load(fullfile(pathname,file));
    
    global Blood
    Blood.ParentFraction.data.tPPf = dataPPf(:,1);
    Blood.ParentFraction.data.PPf  = dataPPf(:,2);
    Blood.ParentFraction.data.wPPf = dataPPf(:,3);

    MultiBlood_plot(handles,Blood)
    
end


% --- Executes on button press in Fit.
function Fit_Callback(hObject, eventdata, handles)
% hObject    handle to Fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Blood
if ~isfield(Blood,'TotalPlasma')
    uiwait(msgbox('No TotalPlasma data','MultiBlood Error','error'));
elseif ~isfield(Blood,'ParentFraction')
    uiwait(msgbox('No ParentFraction data','MultiBlood Error','error'));
else   
    [Blood.UnifiedFit.par,Blood.UnifiedFit.info,Blood.UnifiedFit.info_Cp] = MultiBlood_fit(Blood);
    MultiBlood_plot(handles,Blood)
end

% --- Executes on button press in pushbutton_Cbauto.
function pushbutton_Cbauto_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Cbauto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uigetfile('*.*','Please select Cb automatic file');
if ~file==0
    dataCbauto = load(fullfile(pathname,file));
    
    global Blood
    Blood.WholeBlood.data(2).tCb = dataCbauto(:,1);
    Blood.WholeBlood.data(2).Cb  = dataCbauto(:,2);
    Blood.WholeBlood.data(2).wCb = dataCbauto(:,3);
    
    MultiBlood_plot(handles,Blood)
    
end

% --- Executes on button press in pushbutton_Cbmanu.
function pushbutton_Cbmanu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Cbmanu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uigetfile('*.*','Please select Cb manual file');
if ~file==0
    dataCbmanu = load(fullfile(pathname,file));
    
    global Blood
    Blood.WholeBlood.data(1).tCb = dataCbmanu(:,1);
    Blood.WholeBlood.data(1).Cb  = dataCbmanu(:,2);
    Blood.WholeBlood.data(1).wCb = dataCbmanu(:,3);
    
    MultiBlood_plot(handles,Blood)

end

% --- Executes on button press in radiobutton_manu.
function radiobutton_manu_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_manu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_manu

handles.pushbutton_Cbmanu.Visible = 'off';
handles.pushbutton_Cbauto.Visible = 'off';
handles.pushbutton_FitPOB.Visible = 'off';

% --- Executes on button press in radiobutton_auto.
function radiobutton_auto_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.pushbutton_Cbmanu.Visible = 'on';
handles.pushbutton_Cbauto.Visible = 'on';
handles.pushbutton_FitPOB.Visible = 'on';


% --- Executes on button press in pushbutton_FitPOB.
function pushbutton_FitPOB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FitPOB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Blood
if ~isfield(Blood,'TotalPlasma')
    uiwait(msgbox('No TotalPlasma data','MultiBlood Error','error'));
elseif ~isfield(Blood,'WholeBlood')
    uiwait(msgbox('No WholeBlood manual data','MultiBlood Error','error'));
elseif isempty(Blood.WholeBlood.data(1).tCb)
    uiwait(msgbox('No WholeBlood manual data','MultiBlood Error','error'));
else   
    Blood.PlasmaOverBlood.data.tPOB = Blood.TotalPlasma.data(1).tCtot;
    Blood.PlasmaOverBlood.data.POB  = Blood.TotalPlasma.data(1).Ctot./Blood.WholeBlood.data(1).Cb;
    Blood.PlasmaOverBlood.data.wPOB = ones(size(Blood.PlasmaOverBlood.data.POB));

    POB
end

% --- Executes on button press in pushbutton_Options.
function pushbutton_Options_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(msgbox('Options are not yet implemented in the GUI, they can be manually edited at the beginning of MultiBlood_fit.m','MultiBlood message'));

% --- Executes on button press in pushbutton_savemat.
function pushbutton_savemat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savemat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, pathname] = uiputfile('*.mat','Please select where to save the blood mat');
if ~file==0
    global Blood
    save(fullfile(pathname,file),'Blood')

end

% --- Executes on button press in pushbutton_loadmat.
function pushbutton_loadmat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uigetfile('*.mat','Please select Blood mat');
if ~file==0
    clear global Blood
    try
        global Blood 
        load(fullfile(pathname,file),'Blood');
        MultiBlood_plot(handles,Blood)
        
    catch err
        uiwait(msgbox('Error in loading Blood','MultiBlood Error','error'));
    end

end

% --- Executes on button press in pushbutton_yCp.
function pushbutton_yCp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_yCp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uiputfile('*.txt','Please select where to save yCp');
if ~file==0
    global Blood
    try
        time = eval(handles.edit_time.String);
        time = time(:);
        yCp  = modelCp(Blood.UnifiedFit.par,Blood.UnifiedFit.info_Cp,time);
        
        fileID = fopen(fullfile(pathname,file),'w');
        fprintf(fileID, 'time yCp\n');
        fprintf(fileID,'%f %f\n',[time,yCp]');
        fclose(fileID);
        
    catch err
        uiwait(msgbox('Error in time format','MultiBlood Error','error'));
    end

end

% --- Executes on button press in pushbutton_yCmet.
function pushbutton_yCmet_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_yCmet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uiputfile('*.txt','Please select where to save yCmet');
if ~file==0
    global Blood
    try
        time  = eval(handles.edit_time.String);
        time  = time(:);
        yCmet = modelCmet(Blood.UnifiedFit.par,Blood.UnifiedFit.info,time);
        
        fileID = fopen(fullfile(pathname,file),'w');
        fprintf(fileID, 'time yCmet\n');
        fprintf(fileID,'%f %f\n',[time,yCmet]');
        fclose(fileID);
        
    catch err
        uiwait(msgbox('Error in time format','MultiBlood Error','error'));
    end

end

% --- Executes on button press in pushbutton_yCtot.
function pushbutton_yCtot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_yCtot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uiputfile('*.txt','Please select where to save yCtot');
if ~file==0
    global Blood
    try
        time  = eval(handles.edit_time.String);
        time  = time(:);
        yCtot = modelCtot(Blood.UnifiedFit.par,Blood.UnifiedFit.info,time);
        
        fileID = fopen(fullfile(pathname,file),'w');
        fprintf(fileID, 'time yCtot\n');
        fprintf(fileID,'%f %f\n',[time,yCtot]');
        fclose(fileID);
        
    catch err
        uiwait(msgbox('Error in time format','MultiBlood Error','error'));
    end

end

% --- Executes on button press in pushbutton_yPPf.
function pushbutton_yPPf_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_yPPf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uiputfile('*.txt','Please select where to save yPPf');
if ~file==0
    global Blood
    try
        time = eval(handles.edit_time.String);
        time = time(:);
        yPPf = modelPPf(Blood.UnifiedFit.par,Blood.UnifiedFit.info,time);
        
        fileID = fopen(fullfile(pathname,file),'w');
        fprintf(fileID, 'time yPPf\n');
        fprintf(fileID,'%f %f\n',[time,yPPf]');
        fclose(fileID);
        
    catch err
        uiwait(msgbox('Error in time format','MultiBlood Error','error'));
    end

end


function edit_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_time as text
%        str2double(get(hObject,'String')) returns contents of edit_time as a double


% --- Executes during object creation, after setting all properties.
function edit_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_All.
function pushbutton_All_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname] = uiputfile('*.txt','Please select where to save modelled data');
if ~file==0
    global Blood
    try
        time = eval(handles.edit_time.String);
        time = time(:);
        
        yCp   = modelCp(Blood.UnifiedFit.par,Blood.UnifiedFit.info_Cp,time);
        yCtot = modelCtot(Blood.UnifiedFit.par,Blood.UnifiedFit.info,time);
        yCmet = modelCmet(Blood.UnifiedFit.par,Blood.UnifiedFit.info,time);
        yPPf  = modelPPf(Blood.UnifiedFit.par,Blood.UnifiedFit.info,time);
        
        fileID = fopen(fullfile(pathname,file),'w');
        fprintf(fileID, 'time yCp yCtot yPPf yCmet \n');
        fprintf(fileID,'%f %f %f %f %f\n',[time,yCp,yCtot,yPPf,yCmet]');
        fclose(fileID);
        
    catch err
        uiwait(msgbox('Error in time format','MultiBlood Error','error'));
    end

end


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global Blood
cla(handles.axes_Ctot,'reset')
cla(handles.axes_PPf,'reset')
handles.uipanel7.Visible = 'off';
close(gcbf)
MultiBlood


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
clear global Blood
delete(hObject);
