function varargout = METAlab_GTG_preprocess_GUI(varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: Beta 0.25 (05.07.14)
% 
% 
% History:
% 02.27.14 - Beta 0.13 - initial public release
% 03.11.14 - Beta 0.20 - 1) small bugfixes, 2) major overhaul of user 
%                        interface into GUIs
% 03.17.14 - Beta 0.21 - 1) small bugfixes
% 03.24.14 - Beta 0.22 - 1) lots of small bugfixes
% 04.08.14 - Beta 0.23 - small bugfixes
% 04.23.14 - Beta 0.24 - no changes to this stage
% 05.07.14 - Beta 0.25 - no changes to this stage
%
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights




% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @METAlab_GTG_preprocess_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @METAlab_GTG_preprocess_GUI_OutputFcn, ...
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
% End initialization code

function METAlab_GTG_preprocess_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = METAlab_GTG_preprocess_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function IDs_edit_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
global out;
temp     = get(hObject,'String');
out.subs = evalin('base',temp);
if size(out.subs,1) < size(out.subs,2)
    out.subs = out.subs';
end
if ismatrix(out.subs)
    out.subs = strtrim(cellstr(num2str(out.subs)));
end

function IDs_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function IDs_edit_ButtonDownFcn(hObject, eventdata, handles)
set(hObject, 'Enable', 'On');
uicontrol(handles.IDs_edit);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ROIlab_edit_Callback(hObject, eventdata, handles)
global out;
temp           = get(hObject,'String');
out.ROI_labels = evalin('base',temp);
out.nROI       = length(out.ROI_labels);

function ROIlab_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ROIlab_edit_ButtonDownFcn(hObject, eventdata, handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Outfile_edit_Callback(hObject, eventdata, handles)
global out;
out.outname = get(hObject,'String');

function Outfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Outfile_pushbutton_Callback(hObject, eventdata, handles) %#ok<*INUSL>
global out;
out.outname = [uigetdir(pwd,'Select the output directory'),'/'];
set(handles.Outfile_edit,'String',out.outname);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function nTP_edit_Callback(hObject, eventdata, handles)
global out;
out.nTP = str2double(get(hObject,'String'));

function nTP_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TR_edit_Callback(hObject, eventdata, handles)
global out;
out.TR = str2double(get(hObject,'String'));

function TR_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Saveintermed_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents = cellstr(get(hObject,'String'));
out.saveintermed = contents{get(hObject,'Value')};

function Saveintermed_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Funcfile_edit_Callback(hObject, eventdata, handles)
global out;
out.func_first_filename = get(hObject,'String');

function Funcfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Funcfile_pushbutton_Callback(hObject, eventdata, handles)
global out;
[file,path]             = uigetfile('*.nii.gz','Select the 4d EPI for the first participant');
out.func_first_filename = [path,file];
set(handles.Funcfile_edit,'String',out.func_first_filename);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Funcmaskfile_pushbutton_Callback(hObject, eventdata, handles)
global out;
[file,path]                 = uigetfile('*.nii.gz','Select the 3d functional brain mask (used to limit the voxels included) for the first participant');
out.first_funcmask_filename = [path,file];
set(handles.Funcmaskfile_edit,'String',out.first_funcmask_filename);

function Funcmaskfile_edit_Callback(hObject, eventdata, handles)
global out;
out.first_funcmask_filename = get(hObject,'String');

function Funcmaskfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ROImaskfile_edit_Callback(hObject, eventdata, handles)
global out;
out.first_parc_filename = get(hObject,'String');

function ROImaskfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ROImaskfile_pushbutton_Callback(hObject, eventdata, handles)
global out;
[file,path]             = uigetfile('*.nii.gz','Select the 3d image containing ROI masks for the first participant');
out.first_parc_filename = [path,file];
set(handles.ROImaskfile_edit,'String',out.first_parc_filename);

function ROImaskspace_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents       = cellstr(get(hObject,'String'));
out.parc_space = contents{get(hObject,'Value')};

function ROImaskspace_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function WMmaskfile_edit_Callback(hObject, eventdata, handles)
global out;
out.first_WM_filename = get(hObject,'String');

function WMmaskfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function WMmaskfile_pushbutton_Callback(hObject, eventdata, handles)
global out;
[file,path]           = uigetfile('*.nii.gz','Select the white matter mask for the first participant');
out.first_WM_filename = [path,file];
set(handles.WMmaskfile_edit,'String',out.first_WM_filename);

function WMmaskspace_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents     = cellstr(get(hObject,'String'));
out.WM_space = contents{get(hObject,'Value')};

function WMmaskspace_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ventmaskfile_edit_Callback(hObject, eventdata, handles)
global out;
out.first_vent_filename = get(hObject,'String');

function Ventmaskfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Ventmaskfile_pushbutton_Callback(hObject, eventdata, handles)
global out;
[file,path]             = uigetfile('*.nii.gz','Select the ventricular mask for the first participant');
out.first_vent_filename = [path,file];
set(handles.Ventmaskfile_edit,'String',out.first_vent_filename);

function Ventmaskspace_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents       = cellstr(get(hObject,'String'));
out.vent_space = contents{get(hObject,'Value')};

function Ventmaskspace_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ST_checkbox_Callback(hObject, eventdata, handles)
global out;
out.ST_correct = get(hObject,'Value');

if out.ST_correct     == 1
    set(handles.STord_popupmenu,'enable','on');
elseif out.ST_correct == 0
    set(handles.STord_popupmenu,'enable','off');
end

function STord_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents   = cellstr(get(hObject,'String'));
out.ST_ord = contents{get(hObject,'Value')};

function STord_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Detr_checkbox_Callback(hObject, eventdata, handles)
global out;
out.detr = get(hObject,'Value');

if out.detr     == 1
    set(handles.Detrord_popupmenu,'enable','on');
elseif out.detr == 0
    set(handles.Detrord_popupmenu,'enable','off');
end

function Detrord_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents     = cellstr(get(hObject,'String'));
out.detr_ord = str2double(contents{get(hObject,'Value')});

function Detrord_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function BP_checkbox_Callback(hObject, eventdata, handles)
global out;
out.BP = get(hObject,'Value');

if out.BP     == 1
    set(handles.BPtype_popupmenu,'enable','on');
    set(handles.BP_HP_edit,'enable','on');
    set(handles.BP_LP_edit,'enable','on');
elseif out.BP == 0
    set(handles.BPtype_popupmenu,'enable','off');
    set(handles.BP_HP_edit,'enable','off');
    set(handles.BP_LP_edit,'enable','off');
end

function BPtype_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents    = cellstr(get(hObject,'String'));
out.BP_type = contents{get(hObject,'Value')};

if strcmp(out.BP_type,'Butterworth')
    set(handles.BP_buttord_popupmenu,'enable','on');
elseif ~strcmp(out.BP_type,'Butterworth')
    set(handles.BP_buttord_popupmenu,'enable','off');
end

function BPtype_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_HP_edit_Callback(hObject, eventdata, handles)
global out;
out.BP_HP_cutoff = str2double(get(hObject,'String'));

function BP_HP_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_LP_edit_Callback(hObject, eventdata, handles)
global out;
out.BP_LP_cutoff = str2double(get(hObject,'String'));

function BP_LP_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BP_buttord_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents    = cellstr(get(hObject,'String'));
out.butter_ord = contents{get(hObject,'Value')};

function BP_buttord_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MC_checkbox_Callback(hObject, eventdata, handles)
global out;
out.MC = get(hObject,'Value');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Motcens_checkbox_Callback(hObject, eventdata, handles)
global out;
out.motcens = get(hObject,'Value');

if out.motcens     == 1
    set(handles.Motcens_FD_edit,'enable','on');
    set(handles.Motcens_DVARS_edit,'enable','on');
elseif out.motcens == 0
    set(handles.Motcens_FD_edit,'enable','off');
    set(handles.Motcens_DVARS_edit,'enable','off');
end

function Motcens_FD_edit_Callback(hObject, eventdata, handles)
global out;
out.motcens_FD_cutoff = str2double(get(hObject,'String'));

function Motcens_FD_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Motcens_DVARS_edit_Callback(hObject, eventdata, handles)
global out;
out.motcens_DVARS_cutoff = str2double(get(hObject,'String'));

function Motcens_DVARS_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Motparpart_checkbox_Callback(hObject, eventdata, handles)
global out;
out.motpar_part = get(hObject,'Value');

if out.motpar_part     == 1
    set(handles.Motparpart_t1_checkbox,'enable','on');
    set(handles.Motparpart_sqr_checkbox,'enable','on');
    set(handles.Motparpart_deriv_checkbox,'enable','on');
elseif out.motpar_part == 0
    set(handles.Motparpart_t1_checkbox,'enable','off');
    set(handles.Motparpart_sqr_checkbox,'enable','off');
    set(handles.Motparpart_deriv_checkbox,'enable','off');
end

function Motparpart_t1_checkbox_Callback(hObject, eventdata, handles)
global out;
out.motpart1_part    = get(hObject,'Value');

function Motparpart_sqr_checkbox_Callback(hObject, eventdata, handles)
global out;
out.motparsqr_part   = get(hObject,'Value');

function Motparpart_deriv_checkbox_Callback(hObject, eventdata, handles)
global out;
out.motparderiv_part = get(hObject,'Value');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Globpart_checkbox_Callback(hObject, eventdata, handles)
global out;
out.globsig_part = get(hObject,'Value');

if out.globsig_part     == 1
    set(handles.Globpart_deriv_checkbox,'enable','on');
    set(handles.Globpart_GNI_checkbox,'enable','on');
    set(handles.Globpart_GCOR_checkbox,'enable','on');
elseif out.globsig_part == 0
    set(handles.Globpart_deriv_checkbox,'enable','off');
    set(handles.Globpart_GNI_checkbox,'enable','off');
    set(handles.Globpart_GCOR_checkbox,'enable','off');
end

function Globpart_deriv_checkbox_Callback(hObject, eventdata, handles)
global out;
out.globsigderiv_part = get(hObject,'Value');

function Globpart_GNI_checkbox_Callback(hObject, eventdata, handles)
global out;
out.globsig_calcGNI = get(hObject,'Value');

function Globpart_GCOR_checkbox_Callback(hObject, eventdata, handles)
global out;
out.globsig_calcGCOR = get(hObject,'Value');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function WMpart_checkbox_Callback(hObject, eventdata, handles)
global out;
out.WMsig_part = get(hObject,'Value');

if out.WMsig_part == 1
    set(handles.WMpart_scope_popupmenu,'enable','on');
    set(handles.WMpart_deriv_checkbox,'enable','on');
    set(handles.WMmaskfile_edit,'enable','on');
    set(handles.WMmaskfile_pushbutton,'enable','on');
    set(handles.WMmaskspace_popupmenu,'enable','on');
elseif out.WMsig_part == 0
    set(handles.WMpart_scope_popupmenu,'enable','off');
    set(handles.WMpart_deriv_checkbox,'enable','off');
    set(handles.WMmaskfile_edit,'enable','off');
    set(handles.WMmaskfile_pushbutton,'enable','off');
    set(handles.WMmaskspace_popupmenu,'enable','off');
end

function WMpart_scope_popupmenu_Callback(hObject, eventdata, handles)
global out;
contents         = cellstr(get(hObject,'String'));
out.WMmask_scope = contents{get(hObject,'Value')};

function WMpart_scope_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function WMpart_deriv_checkbox_Callback(hObject, eventdata, handles)
global out;
out.WMsigderiv_part = get(hObject,'Value');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ventpart_checkbox_Callback(hObject, eventdata, handles)
global out;
out.ventsig_part = get(hObject,'Value');

if out.ventsig_part == 1
    set(handles.Ventpart_deriv_checkbox,'enable','on');
    set(handles.Ventmaskfile_edit,'enable','on');
    set(handles.Ventmaskfile_pushbutton,'enable','on');
    set(handles.Ventmaskspace_popupmenu,'enable','on');
elseif out.ventsig_part == 0
    set(handles.Ventpart_deriv_checkbox,'enable','off');
    set(handles.Ventmaskfile_edit,'enable','off');
    set(handles.Ventmaskfile_pushbutton,'enable','off');
    set(handles.Ventmaskspace_popupmenu,'enable','off');
end

function Ventpart_deriv_checkbox_Callback(hObject, eventdata, handles)
global out;
out.ventsigderiv_part = get(hObject,'Value');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_pushbutton_Callback(hObject, eventdata, handles)
global out;

% Check whether inputs have been specified
if ~isfield(out,'subs')
    msgbox('Enter a cell array of participant IDs','Error','error')
    return
end
if ~isfield(out,'ROI_labels')
    msgbox('Enter a cell array of ROI labels','Error','error')
    return
end
if ~isfield(out,'outname')
    msgbox('Enter an output name','Error','error')
    return
end
if ~isfield(out,'nTP')
    out.nTP = 120;
end
if ~isfield(out,'TR')
    out.TR = 2;
end
if ~isfield(out,'func_first_filename')
    msgbox('Enter the 4d EPI filename for the first participant','Error','error')
    return
end
if ~isfield(out,'first_funcmask_filename')
    msgbox('Enter the 3d brainmask filename for the first participant','Error','error')
    return
end
if ~isfield(out,'first_parc_filename')
    msgbox('Enter the filename for the 3d image containing ROI masks for the first participant','Error','error')
    return
end
if ~isfield(out,'parc_space')
    out.parc_space = 'Functional';
end
if ~isfield(out,'saveintermed')
    out.saveintermed = 'No';
end
if ~isfield(out,'ST_correct')
    out.ST_correct = 0;
end
if out.ST_correct == 1 && ~isfield(out,'ST_ord')
    msgbox('Please select the slice aquisition order','Error','error')
    return
end
if ~isfield(out,'detr')
    out.detr = 0;
end
if out.detr == 1 && ~isfield(out,'detr_ord')
    out.detr_ord = 0;
end
if ~isfield(out,'BP')
    out.BP = 0;
end
if out.BP == 1 && ~isfield(out,'BP_type')
    msgbox('Please select the bandpass filter type','Error','error')
    return
end
if ~isfield(out,'BP_LP_cutoff')
    out.BP_LP_cutoff = 0.10;
end
if ~isfield(out,'BP_HP_cutoff')
    out.BP_HP_cutoff = 0.01;
end
if isfield(out,'BP_type')
    if strcmp(out.BP_type,'Butterworth') && ~isfield(out,'butter_ord')
        out.butter_ord = 1;
    end
end
if ~isfield(out,'MC')
    out.MC = 0;
end
if ~isfield(out,'motcens')
    out.motcens = 0;
end
if ~isfield(out,'motcens_FD_cutoff')
    out.motcens_FD_cutoff = 0.3;
end
if ~isfield(out,'motcens_DVARS_cutoff')
    out.motcens_DVARS_cutoff = 2.5;
end
if ~isfield(out,'motpar_part')
    out.motpar_part = 0;
end
if ~isfield(out,'motpart1_part')
    out.motpart1_part = 0;
end
if ~isfield(out,'motparsqr_part')
    out.motparsqr_part = 0;
end
if ~isfield(out,'motparderiv_part')
    out.motparderiv_part = 0;
end
if ~isfield(out,'globsig_part')
    out.globsig_part = 0;
end
if ~isfield(out,'globsigderiv_part')
    out.globsigderiv_part = 0;
end
if ~isfield(out,'globsig_calcGCOR')
    out.globsig_calcGCOR = 0;
end
if ~isfield(out,'globsig_calcGNI')
    out.globsig_calcGNI = 0;
end
if ~isfield(out,'WMsig_part')
    out.WMsig_part = 0;
end
if ~isfield(out,'WMsigderiv_part')
    out.WMsigderiv_part = 0;
end
if out.WMsig_part == 1 && ~isfield(out,'first_WM_filename')
    msgbox('Enter the filename for the white matter mask for the first participant','Error','error')
    return
end
if ~isfield(out,'WM_space')
    out.WM_space = 'Functional';
end
if ~isfield(out,'WMmask_scope')
    out.WMmask_scope = 'Entire Mask';
end
if ~isfield(out,'ventsig_part')
    out.ventsig_part = 0;
end
if ~isfield(out,'ventsigderiv_part')
    out.ventsigderiv_part = 0;
end
if out.ventsig_part == 1 && ~isfield(out,'first_vent_filename')
    msgbox('Enter the filename for the ventricular mask for the first participant','Error','error')
    return
end
if ~isfield(out,'vent_space')
    out.vent_space = 'Functional';
end

set(handles.Start_pushbutton,'enable','off');

if out.MC == 0 && out.motpar_part == 1
    par_base_filename = strrep(out.func_first_filename,'.nii.gz','.par');
    if ~exist(par_base_filename,'file')
        [file,path]       = uigetfile('*.par','Select the .par file (containing motion correction parameters) for the first participant');
        par_base_filename = [path,file];
    end
    par_base_filename = strrep(par_base_filename,out.subs{1},'SUBNUM');
end

% Set base filenames
func_base_filename     = strrep(out.func_first_filename,out.subs{1},'SUBNUM');
funcmask_base_filename = strrep(out.first_funcmask_filename,out.subs{1},'SUBNUM');
parc_base_filename     = strrep(out.first_parc_filename,out.subs{1},'SUBNUM');
if isfield(out,'first_WM_filename')
    WM_base_filename   = strrep(out.first_WM_filename,out.subs{1},'SUBNUM');
end
if isfield(out,'first_vent_filename')
    vent_base_filename = strrep(out.first_vent_filename,out.subs{1},'SUBNUM');
end

if strcmp(out.parc_space,'Structural') || strcmp(out.WM_space,'Structural') || strcmp(out.vent_space,'Structural')
    [file,path]                          = uigetfile('*.mat','Select the structural-to-functional transformation matrix for the first participant');
    filename                             = [path,file];
    struct2func_regmat_base_filename = strrep(filename,out.subs{1},'SUBNUM');
else
    struct2func_regmat_base_filename = ' ';
end

if strcmp(out.parc_space,'Standard') || strcmp(out.WM_space,'Standard') || strcmp(out.vent_space,'Standard')
    [path,file]                            = uigetfile('*.nii.gz','Select the standard-to-functional warp file for the first participant');
    filename                               = [path,file];
    standard2func_regmat_base_filename = strrep(filename,out.subs{1},'SUBNUM');
else
    standard2func_regmat_base_filename = ' ';
end

toolboxes = ver;
use_parfor = any(strcmpi({toolboxes.Name},'Parallel Computing Toolbox'));
if use_parfor
    try
        if parpool('size') == 0
            num_par_workers = str2double(inputdlg(sprintf('The Parallel Computing Toolbox was found on your system.\n\nEnter the number of workers you want to use (enter 1 to not use the PCT).\n\nNote: this must be <= the number of cores'),'PCT Workers',2));
            if num_par_workers > 12
                num_par_workers = 12;
            end
            if num_par_workers > feature('numCores')
                num_par_workers = feature('numCores');
            end
            if num_par_workers > 1
                parpool('open',num_par_workers);
            else
                use_parfor = false;
            end
        end
    catch
        if matlabpool('size') == 0 %#ok<*DPOOL>
            num_par_workers = str2double(inputdlg(sprintf('The Parallel Computing Toolbox was found on your system.\n\nEnter the number of workers you want to use (enter 1 to not use the PCT).\n\nNote: this must be <= the number of cores'),'PCT Workers',2));
            if num_par_workers > 12
                num_par_workers = 12;
            end
            if num_par_workers > feature('numCores')
                num_par_workers = feature('numCores');
            end
            if num_par_workers > 1
                matlabpool('open',num_par_workers);
            else
                use_parfor = false;
            end
        end
    end
end

preproc_outname = [out.outname '_preprocessed_timeseries'];

% Write non-participant specific info to logfile
preproc_logfile_outname = [out.outname '_preproc_logfile.txt'];
logfile_fid = fopen(preproc_logfile_outname,'w');
fprintf(logfile_fid,'Output filename = %s\n',preproc_outname);
fprintf(logfile_fid,'# of ROIs = %u\n',out.nROI);
fprintf(logfile_fid,'# of timepoints = %u\n',out.nTP);
fprintf(logfile_fid,'(User specified) TR = %u\n',out.TR);
if out.ST_correct == 1
    fprintf(logfile_fid,'Slicetiming correction was performed with %s (user specified) slice order\n',out.ST_ord);
end
if out.MC == 1
    fprintf(logfile_fid,'Motion correction was performed\n');
end
if out.detr == 1
    fprintf(logfile_fid,'The data were detrended for up to polynomials of order %u\n',out.detr_ord);
end
if out.BP == 1 && strcmp(out.BP_type,'Ideal')
    fprintf(logfile_fid,'The data were bandpass filtered with the "Ideal" filter (lowpass cutoff = %6.4f, highpass cutoff = %6.4f)\n',out.BP_LP_cutoff,out.BP_HP_cutoff);
elseif out.BP == 1 && strcmp(out.BP_type,'Butterworth')
    fprintf(logfile_fid,'The data were bandpass filtered with a Butterworth filter of order %u (lowpass cutoff = %6.4f, highpass cutoff = %6.4f)\n',out.BP_butterord,out.BP_HP_cutoff,out.BP_LP_cutoff);
elseif out.BP == 1 && strcmp(out.BP_type,'FSL')
    fprintf(logfile_fid,'The data were bandpass filtered with FSL''s non-linear highpass and Gaussian linear lowpass filter (lowpass cutoff = %6.4f, highpass cutoff = %6.4f)\n',out.BP_LP_cutoff,out.BP_HP_cutoff);
end
if out.motcens == 1
    fprintf(logfile_fid,'Motion-censoring was performed with FD cutoff = %5.3fmm and DVARS cutoff = %6.3f\n',out.motcens_FD_cutoff,out.motcens_DVARS_cutoff);
end
fprintf(logfile_fid,'\nBase filenames:\n');
fprintf(logfile_fid,'Base filename for functional data = %s\n',func_base_filename);
fprintf(logfile_fid,'Base filename for functional mask = %s\n',funcmask_base_filename);
fprintf(logfile_fid,'Base filename for ROI mask = %s, which was input in %s space\n',parc_base_filename,out.parc_space);
if out.WMsig_part == 1
    fprintf(logfile_fid,'Base filename for white matter mask = %s, which was input in %s space\n',WM_base_filename,out.WM_space);
end
if out.ventsig_part == 1
    fprintf(logfile_fid,'Base filename for ventricle mask = %s, which was input in %s space\n',vent_base_filename,out.vent_space);
end
if strcmp(out.parc_space,'Structural') || strcmp(out.WM_space,'Structural') || strcmp(out.vent_space,'Structural')
    fprintf(logfile_fid,'Base filename for structural to functional warp = %s\n',struct2func_regmat_base_filename);
end
if strcmp(out.parc_space,'Standard') || strcmp(out.WM_space,'Standard') || strcmp(out.vent_space,'Standard')
    fprintf(logfile_fid,'Base filename for standard space to functional warp = %s\n',standard2func_regmat_base_filename);
end
fprintf(logfile_fid,'\nData partialing:\n');
if out.motpar_part == 1
    fprintf(logfile_fid,'Motion paramaters were partialed from the timeseries data\n');
    if out.motpart1_part == 1
        fprintf(logfile_fid,'The t - 1 motion paramaters were partialed from the timeseries data\n');
    end
    if out.motparderiv_part == 1
        fprintf(logfile_fid,'The 1st derivatives of the motion paramaters were partialed from the timeseries data\n');
    end
    if out.motparsqr_part == 1
        fprintf(logfile_fid,'The squares of the motion paramaters were partialed from the timeseries data\n');
    end
end
if out.globsig_part == 1 && out.globsig_calcGNI == 0
    fprintf(logfile_fid,'Global signal was partialed from the timeseries data for all participants\n');
    if out.globsigderiv_part == 1
        fprintf(logfile_fid,'The 1st derivative of the global signal was partialed from the timeseries data\n');
    end
elseif out.globsig_part == 1 && out.globsig_calcGNI == 1
    fprintf(logfile_fid,'Global signal was partialed from the timeseries data for participants with GNI < 3\n');
    if out.globsigderiv_part == 1
        fprintf(logfile_fid,'The 1st derivative of the global signal was partialed from the timeseries data for participants with GNI < 3\n');
    end
end
if out.WMsig_part == 1 && strcmp(out.WMmask_scope,'Entire Mask')
    fprintf(logfile_fid,'White matter signal (from entire WM mask) was partialed from the timeseries data\n');
elseif out.WMsig_part == 1 && strcmp(out.WMmask_scope,'Local mask')
    fprintf(logfile_fid,'White matter signal (from WM within a ~45mm radius sphere around each voxel) was partialed from the timeseries data\n');
end
if out.WMsig_part == 1 && out.WMsigderiv_part == 1
    fprintf(logfile_fid,'The 1st derivative of the white matter signal was partialed from the timeseries data\n');
end
if out.ventsig_part == 1
    fprintf(logfile_fid,'Ventricular signal was partialed from the timeseries data\n');
    if out.ventsigderiv_part == 1
        fprintf(logfile_fid,'The 1st derivative of the ventricular signal was partialed from the timeseries data\n');
    end
end
fprintf(logfile_fid,'\nParticipant specific information:\n');

if use_parfor
    subs = out.subs;
    MC = out.MC;
    motpar_part = out.motpar_part;
    parc_space = out.parc_space;
    WM_space = out.WM_space;
    vent_space = out.vent_space;
    loc_out = out;
    
    parfor currsub = 1:length(subs)
        sub = subs{currsub};
        
        func_filename          = strrep(func_base_filename,'SUBNUM',sub);
        parc_filename          = strrep(parc_base_filename,'SUBNUM',sub);
        funcmask_filename      = strrep(funcmask_base_filename,'SUBNUM',sub);
        if exist('WM_base_filename','var')
            WM_filename        = strrep(WM_base_filename,'SUBNUM',sub);
        else
            WM_filename        = ' ';
        end
        if exist('vent_base_filename','var')
            vent_filename      = strrep(vent_base_filename,'SUBNUM',sub);
        else
            vent_filename      = ' ';
        end
        
        if MC == 0 && motpar_part == 1
            par_filename       = strrep(par_base_filename,'SUBNUM',sub);
        else
            par_filename       = ' ';
        end
        if strcmp(parc_space,'Structural')
            parc_warp_filename = strrep(struct2func_regmat_base_filename,'SUBNUM',sub);
        elseif strcmp(parc_space,'Standard')
            parc_warp_filename = strrep(standard2func_regmat_base_filename,'SUBNUM',sub);
        else
            parc_warp_filename = ' ';
        end
        if strcmp(WM_space,'Structural')
            WM_warp_filename   = strrep(struct2func_regmat_base_filename,'SUBNUM',sub);
        elseif strcmp(WM_space,'Standard')
            WM_warp_filename   = strrep(standard2func_regmat_base_filename,'SUBNUM',sub);
        else
            WM_warp_filename   = ' ';
        end
        if strcmp(vent_space,'Structural')
            vent_warp_filename = strrep(struct2func_regmat_base_filename,'SUBNUM',sub);
        elseif strcmp(vent_space,'Standard')
            vent_warp_filename = strrep(standard2func_regmat_base_filename,'SUBNUM',sub);
        else
            vent_warp_filename = ' ';
        end
        
        if exist(func_filename,'file') && exist(parc_filename,'file') && exist(funcmask_filename,'file')
            [ts{currsub,1},num_censored_vols(currsub,1),num_censored_vols_FD(currsub,1),num_censored_vols_DVARS(currsub,1),GCOR(currsub,1),mean_FD(currsub,1),mean_DVARS(currsub,1)] = preprocess_for_graph(loc_out,sub,logfile_fid,func_filename,parc_filename,funcmask_filename,WM_filename,vent_filename,parc_warp_filename,WM_warp_filename,vent_warp_filename,par_filename); %#ok<*PFOUS>
        else
            fprintf(logfile_fid,'Missing files for %s\n',sub);
            ts{currsub,1}                      = NaN;
            num_censored_vols(currsub,1)       = NaN;
            num_censored_vols_FD(currsub,1)    = NaN;
            num_censored_vols_DVARS(currsub,1) = NaN;
            GCOR(currsub,1)                    = NaN;
            mean_FD(currsub,1)                 = NaN;
            mean_DVARS(currsub,1)              = NaN;
        end
    end
    out.ts;
    out.num_censored_vols;
    out.num_censored_vols_FD;
    out.num_censored_vols_DVARS;
    out.GCOR;
    out.mean_FD;
    out.mean_DVARS;
else
    progressbar('Total Progress')
    
    for currsub = length(out.subs):-1:1
        sub = out.subs{currsub};
        func_filename          = strrep(func_base_filename,'SUBNUM',sub);
        parc_filename          = strrep(parc_base_filename,'SUBNUM',sub);
        funcmask_filename      = strrep(funcmask_base_filename,'SUBNUM',sub);
        if exist('WM_base_filename','var')
            WM_filename        = strrep(WM_base_filename,'SUBNUM',sub);
        else
            WM_filename        = ' ';
        end
        if exist('vent_base_filename','var')
            vent_filename      = strrep(vent_base_filename,'SUBNUM',sub);
        else
            vent_filename      = ' ';
        end
        
        if out.MC == 0 && out.motpar_part == 1
            par_filename       = strrep(par_base_filename,'SUBNUM',sub);
        else
            par_filename       = ' ';
        end
        if strcmp(out.parc_space,'Structural')
            parc_warp_filename = strrep(struct2func_regmat_base_filename,'SUBNUM',sub);
        elseif strcmp(out.parc_space,'Standard')
            parc_warp_filename = strrep(standard2func_regmat_base_filename,'SUBNUM',sub);
        else
            parc_warp_filename = ' ';
        end
        if strcmp(out.WM_space,'Structural')
            WM_warp_filename   = strrep(struct2func_regmat_base_filename,'SUBNUM',sub);
        elseif strcmp(out.WM_space,'Standard')
            WM_warp_filename   = strrep(standard2func_regmat_base_filename,'SUBNUM',sub);
        else
            WM_warp_filename   = ' ';
        end
        if strcmp(out.vent_space,'Structural')
            vent_warp_filename = strrep(struct2func_regmat_base_filename,'SUBNUM',sub);
        elseif strcmp(out.vent_space,'Standard')
            vent_warp_filename = strrep(standard2func_regmat_base_filename,'SUBNUM',sub);
        else
            vent_warp_filename = ' ';
        end
        
        if exist(func_filename,'file') && exist(parc_filename,'file') && exist(funcmask_filename,'file')
            [out.ts{currsub,1},out.num_censored_vols(currsub,1),out.num_censored_vols_FD(currsub,1),out.num_censored_vols_DVARS(currsub,1),out.GCOR(currsub,1),out.mean_FD(currsub,1),out.mean_DVARS(currsub,1)] = preprocess_for_graph(out,sub,logfile_fid,func_filename,parc_filename,funcmask_filename,WM_filename,vent_filename,parc_warp_filename,WM_warp_filename,vent_warp_filename,par_filename);
        else
            fprintf(logfile_fid,'Missing files for %s\n',sub);
            out.ts{currsub,1}                      = NaN;
            out.num_censored_vols(currsub,1)       = NaN;
            out.num_censored_vols_FD(currsub,1)    = NaN;
            out.num_censored_vols_DVARS(currsub,1) = NaN;
            out.GCOR(currsub,1)                    = NaN;
            out.mean_FD(currsub,1)                 = NaN;
            out.mean_DVARS(currsub,1)              = NaN;
        end
        
        prog = 1-((currsub-1)/length(out.subs));
        progressbar(prog)
    end
end

if use_parfor
    try
        parpool close
    catch
        matlabpool close
    end
end

fclose(logfile_fid);
out_data = out; %#ok<*NASGU>
save(out.outname,'out_data');
set(handles.Start_pushbutton,'enable','on');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Conduct preprocessing for a participant
function [ts,num_censored_vols,num_censored_vols_FD,num_censored_vols_DVARS,GCOR,mean_FD,mean_DVARS] = preprocess_for_graph(subfunc_out,sub,logfile_fid,orig_func_filename,parc_filename,funcmask_filename,WM_filename,vent_filename,parc_warp_filename,WM_warp_filename,vent_warp_filename,par_filename)

if subfunc_out.BP == 1
    if strcmp(subfunc_out.BP_type,'Butterworth')
        [butter_zeds,butter_poles,butter_gain] = butter(subfunc_out.butter_ord,[subfunc_out.BP_HP_cutoff,subfunc_out.BP_LP_cutoff]/(subfunc_out.TR/2),'bandpass');
        [butter_sos,butter_gain] = zp2sos(butter_zeds,butter_poles,butter_gain);
        butter_filt = dfilt.df2sos(butter_sos,butter_gain);
    elseif strcmp(subfunc_out.BP_type,'Ideal')
        filt_ind = calc_IdealFilter(subfunc_out.nTP,subfunc_out.TR,subfunc_out.BP_HP_cutoff,subfunc_out.BP_LP_cutoff);
    elseif strcmp(subfunc_out.BP_type,'FSL')
        HP_sigma = (1./subfunc_out.BP_HP_cutoff)./subfunc_out.TR;
        LP_sigma = (1./subfunc_out.BP_LP_cutoff)./subfunc_out.TR;
    end
end

if subfunc_out.ST_correct == 1
    switch subfunc_out.ST_ord
        case 'Sequential up'
            slice_order = '';
        case 'Sequential down'
            slice_order = '--down';
        case 'Interleaved'
            slice_order = '--odd';
    end
    eval(['!slicetimer -i ',orig_func_filename(1:(end-7)),' -r ',num2str(subfunc_out.TR),' ',slice_order]);
    orig_func_filename = strrep(orig_func_filename,'.nii','_st.nii');
end

if subfunc_out.MC == 1
    eval(['!mcflirt -in ',orig_func_filename,' -plots']);
    orig_func_filename = strrep(orig_func_filename,'.nii','_mcf.nii');
    par_filename = strrep(orig_func_filename,'.nii.gz','.par');
end

func_filename = orig_func_filename;

if subfunc_out.detr == 1
    detrend_image(func_filename,funcmask_filename,subfunc_out.detr_ord);
    func_filename = [func_filename(1:(strfind(func_filename,'.nii.gz')-1)),'_detr',num2str(subfunc_out.detr_ord),'.nii.gz'];
end

if ~strcmp(subfunc_out.parc_space,'Functional')
    out_parc_filename = strrep(parc_filename,'.nii.gz','_warp2func.nii.gz');
    if any(strfind(parc_warp_filename,'.mat'))
        eval(['!flirt -interp nearestneighbour -in ',parc_filename,' -ref ',funcmask_filename,' -out ',out_parc_filename,' -init ',parc_warp_filename,' -applyxfm']);
    elseif any(strfind(parc_warp_filename,'.nii.gz'))
        eval(['!applywarp --ref=',funcmask_filename,' --in=',parc_filename,' --warp=',parc_warp_filename,' --out=',out_parc_filename,' --interp=nn']);
    end
    parc_filename = out_parc_filename;
end

if ~strcmp(subfunc_out.WM_space,'Functional')
    out_WM_filename = strrep(WM_filename,'.nii.gz','_warp2func.nii.gz');
    if any(strfind(WM_warp_filename,'.mat'))
        eval(['!flirt -interp nearestneighbour -in ',WM_filename,' -ref ',funcmask_filename,' -out ',out_WM_filename,' -init ',WM_warp_filename,' -applyxfm']);
    elseif any(strfind(vent_warp_filename,'.nii.gz'))
        eval(['!applywarp --ref=',funcmask_filename,' --in=',WM_filename,' --warp=',WM_warp_filename,' --out=',out_WM_filename,' --interp=nn']);
    end
    WM_filename = out_WM_filename;
end

if ~strcmp(subfunc_out.vent_space,'Functional')
    out_vent_filename = strrep(vent_filename,'.nii.gz','_warp2func.nii.gz');
    if any(strfind(vent_warp_filename,'.mat'))
        eval(['!flirt -interp nearestneighbour -in ',vent_filename,' -ref ',funcmask_filename,' -out ',out_vent_filename,' -init ',vent_warp_filename,' -applyxfm']);
    elseif any(strfind(vent_warp_filename,'.nii.gz'))
        eval(['!applywarp --ref=',funcmask_filename,' --in=',vent_filename,' --warp=',vent_warp_filename,' --out=',out_vent_filename,' --interp=nn']);
    end
    vent_filename = out_vent_filename;
end

desmat = [];

if subfunc_out.WMsig_part == 1
    if strcmp(subfunc_out.WMmask_scope,'Entire Mask')
        WM_extract_filename = strrep(WM_filename,'.nii.gz','.txt');
        eval(['!fslmeants -i ',func_filename,' -o ',WM_extract_filename,' -m ',WM_filename]);
        WM_pred = dlmread(WM_extract_filename);
        WM_pred = spm_detrend(WM_pred,subfunc_out.detr_ord);
        desmat = [desmat,WM_pred];
    else
        full_WM_mask = load_nii_gz(WM_filename);
        WM_fmask_inds = find(full_WM_mask.img == 1);
        WM_rad = round(45/mean(full_WM_mask.hdr.dime.pixdim(2:4)));
        WM_fmask_dims = size(full_WM_mask.img);
        clear full_WM_mask
        [vx,vy,vz] = meshgrid(-WM_rad:WM_rad);
        V = sqrt((vx.^2)+(vy.^2)+(vz.^2));
        V(V <= WM_rad) = 1;
        V(V > WM_rad) = 0;
        [WM_sp_x,WM_sp_y,WM_sp_z] = ind2sub(size(V),find(V == 1));
        WM_sp_x = WM_sp_x - WM_rad - 1;
        WM_sp_y = WM_sp_y - WM_rad - 1;
        WM_sp_z = WM_sp_z - WM_rad - 1;
    end
    
    if subfunc_out.WMsigderiv_part == 1 && strcmp(subfunc_out.WMmask_scope,'Entire Mask')
        WM1stderiv_pred = WM_pred(3:end) - WM_pred(1:(end-2));
        WM1stderiv_pred = [WM1stderiv_pred(1);WM1stderiv_pred;WM1stderiv_pred(end)];
        WM1stderiv_pred = spm_detrend(WM1stderiv_pred,subfunc_out.detr_ord);
        desmat = [desmat,WM1stderiv_pred];
    end
end

if subfunc_out.ventsig_part == 1
    vent_extract_filename = strrep(vent_filename,'.nii.gz','.txt');
    eval(['!fslmeants -i ',func_filename,' -o ',vent_extract_filename,' -m ',vent_filename]);
    vent_pred = dlmread(vent_extract_filename);
    vent_pred = spm_detrend(vent_pred,subfunc_out.detr_ord);
    desmat = [desmat,vent_pred];
    
    if subfunc_out.ventsigderiv_part == 1
        vent1stderiv_pred = vent_pred(3:end) - vent_pred(1:(end-2));
        vent1stderiv_pred = [vent1stderiv_pred(1);vent1stderiv_pred;vent1stderiv_pred(end)];
        vent1stderiv_pred = spm_detrend(vent1stderiv_pred,subfunc_out.detr_ord);
        desmat = [desmat,vent1stderiv_pred];
    end
end

if subfunc_out.globsig_part == 1
    if subfunc_out.globsig_calcGNI == 1
        GNI = Rest2GNI_edit(func_filename,funcmask_filename,100);
        fprintf(logfile_fid,'Original GNI for %s = %6.3f\n',sub,GNI);
    else
        GNI = 0;
    end
    if GNI <= 3
        funcmask_extract_filename = strrep(funcmask_filename,'.nii.gz','.txt');
        eval(['!fslmeants -i ',func_filename,' -o ',funcmask_extract_filename,' -m ',funcmask_filename]);
        global_pred = dlmread(funcmask_extract_filename);
        global_pred = spm_detrend(global_pred,subfunc_out.detr_ord);
        desmat = [desmat,global_pred];
        if subfunc_out.globsigderiv_part == 1
            global1stderiv_pred = global_pred(3:end) - global_pred(1:(end-2));
            global1stderiv_pred = [global1stderiv_pred(1);global1stderiv_pred;global1stderiv_pred(end)];
            global1stderiv_pred = spm_detrend(global1stderiv_pred,subfunc_out.detr_ord);
            desmat = [desmat,global1stderiv_pred];
        end
    end
end

if subfunc_out.motpar_part == 1
    mot_pred = dlmread(par_filename);
    for par = 1:size(mot_pred,2)
        mot_pred(:,par) = spm_detrend(mot_pred(:,par),subfunc_out.detr_ord);
    end
    desmat = [desmat,mot_pred];
    if subfunc_out.motpart1_part == 1
        mot1back_pred = [mot_pred(2:end,:);mot_pred(end,:)];
        for par = 1:size(mot_pred,2)
            mot1back_pred(:,par) = spm_detrend(mot1back_pred(:,par),subfunc_out.detr_ord);
        end
        desmat = [desmat,mot1back_pred];
    end
    if subfunc_out.motparderiv_part == 1
        mot1stderiv_pred = mot_pred(3:end,:) - mot_pred(1:(end-2),:);
        mot1stderiv_pred = [mot1stderiv_pred(1,:);mot1stderiv_pred;mot1stderiv_pred(end,:)];
        for par = 1:size(mot_pred,2)
            mot1stderiv_pred(:,par) = spm_detrend(mot1stderiv_pred(:,par),subfunc_out.detr_ord);
        end
        desmat = [desmat,mot1stderiv_pred];
    end
    if subfunc_out.motparsqr_part == 1
        motsquare_pred = mot_pred.^2;
        for par = 1:size(mot_pred,2)
            motsquare_pred(:,par) = spm_detrend(motsquare_pred(:,par),subfunc_out.detr_ord);
        end
        desmat = [desmat,motsquare_pred];
        if subfunc_out.motpart1_part == 1
            mot1backsquare_pred = mot1back_pred.^2;
            for par = 1:size(mot_pred,2)
                mot1backsquare_pred(:,par) = spm_detrend(mot1backsquare_pred(:,par),subfunc_out.detr_ord);
            end
            desmat = [desmat,mot1backsquare_pred];
        end
    end
end

func_data = load_nii_gz(func_filename);
funcmask = load_nii_gz(funcmask_filename);
func_data.img = double(func_data.img);
funcmask.img = double(funcmask.img);

out_func_data.img = zeros(size(func_data.img));

if subfunc_out.BP == 1 && (subfunc_out.WMsig_part == 1 || subfunc_out.ventsig_part == 1 || (subfunc_out.globsig_part == 1 && GNI <= 3) || subfunc_out.motpar_part == 1)
    desmat = [ones(size(desmat,1),1),desmat];
    orig_desmat = desmat;
    if rank(desmat) ~= min(size(desmat))
        error(['Initial desmat to partial out unwanted variance for ',sub,' is not full rank']);
    end
    func_filename = strrep(func_filename,'.nii.gz','_remnuisance_bpfilt.nii.gz');
    Q = desmat*pinv(full(desmat));
    for x = 1:size(func_data.img,1)
        for y = 1:size(func_data.img,2)
            for z = 1:size(func_data.img,3)
                if funcmask.img(x,y,z) == 1
                    if strcmp(subfunc_out.WMmask_scope,'Local Mask')
                        curr_WM_sp_x = WM_sp_x + x;
                        curr_WM_sp_y = WM_sp_y + y;
                        curr_WM_sp_z = WM_sp_z + z;
                        inrangeinds = curr_WM_sp_x > 0 & curr_WM_sp_x <= size(func_data.img,1) & curr_WM_sp_y > 0 & curr_WM_sp_y <= size(func_data.img,2) & curr_WM_sp_z > 0 & curr_WM_sp_z <= size(func_data.img,3);
                        WM_sp_inds = sub2ind(WM_fmask_dims,curr_WM_sp_x(inrangeinds),curr_WM_sp_y(inrangeinds),curr_WM_sp_z(inrangeinds));
                        loc_WM_inds = intersect(WM_fmask_inds,WM_sp_inds);
                        if ~isempty(loc_WM_inds)
                            for tp = 1:size(func_data.img,4)
                                tp_func = func_data.img(:,:,:,tp);
                                loc_WM_pred(tp,1) = sum(tp_func(loc_WM_inds))/length(loc_WM_inds); %#ok<*AGROW>
                            end
                            loc_WM_pred = spm_detrend(loc_WM_pred,subfunc_out.detr_ord);
                            desmat = [orig_desmat,loc_WM_pred];
                            if subfunc_out.WMsigderiv_part == 1
                                loc_WM1stderiv_pred = loc_WM_pred(3:end) - loc_WM_pred(1:(end-2));
                                loc_WM1stderiv_pred = [loc_WM1stderiv_pred(1);loc_WM1stderiv_pred;loc_WM1stderiv_pred(end)];
                                loc_WM1stderiv_pred = spm_detrend(loc_WM1stderiv_pred,subfunc_out.detr_ord);
                                desmat = [desmat,loc_WM1stderiv_pred];
                            end
                        end
                        Q = desmat*pinv(full(desmat));
                    end
                    tempdata = squeeze(func_data.img(x,y,z,:))-(Q*squeeze(func_data.img(x,y,z,:)));
                    tempdata = tempdata-mean(tempdata);
                    
                    if exist('butter_filt','var')
                        tempdata_padded = [zeros(15,size(tempdata,2));tempdata;zeros(15,size(tempdata,2))];
                        temp_butter = filter(butter_filt,tempdata_padded);
                        temp_butter(end:-1:1) = filter(butter_filt,temp_butter(end:-1:1));
                        out_func_data.img(x,y,z,:) = temp_butter(16:(end-15));
                    elseif exist('filt_ind','var')
                        padlength = rest_nextpow2_one35(subfunc_out.nTP);
                        tempdata = [tempdata;zeros(padlength-subfunc_out.nTP,size(tempdata,2))];
                        freq = fft(tempdata);
                        freq(filt_ind,:) = 0;
                        tempdata = ifft(freq);
                        out_func_data.img(x,y,z,:) = tempdata(1:subfunc_out.nTP,:);
                    else
                        out_func_data.img(x,y,z,:) = tempdata;
                    end
                end
            end
        end
    end
    if exist('HP_sigma','var')
        out_func_data.hdr = func_data.hdr;
        out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
        out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
        out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
        out_func_data.hdr.dime.datatype = 64;
        out_func_data.hdr.dime.bitpix = 64;
        save_nii_gz(out_func_data,func_filename);
        eval(['!fslmaths ',func_filename,' -bptf ',HP_sigma,' ',LP_sigma,' ',func_filename]);
        out_func_data = load_nii_gz(func_filename);
    end
elseif subfunc_out.BP == 1
    func_filename = strrep(func_filename,'.nii.gz','_bpfilt.nii.gz');
    if exist('HP_sigma','var')
        out_func_data.img = func_data.img;
        out_func_data.hdr = func_data.hdr;
        out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
        out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
        out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
        out_func_data.hdr.dime.datatype = 64;
        out_func_data.hdr.dime.bitpix = 64;
        save_nii_gz(out_func_data,func_filename);
        eval(['!fslmaths ',func_filename,' -bptf ',HP_sigma,' ',LP_sigma,' ',func_filename]);
        out_func_data = load_nii_gz(func_filename);
    else
        for x = 1:size(func_data.img,1)
            for y = 1:size(func_data.img,2)
                for z = 1:size(func_data.img,3)
                    if funcmask.img(x,y,z) == 1
                        tempdata = squeeze(func_data.img(x,y,z,:));
                        tempdata = tempdata-mean(tempdata);
                        if exist('butter_filt','var')
                            tempdata_padded = [zeros(15,size(tempdata,2));tempdata;zeros(15,size(tempdata,2))];
                            temp_butter = filter(butter_filt,tempdata_padded);
                            temp_butter(end:-1:1) = filter(butter_filt,temp_butter(end:-1:1));
                            out_func_data.img(x,y,z,:) = temp_butter(16:(end-15));
                        else
                            padlength = rest_nextpow2_one35(subfunc_out.nTP);
                            tempdata = [tempdata;zeros(padlength-subfunc_out.nTP,size(tempdata,2))];
                            freq = fft(tempdata);
                            freq(filt_ind,:) = 0;
                            tempdata = ifft(freq);
                            out_func_data.img(x,y,z,:) = tempdata(1:subfunc_out.nTP,:);
                        end
                    end
                end
            end
        end
    end
elseif subfunc_out.WMsig_part == 1 || subfunc_out.ventsig_part == 1 || (subfunc_out.globsig_part == 1 && GNI <= 3) || subfunc_out.motpar_part == 1
    desmat = [ones(size(desmat,1),1),desmat];
    orig_desmat = desmat;
    if rank(desmat) ~= min(size(desmat))
        error(['Initial desmat to partial out unwanted variance for ' sub ' is not full rank']);
    end
    func_filename = strrep(func_filename,'.nii.gz','_remnuisance.nii.gz');
    Q = desmat*pinv(full(desmat));
    for x = 1:size(func_data.img,1)
        for y = 1:size(func_data.img,2)
            for z = 1:size(func_data.img,3)
                if funcmask.img(x,y,z) == 1
                    if strcmp(subfunc_out.WMmask_scope,'Local Mask')
                        curr_WM_sp_x = WM_sp_x + x;
                        curr_WM_sp_y = WM_sp_y + y;
                        curr_WM_sp_z = WM_sp_z + z;
                        inrangeinds = curr_WM_sp_x > 0 & curr_WM_sp_x <= size(func_data.img,1) & curr_WM_sp_y > 0 & curr_WM_sp_y <= size(func_data.img,2) & curr_WM_sp_z > 0 & curr_WM_sp_z <= size(func_data.img,3);
                        WM_sp_inds = sub2ind(WM_fmask_dims,curr_WM_sp_x(inrangeinds),curr_WM_sp_y(inrangeinds),curr_WM_sp_z(inrangeinds));
                        loc_WM_inds = intersect(WM_fmask_inds,WM_sp_inds);
                        if ~isempty(loc_WM_inds)
                            for tp = 1:size(func_data.img,4)
                                tp_func = func_data.img(:,:,:,tp);
                                loc_WM_pred(tp,1) = sum(tp_func(loc_WM_inds))/length(loc_WM_inds);
                            end
                            loc_WM_pred = spm_detrend(loc_WM_pred,subfunc_out.detr_ord);
                            desmat = [orig_desmat,loc_WM_pred];
                            if subfunc_out.WMsigderiv_part == 1
                                loc_WM1stderiv_pred = loc_WM_pred(3:end) - loc_WM_pred(1:(end-2));
                                loc_WM1stderiv_pred = [loc_WM1stderiv_pred(1);loc_WM1stderiv_pred;loc_WM1stderiv_pred(end)];
                                loc_WM1stderiv_pred = spm_detrend(loc_WM1stderiv_pred,subfunc_out.detr_ord);
                                desmat = [desmat,loc_WM1stderiv_pred];
                            end
                        end
                        Q = desmat*pinv(full(desmat));
                    end
                    out_func_data.img(x,y,z,:) = squeeze(func_data.img(x,y,z,:))-(Q*squeeze(func_data.img(x,y,z,:)));
                end
            end
        end
    end
else
    out_func_data.img = func_data.img;
end

if strcmp(subfunc_out.saveintermed,'Yes')
    out_func_data.hdr = func_data.hdr;
    out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
    out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
    out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
    out_func_data.hdr.dime.datatype = 64;
    out_func_data.hdr.dime.bitpix = 64;
    save_nii_gz(out_func_data,func_filename);
end

if subfunc_out.motcens == 1
    out_func_data.img(repmat(logical(funcmask.img),[1,1,1,size(out_func_data.img,4)])) = out_func_data.img(repmat(logical(funcmask.img),[1,1,1,size(out_func_data.img,4)]))+50-min(out_func_data.img(repmat(logical(funcmask.img),[1,1,1,size(out_func_data.img,4)])));
    out_func_data.hdr = func_data.hdr;
    out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
    out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
    out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
    out_func_data.hdr.dime.datatype = 64;
    out_func_data.hdr.dime.bitpix = 64;
    DVARS_func_filename = strrep(func_filename,'.nii.gz','_forDVARS.nii.gz');
    save_nii_gz(out_func_data,DVARS_func_filename);
end

if subfunc_out.motcens == 1
    mot_pred = dlmread(par_filename);
    FD = cat(1,0,sum(abs(diff([(5000-5000*cos(mot_pred(:,1:3))),mot_pred(:,4:6)])),2));
    mean_FD = mean(FD);
    %%% Non-standardized method for calculating DVARS
    % DVARS_vox = diff(out_func_data.img,1,4).^2;
    % for vol = size(DVARS_vox,4):-1:1
    %     DVARS(vol) = mean(DVARS_vox([logical(funcmask.img),vol])).^0.5;
    % end
    
    DVARS_outname = [func_filename(1:(strfind(func_filename,'.nii.gz')-1)),'_DVARS.txt'];
    DVARS_scriptloc = which('DVARS_edit.sh');
    eval(['!',DVARS_scriptloc,' ',DVARS_func_filename,' ',DVARS_outname]);
    DVARS = dlmread(DVARS_outname);
    DVARS = cat(1,0,DVARS);
    eval(['!rm ',DVARS_func_filename]);
    mean_DVARS = mean(DVARS);
    
    num_censored_vols_FD = sum(FD >= subfunc_out.motcens_FD_cutoff);
    num_censored_vols_DVARS = sum(DVARS >= subfunc_out.motcens_DVARS_cutoff);
    
    temporal_mask = logical(FD < subfunc_out.motcens_FD_cutoff & DVARS < subfunc_out.motcens_DVARS_cutoff);
    censored_vols = [0;find(temporal_mask == 0)];
    for c_vol = 1:(length(censored_vols)-1)
        seg_length = censored_vols(c_vol+1)-censored_vols(c_vol);
        if seg_length <= 5
            temporal_mask(censored_vols(c_vol)+1:censored_vols(c_vol+1)) = 0;
            temporal_mask(censored_vols(c_vol)+1:censored_vols(c_vol+1)) = 0;
        end
    end
    num_censored_vols = sum(temporal_mask == 0);
    if num_censored_vols > 0
        if (subfunc_out.nTP-num_censored_vols >= 50) && (num_censored_vols/subfunc_out.nTP <= .75)
            func_filename = orig_func_filename;
            
            if subfunc_out.detr == 1
                detrend_image(func_filename,funcmask_filename,subfunc_out.detr_ord,temporal_mask);
                func_filename = [orig_func_filename(1:(strfind(orig_func_filename,'.nii.gz')-1)),'_motcensor_detr',num2str(subfunc_out.detr_ord),'.nii.gz'];
            end
            
            desmat = [];
            
            if subfunc_out.WMsig_part == 1 && strcmp(subfunc_out.WMmask_scope,'Entire Mask')
                WM_extract_filename = strrep(WM_filename,'.nii.gz','_motcensor.txt');
                eval(['!fslmeants -i ',func_filename,' -o ',WM_extract_filename,' -m ',WM_filename]);
                WM_pred = dlmread(WM_extract_filename);
                WM_pred = spm_detrend(WM_pred,subfunc_out.detr_ord);
                desmat = [desmat,WM_pred];
                if subfunc_out.WMsigderiv_part == 1
                    WM1stderiv_pred = WM_pred(3:end) - WM_pred(1:(end-2));
                    WM1stderiv_pred = [WM1stderiv_pred(1);WM1stderiv_pred;WM1stderiv_pred(end)];
                    WM1stderiv_pred = spm_detrend(WM1stderiv_pred,subfunc_out.detr_ord);
                    desmat = [desmat,WM1stderiv_pred];
                end
            end
            
            if subfunc_out.ventsig_part == 1
                vent_extract_filename = strrep(vent_filename,'.nii.gz','_motcensor.txt');
                eval(['!fslmeants -i ' func_filename ' -o ' vent_extract_filename ' -m ' vent_filename]);
                vent_pred = dlmread(vent_extract_filename);
                vent_pred = spm_detrend(vent_pred,subfunc_out.detr_ord);
                desmat = [desmat,vent_pred];
                
                if subfunc_out.ventsigderiv_part == 1
                    vent1stderiv_pred = vent_pred(3:end) - vent_pred(1:(end-2));
                    vent1stderiv_pred = [vent1stderiv_pred(1);vent1stderiv_pred;vent1stderiv_pred(end)];
                    vent1stderiv_pred = spm_detrend(vent1stderiv_pred,subfunc_out.detr_ord);
                    desmat = [desmat,vent1stderiv_pred];
                end
            end
            
            if subfunc_out.globsig_part == 1
                if subfunc_out.globsig_calcGNI == 1
                    GNI = Rest2GNI_edit(func_filename,funcmask_filename,1000); % If your machine freezes/slows down tremendously at this step b/c you have low RAM, you can change the 1000 value to 100 (or less) and it will use less RAM
                    fprintf(logfile_fid,'Motion-censored GNI for %s = %6.3f\n',sub,GNI);
                else
                    GNI = 0;
                end
                if GNI <= 3
                    funcmask_extract_filename = strrep(funcmask_filename,'.nii.gz','_motcensor.txt');
                    eval(['!fslmeants -i ',func_filename,' -o ',funcmask_extract_filename,' -m ',funcmask_filename]);
                    global_pred = dlmread(funcmask_extract_filename);
                    global_pred = spm_detrend(global_pred,subfunc_out.detr_ord);
                    desmat = [desmat,global_pred];
                    if subfunc_out.globsigderiv_part == 1
                        global1stderiv_pred = global_pred(3:end) - global_pred(1:(end-2));
                        global1stderiv_pred = [global1stderiv_pred(1);global1stderiv_pred;global1stderiv_pred(end)];
                        global1stderiv_pred = spm_detrend(global1stderiv_pred,subfunc_out.detr_ord);
                        desmat = [desmat,global1stderiv_pred];
                    end
                end
            end
            
            if subfunc_out.motpar_part == 1
                mot_pred = dlmread(par_filename);
                if subfunc_out.motpart1_part == 1
                    mot1back_pred = [mot_pred(2:end,:);mot_pred(end,:)];
                    mot1back_pred = mot1back_pred(temporal_mask,:);
                    for par = 1:size(mot_pred,2)
                        mot1back_pred(:,par) = spm_detrend(mot1back_pred(:,par),subfunc_out.detr_ord);
                    end
                    desmat = [desmat,mot1back_pred];
                end
                if subfunc_out.motparderiv_part == 1
                    mot1stderiv_pred = mot_pred(3:end,:) - mot_pred(1:(end-2),:);
                    mot1stderiv_pred = [mot1stderiv_pred(1,:);mot1stderiv_pred;mot1stderiv_pred(end,:)];
                    mot1stderiv_pred = mot1stderiv_pred(temporal_mask,:);
                    for par = 1:size(mot_pred,2)
                        mot1stderiv_pred(:,par) = spm_detrend(mot1stderiv_pred(:,par),subfunc_out.detr_ord);
                    end
                    desmat = [desmat,mot1stderiv_pred];
                end
                if subfunc_out.motparsqr_part == 1
                    motsquare_pred = mot_pred.^2;
                    motsquare_pred = motsquare_pred(temporal_mask,:);
                    for par = 1:size(mot_pred,2)
                        motsquare_pred(:,par) = spm_detrend(motsquare_pred(:,par),subfunc_out.detr_ord);
                    end
                    desmat = [desmat,motsquare_pred];
                end
                mot_pred = mot_pred(temporal_mask,:);
                for par = 1:size(mot_pred,2)
                    mot_pred(:,par) = spm_detrend(mot_pred(:,par),subfunc_out.detr_ord);
                end
                desmat = [desmat,mot_pred];
            end
            
            func_data = load_nii_gz(func_filename);
            func_data.img = double(func_data.img);
            
            out_func_data.img = zeros(size(func_data.img));
            if subfunc_out.WMsig_part == 1 || subfunc_out.ventsig_part == 1 || (subfunc_out.globsig_part == 1 && GNI <= 3) || subfunc_out.motpar_part == 1
                desmat = [ones(size(desmat,1),1),desmat];
                orig_desmat = desmat;
                if rank(desmat) ~= min(size(desmat))
                    error(['Motion censoring desmat to partial out unwanted variance for ' sub ' is not full rank']);
                end
                func_filename = strrep(func_filename,'.nii.gz','_remnuisance.nii.gz');
                Q = desmat*pinv(full(desmat));
                for x = 1:size(func_data.img,1)
                    for y = 1:size(func_data.img,2)
                        for z = 1:size(func_data.img,3)
                            if funcmask.img(x,y,z) == 1
                                if strcmp(subfunc_out.WMmask_scope,'Local Mask')
                                    curr_WM_sp_x = WM_sp_x + x;
                                    curr_WM_sp_y = WM_sp_y + y;
                                    curr_WM_sp_z = WM_sp_z + z;
                                    WM_sp_inds = sub2ind(WM_fmask_dims,[curr_WM_sp_x,curr_WM_sp_y,curr_WM_sp_z]);
                                    loc_WM_inds = intersect(WM_fmask_inds,WM_sp_inds);
                                    if ~isempty(loc_WM_inds)
                                        for tp = 1:size(func_data.img,4)
                                            tp_func = func_data.img(:,:,:,tp);
                                            loc_WM_pred(tp,1) = mean(tp_func(loc_WM_inds));
                                        end
                                        loc_WM_pred = spm_detrend(loc_WM_pred,subfunc_out.detr_ord);
                                        desmat = [orig_desmat,loc_WM_pred];
                                        if subfunc_out.WMsigderiv_part == 1
                                            loc_WM1stderiv_pred = loc_WM_pred(3:end) - loc_WM_pred(1:(end-2));
                                            loc_WM1stderiv_pred = [loc_WM1stderiv_pred(1);loc_WM1stderiv_pred;loc_WM1stderiv_pred(end)];
                                            loc_WM1stderiv_pred = spm_detrend(loc_WM1stderiv_pred,subfunc_out.detr_ord);
                                            desmat = [desmat,loc_WM1stderiv_pred];
                                        end
                                    end
                                    Q = desmat*pinv(full(desmat));
                                end
                                out_func_data.img(x,y,z,:) = squeeze(func_data.img(x,y,z,:))-(Q*squeeze(func_data.img(x,y,z,:)));
                            end
                        end
                    end
                end
                out_func_data.hdr = func_data.hdr;
                out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
                out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
                out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
                out_func_data.hdr.dime.datatype = 64;
                out_func_data.hdr.dime.bitpix = 64;
                if strcmp(subfunc_out.saveintermed,'Yes')
                    save_nii_gz(out_func_data,func_filename);
                end
            else
                out_func_data = func_data;
            end
            
            if subfunc_out.BP == 1
                func_filename = strrep(func_filename,'.nii.gz','_bpfilt.nii.gz');
                orig_times = (1:subfunc_out.nTP);
                uncensored_times = orig_times(temporal_mask);
                freq_bins = 1:1:subfunc_out.nTP;
                for bin = length(freq_bins):-1:1
                    theta = (1/(2*freq_bins(bin)))*atan(sum(sin(2*freq_bins(bin)*uncensored_times))/sum(cos(2*freq_bins(bin)*uncensored_times)));
                    cosmult(:,bin) = cos(freq_bins(bin).*(uncensored_times-theta))';
                    cosdiv(bin) = sum(cos(freq_bins(bin).*(uncensored_times-theta)).^2);
                    sinmult(:,bin) = sin(freq_bins(bin).*(uncensored_times-theta))';
                    sindiv(bin) = sum(sin(freq_bins(bin).*(uncensored_times-theta)).^2);
                    interpmult(:,:,bin) = [cos(freq_bins(bin).*(orig_times-theta));sin(freq_bins(bin).*(orig_times-theta))];
                end
                out_func_data.img = out_func_data.img - repmat(mean(out_func_data.img,4),[1,1,1,size(out_func_data.img,4)]);
                
                if exist('HP_sigma','var')
                    temp_data = zeros([size(func_data.img,1),size(func_data.img,2),size(func_data.img,3),subfunc_out.nTP]);
                    for x = 1:size(func_data.img,1)
                        for y = 1:size(func_data.img,2)
                            for z = 1:size(func_data.img,3)
                                if funcmask.img(x,y,z) == 1
                                    for bin = length(freq_bins):-1:1
                                        cosval = sum(squeeze(out_func_data.img(x,y,z,:)).*cosmult(:,bin))./cosdiv(bin);
                                        sinval = sum(squeeze(out_func_data.img(x,y,z,:)).*sinmult(:,bin))./sindiv(bin);
                                        interp_data(:,bin) = [cosval,sinval]*interpmult(:,:,bin);
                                    end
                                    temp_data(x,y,z,:) = sum(interp_data,2);
                                end
                            end
                        end
                    end
                    out_func_data.img = temp_data;
                    out_func_data.hdr = func_data.hdr;
                    out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
                    out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
                    out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
                    out_func_data.hdr.dime.datatype = 64;
                    out_func_data.hdr.dime.bitpix = 64;
                    save_nii_gz(out_func_data,func_filename);
                    eval(['!fslmaths ',func_filename,' -bptf ',HP_sigma,' ',LP_sigma,' ',func_filename]);
                    out_func_data = load_nii_gz(func_filename);
                    out_func_data.img = out_func_data.img(:,:,:,temporal_mask);
                    out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
                    out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
                    out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
                    out_func_data.hdr.dime.datatype = 64;
                    out_func_data.hdr.dime.bitpix = 64;
                    save_nii_gz(out_func_data,func_filename);
                else
                    for x = 1:size(func_data.img,1)
                        for y = 1:size(func_data.img,2)
                            for z = 1:size(func_data.img,3)
                                if funcmask.img(x,y,z) == 1
                                    for bin = length(freq_bins):-1:1
                                        cosval = sum(squeeze(out_func_data.img(x,y,z,:)).*cosmult(:,bin))./cosdiv(bin);
                                        sinval = sum(squeeze(out_func_data.img(x,y,z,:)).*sinmult(:,bin))./sindiv(bin);
                                        interp_data(:,bin) = [cosval,sinval]*interpmult(:,:,bin);
                                    end
                                    interp_data = sum(interp_data,2);
                                    if exist('butter_filt','var')
                                        interp_data_padded = [zeros(15,size(interp_data,2));interp_data;zeros(15,size(interp_data,2))];
                                        temp_butter = filter(butter_filt,interp_data_padded);
                                        temp_butter(end:-1:1) = filter(butter_filt,temp_butter(end:-1:1));
                                        temp_butter = temp_butter(16:(end-15));
                                        out_func_data.img(x,y,z,:) = temp_butter(temporal_mask,:);
                                    elseif exist('filt_ind','var')
                                        padlength = rest_nextpow2_one35(subfunc_out.nTP);
                                        interp_data = [interp_data;zeros(padlength-subfunc_out.nTP,size(interp_data,2))];
                                        freq = fft(interp_data);
                                        freq(filt_ind,:) = 0;
                                        interp_data = ifft(freq);
                                        interp_data = interp_data(1:subfunc_out.nTP,:);
                                        out_func_data.img(x,y,z,:) = interp_data(temporal_mask,:);
                                    end
                                end
                            end
                        end
                    end
                end
                out_func_data.hdr = func_data.hdr;
                out_func_data.hdr.dime.dim(2:5) = size(out_func_data.img);
                out_func_data.hdr.dime.cal_max = max(out_func_data.img(:));
                out_func_data.hdr.dime.cal_min = min(out_func_data.img(out_func_data.img~=0));
                out_func_data.hdr.dime.datatype = 64;
                out_func_data.hdr.dime.bitpix = 64;
                if strcmp(subfunc_out.saveintermed,'Yes')
                    save_nii_gz(out_func_data,func_filename);
                end
            end
            data_accept = 1;
        else
            data_accept = 0;
        end
    else
        data_accept = 1;
    end
else
    mean_FD = NaN;
    mean_DVARS = NaN;
    num_censored_vols = 0;
    num_censored_vols_FD = 0;
    num_censored_vols_DVARS = 0;
    data_accept = 1;
end

GCOR = NaN;
if data_accept == 1
    if subfunc_out.globsig_calcGCOR == 1
        GCOR_data = reshape(out_func_data.img,[numel(funcmask.img),size(out_func_data.img,4)]);
        GCOR_data = GCOR_data(logical(reshape(funcmask.img,[numel(funcmask.img),1])),:);
        GCOR_data = GCOR_data - (sum(GCOR_data,2)./size(GCOR_data,2))*ones(1,size(GCOR_data,2));
        GCOR = norm(sum(GCOR_data./(sqrt(sum(GCOR_data.^2,2))*ones(1,size(GCOR_data,2))))./size(GCOR_data,1)).^2;
    end
    
    parc_data = load_nii_gz(parc_filename);
    ROI_num_labels = unique(parc_data.img);
    ROI_num_labels = ROI_num_labels(ROI_num_labels ~=0);
    if length(ROI_num_labels) < subfunc_out.nROI
        error(['Too few ROIs in mask for participant #' sub])
    elseif length(ROI_num_labels) > subfunc_out.nROI
        error(['Too many ROIs in mask for participant #' sub])
    end
    nredu_TP = subfunc_out.nTP-num_censored_vols;
    ts = zeros(subfunc_out.nROI,nredu_TP);
    
    for ROI = 1:subfunc_out.nROI
        curr_label = ROI_num_labels(ROI);
        ROImask = zeros(size(funcmask.img));
        if ~isempty(find(parc_data.img == curr_label,1))
            ROImask(logical(parc_data.img == curr_label)) = 1;
            
            nvox_orig = sum(ROImask(:));
            ROImask = ROImask.*funcmask.img;
            nvox_masked = sum(ROImask(:));
            
            if nvox_masked >= 5
                if (nvox_masked/nvox_orig) >=.5
                    for t = 1:nredu_TP
                        ts(ROI,t) = sum(sum(sum(out_func_data.img(:,:,:,t).*ROImask)))./nvox_masked; 
                    end
                    if sum(isnan(ts(ROI,:))) > 0
                        fprintf(logfile_fid,'There is at least one NaN in the timeseries of ROI # %u for %s\n',curr_label,sub);
                    end
                else
                    fprintf(logfile_fid,'Less than 50%% of the original voxels are in the masked version of ROI # %u for %s\n',curr_label,sub);
                    ts(ROI,:) = NaN;
                end
            else
                fprintf(logfile_fid,'Less than 5 voxels in masked ROI # %u for %s\n',curr_label,sub);
                ts(ROI,:) = NaN;
            end
        else
            fprintf(logfile_fid,'No mask for ROI # %s for %u\n',curr_label,sub);
            ts(ROI,:) = NaN;
        end
    end
else
    ts(:,:) = NaN;
end



%%%% Calculate the "ideal" bandpass filter
function [filt_ind] = calc_IdealFilter(nTP,TR,LowCutoff_HighPass,HighCutoff_LowPass)
% Created using the REST toolbox's rest_IdealFilter.m function

sampleFreq 	 = 1/TR;
paddedLength = rest_nextpow2_one35(nTP); %2^nextpow2(sampleLength);

% Get the frequency index
if (LowCutoff_HighPass >= sampleFreq/2) % All high stop
    idxLowCutoff_HighPass = paddedLength/2+1;
else % high pass, such as freq > 0.01 Hz
    idxLowCutoff_HighPass = ceil(LowCutoff_HighPass * paddedLength * TR+1);
end

if (HighCutoff_LowPass>=sampleFreq/2)||(HighCutoff_LowPass==0) % All low pass
    idxHighCutoff_LowPass = paddedLength/2+1;
else % Low pass, such as freq < 0.1 Hz
    idxHighCutoff_LowPass = fix(HighCutoff_LowPass * paddedLength * TR+1);
end

FrequencyMask = zeros(paddedLength,1);
FrequencyMask(idxLowCutoff_HighPass:idxHighCutoff_LowPass,1) = 1;
FrequencyMask(paddedLength-idxLowCutoff_HighPass+2:-1:paddedLength-idxHighCutoff_LowPass+2,1) = 1;

filt_ind = find(FrequencyMask==0);



%%%% Detrend a timeseries for a defined order
function detrend_image(func_filename,funcmask_filename,detr_poly_ord,varargin)

orig = load_nii_gz(func_filename);
mask = load_nii_gz(funcmask_filename);
if ~isa(orig.img,'double')
    orig.img = double(orig.img);
end

if ~isempty(varargin)
    temporal_mask = varargin{1};
    out_filename = [func_filename(1:(strfind(func_filename,'.nii.gz')-1)),'_motcensor_detr',num2str(detr_poly_ord),'.nii.gz'];
else
    temporal_mask = true(size(orig.img,4),1);
    out_filename = [func_filename(1:(strfind(func_filename,'.nii.gz')-1)),'_detr',num2str(detr_poly_ord),'.nii.gz'];
end

orig.img = orig.img(:,:,:,temporal_mask);
outdata.img = zeros(size(orig.img));

for x = 1:size(orig.img,1)
    for y = 1:size(orig.img,2)
        for z = 1:size(orig.img,3)
            if mask.img(x,y,z) == 1
                outdata.img(x,y,z,:) = spm_detrend(squeeze(orig.img(x,y,z,:)),detr_poly_ord);
            end
        end
    end
end

outdata.hdr = orig.hdr;
outdata.hdr.dime.dim(2:5) = size(outdata.img);
outdata.hdr.dime.datatype = 64;
outdata.hdr.dime.bitpix = 64;
outdata.hdr.dime.cal_max = max(outdata.img(:));
outdata.hdr.dime.cal_min = min(outdata.img(outdata.img~=0));
save_nii_gz(outdata,out_filename);
