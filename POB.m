function varargout = POB(varargin)
% POB MATLAB code for POB.fig
%      POB, by itself, creates a new POB or raises the existing
%      singleton*.
%
%      H = POB returns the handle to a new POB or the handle to
%      the existing singleton*.
%
%      POB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POB.M with the given input arguments.
%
%      POB('Property','Value',...) creates a new POB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before POB_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to POB_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help POB

% Last Modified by GUIDE v2.5 10-Feb-2017 16:02:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @POB_OpeningFcn, ...
                   'gui_OutputFcn',  @POB_OutputFcn, ...
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


% --- Executes just before POB is made visible.
function POB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to POB (see VARARGIN)
    
global Blood
addpath('POB_models');
cla(handles.axes_POB,'reset')
cla(handles.axes_wres,'reset')

plot(handles.axes_POB,Blood.PlasmaOverBlood.data.tPOB,Blood.PlasmaOverBlood.data.POB,'o')

    
% Choose default command line output for POB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes POB wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = POB_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_POBmodel.
function popupmenu_POBmodel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_POBmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_POBmodel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_POBmodel
global Blood
contents = cellstr(get(hObject,'String'));
FUN      = contents{get(hObject,'Value')};

Blood.PlasmaOverBlood.fitted = [];
Blood.PlasmaOverBlood.fitted.FUN = FUN;

switch FUN
    case 'Linear interpolation'
        handles.uipanel_polynomial.Visible    = 'off';
        handles.uipanel_generic_model.Visible = 'off'; 
        
    case 'Polynomial'
        N = str2double(get(handles.edit_degree_pol,'String'));
        Blood.PlasmaOverBlood.fitted.fixed_par = N;
        
        handles.uipanel_polynomial.Visible    = 'on';
        handles.uipanel_generic_model.Visible = 'off';
    otherwise
        N = eval(Blood.PlasmaOverBlood.fitted.FUN);
        
        Blood.PlasmaOverBlood.fitted.p0    = ones(N,1);
        Blood.PlasmaOverBlood.fitted.pdown = zeros(size(Blood.PlasmaOverBlood.fitted.p0));
        Blood.PlasmaOverBlood.fitted.pup   = inf(size(Blood.PlasmaOverBlood.fitted.p0));
        Blood.PlasmaOverBlood.fitted.fixed = false(size(Blood.PlasmaOverBlood.fitted.p0));
        
        handles.uitable1.Data = repmat({1,0,Inf,false},N,1);
        handles.uipanel_polynomial.Visible    = 'off';
        handles.uipanel_generic_model.Visible = 'on';
end
        

% --- Executes during object creation, after setting all properties.
function popupmenu_POBmodel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_POBmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

POB_models = dir(fullfile('POB_models','*.m'));
for i = 1 : length(POB_models)
    [~,name,~] = fileparts(POB_models(i).name) ;
    hObject.String{end + 1,1} = name;
end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% keyboard
hObject.Data = {1,0,Inf,false};


function edit_degree_pol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_degree_pol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_degree_pol as text
%        str2double(get(hObject,'String')) returns contents of edit_degree_pol as a double
global Blood        
N = str2double(get(handles.edit_degree_pol,'String'));
Blood.PlasmaOverBlood.fitted.fixed_par = N;

% --- Executes during object creation, after setting all properties.
function edit_degree_pol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_degree_pol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot_POB_generic.
function pushbutton_plot_POB_generic_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot_POB_generic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Blood
tv   = [0:0.1:Blood.PlasmaOverBlood.data.tPOB(end)];
par  = [handles.uitable1.Data{:,1}]';
yPOB = feval(Blood.PlasmaOverBlood.fitted.FUN,par,[],tv);
plot(handles.axes_POB,Blood.PlasmaOverBlood.data.tPOB,Blood.PlasmaOverBlood.data.POB,'o')
hold(handles.axes_POB,'on')
plot(handles.axes_POB,tv,yPOB,'-r')
hold(handles.axes_POB,'off')


% --- Executes on button press in pushbutton_estimate.
function pushbutton_estimate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Blood 
Blood = POB_fit(Blood);

tv   = [0:0.1:Blood.PlasmaOverBlood.data.tPOB(end)];
yPOB = POB_eval(Blood,tv);
plot(handles.axes_POB,Blood.PlasmaOverBlood.data.tPOB,Blood.PlasmaOverBlood.data.POB,'o')
hold(handles.axes_POB,'on')
plot(handles.axes_POB,tv,yPOB,'-r')
hold(handles.axes_POB,'off')


switch Blood.PlasmaOverBlood.fitted.FUN
    case 'Linear interpolation'
        handles.uitable5.Visible         = 'off';
        cla(handles.axes_wres,'reset')
        handles.axes_wres.Visible        = 'off';
        handles.uipanel_statsres.Visible = 'off';
        
    otherwise
        % uitable5
        handles.uitable5.Data = num2cell([Blood.PlasmaOverBlood.fitted.par(:),round(Blood.PlasmaOverBlood.fitted.cvpar(:))]);
        handles.uitable5.Visible = 'on';
        
        % axes_wres
        plot(handles.axes_wres,Blood.PlasmaOverBlood.data.tPOB,Blood.PlasmaOverBlood.fitted.wres,'-o')
        hold(handles.axes_wres,'on')
        plot(handles.axes_wres,[0 Blood.PlasmaOverBlood.data.tPOB(end)],[1 1],'--m')
        plot(handles.axes_wres,[0 Blood.PlasmaOverBlood.data.tPOB(end)],[0 0],'--m')
        plot(handles.axes_wres,[0 Blood.PlasmaOverBlood.data.tPOB(end)],-[1 1],'--m')
        hold(handles.axes_wres,'off')
        handles.axes_wres.Visible = 'on';
        
        % text_results
        handles.text_results.String(1) = {['N data = ',num2str(length(Blood.PlasmaOverBlood.data.POB))]};
        handles.text_results.String(2) = {['N par = ',num2str(length(Blood.PlasmaOverBlood.fitted.par))]};
        handles.text_results.String(3) = {['WRSS = ',num2str(Blood.PlasmaOverBlood.fitted.WRSS)]};
        handles.text_results.String(4) = {['AIC = ',num2str(Blood.PlasmaOverBlood.fitted.AIC)]};
        
        % tests
        [h_ks, p_ks] = kstest(Blood.PlasmaOverBlood.fitted.wres);
        [h_ru, p_ru] = runstest(Blood.PlasmaOverBlood.fitted.wres);
        [h_tt, p_tt] = ttest(Blood.PlasmaOverBlood.fitted.wres);
        if h_ks
            handles.uipanel_ks.BackgroundColor = [1 0 0];
            handles.text_pks.BackgroundColor   = [1 0 0];
        else
            handles.uipanel_ks.BackgroundColor = [0 1 0];
            handles.text_pks.BackgroundColor   = [0 1 0];
        end
        handles.text_pks.String = {['p=', num2str(p_ks)]};
        
        if h_ru
            handles.uipanel_runs.BackgroundColor = [1 0 0];
            handles.text_pru.BackgroundColor     = [1 0 0];
        else
            handles.uipanel_runs.BackgroundColor = [0 1 0];
            handles.text_pru.BackgroundColor     = [0 1 0];
        end
        handles.text_pru.String = {['p=', num2str(p_ru)]};
        
        if h_tt
            handles.uipanel_ttest.BackgroundColor = [1 0 0];
            handles.text_ptt.BackgroundColor      = [1 0 0];
        else
            handles.uipanel_ttest.BackgroundColor = [0 1 0];
            handles.text_ptt.BackgroundColor      = [0 1 0];
        end
        handles.text_ptt.String = {['p=', num2str(p_tt)]};
        
        handles.uipanel_statsres.Visible = 'on';

end


% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Blood 
tPOB = Blood.WholeBlood.data(2).tCb;
POB  = POB_eval(Blood,tPOB);

Blood.TotalPlasma.data(2).tCtot = tPOB;
Blood.TotalPlasma.data(2).Ctot  = Blood.WholeBlood.data(2).Cb.*POB;
Blood.TotalPlasma.data(2).wCtot = Blood.WholeBlood.data(2).wCb./POB;
close(gcbf)
MultiBlood



