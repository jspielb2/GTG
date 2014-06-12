function varargout = METAlab_GTG_calcproperties_GUI(varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: Beta 0.30 (06.10.14)
% 
% 
% History:
% 02.27.14 - Beta 0.13 - initial public release
% 03.11.14 - Beta 0.20 - 1) small bugfixes, 2) major overhaul of user 
%                        interface into GUIs, 3) addition of testing of 
%                        negative weights in thresholded matrices, 4) 
%                        addition of testing of only non-disconnected 
%                        matrices for thresholded matrices, 5) addition of 
%                        pagerank & eigenvector centrality
% 03.17.14 - Beta 0.21 - 1) small bugfixes, 2) addition of parallel
%                        computing toolbox to stage 3
% 03.24.14 - Beta 0.22 - lots of small bugfixes
% 04.08.14 - Beta 0.23 - small bugfixes
% 04.23.14 - Beta 0.24 - small bugfixes
% 05.07.14 - Beta 0.25 - addition of k-coreness centrality
% 06.10.14 - Beta 0.30 - 1) small bugfixes, 2) all properties previously 
%                        calculated for all weights simultaneously are now 
%                        calculated for each sign separately (modularity 
%                        still calculated on entire matrix), 3) clustering
%                        coefficient, local efficiency, matching index,
%                        rich club, & transitivity added to full network
%                        calculations, 4) participant coefficient &
%                        within-module z added to thresholded calculations,
%                        5) calculation of properties for negative weights
%                        in the thresholded matrices is now automatic (to
%                        be consistent with the fully connected matrices),
%                        6) option added to calculate properties for
%                        absolute value of weights, 7) handles now used to 
%                        pass information between functions (rather than 
%                        via out, which was made global), allowing users to
%                        launch processes from the same gui with less 
%                        chance of info from the previous process 
%                        interfering, 8) important change to the way in
%                        which matrices are thresholded; specifically, the
%                        previous version allowed the threshold to be
%                        negative, which sometimes happened for higher
%                        densities (this was a problem for negative weight
%                        properties, but is unlikely to have affected
%                        properties for positive weights); thus, when
%                        calculating properties for negative weights,
%                        sometime positive weights were also allowed in at
%                        higher densities, which it more likely for 
%                        properties for positive and negative weights to be
%                        negatively correlated; now, only weights of the
%                        appropriate sign are allowed in; as a consequence,
%                        it is possible that the chosen maximum density 
%                        cannot be reached (less likely for positive
%                        weights, but is generally problematic for
%                        'sparser' matrices; therefore, the maximum 
%                        possible density is now calculated and, if smaller
%                        than the requested density, used
%
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
                   'gui_OpeningFcn', @METAlab_GTG_calcproperties_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @METAlab_GTG_calcproperties_GUI_OutputFcn, ...
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

function METAlab_GTG_calcproperties_GUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.output = hObject;
guidata(hObject, handles);

function varargout = METAlab_GTG_calcproperties_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Assortmats_edit_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
temp                = get(hObject,'String');
handles.out.conmats = evalin('base',temp);
guidata(hObject,handles);

function Assortmats_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Assortmats_edit_ButtonDownFcn(hObject, eventdata, handles)
set(hObject,'Enable','On');
uicontrol(handles.Assortmats_edit);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ROIlab_edit_Callback(hObject, eventdata, handles)
temp                   = get(hObject,'String');
handles.out.ROI_labels = evalin('base',temp);
handles.out.nROI       = length(handles.out.ROI_labels);
guidata(hObject,handles);

function ROIlab_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ROIlab_edit_ButtonDownFcn(hObject, eventdata, handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function IDs_edit_Callback(hObject, eventdata, handles)
temp                 = get(hObject,'String');
handles.out.subs     = evalin('base',temp);
handles.out.num_subs = length(handles.out.subs);
guidata(hObject,handles);

function IDs_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function IDs_edit_ButtonDownFcn(hObject, eventdata, handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Outfile_edit_Callback(hObject, eventdata, handles)
handles.out.outname = get(hObject,'String');
guidata(hObject,handles);

function Outfile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Outfile_pushbutton_Callback(hObject, eventdata, handles)
handles.out.outname = [uigetdir(pwd,'Select the output directory'),'/'];
set(handles.Outfile_edit,'String',handles.out.outname);
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_vars_pushbutton_Callback(hObject, eventdata, handles)
wksp_vars           = evalin('base','who');
handles.out.denscalc_varmat = [];                                                                                                      % Set empty design matrix to start
var_selection       = listdlg('PromptString',{'Select variables:',''},'SelectionMode','multiple','ListString',char(wksp_vars)); % Ask the user to select their IVs
for var = 1:length(var_selection)                                                                                              % For each IV selected
    handles.out.denscalc_var_names{1,var} = wksp_vars{var_selection(var)};
    handles.out.denscalc_varmat           = [handles.out.denscalc_varmat,evalin('base',wksp_vars{var_selection(var)})];                                                      % Get IV from workspace and add to design matrix
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_covar_pushbutton_Callback(hObject, eventdata, handles)
wksp_vars             = evalin('base','who');
handles.out.denscalc_covarmat = [];                                                                                                       % Set empty design matrix to start
covar_selection       = listdlg('PromptString',{'Select covariates:',''},'SelectionMode','multiple','ListString',char(wksp_vars)); % Ask the user to select their IVs
for covar = 1:length(covar_selection)                                                                                             % For each IV selected
    handles.out.denscalc_covar_names{1,covar} = wksp_vars{covar_selection(covar)};
    handles.out.denscalc_covarmat             = [handles.out.denscalc_covarmat,evalin('base',wksp_vars{covar_selection(covar)})];                                                      % Get IV from workspace and add to design matrix
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_part_popupmenu_Callback(hObject, eventdata, handles)
contents                         = cellstr(get(hObject,'String'));
handles.out.partial_for_min_dens = contents{get(hObject,'Value')};

if strcmp(handles.out.partial_for_min_dens,'Yes')
    set(handles.Denscalc_covar_pushbutton,'enable','on');
else
    set(handles.Denscalc_covar_pushbutton,'enable','off');
end
guidata(hObject,handles);

function Denscalc_part_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CalcAUCnodiscon_checkbox_Callback(hObject, eventdata, handles)
handles.out.calcAUC_nodiscon = get(hObject,'Value');
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_posmax_edit_Callback(hObject, eventdata, handles)
handles.out.max_dens_pos = str2double(get(hObject,'String'));
guidata(hObject,handles);

function Denscalc_posmax_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_posstep_edit_Callback(hObject, eventdata, handles)
handles.out.dens_step_pos = str2double(get(hObject,'String'));
guidata(hObject,handles);

function Denscalc_posstep_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_negmax_edit_Callback(hObject, eventdata, handles)
handles.out.max_dens_neg = str2double(get(hObject,'String'));
guidata(hObject,handles);

function Denscalc_negmax_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Denscalc_negstep_edit_Callback(hObject, eventdata, handles)
handles.out.dens_step_neg = str2double(get(hObject,'String'));
guidata(hObject,handles);

function Denscalc_negstep_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Modruns_edit_Callback(hObject, eventdata, handles)
handles.out.num_mod_runs = str2double(get(hObject,'String'));
set(handles.Start_pushbutton,'enable','on');
guidata(hObject,handles);

function Modruns_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Useabsval_checkbox_Callback(hObject, eventdata, handles)
handles.out.use_abs_val = get(hObject,'Value');

if handles.out.use_abs_val == 1
    set(handles.Denscalc_negmax_edit,'enable','off');
    set(handles.Denscalc_negstep_edit,'enable','off');
elseif handles.out.use_abs_val == 0
    set(handles.Denscalc_negmax_edit,'enable','on');
    set(handles.Denscalc_negstep_edit,'enable','on');
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Calcmaxclub_checkbox_Callback(hObject, eventdata, handles)
handles.out.calc_max_club_size = get(hObject,'Value');

if handles.out.calc_max_club_size == 1
    set(handles.Maxclub_edit,'enable','off');
elseif handles.out.calc_max_club_size == 0
    set(handles.Maxclub_edit,'enable','on');
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Maxclub_edit_Callback(hObject, eventdata, handles)
handles.out.max_rich_club_size = str2double(get(hObject,'String'));
guidata(hObject,handles);

function Maxclub_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Fullconnectprop_listbox_Callback(hObject, eventdata, handles)
contents                             = cellstr(get(hObject,'String'));
handles.out.properties_calcd_fullmat = contents(get(hObject,'Value'));
guidata(hObject,handles);

function Fullconnectprop_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Threshprop_listbox_Callback(hObject, eventdata, handles)
contents                            = cellstr(get(hObject,'String'));
handles.out.properties_calcd_thrmat = contents(get(hObject,'Value'));
guidata(hObject,handles);

function Threshprop_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_pushbutton_Callback(hObject, eventdata, handles)
out = handles.out;

% Check whether inputs have been specified
if ~isfield(out,'conmats')
    msgbox('Enter assortativity matrices','Error','error')
    return
end
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
if ~isfield(out,'denscalc_varmat')
    out.denscalc_varmat      = [];
    out.denscalc_var_names   = {'intercept'};
end
if ~isfield(out,'denscalc_covarmat')
    out.denscalc_covarmat    = [];
    out.denscalc_covar_names = {};
end
if ~isfield(out,'partial_for_min_dens')
    out.partial_for_min_dens = 'No';
end
if ~isfield(out,'calcAUC_nodiscon')
    out.calcAUC_nodiscon     = 0;
end
if ~isfield(out,'max_dens_pos')
    out.max_dens_pos         = 0.6;
end
if ~isfield(out,'dens_step_pos')
    out.dens_step_pos        = 0.01;
end
if ~isfield(out,'max_dens_neg')
    out.max_dens_neg         = 0.6;
end
if ~isfield(out,'dens_step_neg')
    out.dens_step_neg        = 0.01;
end
if ~isfield(out,'num_mod_runs')
    out.num_mod_runs         = 10000;
end
if ~isfield(out,'use_abs_val')
    out.use_abs_val          = 0;
end
if ~isfield(out,'calc_max_club_size')
    out.calc_max_club_size   = 0;
end
if out.calc_max_club_size == 1 && isfield(out,'max_rich_club_size')
    out                    = rmfield(out,'max_rich_club_size');
elseif out.calc_max_club_size == 0 && ~isfield(out,'max_rich_club_size')
    out.max_rich_club_size = 30;
end
if ~isfield(out,'properties_calcd_fullmat') && ~isfield(out,'properties_calcd_thrmat')
    msgbox('Select at least one property to test','Error','error')
    return
elseif ~isfield(out,'properties_calcd_thrmat') && all(strcmp(out.properties_calcd_fullmat,'None') == 1)
    msgbox('Select at least one property to test','Error','error')
    return
elseif ~isfield(out,'properties_calcd_fullmat') && all(strcmp(out.properties_calcd_thrmat,'None') == 1)
    msgbox('Select at least one property to test','Error','error')
    return
elseif (isfield(out,'properties_calcd_fullmat') && all(strcmp(out.properties_calcd_fullmat,'None') == 1)) && (isfield(out,'properties_calcd_thrmat') && all(strcmp(out.properties_calcd_thrmat,'None') == 1))
    msgbox('Select at least one property to test','Error','error')
    return
end
if ~isfield(out,'properties_calcd_fullmat')
    out.properties_calcd_fullmat = {};
end
if ~isfield(out,'properties_calcd_thrmat')
    out.properties_calcd_thrmat  = {};
end

set(handles.Start_pushbutton,'enable','off');

out.num_subs = size(out.conmats,3);                                                                                                    % Determine the number of participants
out.nROI     = length(out.ROI_labels);                                                                                         % Determine the number of nodes

% Set intial values to 0 (no testing)
out.calc_props_fullmat.assort        = 0;
out.calc_props_fullmat.cpl           = 0;
out.calc_props_fullmat.clust_coef    = 0;
out.calc_props_fullmat.div_coef      = 0;
out.calc_props_fullmat.edge_bet_cent = 0;
out.calc_props_fullmat.eigvec_cent   = 0;
out.calc_props_fullmat.glob_eff      = 0;
out.calc_props_fullmat.loc_eff       = 0;
out.calc_props_fullmat.match         = 0;
out.calc_props_fullmat.node_bet_cent = 0;
out.calc_props_fullmat.strength      = 0;
out.calc_props_fullmat.pagerank_cent = 0;
out.calc_props_fullmat.part_coef     = 0;
out.calc_props_fullmat.rich_club     = 0;
out.calc_props_fullmat.trans         = 0;
out.calc_props_fullmat.mod_deg_z     = 0;

out.calc_props_thrmat.assort        = 0;
out.calc_props_thrmat.cpl           = 0;
out.calc_props_thrmat.clust_coef    = 0;
out.calc_props_thrmat.deg           = 0;
out.calc_props_thrmat.dens          = 0;
out.calc_props_thrmat.edge_bet_cent = 0;
out.calc_props_thrmat.eigvec_cent   = 0;
out.calc_props_thrmat.glob_eff      = 0;
out.calc_props_thrmat.kcore_cent    = 0;
out.calc_props_thrmat.loc_eff       = 0;
out.calc_props_thrmat.match         = 0;
out.calc_props_thrmat.node_bet_cent = 0;
out.calc_props_thrmat.pagerank_cent = 0;
out.calc_props_thrmat.part_coef     = 0;
out.calc_props_thrmat.rich_club     = 0;
out.calc_props_thrmat.small_world   = 0;
out.calc_props_thrmat.sub_cent      = 0;
out.calc_props_thrmat.trans         = 0;
out.calc_props_thrmat.mod_deg_z     = 0;

% Determine which properties the user selected for fully connected matrices
if ismember('Assortativity',out.properties_calcd_fullmat) && out.use_abs_val == 0
    out.calc_props_fullmat.assort        = 1;
elseif ismember('Assortativity',out.properties_calcd_fullmat)
    out.properties_calcd_fullmat(ismember(out.properties_calcd_fullmat,'Assortativity')) = [];
end
if ismember('Characteristic Path Length',out.properties_calcd_fullmat)
    out.calc_props_fullmat.cpl           = 1;
end
if ismember('Clustering Coefficient',out.properties_calcd_fullmat)
    out.calc_props_fullmat.clust_coef    = 1;
end
if ismember('Diversity Coefficient',out.properties_calcd_fullmat)
    out.calc_props_fullmat.div_coef      = 1;
end
if ismember('Edge Betweeness Centrality',out.properties_calcd_fullmat)
    out.calc_props_fullmat.edge_bet_cent = 1;
end
if ismember('Eigenvector Centrality',out.properties_calcd_fullmat)
    out.calc_props_fullmat.eigvec_cent   = 1;
end
if ismember('Global Efficiency',out.properties_calcd_fullmat)
    out.calc_props_fullmat.glob_eff      = 1;
end
if ismember('Local Efficiency',out.properties_calcd_fullmat)
    out.calc_props_fullmat.loc_eff       = 1;
end
if ismember('Matching Index',out.properties_calcd_fullmat)
    out.calc_props_fullmat.match         = 1;
end
if ismember('Node Betweeness Centrality',out.properties_calcd_fullmat)
    out.calc_props_fullmat.node_bet_cent = 1;
end
if ismember('Node Strength',out.properties_calcd_fullmat)
    out.calc_props_fullmat.strength      = 1;
end
if ismember('PageRank Centrality',out.properties_calcd_fullmat)
    out.calc_props_fullmat.pagerank_cent = 1;
end
if ismember('Participation Coefficient',out.properties_calcd_fullmat)
    out.calc_props_fullmat.part_coef     = 1;
end
if ismember('Rich Club Networks',out.properties_calcd_fullmat) && out.use_abs_val == 0
    out.calc_props_fullmat.rich_club     = 1;
elseif ismember('Rich Club Networks',out.properties_calcd_fullmat)
    out.properties_calcd_fullmat(ismember(out.properties_calcd_fullmat,'Rich Club Networks')) = [];
end
if ismember('Transitivity',out.properties_calcd_fullmat)
    out.calc_props_fullmat.trans         = 1;
end
if ismember('Within-Module Degree Z-Score',out.properties_calcd_fullmat)
    out.calc_props_fullmat.mod_deg_z     = 1;
end

% Determine which properties the user selected for thresholded matrices
if ismember('Assortativity',out.properties_calcd_thrmat)
    out.calc_props_thrmat.assort        = 1;
end
if ismember('Characteristic Path Length',out.properties_calcd_thrmat)
    out.calc_props_thrmat.cpl           = 1;
end
if ismember('Clustering Coefficient',out.properties_calcd_thrmat)
    out.calc_props_thrmat.clust_coef    = 1;
end
if ismember('Degree',out.properties_calcd_thrmat)
    out.calc_props_thrmat.deg           = 1;
end
if ismember('Density',out.properties_calcd_thrmat)
    out.calc_props_thrmat.dens          = 1;
end
if ismember('Edge Betweeness Centrality',out.properties_calcd_thrmat)
    out.calc_props_thrmat.edge_bet_cent = 1;
end
if ismember('Eigenvector Centrality',out.properties_calcd_thrmat)
    out.calc_props_thrmat.eigvec_cent   = 1;
end
if ismember('Global Efficiency',out.properties_calcd_thrmat)
    out.calc_props_thrmat.glob_eff      = 1;
end
if ismember('K-Coreness Centrality',out.properties_calcd_thrmat)
    out.calc_props_thrmat.kcore_cent    = 1;
end
if ismember('Local Efficiency',out.properties_calcd_thrmat)
    out.calc_props_thrmat.loc_eff       = 1;
end
if ismember('Matching Index',out.properties_calcd_thrmat)
    out.calc_props_thrmat.match         = 1;
end
if ismember('Node Betweeness Centrality',out.properties_calcd_thrmat)
    out.calc_props_thrmat.node_bet_cent = 1;
end
if ismember('PageRank Centrality',out.properties_calcd_thrmat)
    out.calc_props_thrmat.pagerank_cent = 1;
end
if ismember('Participation Coefficient',out.properties_calcd_thrmat)
    out.calc_props_thrmat.part_coef     = 1;
end
if ismember('Rich Club Networks',out.properties_calcd_thrmat)
    out.calc_props_thrmat.rich_club     = 1;
end
if ismember('Small Worldness',out.properties_calcd_thrmat)
    out.calc_props_thrmat.small_world   = 1;
end
if ismember('Subgraph Centrality',out.properties_calcd_thrmat)
    out.calc_props_thrmat.sub_cent      = 1;
end
if ismember('Transitivity',out.properties_calcd_thrmat)
    out.calc_props_thrmat.trans         = 1;
end
if ismember('Within-Module Degree Z-Score',out.properties_calcd_thrmat)
    out.calc_props_thrmat.mod_deg_z     = 1;
end

out.conmats(logical(repmat(eye(size(out.conmats,1)),[1,1,size(out.conmats,3)]))) = 1;                                                                                                                % Set diagonal of connectivity matrices to 1
out.outname                                                                      = [out.outname '_propcalc'];                                                                                                                                          % Create name for output file
out.num_rep_levs                                                                 = size(out.conmats,4);                                                                                                                                                   % Determine # of repeated levels

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
    catch %#ok<*CTCH>
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

if out.use_abs_val == 1
    out.conmats = abs(out.conmats);
end

if out.calc_props_fullmat.assort             == 1 || ...
        out.calc_props_fullmat.cpl           == 1 || ...
        out.calc_props_fullmat.clust_coef    == 1 || ...
        out.calc_props_fullmat.div_coef      == 1 || ...
        out.calc_props_fullmat.edge_bet_cent == 1 || ...
        out.calc_props_fullmat.eigvec_cent   == 1 || ...
        out.calc_props_fullmat.glob_eff      == 1 || ...
        out.calc_props_fullmat.loc_eff       == 1 || ...
        out.calc_props_fullmat.match         == 1 || ...
        out.calc_props_fullmat.node_bet_cent == 1 || ...
        out.calc_props_fullmat.rich_club     == 1 || ...
        out.calc_props_fullmat.strength      == 1 || ...
        out.calc_props_fullmat.pagerank_cent == 1 || ...    
        out.calc_props_fullmat.part_coef     == 1 || ...
        out.calc_props_fullmat.trans         == 1 || ...
        out.calc_props_fullmat.mod_deg_z     == 1
    out.calcfullmat = 1;
else
    out.calcfullmat = 0;
end

if out.calc_props_thrmat.assort             == 1 || ...
        out.calc_props_thrmat.cpl           == 1 || ...
        out.calc_props_thrmat.clust_coef    == 1 || ...
        out.calc_props_thrmat.deg           == 1 || ...
        out.calc_props_thrmat.dens          == 1 || ...
        out.calc_props_thrmat.edge_bet_cent == 1 || ...
        out.calc_props_thrmat.eigvec_cent   == 1 || ...
        out.calc_props_thrmat.glob_eff      == 1 || ...
        out.calc_props_thrmat.kcore_cent    == 1 || ...
        out.calc_props_thrmat.loc_eff       == 1 || ...
        out.calc_props_thrmat.match         == 1 || ...
        out.calc_props_thrmat.node_bet_cent == 1 || ...
        out.calc_props_thrmat.pagerank_cent == 1 || ...
        out.calc_props_thrmat.part_coef     == 1 || ...
        out.calc_props_thrmat.rich_club     == 1 || ...
        out.calc_props_thrmat.small_world   == 1 || ...
        out.calc_props_thrmat.sub_cent      == 1 || ...
        out.calc_props_thrmat.trans         == 1 || ...
        out.calc_props_thrmat.mod_deg_z     == 1
    out.calcthrmat = 1;
else
    out.calcthrmat = 0;
end

if ~use_parfor
    if out.calcfullmat == 1 && out.calcthrmat == 1
        progressbar('Progress For Fully Connected Matrices','Progress For Thresholded Matrices','Progress For Calculating AUC for Thresholded Matrices')                                         % Initialize progress bars at zero
    elseif out.calcfullmat == 1
        progressbar('Progress For Fully Connected Matrices')                                         % Initialize progress bars at zero
    else
        progressbar('Progress For Thresholded Matrices','Progress For Calculating AUC for Thresholded Matrices')                                         % Initialize progress bars at zero
    end
end

if out.calc_props_fullmat.div_coef       == 1 || ...
        out.calc_props_fullmat.part_coef == 1 || ...
        out.calc_props_fullmat.mod_deg_z == 1 || ...
        out.calc_props_thrmat.part_coef  == 1 || ...
        out.calc_props_thrmat.mod_deg_z  == 1            % If properties requiring a modular organization should be calculated
    
    %%%% Create modularity based on mean network
    if size(out.conmats,4) > 1
        [full_mean_conmat]   = create_mean_conmats(reshape(out.conmats,[size(out.conmats,1),size(out.conmats,2),size(out.conmats,3)*size(out.conmats,4)]));                              % Calculate the mean connectivity matrix across participants; if there are repeated levels, concatenate along the participant dimension beforhand
    else
        [full_mean_conmat]   = create_mean_conmats(out.conmats);                              % Calculate the mean connectivity matrix across participants; if there are repeated levels, concatenate along the participant dimension beforhand
    end
    full_mean_conmat(logical(eye(size(out.conmats,1)))) = 1;
    for run              = out.num_mod_runs:-1:1                                                                                                                                     % Loop on run
        [louv_ci]        = modularity_louvain_und_sign(full_mean_conmat);                                                                                                            % Calculate the initial organization
        [fine_ci,Q(run)] = modularity_finetune_und_sign(full_mean_conmat,'sta',louv_ci);                                                                                             % Fine tune organization
        % Relable groups so that new labels appear in numerical order
        % (so that identical modular organizations will not appear
        % different simply because of different group lables)
        grp_labels       = unique(fine_ci);
        grpinds          = zeros(length(grp_labels),1);
        for grp          = 1:length(grp_labels)
            curr_label   = grp_labels(grp);
            grpinds(grp) = find(fine_ci == curr_label,1);
        end
        [~,reinds]       = sort(grpinds);
        for grp          = 1:length(grp_labels)
            curr_label   = grp_labels(reinds(grp));
            mod_grps(logical(fine_ci == curr_label),run) = grp_labels(grp);
        end
    end
    out.mod_grps         = mod_grps(:,find(Q == max(Q),1,'first'));                                                                                                                  % Find grouping that maximizes modularity (with high # of runs, this is identical to taking the most common grouping or to taking the mode group assignment for each node)
end



%%%% Fully connected networks
if out.calcfullmat == 1
    
    fprintf('Calculating properties for fully connected matrices ...\n')
    
    %%%% Calculate network measures for each participant, for each repeated
    %%%% level
    if use_parfor
        calc_props_fullmat = out.calc_props_fullmat;
        for rep_lev         = out.num_rep_levs:-1:1                                                                                                                                        % Loop through each repeated level
            conmats = squeeze(out.conmats(:,:,:,rep_lev));
            parfor curr_sub = 1:out.num_subs                                                                                                                                                 % Loop through each participant
                curr_conmat = conmats(:,:,curr_sub);                                                                                                                    % Extract connectivity matrix for current participant
                if use_abs_val == 0
                    if calc_props_fullmat.assort == 1                                                                                                                                        % If assortativity should be calculated
                        [assort_pos(curr_sub,rep_lev),assort_neg(curr_sub,rep_lev)] = assortativity_wei_sign(curr_conmat,0);                                                                                      % Each output should be 1 number
                    end
                    
                    if calc_props_fullmat.cpl == 1 || calc_props_fullmat.glob_eff == 1 || calc_props_fullmat.edge_bet_cent == 1 || calc_props_fullmat.node_bet_cent == 1                                                                                    % If either node or edge betweeness centrality should be calculated
                        length_mat = weight_conversion(curr_conmat,'lengths');                                                                                                                   % Convert weights to lengths
                        
                        if calc_props_fullmat.cpl == 1 || calc_props_fullmat.glob_eff == 1                                                                                                   % If either the characteristic path length or global efficiency should be calculated
                            if calc_props_fullmat.cpl == 1 && calc_props_fullmat.glob_eff == 1                                                                                               % If both should be calculated
                                [cpl_pos(curr_sub,rep_lev),cpl_neg(curr_sub,rep_lev),glob_eff_pos(curr_sub,rep_lev),glob_eff_neg(curr_sub,rep_lev)] = charpath_sign(length_mat);                                               % Each output should be 1 number
                            elseif calc_props_fullmat.cpl == 1                                                                                                                                   % If only the characteristic path length should be calculated
                                [cpl_pos(curr_sub,rep_lev),cpl_neg(curr_sub,rep_lev)] = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            else                                                                                                                                                                     % If only the global efficiency should be calculated
                                [~,~,glob_eff_pos(curr_sub,rep_lev),glob_eff_neg(curr_sub,rep_lev)] = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            end
                        end
                        
                        if calc_props_fullmat.node_bet_cent == 1                                                                                                                             % If node betweeness centrality  should be calculated
                            [node_bet_cent_pos(curr_sub,:,rep_lev),node_bet_cent_neg(curr_sub,:,rep_lev)] = betweenness_wei_sign(length_mat);                                                                            % Each output should be vector of size #ROIs
                        end
                        
                        if calc_props_fullmat.edge_bet_cent == 1                                                                                                                             % If edge betweeness centrality  should be calculated
                            [edge_bet_cent_pos(curr_sub,:,:,rep_lev),edge_bet_cent_neg(curr_sub,:,:,rep_lev)] = edge_betweenness_wei_sign(length_mat);                                                                       % Each output should be square matrix of size #ROIs
                        end
                    end
                    
                    if calc_props_fullmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                        [clust_coef_pos(curr_sub,:,rep_lev),clust_coef_neg(curr_sub,:,rep_lev)] = clustering_coef_wu_sign(curr_conmat);                                        % Each output should be vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.div_coef == 1                                                                                                                                      % If the diversity coefficient should be calculated
                        [div_coef_pos(curr_sub,:,rep_lev),div_coef_neg(curr_sub,:,rep_lev)] = diversity_coef_sign(curr_conmat,out.mod_grps);       % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.eigvec_cent == 1                                                                                                                                   % If the diversity coefficient should be calculated
                        [eigvec_cent_pos(curr_sub,:,rep_lev),eigvec_cent_neg(curr_sub,:,rep_lev)] = eigenvector_centrality_und_sign(curr_conmat);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                        [loc_eff_pos(curr_sub,:,rep_lev),loc_eff_neg(curr_sub,:,rep_lev)] = efficiency_wei_sign(curr_conmat,1);                                             % Each output should be vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.match == 1                                                                                                             % If the matching index should be calculated
                        [match_pos(curr_sub,:,:,rep_lev),match_neg(curr_sub,:,:,rep_lev)] = matching_ind_und_sign(curr_conmat);                                             % Each output should be square matrix of of size #ROIs
                    end
                    
                    if calc_props_fullmat.strength == 1                                                                                                                                      % If node strength should be calculated
                        [strength_pos(curr_sub,:,rep_lev),strength_neg(curr_sub,:,rep_lev), ...
                            strength_totpos(curr_sub,rep_lev),strength_totneg(curr_sub,rep_lev)] = strengths_und_sign(curr_conmat);                % Produces four outputs, two describe entire network, two describe each node
                    end
                    
                    if calc_props_fullmat.pagerank_cent == 1                                                                                                                                 % If the diversity coefficient should be calculated
                        [pagerank_cent_pos(curr_sub,:,rep_lev),pagerank_cent_neg(curr_sub,:,rep_lev)] = pagerank_centrality_sign(curr_conmat,0.85);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                        [part_coef_pos(curr_sub,:,rep_lev),part_coef_neg(curr_sub,:,rep_lev)] = participation_coef_sign(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.rich_club == 1                                                                                                         % If rich club networks should be calculated
                        if exist('out.max_club_size','var')                                                                                                  % If the user has specified a maximum density
                            [rich_club_pos{curr_sub,rep_lev},rich_club_neg{curr_sub,rep_lev}] = rich_club_wu(curr_conmat,out.max_club_size);                           % Each output should be vector of size max density
                        else                                                                                                                                 % If not
                            [rich_club_pos{curr_sub,rep_lev},rich_club_neg{curr_sub,rep_lev}] = rich_club_wu(curr_conmat);                                             % Each output should be vector of size of max density
                        end
                    end
                    
                    if calc_props_fullmat.trans == 1                                                                                                             % If transitivity should be calculated
                        [trans_pos(curr_sub,rep_lev),trans_neg(curr_sub,rep_lev)] = transitivity_wu_sign(curr_conmat);                                                  % Each output should be 1 number
                    end
                    
                    if calc_props_fullmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                        [mod_deg_z_pos(curr_sub,:,rep_lev),mod_deg_z_neg(curr_sub,:,rep_lev)] = module_degree_zscore_sign(curr_conmat,out.mod_grps);                                                                 % Each output should be vector of size #ROIs
                    end
                else
                    if calc_props_fullmat.assort == 1                                                                                                                                        % If assortativity should be calculated
                        assort_pos(curr_sub,rep_lev) = assortativity_wei_sign(curr_conmat,0);                                                                                      % Each output should be 1 number
                    end
                    
                    if calc_props_fullmat.cpl == 1 || calc_props_fullmat.glob_eff == 1 || calc_props_fullmat.edge_bet_cent == 1 || calc_props_fullmat.node_bet_cent == 1                                                                                    % If either node or edge betweeness centrality should be calculated
                        length_mat = weight_conversion(curr_conmat,'lengths');                                                                                                                   % Convert weights to lengths
                        
                        if calc_props_fullmat.cpl == 1 || calc_props_fullmat.glob_eff == 1                                                                                                   % If either the characteristic path length or global efficiency should be calculated
                            if calc_props_fullmat.cpl == 1 && calc_props_fullmat.glob_eff == 1                                                                                               % If both should be calculated
                                [cpl_pos(curr_sub,rep_lev),~,glob_eff_pos(curr_sub,rep_lev)] = charpath_sign(length_mat);                                               % Each output should be 1 number
                            elseif calc_props_fullmat.cpl == 1                                                                                                                                   % If only the characteristic path length should be calculated
                                cpl_pos(curr_sub,rep_lev) = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            else                                                                                                                                                                     % If only the global efficiency should be calculated
                                [~,~,glob_eff_pos(curr_sub,rep_lev)] = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            end
                        end
                        
                        if calc_props_fullmat.node_bet_cent == 1                                                                                                                             % If node betweeness centrality  should be calculated
                            node_bet_cent_pos(curr_sub,:,rep_lev) = betweenness_wei_sign(length_mat);                                                                            % Each output should be vector of size #ROIs
                        end
                        
                        if calc_props_fullmat.edge_bet_cent == 1                                                                                                                             % If edge betweeness centrality  should be calculated
                            edge_bet_cent_pos(curr_sub,:,:,rep_lev) = edge_betweenness_wei_sign(length_mat);                                                                       % Each output should be square matrix of size #ROIs
                        end
                    end
                    
                    if calc_props_fullmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                        clust_coef_pos(curr_sub,:,rep_lev) = clustering_coef_wu_sign(curr_conmat);                                        % Each output should be vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.div_coef == 1                                                                                                                                      % If the diversity coefficient should be calculated
                        div_coef_pos(curr_sub,:,rep_lev) = diversity_coef_sign(curr_conmat,out.mod_grps);       % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.eigvec_cent == 1                                                                                                                                   % If the diversity coefficient should be calculated
                        eigvec_cent_pos(curr_sub,:,rep_lev) = eigenvector_centrality_und_sign(curr_conmat);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                        loc_eff_pos(curr_sub,:,rep_lev) = efficiency_wei_sign(curr_conmat,1);                                             % Each output should be vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.match == 1                                                                                                             % If the matching index should be calculated
                        match_pos(curr_sub,:,:,rep_lev) = matching_ind_und_sign(curr_conmat);                                             % Each output should be square matrix of of size #ROIs
                    end
                    
                    if calc_props_fullmat.strength == 1                                                                                                                                      % If node strength should be calculated
                        [strength_pos(curr_sub,:,rep_lev),~, ...
                            strength_totpos(curr_sub,rep_lev)] = strengths_und_sign(curr_conmat);                % Produces four outputs, two describe entire network, two describe each node
                    end
                    
                    if calc_props_fullmat.pagerank_cent == 1                                                                                                                                 % If the diversity coefficient should be calculated
                        pagerank_cent_pos(curr_sub,:,rep_lev) = pagerank_centrality_sign(curr_conmat,0.85);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                        part_coef_pos(curr_sub,:,rep_lev) = participation_coef_sign(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if calc_props_fullmat.rich_club == 1                                                                                                         % If rich club networks should be calculated
                        if exist('out.max_club_size','var')                                                                                                  % If the user has specified a maximum density
                            rich_club_pos{curr_sub,rep_lev} = rich_club_wu(curr_conmat,out.max_club_size);                           % Each output should be vector of size max density
                        else                                                                                                                                 % If not
                            rich_club_pos{curr_sub,rep_lev} = rich_club_wu(curr_conmat);                                             % Each output should be vector of size of max density
                        end
                    end
                    
                    if calc_props_fullmat.trans == 1                                                                                                             % If transitivity should be calculated
                        trans_pos(curr_sub,rep_lev) = transitivity_wu_sign(curr_conmat);                                                  % Each output should be 1 number
                    end
                    
                    if calc_props_fullmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                        mod_deg_z_pos(curr_sub,:,rep_lev) = module_degree_zscore_sign(curr_conmat,out.mod_grps);                                                                 % Each output should be vector of size #ROIs
                    end
                end
            end
        end
        
        if out.use_abs_val == 0
            if calc_props_fullmat.assort == 1                                                                                                                                        % If assortativity was calculated
                out.fullmat_graph_meas.assort_pos = assort_pos;
                out.fullmat_graph_meas.assort_neg = assort_neg;
                clear assort_pos assort_neg
            end
            if calc_props_fullmat.cpl == 1                                                                                                                                   % If only the characteristic path length was calculated
                out.fullmat_graph_meas.cpl_pos = cpl_pos;
                out.fullmat_graph_meas.cpl_neg = cpl_neg;
                clear cpl_pos cpl_neg
            end
            if calc_props_fullmat.clust_coef == 1                                                                                                                                   % If only the characteristic path length was calculated
                out.fullmat_graph_meas.clust_coef_pos = clust_coef_pos;
                out.fullmat_graph_meas.clust_coef_neg = clust_coef_neg;
                clear clust_coef_pos clust_coef_neg
            end
            if calc_props_fullmat.glob_eff == 1                                                                                                                                         % If only the global efficiency was calculated
                out.fullmat_graph_meas.glob_eff_pos = glob_eff_pos;
                out.fullmat_graph_meas.glob_eff_neg = glob_eff_neg;
                clear glob_eff_pos glob_eff_neg
            end
            if calc_props_fullmat.div_coef == 1                                                                                                                                      % If the diversity coefficient was calculated
                out.fullmat_graph_meas.div_coef_pos = div_coef_pos;
                out.fullmat_graph_meas.div_coef_neg = div_coef_neg;
                clear div_coef_pos div_coef_neg
            end
            if calc_props_fullmat.edge_bet_cent == 1                                                                                                                             % If edge betweeness centrality  was calculated
                out.fullmat_graph_meas.edge_bet_cent_pos = edge_bet_cent_pos;
                out.fullmat_graph_meas.edge_bet_cent_neg = edge_bet_cent_neg;
                clear edge_bet_cent_pos edge_bet_cent_neg
            end
            if calc_props_fullmat.eigvec_cent == 1                                                                                                                                   % If the diversity coefficient was calculated
                out.fullmat_graph_meas.eigvec_cent_pos = eigvec_cent_pos;
                out.fullmat_graph_meas.eigvec_cent_neg = eigvec_cent_neg;
                clear eigvec_cent_pos eigvec_cent_neg
            end
            if calc_props_fullmat.loc_eff == 1                                                                                                                                   % If the diversity coefficient was calculated
                out.fullmat_graph_meas.loc_eff_pos = loc_eff_pos;
                out.fullmat_graph_meas.loc_eff_neg = loc_eff_neg;
                clear loc_eff_pos loc_eff_neg
            end
            if calc_props_fullmat.match == 1                                                                                                                                   % If the diversity coefficient was calculated
                out.fullmat_graph_meas.match_pos = match_pos;
                out.fullmat_graph_meas.match_neg = match_neg;
                clear match_pos match_neg
            end
            if calc_props_fullmat.node_bet_cent == 1                                                                                                                             % If node betweeness centrality  was calculated
                out.fullmat_graph_meas.node_bet_cent_pos = node_bet_cent_pos;
                out.fullmat_graph_meas.node_bet_cent_neg = node_bet_cent_neg;
                clear node_bet_cent_pos node_bet_cent_neg
            end
            if calc_props_fullmat.strength == 1                                                                                                                                      % If node strength was calculated
                out.fullmat_graph_meas.strength_pos    = strength_pos;
                out.fullmat_graph_meas.strength_neg    = strength_neg;
                out.fullmat_graph_meas.strength_totpos = strength_totpos;
                out.fullmat_graph_meas.strength_totneg = strength_totneg;
                clear strength_pos strength_neg strength_totpos strength_totneg
            end
            if calc_props_fullmat.pagerank_cent == 1                                                                                                                                 % If the diversity coefficient was calculated
                out.fullmat_graph_meas.pagerank_cent_pos = pagerank_cent_pos;
                out.fullmat_graph_meas.pagerank_cent_neg = pagerank_cent_neg;
                clear pagerank_cent_pos pagerank_cent_neg
            end
            if calc_props_fullmat.part_coef == 1                                                                                                                                     % If the participation coefficient was calculated
                out.fullmat_graph_meas.part_coef_pos = part_coef_pos;
                out.fullmat_graph_meas.part_coef_neg = part_coef_neg;
                clear part_coef_pos part_coef_neg
            end
            if calc_props_fullmat.rich_club == 1                                                                                                                                     % If the participation coefficient was calculated
                out.fullmat_graph_meas.rich_club_pos = rich_club_pos;
                out.fullmat_graph_meas.rich_club_neg = rich_club_neg;
                clear rich_club_pos rich_club_neg
            end
            if calc_props_fullmat.trans == 1                                                                                                                                     % If the participation coefficient was calculated
                out.fullmat_graph_meas.trans_pos = trans_pos;
                out.fullmat_graph_meas.trans_neg = trans_neg;
                clear trans_pos trans_neg
            end
            if calc_props_fullmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score was calculated
                out.fullmat_graph_meas.mod_deg_z_pos = mod_deg_z_pos;
                out.fullmat_graph_meas.mod_deg_z_neg = mod_deg_z_neg;
                clear mod_deg_z_pos mod_deg_z_neg
            end
        else
            if calc_props_fullmat.assort == 1                                                                                                                                        % If assortativity was calculated
                out.fullmat_graph_meas.assort_pos = assort_pos;
                clear assort_pos
            end
            if calc_props_fullmat.cpl == 1                                                                                                                                   % If only the characteristic path length was calculated
                out.fullmat_graph_meas.cpl_pos = cpl_pos;
                clear cpl_pos
            end
            if calc_props_fullmat.clust_coef == 1                                                                                                                                   % If only the characteristic path length was calculated
                out.fullmat_graph_meas.clust_coef_pos = clust_coef_pos;
                clear clust_coef_pos
            end
            if calc_props_fullmat.glob_eff == 1                                                                                                                                         % If only the global efficiency was calculated
                out.fullmat_graph_meas.glob_eff_pos = glob_eff_pos;
                clear glob_eff_pos
            end
            if calc_props_fullmat.div_coef == 1                                                                                                                                      % If the diversity coefficient was calculated
                out.fullmat_graph_meas.div_coef_pos = div_coef_pos;
                clear div_coef_pos
            end
            if calc_props_fullmat.edge_bet_cent == 1                                                                                                                             % If edge betweeness centrality  was calculated
                out.fullmat_graph_meas.edge_bet_cent_pos = edge_bet_cent_pos;
                clear edge_bet_cent_pos
            end
            if calc_props_fullmat.eigvec_cent == 1                                                                                                                                   % If the diversity coefficient was calculated
                out.fullmat_graph_meas.eigvec_cent_pos = eigvec_cent_pos;
                clear eigvec_cent_pos
            end
            if calc_props_fullmat.loc_eff == 1                                                                                                                                   % If the diversity coefficient was calculated
                out.fullmat_graph_meas.loc_eff_pos = loc_eff_pos;
                clear loc_eff_pos
            end
            if calc_props_fullmat.match == 1                                                                                                                                   % If the diversity coefficient was calculated
                out.fullmat_graph_meas.match_pos = match_pos;
                clear match_pos
            end
            if calc_props_fullmat.node_bet_cent == 1                                                                                                                             % If node betweeness centrality  was calculated
                out.fullmat_graph_meas.node_bet_cent_pos = node_bet_cent_pos;
                clear node_bet_cent_pos
            end
            if calc_props_fullmat.strength == 1                                                                                                                                      % If node strength was calculated
                out.fullmat_graph_meas.strength_pos    = strength_pos;
                out.fullmat_graph_meas.strength_totpos = strength_totpos;
                clear strength_pos strength_totpos
            end
            if calc_props_fullmat.pagerank_cent == 1                                                                                                                                 % If the diversity coefficient was calculated
                out.fullmat_graph_meas.pagerank_cent_pos = pagerank_cent_pos;
                clear pagerank_cent_pos
            end
            if calc_props_fullmat.part_coef == 1                                                                                                                                     % If the participation coefficient was calculated
                out.fullmat_graph_meas.part_coef_pos = part_coef_pos;
                clear part_coef_pos
            end
            if calc_props_fullmat.rich_club == 1                                                                                                                                     % If the participation coefficient was calculated
                out.fullmat_graph_meas.rich_club_pos = rich_club_pos;
                clear rich_club_pos
            end
            if calc_props_fullmat.trans == 1                                                                                                                                     % If the participation coefficient was calculated
                out.fullmat_graph_meas.trans_pos = trans_pos;
                clear trans_pos
            end
            if calc_props_fullmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score was calculated
                out.fullmat_graph_meas.mod_deg_z_pos = mod_deg_z_pos;
                clear mod_deg_z_pos
            end
        end
    else
        for rep_lev         = out.num_rep_levs:-1:1                                                                                                                                        % Loop through each repeated level
            for curr_sub    = 1:out.num_subs                                                                                                                                                 % Loop through each participant
                curr_conmat = squeeze(out.conmats(:,:,curr_sub,rep_lev));                                                                                                                    % Extract connectivity matrix for current participant
                
                if out.use_abs_val == 0
                    if out.calc_props_fullmat.assort == 1                                                                                                                                        % If assortativity should be calculated
                        [out.fullmat_graph_meas.assort_pos(curr_sub,rep_lev),out.fullmat_graph_meas.assort_neg(curr_sub,rep_lev)] = assortativity_wei_sign(curr_conmat);                                                                                      % Each output should be 1 number
                    end
                    
                    if out.calc_props_fullmat.cpl == 1 || out.calc_props_fullmat.glob_eff == 1 || out.calc_props_fullmat.edge_bet_cent == 1 || out.calc_props_fullmat.node_bet_cent == 1                                                                                    % If either node or edge betweeness centrality should be calculated
                        length_mat = weight_conversion(curr_conmat,'lengths');                                                                                                                   % Convert weights to lengths
                        
                        if out.calc_props_fullmat.cpl == 1 || out.calc_props_fullmat.glob_eff == 1                                                                                                   % If either the characteristic path length or global efficiency should be calculated
                            if out.calc_props_fullmat.cpl == 1 && out.calc_props_fullmat.glob_eff == 1                                                                                               % If both should be calculated
                                [out.fullmat_graph_meas.cpl_pos(curr_sub,rep_lev),out.fullmat_graph_meas.cpl_neg(curr_sub,rep_lev), ...
                                    out.fullmat_graph_meas.glob_eff_pos(curr_sub,rep_lev),out.fullmat_graph_meas.glob_eff_neg(curr_sub,rep_lev)] = charpath_sign(length_mat);                                               % Each output should be 1 number
                            elseif out.calc_props_fullmat.cpl == 1                                                                                                                                   % If only characteristic path length should be calculated
                                [out.fullmat_graph_meas.cpl_pos(curr_sub,rep_lev),out.fullmat_graph_meas.cpl_neg(curr_sub,rep_lev)]        = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            else                                                                                                                                                                     % If only global efficiency should be calculated
                                [~,~,out.fullmat_graph_meas.glob_eff_pos(curr_sub,rep_lev),out.fullmat_graph_meas.glob_eff_neg(curr_sub,rep_lev)] = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            end
                        end
                        
                        if out.calc_props_fullmat.node_bet_cent == 1                                                                                                                             % If node betweeness centrality  should be calculated
                            [out.fullmat_graph_meas.node_bet_cent_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.node_bet_cent_neg(curr_sub,:,rep_lev)]   = betweenness_wei_sign(length_mat);                                                                            % Each output should be vector of size #ROIs
                        end
                        
                        if out.calc_props_fullmat.edge_bet_cent == 1                                                                                                                             % If edge betweeness centrality  should be calculated
                            [out.fullmat_graph_meas.edge_bet_cent_pos(curr_sub,:,:,rep_lev),out.fullmat_graph_meas.edge_bet_cent_neg(curr_sub,:,:,rep_lev)] = edge_betweenness_wei_sign(length_mat);                                                                       % Each output should be square matrix of size #ROIs
                        end
                    end
                    
                    if out.calc_props_fullmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                        [out.fullmat_graph_meas.clust_coef_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.clust_coef_neg(curr_sub,:,rep_lev)] = clustering_coef_wu_sign(curr_conmat);                                        % Each output should be vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.div_coef == 1                                                                                                                                      % If the diversity coefficient should be calculated
                        [out.fullmat_graph_meas.div_coef_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.div_coef_neg(curr_sub,:,rep_lev)] = diversity_coef_sign(curr_conmat,out.mod_grps);       % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.eigvec_cent == 1                                                                                                                                   % If the diversity coefficient should be calculated
                        [out.fullmat_graph_meas.eigvec_cent_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.eigvec_cent_neg(curr_sub,:,rep_lev)] = eigenvector_centrality_und_sign(curr_conmat);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                        [out.fullmat_graph_meas.loc_eff_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.loc_eff_neg(curr_sub,:,rep_lev)] = efficiency_wei_sign(curr_conmat,1);                                             % Each output should be vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.match == 1                                                                                                             % If the matching index should be calculated
                        [out.fullmat_graph_meas.match_pos(curr_sub,:,:,rep_lev),out.fullmat_graph_meas.match_neg(curr_sub,:,:,rep_lev)] = matching_ind_und_sign(curr_conmat);                                             % Each output should be square matrix of of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.strength == 1                                                                                                                                      % If node strength should be calculated
                        [out.fullmat_graph_meas.strength_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.strength_neg(curr_sub,:,rep_lev), ...
                            out.fullmat_graph_meas.strength_totpos(curr_sub,rep_lev),out.fullmat_graph_meas.strength_totneg(curr_sub,rep_lev)] = strengths_und_sign(curr_conmat);                % Produces four outputs, two describe entire network, two describe each node
                    end
                    
                    if out.calc_props_fullmat.pagerank_cent == 1                                                                                                                                 % If the diversity coefficient should be calculated
                        [out.fullmat_graph_meas.pagerank_cent_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.pagerank_cent_neg(curr_sub,:,rep_lev)] = pagerank_centrality_sign(curr_conmat,0.85);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                        [out.fullmat_graph_meas.part_coef_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.part_coef_neg(curr_sub,:,rep_lev)] = participation_coef_sign(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.rich_club == 1                                                                                                         % If rich club networks should be calculated
                        if exist('out.max_club_size','var')                                                                                                  % If the user has specified a maximum density
                            [out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev},out.fullmat_graph_meas.rich_club_neg{curr_sub,rep_lev}] = rich_club_wu_sign(curr_conmat,out.max_club_size);                           % Each output should be vector of size max density
                        else                                                                                                                                 % If not
                            [out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev},out.fullmat_graph_meas.rich_club_neg{curr_sub,rep_lev}] = rich_club_wu_sign(curr_conmat);                                             % Each output should be vector of size of max density
                        end
                    end
                    
                    if out.calc_props_fullmat.trans == 1                                                                                                             % If transitivity should be calculated
                        [out.fullmat_graph_meas.trans_pos(curr_sub,rep_lev),out.fullmat_graph_meas.trans_neg(curr_sub,rep_lev)] = transitivity_wu_sign(curr_conmat);                                                  % Each output should be 1 number
                    end
                    
                    if out.calc_props_fullmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                        [out.fullmat_graph_meas.mod_deg_z_pos(curr_sub,:,rep_lev),out.fullmat_graph_meas.mod_deg_z_neg(curr_sub,:,rep_lev)] = module_degree_zscore_sign(curr_conmat,out.mod_grps);                                                                 % Each output should be vector of size #ROIs
                    end
                    
                    prog = (curr_sub/out.num_subs)*(1-((rep_lev-1)/out.num_rep_levs));                                                                                                         % Calculate progress
                    if out.calcthrmat == 1
                        progressbar(prog,[],[])                                                                                                                                                      % Update progress bar
                    else
                        progressbar(prog)                                                                                                                                                      % Update progress bar
                    end
                    
                else
                    if out.calc_props_fullmat.assort == 1                                                                                                                                        % If assortativity should be calculated
                        out.fullmat_graph_meas.assort_pos(curr_sub,rep_lev) = assortativity_wei_sign(curr_conmat);                                                                                      % Each output should be 1 number
                    end
                    
                    if out.calc_props_fullmat.cpl == 1 || out.calc_props_fullmat.glob_eff == 1 || out.calc_props_fullmat.edge_bet_cent == 1 || out.calc_props_fullmat.node_bet_cent == 1                                                                                    % If either node or edge betweeness centrality should be calculated
                        length_mat = weight_conversion(curr_conmat,'lengths');                                                                                                                   % Convert weights to lengths
                        
                        if out.calc_props_fullmat.cpl == 1 || out.calc_props_fullmat.glob_eff == 1                                                                                                   % If either the characteristic path length or global efficiency should be calculated
                            if out.calc_props_fullmat.cpl == 1 && out.calc_props_fullmat.glob_eff == 1                                                                                               % If both should be calculated
                                [out.fullmat_graph_meas.cpl_pos(curr_sub,rep_lev),~, ...
                                    out.fullmat_graph_meas.glob_eff_pos(curr_sub,rep_lev)] = charpath_sign(length_mat);                                               % Each output should be 1 number
                            elseif out.calc_props_fullmat.cpl == 1                                                                                                                                   % If only the characteristic path length should be calculated
                                out.fullmat_graph_meas.cpl_pos(curr_sub,rep_lev) = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            else                                                                                                                                                                     % If only the global efficiency should be calculated
                                [~,~,out.fullmat_graph_meas.glob_eff_pos(curr_sub,rep_lev)] = charpath_sign(length_mat);                                                                                          % Each output should be 1 number
                            end
                        end
                        
                        if out.calc_props_fullmat.node_bet_cent == 1                                                                                                                             % If node betweeness centrality  should be calculated
                            out.fullmat_graph_meas.node_bet_cent_pos(curr_sub,:,rep_lev)   = betweenness_wei_sign(length_mat);                                                                            % Each output should be vector of size #ROIs
                        end
                        
                        if out.calc_props_fullmat.edge_bet_cent == 1                                                                                                                             % If edge betweeness centrality  should be calculated
                            out.fullmat_graph_meas.edge_bet_cent_pos(curr_sub,:,:,rep_lev) = edge_betweenness_wei_sign(length_mat);                                                                       % Each output should be square matrix of size #ROIs
                        end
                    end
                    
                    if out.calc_props_fullmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                        out.fullmat_graph_meas.clust_coef_pos(curr_sub,:,rep_lev) = clustering_coef_wu_sign(curr_conmat);                                        % Each output should be vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.div_coef == 1                                                                                                                                      % If the diversity coefficient should be calculated
                        out.fullmat_graph_meas.div_coef_pos(curr_sub,:,rep_lev) = diversity_coef_sign(curr_conmat,out.mod_grps);       % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.eigvec_cent == 1                                                                                                                                   % If the diversity coefficient should be calculated
                        out.fullmat_graph_meas.eigvec_cent_pos(curr_sub,:,rep_lev) = eigenvector_centrality_und_sign(curr_conmat);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                        out.fullmat_graph_meas.loc_eff_pos(curr_sub,:,rep_lev) = efficiency_wei_sign(curr_conmat,1);                                             % Each output should be vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.match == 1                                                                                                             % If the matching index should be calculated
                        out.fullmat_graph_meas.match_pos(curr_sub,:,:,rep_lev) = matching_ind_und_sign(curr_conmat);                                             % Each output should be square matrix of of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.strength == 1                                                                                                                                      % If node strength should be calculated
                        [out.fullmat_graph_meas.strength_pos(curr_sub,:,rep_lev),~, ...
                            out.fullmat_graph_meas.strength_totpos(curr_sub,rep_lev)] = strengths_und_sign(curr_conmat);                % Produces four outputs, two describe entire network, two describe each node
                    end
                    
                    if out.calc_props_fullmat.pagerank_cent == 1                                                                                                                                 % If the diversity coefficient should be calculated
                        out.fullmat_graph_meas.pagerank_cent_pos(curr_sub,:,rep_lev) = pagerank_centrality_sign(curr_conmat,0.85);                                                                        % Produces vector of size #ROIs
                    end
                    
                    if out.calc_props_fullmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                        out.fullmat_graph_meas.part_coef_pos(curr_sub,:,rep_lev) = participation_coef_sign(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                    end
                    if out.calc_props_fullmat.rich_club == 1                                                                                                         % If rich club networks should be calculated
                        if exist('out.max_club_size','var')                                                                                                  % If the user has specified a maximum density
                            out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev} = rich_club_wu_sign(curr_conmat,out.max_club_size);                           % Each output should be vector of size max density
                        else                                                                                                                                 % If not
                            out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev} = rich_club_wu_sign(curr_conmat);                                             % Each output should be vector of size of max density
                        end
                    end
                    
                    if out.calc_props_fullmat.trans == 1                                                                                                             % If transitivity should be calculated
                        out.fullmat_graph_meas.trans_pos(curr_sub,rep_lev) = transitivity_wu_sign(curr_conmat);                                                  % Each output should be 1 number
                    end
                    
                    if out.calc_props_fullmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                        out.fullmat_graph_meas.mod_deg_z_pos(curr_sub,:,rep_lev) = module_degree_zscore_sign(curr_conmat,out.mod_grps);                                                                 % Each output should be vector of size #ROIs
                    end
                    
                    prog = (curr_sub/out.num_subs)*(1-((rep_lev-1)/out.num_rep_levs));                                                                                                         % Calculate progress
                    if out.calcthrmat == 1
                        progressbar(prog,[],[])                                                                                                                                                      % Update progress bar
                    else
                        progressbar(prog)                                                                                                                                                      % Update progress bar
                    end
                end
            end
        end
    end
    
    
    if out.calc_props_fullmat.rich_club == 1                                                                                                            % If rich club networks were calculated
        %%%% Calculate maximum club size based on data if none provided
        if out.use_abs_val == 0
            if isfield(out,'max_club_size')                                                                                                             % If max was provided
                out.max_club_size_full_pos = out.max_club_size;
                out.max_club_size_full_neg = out.max_club_size;
            else
                out.max_club_size_full_pos = 10000;                                                                                                                   % Set starting value as way higher than it could be
                out.max_club_size_full_neg = 10000;                                                                                                                   % Set starting value as way higher than it could be
                for rep_lev = 1:out.num_rep_levs                                                                                                           % Loop on repeated levels
                    for curr_sub = 1:out.num_subs                                                                                                        % Loop on participants
                        if length(out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev}) < out.max_club_size_full_pos                                           % If this max is less than the current threshold
                            out.max_club_size_full_pos = length(out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev});                                         % Set new threshold
                        end
                        
                        if length(out.fullmat_graph_meas.rich_club_neg{curr_sub,rep_lev}) < out.max_club_size_full_neg                                           % If this max is less than the current threshold
                            out.max_club_size_full_neg = length(out.fullmat_graph_meas.rich_club_neg{curr_sub,rep_lev});                                         % Set new threshold
                        end
                    end
                end
            end
            
            for rep_lev = 1:out.num_rep_levs                                                                                                           % Loop on repeated levels
                for curr_sub = out.num_subs:-1:1                                                                                                        % Loop on participants
                    temp_rcp(curr_sub,:,rep_lev) = out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev}(1:out.max_club_size_full_pos);
                    temp_rcn(curr_sub,:,rep_lev) = out.fullmat_graph_meas.rich_club_neg{curr_sub,rep_lev}(1:out.max_club_size_full_neg);
                end
            end
            
            out.fullmat_graph_meas.rich_club_pos = temp_rcp;
            out.fullmat_graph_meas.rich_club_neg = temp_rcn;
        else
            if isfield(out,'max_club_size')                                                                                                             % If max was provided
                out.max_club_size_full_pos = out.max_club_size;
            else
                out.max_club_size_full_pos = 10000;                                                                                                                   % Set starting value as way higher than it could be
                for rep_lev = 1:out.num_rep_levs                                                                                                           % Loop on repeated levels
                    for curr_sub = 1:out.num_subs                                                                                                        % Loop on participants
                        if length(out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev}) < out.max_club_size_full_pos                                           % If this max is less than the current threshold
                            out.max_club_size_full_pos = length(out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev});                                         % Set new threshold
                        end
                    end
                end
            end
            
            for rep_lev = 1:out.num_rep_levs                                                                                                           % Loop on repeated levels
                for curr_sub = out.num_subs:-1:1                                                                                                        % Loop on participants
                    temp_rcp(curr_sub,:,rep_lev) = out.fullmat_graph_meas.rich_club_pos{curr_sub,rep_lev}(1:out.max_club_size_full_pos);
                end
            end
            
            out.fullmat_graph_meas.rich_club_pos = temp_rcp;
        end
    end
    
    fprintf('Done calculating properties for fully connected matrices!\n\n')                                                                                                             % Alert user
end




%%%%%%%%%%%%%%%%%%%%% Thresholded networks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if out.calcthrmat == 1             % If any properties for thresholded networks should be calculated
    
    if isempty(out.denscalc_varmat)
        for rep_lev = out.num_rep_levs:-1:1                                          % For each repeated level
            full_mean_conmat_pos(:,:,rep_lev) = create_mean_conmats(out.conmats(:,:,:,rep_lev)); % Calculate mean connectivity matrix
            full_mean_conmat_pos(full_mean_conmat_pos < 0) = 0;
            full_density_pos(rep_lev) = find_min_graph_density(full_mean_conmat_pos(:,:,rep_lev)); % Find the minumum density at which the mean network remains connected
        end
        out.min_dens_pos = ceil(100*max(full_density_pos(:)))/100;              % Note minimum density
        
        if out.use_abs_val == 0
            for rep_lev = out.num_rep_levs:-1:1                                    % For each repeated level
                full_mean_conmat_neg(:,:,rep_lev) = create_mean_conmats(-out.conmats(:,:,:,rep_lev)); % Calculate mean connectivity matrix
                full_mean_conmat_neg(full_mean_conmat_neg < 0) = 0;
                full_density_neg(rep_lev) = find_min_graph_density(full_mean_conmat_neg(:,:,rep_lev)); % Find the minumum density at which the mean network remains connected
            end
            out.min_dens_neg = ceil(100*max(full_density_neg(:)))/100;          % Note minimum density
        end
        
    else
        if strcmp(out.partial_for_min_dens,'Yes')                                    % If the IVs should be partialed
            if rank([out.denscalc_varmat,out.denscalc_covarmat,ones(size(out.denscalc_varmat,1),1)]) == (size([out.denscalc_varmat,out.denscalc_covarmat],2)+1) % If an intercept can be added without making the design matrix rank deficient
                out.denscalc_covarmat = [out.denscalc_covarmat,ones(size(out.denscalc_varmat,1),1)];
                out.denscalc_covar_names = [out.denscalc_covar_names, 'intercept'];
            end
            min_dens_calc_vars = [];                                                 % Set empty matrix to start
            for var = size(out.denscalc_varmat,2):-1:1                               % For each IV (reverse indexed so min_dens_calc_vars is preallocated upon creation)
                des_part_ivs = [out.denscalc_covarmat,out.denscalc_varmat(:,setdiff((1:size(out.denscalc_varmat,2)),var))]; % Determine covariates to partial
                des_part_dv = out.denscalc_varmat(:,var);                            % Extract current IV from which to partial shared variance
                [~,~,min_dens_calc_vars(:,var)] = regress(des_part_dv,des_part_ivs); % Partial shared variance
            end
        else                                                                         % If IVs should not be partialed
            min_dens_calc_vars = out.denscalc_varmat;                                % Set matrix full variables
        end
                
        %%%% Find the minimum density. This is done by creating several
        %%%% mean networks, finding the minumum density at which each
        %%%% remains connected, taking the maximum value (which should be
        %%%% valid for all networks examined). Besides the overall mean 
        %%%% network, networks are created by stratifying each of the IVs
        %%%% selected above into groups (# og groups depending on the total
        %%%% N), and creating mean networks for each of these groups. This,
        %%%% stratification is done to avoid the mean density being invalid
        %%%% for a subset of participants (e.g., those who are high on some
        %%%% IV), which bias tests for that IV
        if out.num_subs <= 20                           % If the total N is 15 or less
            min_dens_num_grps = 1;                      % Create 1 group for each IV
        elseif out.num_subs <= 89                       % If the total N is between 20 & 89
            min_dens_num_grps = floor(out.num_subs/20); % Create 1 group for every ~20 participants
        else
            min_dens_num_grps = floor(out.num_subs/30); % Create 1 group for every 30 participants
        end
        
        if min_dens_num_grps == 1
            for rep_lev = out.num_rep_levs:-1:1                                        % For each repeated level
                full_mean_conmat_pos(:,:,rep_lev) = create_mean_conmats(out.conmats(:,:,:,rep_lev)); % Calculate mean connectivity matrix
                full_mean_conmat_pos(full_mean_conmat_pos < 0) = 0;
                full_density_pos(rep_lev) = find_min_graph_density(full_mean_conmat_pos(:,:,rep_lev)); % Find the minumum density at which the mean network remains connected
            end
            out.min_dens_pos = ceil(100*max(full_density_pos(:)))/100;              % Note minimum density
            
            if out.use_abs_val == 0
                for rep_lev = out.num_rep_levs:-1:1                                    % For each repeated level
                    full_mean_conmat_neg(:,:,rep_lev) = create_mean_conmats(-out.conmats(:,:,:,rep_lev)); % Calculate mean connectivity matrix
                    full_mean_conmat_neg(full_mean_conmat_neg < 0) = 0;
                    full_density_neg(rep_lev) = find_min_graph_density(full_mean_conmat_neg(:,:,rep_lev)); % Find the minumum density at which the mean network remains connected
                end
                out.min_dens_neg = ceil(100*max(full_density_neg(:)))/100;          % Note minimum density
                out.neg_mindens_nan = 0;
                if isnan(out.min_dens_neg)
                    out.neg_mindens_nan = 1;
                end
            end
        else
            for rep_lev = out.num_rep_levs:-1:1                                        % Loop on repeated levels
                for var = size(min_dens_calc_vars,2):-1:1                                % For each IV to use
                    [full_mean_conmat_pos(:,:,rep_lev),grp_mean_conmats_pos(:,:,:,rep_lev)] = create_mean_conmats(out.conmats(:,:,:,rep_lev),min_dens_calc_vars(:,var),1,'-num_grps',min_dens_num_grps); % Create an overall mean connectivity matrix and mean matrices for each subgrouping
                    full_mean_conmat_pos(full_mean_conmat_pos < 0) = 0;
                    grp_mean_conmats_pos(grp_mean_conmats_pos < 0) = 0;
                    full_density_pos(var,rep_lev) = find_min_graph_density(full_mean_conmat_pos(:,:,rep_lev)); % Find minimum density for overall mean network
                    for grp = min_dens_num_grps:-1:1                                     % Loop on # of subgroups
                        grp_density_pos(var,grp,rep_lev) = find_min_graph_density(squeeze(grp_mean_conmats_pos(:,:,grp,rep_lev))); % Find minimum density for each subgroups network
                    end
                end
            end
            out.min_dens_pos = ceil(100*max(max(full_density_pos(:)),max(grp_density_pos(:))))/100;                % Find maximum of all the minima
            
            if out.use_abs_val == 0
                [full_mean_conmat_neg(:,:,rep_lev),grp_mean_conmats_neg(:,:,:,rep_lev)] = create_mean_conmats(-out.conmats(:,:,:,rep_lev),min_dens_calc_vars(:,var),1,'-num_grps',min_dens_num_grps); % Create an overall mean connectivity matrix and mean matrices for each subgrouping
                full_mean_conmat_neg(full_mean_conmat_neg < 0) = 0;
                grp_mean_conmats_neg(grp_mean_conmats_neg < 0) = 0;
                for rep_lev = out.num_rep_levs:-1:1                                                              % Loop on repeated levels
                    for var = size(min_dens_calc_vars,2):-1:1                                                      % For each IV to use
                        full_density_neg(var,rep_lev) = find_min_graph_density(full_mean_conmat_neg(:,:,rep_lev)); % Find minimum density for overall mean network
                        for grp = min_dens_num_grps:-1:1                                                           % Loop on # of subgroups
                            grp_density_neg(var,grp,rep_lev) = find_min_graph_density(squeeze(grp_mean_conmats_neg(:,:,grp,rep_lev))); % Find minimum density for each subgroups network
                        end
                    end
                end
                out.min_dens_neg = ceil(100*max(max(full_density_neg(:)),max(grp_density_neg(:))))/100;            % Find maximum of all the minima
                out.neg_mindens_nan = 0;
                if isnan(out.min_dens_neg)
                    out.neg_mindens_nan = 1;
                end
            end
        end
    end
    
    for rep_lev = out.num_rep_levs:-1:1                                                                                                   % Loop on repeated levels
        max_dens_pos(rep_lev) = density_und(weight_conversion(threshold_absolute(full_mean_conmat_pos(:,:,rep_lev),0),'binarize'));
    end
    if out.max_dens_pos > min(max_dens_pos(:))
        out.max_dens_pos = floor(100*min(max_dens_pos(:)))/100;
        fprintf('Warning: Requested maximum density could not be reached for positive weights\n')
    end
    if mod((out.max_dens_pos-out.min_dens_pos),out.dens_step_pos) ~= 0
        out.dens_step_pos = (out.max_dens_pos-out.min_dens_pos)/floor((out.max_dens_pos-out.min_dens_pos)/out.dens_step_pos);                                                               % Find an appropriate step size close to that which they entered
    end
    out.dens_pos = out.min_dens_pos:out.dens_step_pos:out.max_dens_pos; % Calculate all the densities to use
    
    if out.use_abs_val == 0 && out.neg_mindens_nan == 0
        for rep_lev = out.num_rep_levs:-1:1                                                                                                   % Loop on repeated levels
            max_dens_neg(rep_lev) = density_und(weight_conversion(threshold_absolute(full_mean_conmat_neg(:,:,rep_lev),0),'binarize'));
        end
        if out.max_dens_neg > min(max_dens_neg(:))
            out.max_dens_neg = floor(100*min(max_dens_neg(:)))/100;
            fprintf('Warning: Requested maximum density could not be reached for negative weights\n')
        end
        if mod((out.max_dens_neg-out.min_dens_neg),out.dens_step_neg) ~= 0
            out.dens_step_neg = (out.max_dens_neg-out.min_dens_neg)/floor((out.max_dens_neg-out.min_dens_neg)/out.dens_step_neg);                                                               % Find an appropriate step size close to that which they entered
        end
        out.dens_neg = out.min_dens_neg:out.dens_step_neg:out.max_dens_neg; % Calculate all the densities to use
    end
    
    min_diff = 0.0001;                                                       % Tolerance for what is considered acceptably close to the currently acceptable density (this might need to be increased for networks with a small # of nodes)
    min_step = 0.00000001;                                                   % Step minimum step size (for increasing/decreasing threshold) before the script will give up
    
    %%%% Threshold at different densities
    conmats_pos = out.conmats;
    conmats_pos(conmats_pos < 0) = 0;
    
    threshed_conmats_pos = zeros([size(out.conmats,1),size(out.conmats,2),size(out.conmats,3),length(out.dens_pos),size(out.conmats,4)]);                         % Preallocate
    for rep_lev = out.num_rep_levs:-1:1                                                                                                   % Loop on repeated levels
        for curr_dens = 1:length(out.dens_pos)                                                                                            % For each density level
            curr_targ = out.dens_pos(curr_dens);                                                                                          % Set current target density
            thr = 0.5;                                                                                                                    % Set starting threshold
            step = 0.5;                                                                                                                   % Set starting step size
            diff = curr_targ-density_und(weight_conversion(threshold_absolute(full_mean_conmat_pos(:,:,rep_lev),thr),'binarize')); % Find starting difference between current density and target
            while (abs(diff) > min_diff) && (step > min_step)                                                                             % While the current density is not acceptably close to the target density
                if sign(diff) == -1                                                                                                       % If the sign of the difference is negative
                    while sign(diff) == -1                                                                                                % Loop until the difference becomes positive
                        thr = thr+step;                                                                                                   % Increase the threshold by the step size
                        diff = curr_targ-density_und(weight_conversion(threshold_absolute(full_mean_conmat_pos(:,:,rep_lev),thr),'binarize')); % Find current difference
                    end
                else                                                                                                                      % If the sign of the difference is positive
                    while sign(diff) == 1                                                                                                 % Loop until the difference becomes negative
                        thr = thr-step;                                                                                                   % Decrease the threshold by the step size
                        diff = curr_targ-density_und(weight_conversion(threshold_absolute(full_mean_conmat_pos(:,:,rep_lev),thr),'binarize')); % Find current difference
                    end
                end
                step = step/2;                                                                                                            % Reduce step size by half
            end
            temp_mats = conmats_pos(:,:,:,rep_lev);                                                                                           % Get unthresholded matrices
            temp_mats(temp_mats < thr) = 0;                                                                                               % Threshold
            threshed_conmats_pos(:,:,:,curr_dens,rep_lev) = temp_mats;                                                                        % Record thresholded matrices
            for curr_sub = 1:out.num_subs
                out.connected_nets_pos(curr_sub,curr_dens,rep_lev) = isempty(find(reachdist(weight_conversion(threshed_conmats_pos(:,:,curr_sub,curr_dens,rep_lev),'binarize')) == 0,1));
            end
        end
        clear temp_mats
    end
    
    if out.use_abs_val == 0 && out.neg_mindens_nan == 0
        conmats_neg = -out.conmats;
        conmats_neg(conmats_neg < 0) = 0;
        
        threshed_conmats_neg = zeros([size(out.conmats,1),size(out.conmats,2),size(out.conmats,3),length(out.dens_neg),size(out.conmats,4)]);   % Preallocate
        for rep_lev = out.num_rep_levs:-1:1                                                                                                     % Loop on repeated levels
            for curr_dens = 1:length(out.dens_neg)                                                                                              % For each density level
                curr_targ = out.dens_neg(curr_dens);                                                                                            % Set current target density
                thr = 0.5;                                                                                                                      % Set starting threshold
                step = 0.5;                                                                                                                     % Set starting step size
                diff = curr_targ-density_und(weight_conversion(threshold_absolute(full_mean_conmat_neg(:,:,rep_lev),thr),'binarize')); % Find starting difference between current density and target
                while (abs(diff) > min_diff) && (step > min_step)                                                                               % While the current density is not acceptably close to the target density
                    if sign(diff) == -1                                                                                                         % If the sign of the difference is negative
                        while sign(diff) == -1                                                                                                  % Loop until the difference becomes positive
                            thr = thr+step;                                                                                                     % Increase the threshold by the step size
                            diff = curr_targ-density_und(weight_conversion(threshold_absolute(full_mean_conmat_neg(:,:,rep_lev),thr),'binarize')); % Find current difference
                        end
                    else                                                                                                                        % If the sign of the difference is positive
                        while sign(diff) == 1                                                                                                   % Loop until the difference becomes negative
                            thr = thr-step;                                                                                                     % Decrease the threshold by the step size
                            diff = curr_targ-density_und(weight_conversion(threshold_absolute(full_mean_conmat_neg(:,:,rep_lev),thr),'binarize')); % Find current difference
                            if thr < 0
                                thr = NaN;
                                break;
                            end
                        end
                    end
                    step = step/2;                                                                                                              % Reduce step size by half
                    if thr < 0
                        thr = NaN;
                        break;
                    end
                end
                temp_mats = conmats_neg(:,:,:,rep_lev);                                                                                         % Get unthresholded matrices
                temp_mats(temp_mats < thr) = 0;                                                                                                 % Threshold
                threshed_conmats_neg(:,:,:,curr_dens,rep_lev) = temp_mats;                                                                      % Record thresholded matrices
                for curr_sub = 1:out.num_subs
                    out.connected_nets_neg(curr_sub,curr_dens,rep_lev) = isempty(find(reachdist(weight_conversion(threshed_conmats_neg(:,:,curr_sub,curr_dens,rep_lev),'binarize')) == 0,1));
                end
            end
            clear temp_mats
        end
    end
    
    fprintf('Calculating properties for thresholded matrices ...\n')                                                                          % Let user know about progress
    
    %%%% Calculate network measures for each participant, for each
    %%%% threshold
    if use_parfor
        calc_props_thrmat = out.calc_props_thrmat;
        for rep_lev = out.num_rep_levs:-1:1                                                                                                                % Loop on repeated levels
            for curr_dens = 1:size(threshed_conmats_pos,4)                                                                                                       % Loop on densities
                parfor curr_sub = 1:out.num_subs                                                                                                                % Loop through each participant
                    curr_conmat = squeeze(threshed_conmats_pos(:,:,curr_sub,curr_dens,rep_lev));                                                                 % Extract connectivity matrix for current participant
                    
                    if calc_props_thrmat.assort == 1                                                                                                            %#ok<*PFBNS> % If assortativity should be calculated
                        assort_pos(curr_dens,curr_sub,rep_lev) = assortativity_wei(curr_conmat,0);                                             % Each output should be 1 number
                    end
                    
                    if calc_props_thrmat.cpl == 1 || calc_props_thrmat.glob_eff == 1                                                                               % If any properties requiring distance matrices should be calculated
                        dist_mat = distance_wei(weight_conversion(curr_conmat,'lengths'));                                                                   % Calculate distance matrix
                        if calc_props_thrmat.cpl == 1 && calc_props_thrmat.glob_eff == 1                                                                           % If both characteristic path length and global efficiency should be calculated
                            [cpl_pos(curr_dens,curr_sub,rep_lev),glob_eff_pos(curr_dens,curr_sub,rep_lev)] = charpath(dist_mat); % Each output should be 1 number
                        elseif calc_props_thrmat.cpl == 1                                                                                                       % If only characteristic path length should be calculated
                            [cpl_pos(curr_dens,curr_sub,rep_lev)]                                          = charpath(dist_mat);                                                        % Each output should be 1 number
                        else                                                                                                                                 % If only global efficiency should be calculated
                            [~,glob_eff_pos(curr_dens,curr_sub,rep_lev)]                                   = charpath(dist_mat);                                                 % Each output should be 1 number
                        end
                    end
                    
                    if calc_props_thrmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                        clust_coef_pos(curr_dens,curr_sub,:,rep_lev) = clustering_coef_wu(curr_conmat);                                        % Each output should be vector of size #ROIs
                    end
                    
                    if calc_props_thrmat.deg == 1 || calc_props_thrmat.dens == 1 || calc_props_thrmat.kcore_cent == 1 || calc_props_thrmat.sub_cent == 1 || calc_props_thrmat.small_world == 1                % If any properties requiring binary matrices should be calculated
                        bin_conmat                                          = weight_conversion(curr_conmat,'binarize');                                                                              % Calcualte binary matrices
                        if calc_props_thrmat.deg == 1                                                                                                           % If degree should be calculated
                            deg_pos(curr_dens,curr_sub,:,rep_lev)           = degrees_und(bin_conmat);                                                   % Each output should be vector of size #ROIs
                        end
                        if calc_props_thrmat.dens == 1                                                                                                          % If density should be calculated
                            dens_pos(curr_dens,curr_sub,rep_lev)            = density_und(bin_conmat);                                                    % Each output should be 1 number
                        end
                        if calc_props_thrmat.kcore_cent == 1                                                                                                          % If k-coreness centrality should be calculated
                            kcore_cent_pos(curr_dens,curr_sub,rep_lev)      = kcoreness_centrality_bu(bin_conmat);                                                    % Each output should be 1 number
                        end
                        if calc_props_thrmat.small_world == 1                                                                                                   % If small-worldness should be calculated
                            small_world_pos(curr_dens,curr_sub,rep_lev)     = HumphriesGurney_smallworldness_bu(bin_conmat);                       % Each output should be 1 number
                        end
                        if calc_props_thrmat.sub_cent == 1                                                                                                      % If subgraph centrality should be calculated
                            subgraph_cent_pos(curr_dens,curr_sub,:,rep_lev) = subgraph_centrality(bin_conmat);                                 % Each output should be vector of size #ROIs
                        end
                    end
                    
                    if calc_props_thrmat.edge_bet_cent == 1 || calc_props_thrmat.node_bet_cent == 1                                                                % If any properties requiring length matrices should be calculated
                        length_mat                                            = weight_conversion(curr_conmat,'lengths');                                                                               % Calculate length matrix
                        if calc_props_thrmat.edge_bet_cent == 1                                                                                                 % If edge betweeness centrality should be calculated
                            edge_bet_cent_pos(curr_dens,curr_sub,:,:,rep_lev) = edge_betweenness_wei(length_mat);                              % Each output should be square matrix of size #ROIs
                        end
                        if calc_props_thrmat.node_bet_cent == 1                                                                                                 % If node betweeness centrality should be calculated
                            node_bet_cent_pos(curr_dens,curr_sub,:,rep_lev)   = betweenness_wei(length_mat);                                     % Each output should be vector of size #ROIs
                        end
                    end
                    
                    if calc_props_thrmat.eigvec_cent == 1                                                                                                       % If eigenvector centrality should be calculated
                        eigvec_cent_pos(curr_dens,curr_sub,:,rep_lev) = eigenvector_centrality_und(curr_conmat);                               % Produces vector of size #ROIs
                    end
                    
                    if calc_props_thrmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                        loc_eff_pos(curr_dens,curr_sub,:,rep_lev) = efficiency_wei(curr_conmat,1);                                             % Each output should be vector of size #ROIs
                    end
                    
                    if calc_props_thrmat.match == 1                                                                                                             % If the matching index should be calculated
                        match_pos(curr_dens,curr_sub,:,:,rep_lev) = matching_ind_und(curr_conmat);                                             % Each output should be square matrix of of size #ROIs
                    end
                    
                    if calc_props_thrmat.pagerank_cent == 1                                                                                                     % If pagerank centrality should be calculated
                        pagerank_cent_pos(curr_dens,curr_sub,:,rep_lev) = pagerank_centrality(curr_conmat,0.85);                               % Produces vector of size #ROIs
                    end
                    
                    if calc_props_thrmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                        part_coef_pos(curr_dens,curr_sub,:,rep_lev) = participation_coef(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if calc_props_thrmat.rich_club == 1                                                                                                         % If rich club networks should be calculated
                        if exist('out.max_club_size','var')                                                                                                  % If the user has specified a maximum density
                            rich_club_pos{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat,out.max_club_size);                           % Each output should be vector of size max density
                        else                                                                                                                                 % If not
                            rich_club_pos{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat);                                             % Each output should be vector of size of max density
                        end
                    end
                    
                    if calc_props_thrmat.trans == 1                                                                                                             % If transitivity should be calculated
                        trans_pos(curr_dens,curr_sub,rep_lev) = transitivity_wu(curr_conmat);                                                  % Each output should be 1 number
                    end
                    
                    if calc_props_thrmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                        mod_deg_z_pos(curr_dens,curr_sub,:,rep_lev) = module_degree_zscore(curr_conmat,out.mod_grps,0);                                                                 % Each output should be vector of size #ROIs
                    end
                end
            end
            
            if calc_props_thrmat.assort == 1                                                                                                            %#ok<*PFBNS> % If assortativity should be calculated
                thrmat_graph_meas.assort_pos        = assort_pos;
                clear assort_pos
            end
            if calc_props_thrmat.cpl == 1                                                                                                       % If only characteristic path length should be calculated
                thrmat_graph_meas.cpl_pos           = cpl_pos;
                clear cpl_pos
            end
            if calc_props_thrmat.glob_eff_pos == 1                                                                                                                        % If only global efficiency should be calculated
                thrmat_graph_meas.glob_eff_pos      = glob_eff_pos;
                clear glob_eff_pos
            end
            if calc_props_thrmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                thrmat_graph_meas.clust_coef_pos    = clust_coef_pos;
                clear clust_coef_pos
            end
            if calc_props_thrmat.deg == 1                                                                                                           % If degree should be calculated
                thrmat_graph_meas.deg_pos           = deg_pos;
                clear deg_pos
            end
            if calc_props_thrmat.dens == 1                                                                                                          % If density should be calculated
                thrmat_graph_meas.dens_pos          = dens_pos;
                clear dens_pos
            end
            if calc_props_thrmat.kcore_cent == 1                                                                                                          % If k-coreness centrality should be calculated
                thrmat_graph_meas.kcore_cent_pos    = kcore_cent_pos;
                clear kcore_cent_pos
            end
            if calc_props_thrmat.small_world == 1                                                                                                   % If small-worldness should be calculated
                thrmat_graph_meas.small_world_pos   = small_world_pos;
                clear small_world_pos
            end
            if calc_props_thrmat.sub_cent == 1                                                                                                      % If subgraph centrality should be calculated
                thrmat_graph_meas.subgraph_cent_pos = subgraph_cent_pos;
                clear subgraph_cent_pos
            end
            if calc_props_thrmat.edge_bet_cent == 1                                                                                                 % If edge betweeness centrality should be calculated
                thrmat_graph_meas.edge_bet_cent_pos = edge_bet_cent_pos;
                clear edge_bet_cent_pos
            end
            if calc_props_thrmat.node_bet_cent == 1                                                                                                 % If node betweeness centrality should be calculated
                thrmat_graph_meas.node_bet_cent_pos = node_bet_cent_pos;
                clear node_bet_cent_pos
            end
            if calc_props_thrmat.eigvec_cent == 1                                                                                                       % If eigenvector centrality should be calculated
                thrmat_graph_meas.eigvec_cent_pos   = eigvec_cent_pos;
                clear eigvec_cent_pos
            end
            if calc_props_thrmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                thrmat_graph_meas.loc_eff_pos       = loc_eff_pos;
                clear loc_eff_pos
            end
            if calc_props_thrmat.match == 1                                                                                                             % If the matching index should be calculated
                thrmat_graph_meas.match_pos         = match_pos;
                clear match_pos
            end
            if calc_props_thrmat.pagerank_cent == 1                                                                                                     % If pagerank centrality should be calculated            
                thrmat_graph_meas.pagerank_cent_pos = pagerank_cent_pos;
                clear pagerank_cent_pos
            end
            
            if calc_props_thrmat.part_coef == 1                                                                                                     % If pagerank centrality should be calculated            
                thrmat_graph_meas.part_coef_pos     = part_coef_pos;
                clear part_coef_pos
            end
            if calc_props_thrmat.rich_club_pos == 1
                thrmat_graph_meas.rich_club_pos     = rich_club_pos;
                clear rich_club_pos
            end
            if calc_props_thrmat.trans == 1                                                                                                             % If transitivity should be calculated
                thrmat_graph_meas.trans_pos         = trans_pos;
                clear trans_pos
            end
            if calc_props_thrmat.mod_deg_z == 1                                                                                                             % If transitivity should be calculated
                thrmat_graph_meas.mod_deg_z_pos     = mod_deg_z_pos;
                clear mod_deg_z_pos
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                for curr_dens = 1:size(threshed_conmats_neg,4)                                                                                        % Loop on densities
                    parfor curr_sub = 1:out.num_subs                                                                                                            % Loop through each participant
                        curr_conmat = squeeze(threshed_conmats_neg(:,:,curr_sub,curr_dens,rep_lev));                                                  % Extract connectivity matrix for current participant
                        
                        if calc_props_thrmat.assort == 1                                                                                                        % If assortativity should be calculated
                            assort_neg(curr_dens,curr_sub,rep_lev) = assortativity_wei(curr_conmat,0);                              % Each output should be 1 number
                        end
                        
                        if calc_props_thrmat.cpl == 1 || calc_props_thrmat.glob_eff == 1                                                                           % If any properties requiring distance matrices should be calculated
                            dist_mat = distance_wei(weight_conversion(curr_conmat,'lengths'));                                                               % Calculate distance matrix
                            if calc_props_thrmat.cpl == 1 && calc_props_thrmat.glob_eff == 1                                                                       % If both characteristic path length and global efficiency should be calculated
                                [cpl_neg(curr_dens,curr_sub,rep_lev),glob_eff_neg(curr_dens,curr_sub,rep_lev)] = charpath(dist_mat); % Each output should be 1 number
                            elseif calc_props_thrmat.cpl == 1                                                                                                   % If only characteristic path length should be calculated
                                [cpl_neg(curr_dens,curr_sub,rep_lev)]                                          = charpath(dist_mat);                                         % Each output should be 1 number
                            else                                                                                                                             % If only global efficiency should be calculated
                                [~,glob_eff_neg(curr_dens,curr_sub,rep_lev)]                                   = charpath(dist_mat);                                  % Each output should be 1 number
                            end
                        end
                        
                        if calc_props_thrmat.clust_coef == 1                                                                                                    % If the clutering coefficient should be calculated
                            clust_coef_neg(curr_dens,curr_sub,:,rep_lev) = clustering_coef_wu(curr_conmat);                         % Each output should be vector of size #ROIs
                        end
                        
                        if calc_props_thrmat.deg == 1 || calc_props_thrmat.dens == 1 || calc_props_thrmat.kcore_cent == 1 || calc_props_thrmat.sub_cent == 1 || calc_props_thrmat.small_world == 1            % If any properties requiring binary matrices should be calculated
                            bin_conmat = weight_conversion(curr_conmat,'binarize');                                                                          % Calcualte binary matrices
                            if calc_props_thrmat.deg == 1                                                                                                       % If degree should be calculated
                                deg_neg(curr_dens,curr_sub,:,rep_lev)           = degrees_und(bin_conmat);                                    % Each output should be vector of size #ROIs
                            end
                            if calc_props_thrmat.dens == 1                                                                                                      % If density should be calculated
                                dens_neg(curr_dens,curr_sub,rep_lev)            = density_und(bin_conmat);                                     % Each output should be 1 number
                            end
                            if calc_props_thrmat.kcore_cent == 1                                                                                                          % If k-coreness centrality should be calculated
                                kcore_cent_neg(curr_dens,curr_sub,rep_lev)      = kcoreness_centrality_bu(bin_conmat);                                                    % Each output should be 1 number
                            end
                            if calc_props_thrmat.small_world == 1                                                                                               % If small-worldness should be calculated
                                small_world_neg(curr_dens,curr_sub,rep_lev)     = HumphriesGurney_smallworldness_bu(bin_conmat);        % Each output should be 1 number
                            end
                            if calc_props_thrmat.sub_cent == 1                                                                                                  % If subgraph centrality should be calculated
                                subgraph_cent_neg(curr_dens,curr_sub,:,rep_lev) = subgraph_centrality(bin_conmat);                  % Each output should be vector of size #ROIs
                            end
                        end
                        
                        if calc_props_thrmat.eigvec_cent == 1                                                                                                   % If eigenvector centrality should be calculated
                            eigvec_cent_neg(curr_dens,curr_sub,:,rep_lev) = eigenvector_centrality_und(curr_conmat);                % Produces vector of size #ROIs
                        end
                        
                        if calc_props_thrmat.edge_bet_cent == 1 || calc_props_thrmat.node_bet_cent == 1                                                            % If any properties requiring length matrices should be calculated
                            length_mat                                            = weight_conversion(curr_conmat,'lengths');                                                                           % Calculate length matrix
                            if calc_props_thrmat.edge_bet_cent == 1                                                                                             % If edge betweeness centrality should be calculated
                                edge_bet_cent_neg(curr_dens,curr_sub,:,:,rep_lev) = edge_betweenness_wei(length_mat);               % Each output should be square matrix of size #ROIs
                            end
                            if calc_props_thrmat.node_bet_cent == 1                                                                                             % If node betweeness centrality should be calculated
                                node_bet_cent_neg(curr_dens,curr_sub,:,rep_lev)   = betweenness_wei(length_mat);                      % Each output should be vector of size #ROIs
                            end
                        end
                        
                        if calc_props_thrmat.loc_eff == 1                                                                                                       % If local efficiency should be calculated
                            loc_eff_neg(curr_dens,curr_sub,:,rep_lev) = efficiency_wei(curr_conmat,1);                              % Each output should be vector of size #ROIs
                        end
                        
                        if calc_props_thrmat.match == 1                                                                                                         % If the matching index should be calculated
                            match_neg(curr_dens,curr_sub,:,:,rep_lev) = matching_ind_und(curr_conmat);                              % Each output should be square matrix of of size #ROIs
                        end
                        
                        if calc_props_thrmat.pagerank_cent == 1                                                                                                 % If pagerank centrality should be calculated
                            pagerank_cent_neg(curr_dens,curr_sub,:,rep_lev) = pagerank_centrality(curr_conmat,0.85);                % Produces vector of size #ROIs
                        end
                        
                        if calc_props_thrmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                            part_coef_neg(curr_dens,curr_sub,:,rep_lev) = participation_coef(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                        end
                        
                        if calc_props_thrmat.rich_club == 1                                                                                                     % If rich club networks should be calculated
                            if exist('out.max_club_size','var')                                                                                              % If the user has specified a maximum density
                                rich_club_neg{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat,out.max_club_size);            % Each output should be vector of size max density
                            else                                                                                                                             % If not
                                rich_club_neg{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat);                              % Each output should be vector of size of max density
                            end
                        end
                        
                        if calc_props_thrmat.trans == 1                                                                                                         % If transitivity should be calculated
                            trans_neg(curr_dens,curr_sub,rep_lev) = transitivity_wu(curr_conmat);                                   % Each output should be 1 number
                        end
                        
                        if calc_props_thrmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                            mod_deg_z_neg(curr_dens,curr_sub,:,rep_lev) = module_degree_zscore(curr_conmat,out.mod_grps,0);                                                                 % Each output should be vector of size #ROIs
                        end
                    end
                end
                
                if calc_props_thrmat.assort == 1                                                                                                            %#ok<*PFBNS> % If assortativity should be calculated
                    thrmat_graph_meas.assort_neg        = assort_neg;
                    clear assort_neg
                end
                if calc_props_thrmat.cpl == 1                                                                                                       % If only characteristic path length should be calculated
                    thrmat_graph_meas.cpl_neg           = cpl_neg;
                    clear cpl_neg
                end
                if calc_props_thrmat.glob_eff_neg == 1                                                                                                                        % If only global efficiency should be calculated
                    thrmat_graph_meas.glob_eff_neg      = glob_eff_neg;
                    clear glob_eff_neg
                end
                if calc_props_thrmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                    thrmat_graph_meas.clust_coef_neg    = clust_coef_neg;
                    clear clust_coef_neg
                end
                if calc_props_thrmat.deg == 1                                                                                                           % If degree should be calculated
                    thrmat_graph_meas.deg_neg           = deg_neg;
                    clear deg_neg
                end
                if calc_props_thrmat.dens == 1                                                                                                          % If density should be calculated
                    thrmat_graph_meas.dens_neg          = dens_neg;
                    clear dens_neg
                end
                if calc_props_thrmat.kcore_cent == 1                                                                                                          % If k-coreness centrality should be calculated
                    thrmat_graph_meas.kcore_cent_neg    = kcore_cent_neg;
                    clear kcore_cent_neg
                end
                if calc_props_thrmat.small_world == 1                                                                                                   % If small-worldness should be calculated
                    thrmat_graph_meas.small_world_neg   = small_world_neg;
                    clear small_world_neg
                end
                if calc_props_thrmat.sub_cent == 1                                                                                                      % If subgraph centrality should be calculated
                    thrmat_graph_meas.subgraph_cent_neg = subgraph_cent_neg;
                    clear subgraph_cent_neg
                end
                if calc_props_thrmat.edge_bet_cent == 1                                                                                                 % If edge betweeness centrality should be calculated
                    thrmat_graph_meas.edge_bet_cent_neg = edge_bet_cent_neg;
                    clear edge_bet_cent_neg
                end
                if calc_props_thrmat.node_bet_cent == 1                                                                                                 % If node betweeness centrality should be calculated
                    thrmat_graph_meas.node_bet_cent_neg = node_bet_cent_neg;
                    clear node_bet_cent_neg
                end
                if calc_props_thrmat.eigvec_cent == 1                                                                                                       % If eigenvector centrality should be calculated
                    thrmat_graph_meas.eigvec_cent_neg   = eigvec_cent_neg;
                    clear eigvec_cent_neg
                end
                if calc_props_thrmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                    thrmat_graph_meas.loc_eff_neg       = loc_eff_neg;
                    clear loc_eff_neg
                end
                if calc_props_thrmat.match == 1                                                                                                             % If the matching index should be calculated
                    thrmat_graph_meas.match_neg         = match_neg;
                    clear match_neg
                end
                if calc_props_thrmat.pagerank_cent == 1                                                                                                     % If pagerank centrality should be calculated
                    thrmat_graph_meas.pagerank_cent_neg = pagerank_cent_neg;
                    clear pagerank_cent_neg
                end
                if calc_props_thrmat.part_coef == 1                                                                                                     % If pagerank centrality should be calculated
                    thrmat_graph_meas.part_coef_neg     = part_coef_neg;
                    clear part_coef_neg
                end
                if calc_props_thrmat.rich_club_neg == 1
                    thrmat_graph_meas.rich_club_neg     = rich_club_neg;
                    clear rich_club_neg
                end
                if calc_props_thrmat.trans == 1                                                                                                             % If transitivity should be calculated
                    thrmat_graph_meas.trans_neg         = trans_neg;
                    clear trans_neg
                end
                if calc_props_thrmat.mod_deg_z == 1                                                                                                             % If transitivity should be calculated
                    thrmat_graph_meas.mod_deg_z_neg     = mod_deg_z_neg;
                    clear mod_deg_z_neg
                end
            end
        end
    else
        for rep_lev = out.num_rep_levs:-1:1                                                                                                                % Loop on repeated levels
            for curr_dens = 1:size(threshed_conmats_pos,4)                                                                                                       % Loop on densities
                for curr_sub = 1:out.num_subs                                                                                                                % Loop through each participant
                    curr_conmat = squeeze(threshed_conmats_pos(:,:,curr_sub,curr_dens,rep_lev));                                                                 % Extract connectivity matrix for current participant
                    
                    if out.calc_props_thrmat.assort == 1                                                                                                            % If assortativity should be calculated
                        thrmat_graph_meas.assort_pos(curr_dens,curr_sub,rep_lev) = assortativity_wei(curr_conmat,0);                                             % Each output should be 1 number
                    end
                    
                    if out.calc_props_thrmat.cpl == 1 || out.calc_props_thrmat.glob_eff == 1                                                                               % If any properties requiring distance matrices should be calculated
                        dist_mat = distance_wei(weight_conversion(curr_conmat,'lengths'));                                                                   % Calculate distance matrix
                        if out.calc_props_thrmat.cpl == 1 && out.calc_props_thrmat.glob_eff == 1                                                                           % If both characteristic path length and global efficiency should be calculated
                            [thrmat_graph_meas.cpl_pos(curr_dens,curr_sub,rep_lev),thrmat_graph_meas.glob_eff_pos(curr_dens,curr_sub,rep_lev)] = charpath(dist_mat); % Each output should be 1 number
                        elseif out.calc_props_thrmat.cpl == 1                                                                                                       % If only characteristic path length should be calculated
                            [thrmat_graph_meas.cpl_pos(curr_dens,curr_sub,rep_lev)]                                                            = charpath(dist_mat);                                                        % Each output should be 1 number
                        else                                                                                                                                 % If only global efficiency should be calculated
                            [~,thrmat_graph_meas.glob_eff_pos(curr_dens,curr_sub,rep_lev)]                                                     = charpath(dist_mat);                                                 % Each output should be 1 number
                        end
                    end
                    
                    if out.calc_props_thrmat.clust_coef == 1                                                                                                        % If the clutering coefficient should be calculated
                        thrmat_graph_meas.clust_coef_pos(curr_dens,curr_sub,:,rep_lev) = clustering_coef_wu(curr_conmat);                                        % Each output should be vector of size #ROIs
                    end
                    
                    if out.calc_props_thrmat.deg == 1 || out.calc_props_thrmat.dens == 1 || out.calc_props_thrmat.kcore_cent == 1 || out.calc_props_thrmat.sub_cent == 1 || out.calc_props_thrmat.small_world == 1                % If any properties requiring binary matrices should be calculated
                        bin_conmat = weight_conversion(curr_conmat,'binarize');                                                                              % Calcualte binary matrices
                        if out.calc_props_thrmat.deg == 1                                                                                                           % If degree should be calculated
                            thrmat_graph_meas.deg_pos(curr_dens,curr_sub,:,rep_lev)           = degrees_und(bin_conmat);                                                   % Each output should be vector of size #ROIs
                        end
                        if out.calc_props_thrmat.dens == 1                                                                                                          % If density should be calculated
                            thrmat_graph_meas.dens_pos(curr_dens,curr_sub,rep_lev)            = density_und(bin_conmat);                                                    % Each output should be 1 number
                        end
                        if out.calc_props_thrmat.kcore_cent == 1                                                                                                          % If k-coreness centrality should be calculated
                            thrmat_graph_meas.kcore_cent_pos(curr_dens,curr_sub,:,rep_lev)    = kcoreness_centrality_bu(bin_conmat);                                                    % Each output should be 1 number
                        end
                        if out.calc_props_thrmat.small_world == 1                                                                                                   % If small-worldness should be calculated
                            thrmat_graph_meas.small_world_pos(curr_dens,curr_sub,rep_lev)     = HumphriesGurney_smallworldness_bu(bin_conmat);                       % Each output should be 1 number
                        end
                        if out.calc_props_thrmat.sub_cent == 1                                                                                                      % If subgraph centrality should be calculated
                            thrmat_graph_meas.subgraph_cent_pos(curr_dens,curr_sub,:,rep_lev) = subgraph_centrality(bin_conmat);                                 % Each output should be vector of size #ROIs
                        end
                    end
                    
                    if out.calc_props_thrmat.edge_bet_cent == 1 || out.calc_props_thrmat.node_bet_cent == 1                                                                % If any properties requiring length matrices should be calculated
                        length_mat = weight_conversion(curr_conmat,'lengths');                                                                               % Calculate length matrix
                        if out.calc_props_thrmat.edge_bet_cent == 1                                                                                                 % If edge betweeness centrality should be calculated
                            thrmat_graph_meas.edge_bet_cent_pos(curr_dens,curr_sub,:,:,rep_lev) = edge_betweenness_wei(length_mat);                              % Each output should be square matrix of size #ROIs
                        end
                        if out.calc_props_thrmat.node_bet_cent == 1                                                                                                 % If node betweeness centrality should be calculated
                            thrmat_graph_meas.node_bet_cent_pos(curr_dens,curr_sub,:,rep_lev) = betweenness_wei(length_mat);                                     % Each output should be vector of size #ROIs
                        end
                    end
                    
                    if out.calc_props_thrmat.eigvec_cent == 1                                                                                                       % If eigenvector centrality should be calculated
                        thrmat_graph_meas.eigvec_cent_pos(curr_dens,curr_sub,:,rep_lev) = eigenvector_centrality_und(curr_conmat);                               % Produces vector of size #ROIs
                    end
                    
                    if out.calc_props_thrmat.loc_eff == 1                                                                                                           % If local efficiency should be calculated
                        thrmat_graph_meas.loc_eff_pos(curr_dens,curr_sub,:,rep_lev) = efficiency_wei(curr_conmat,1);                                             % Each output should be vector of size #ROIs
                    end
                    
                    if out.calc_props_thrmat.match == 1                                                                                                             % If the matching index should be calculated
                        thrmat_graph_meas.match_pos(curr_dens,curr_sub,:,:,rep_lev) = matching_ind_und(curr_conmat);                                             % Each output should be square matrix of of size #ROIs
                    end
                    
                    if out.calc_props_thrmat.pagerank_cent == 1                                                                                                     % If pagerank centrality should be calculated
                        thrmat_graph_meas.pagerank_cent_pos(curr_dens,curr_sub,:,rep_lev) = pagerank_centrality(curr_conmat,0.85);                               % Produces vector of size #ROIs
                    end
                    
                    if out.calc_props_thrmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                        thrmat_graph_meas.part_coef_pos(curr_dens,curr_sub,:,rep_lev) = participation_coef(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                    end
                    
                    if out.calc_props_thrmat.rich_club == 1                                                                                                         % If rich club networks should be calculated
                        if exist('out.max_club_size','var')                                                                                                  % If the user has specified a maximum density
                            thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat,out.max_club_size);                           % Each output should be vector of size max density
                        else                                                                                                                                 % If not
                            thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat);                                             % Each output should be vector of size of max density
                        end
                    end
                    
                    if out.calc_props_thrmat.trans == 1                                                                                                             % If transitivity should be calculated
                        thrmat_graph_meas.trans_pos(curr_dens,curr_sub,rep_lev) = transitivity_wu(curr_conmat);                                                  % Each output should be 1 number
                    end
                    
                    if out.calc_props_thrmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                        thrmat_graph_meas.mod_deg_z_pos(curr_dens,curr_sub,:,rep_lev) = module_degree_zscore(curr_conmat,out.mod_grps,0);                                                                 % Each output should be vector of size #ROIs
                    end
                    
                    prog = (((curr_sub/out.num_subs)/size(threshed_conmats_pos,4))/out.num_rep_levs)+(((curr_dens-1)/size(threshed_conmats_pos,4))/out.num_rep_levs)+(1-(rep_lev/out.num_rep_levs));                                % Calculate progress
                    if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                        prog = prog/2;
                    end
                    if out.calcfullmat == 1
                        progressbar([],prog,[])                                                                                                                  % Update user
                    else
                        progressbar(prog,[])                                                                                                                                                      % Update progress bar
                    end
                end
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                for curr_dens = 1:size(threshed_conmats_neg,4)                                                                                        % Loop on densities
                    for curr_sub = 1:out.num_subs                                                                                                            % Loop through each participant
                        curr_conmat = squeeze(threshed_conmats_neg(:,:,curr_sub,curr_dens,rep_lev));                                                  % Extract connectivity matrix for current participant
                        
                        if out.calc_props_thrmat.assort == 1                                                                                                        % If assortativity should be calculated
                            thrmat_graph_meas.assort_neg(curr_dens,curr_sub,rep_lev) = assortativity_wei(curr_conmat,0);                              % Each output should be 1 number
                        end
                        
                        if out.calc_props_thrmat.cpl == 1 || out.calc_props_thrmat.glob_eff == 1                                                                           % If any properties requiring distance matrices should be calculated
                            dist_mat = distance_wei(weight_conversion(curr_conmat,'lengths'));                                                               % Calculate distance matrix
                            if out.calc_props_thrmat.cpl == 1 && out.calc_props_thrmat.glob_eff == 1                                                                       % If both characteristic path length and global efficiency should be calculated
                                [thrmat_graph_meas.cpl_neg(curr_dens,curr_sub,rep_lev),thrmat_graph_meas.glob_eff_neg(curr_dens,curr_sub,rep_lev)] = charpath(dist_mat); % Each output should be 1 number
                            elseif out.calc_props_thrmat.cpl == 1                                                                                                   % If only characteristic path length should be calculated
                                [thrmat_graph_meas.cpl_neg(curr_dens,curr_sub,rep_lev)] = charpath(dist_mat);                                         % Each output should be 1 number
                            else                                                                                                                             % If only global efficiency should be calculated
                                [~,thrmat_graph_meas.glob_eff_neg(curr_dens,curr_sub,rep_lev)] = charpath(dist_mat);                                  % Each output should be 1 number
                            end
                        end
                        
                        if out.calc_props_thrmat.clust_coef == 1                                                                                                    % If the clutering coefficient should be calculated
                            thrmat_graph_meas.clust_coef_neg(curr_dens,curr_sub,:,rep_lev) = clustering_coef_wu(curr_conmat);                         % Each output should be vector of size #ROIs
                        end
                        
                        if out.calc_props_thrmat.deg == 1 || out.calc_props_thrmat.dens == 1 || out.calc_props_thrmat.kcore_cent == 1 || out.calc_props_thrmat.sub_cent == 1 || out.calc_props_thrmat.small_world == 1            % If any properties requiring binary matrices should be calculated
                            bin_conmat = weight_conversion(curr_conmat,'binarize');                                                                          % Calcualte binary matrices
                            if out.calc_props_thrmat.deg == 1                                                                                                       % If degree should be calculated
                                thrmat_graph_meas.deg_neg(curr_dens,curr_sub,:,rep_lev)           = degrees_und(bin_conmat);                                    % Each output should be vector of size #ROIs
                            end
                            if out.calc_props_thrmat.dens == 1                                                                                                      % If density should be calculated
                                thrmat_graph_meas.dens_neg(curr_dens,curr_sub,rep_lev)            = density_und(bin_conmat);                                     % Each output should be 1 number
                            end
                            if out.calc_props_thrmat.kcore_cent == 1                                                                                                          % If k-coreness centrality should be calculated
                                thrmat_graph_meas.kcore_cent_neg(curr_dens,curr_sub,:,rep_lev)    = kcoreness_centrality_bu(bin_conmat);                                                    % Each output should be 1 number
                            end
                            if out.calc_props_thrmat.small_world == 1                                                                                               % If small-worldness should be calculated
                                thrmat_graph_meas.small_world_neg(curr_dens,curr_sub,rep_lev)     = HumphriesGurney_smallworldness_bu(bin_conmat);        % Each output should be 1 number
                            end
                            if out.calc_props_thrmat.sub_cent == 1                                                                                                  % If subgraph centrality should be calculated
                                thrmat_graph_meas.subgraph_cent_neg(curr_dens,curr_sub,:,rep_lev) = subgraph_centrality(bin_conmat);                  % Each output should be vector of size #ROIs
                            end
                        end
                        
                        if out.calc_props_thrmat.eigvec_cent == 1                                                                                                   % If eigenvector centrality should be calculated
                            thrmat_graph_meas.eigvec_cent_neg(curr_dens,curr_sub,:,rep_lev) = eigenvector_centrality_und(curr_conmat);                % Produces vector of size #ROIs
                        end
                        
                        if out.calc_props_thrmat.edge_bet_cent == 1 || out.calc_props_thrmat.node_bet_cent == 1                                                            % If any properties requiring length matrices should be calculated
                            length_mat = weight_conversion(curr_conmat,'lengths');                                                                           % Calculate length matrix
                            if out.calc_props_thrmat.edge_bet_cent == 1                                                                                             % If edge betweeness centrality should be calculated
                                thrmat_graph_meas.edge_bet_cent_neg(curr_dens,curr_sub,:,:,rep_lev) = edge_betweenness_wei(length_mat);               % Each output should be square matrix of size #ROIs
                            end
                            if out.calc_props_thrmat.node_bet_cent == 1                                                                                             % If node betweeness centrality should be calculated
                                thrmat_graph_meas.node_bet_cent_neg(curr_dens,curr_sub,:,rep_lev) = betweenness_wei(length_mat);                      % Each output should be vector of size #ROIs
                            end
                        end
                        
                        if out.calc_props_thrmat.loc_eff == 1                                                                                                       % If local efficiency should be calculated
                            thrmat_graph_meas.loc_eff_neg(curr_dens,curr_sub,:,rep_lev) = efficiency_wei(curr_conmat,1);                              % Each output should be vector of size #ROIs
                        end
                        
                        if out.calc_props_thrmat.match == 1                                                                                                         % If the matching index should be calculated
                            thrmat_graph_meas.match_neg(curr_dens,curr_sub,:,:,rep_lev) = matching_ind_und(curr_conmat);                              % Each output should be square matrix of of size #ROIs
                        end
                        
                        if out.calc_props_thrmat.pagerank_cent == 1                                                                                                 % If pagerank centrality should be calculated
                            thrmat_graph_meas.pagerank_cent_neg(curr_dens,curr_sub,:,rep_lev) = pagerank_centrality(curr_conmat,0.85);                % Produces vector of size #ROIs
                        end
                        
                        if out.calc_props_thrmat.part_coef == 1                                                                                                                                     % If the participation coefficient should be calculated
                            thrmat_graph_meas.part_coef_neg(curr_dens,curr_sub,:,rep_lev) = participation_coef(curr_conmat,out.mod_grps); % Produces two outputs, each a vector of size #ROIs
                        end
                        
                        if out.calc_props_thrmat.rich_club == 1                                                                                                     % If rich club networks should be calculated
                            if exist('out.max_club_size','var')                                                                                              % If the user has specified a maximum density
                                thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat,out.max_club_size);            % Each output should be vector of size max density
                            else                                                                                                                             % If not
                                thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev} = rich_club_wu(curr_conmat);                              % Each output should be vector of size of max density
                            end
                        end
                        
                        if out.calc_props_thrmat.trans == 1                                                                                                         % If transitivity should be calculated
                            thrmat_graph_meas.trans_neg(curr_dens,curr_sub,rep_lev) = transitivity_wu(curr_conmat);                                   % Each output should be 1 number
                        end
                        
                        if out.calc_props_thrmat.mod_deg_z == 1                                                                                                                                     % If the within-module degree z-score should be calculated
                            thrmat_graph_meas.mod_deg_z_neg(curr_dens,curr_sub,:,rep_lev) = module_degree_zscore(curr_conmat,out.mod_grps,0);                                                                 % Each output should be vector of size #ROIs
                        end
                        
                        prog = (((((curr_sub/out.num_subs)/size(threshed_conmats_neg,4))/out.num_rep_levs)+(((curr_dens-1)/size(threshed_conmats_neg,4))/out.num_rep_levs)+(1-(rep_lev/out.num_rep_levs)))*0.5)+0.5;                                % Calculate progress
                        if out.calcfullmat == 1
                            progressbar([],prog,[])                                                                                                                  % Update user
                        else
                            progressbar(prog,[])                                                                                                                                                      % Update progress bar
                        end
                    end
                end
            end
        end
    end
    
    fprintf('Done calculating properties for thresholded matrices!\n\n')                                                                                 % Alert user
    
    if out.calc_props_thrmat.rich_club == 1                                                                                                              % If rich club networks were calculated
        %%%% Calculate maximum club size based on data if none provided
        if isfield(out,'max_club_size')                                                                                                             % If no max was provided
            out.max_club_size_thr_pos = out.max_club_size;
            out.max_club_size_thr_neg = out.max_club_size;
        else
            out.max_club_size_thr_pos = 10000;                                                                                                                   % Set starting value as way higher than it could be
            for rep_lev = 1:out.num_rep_levs                                                                                                           % Loop on repeated levels
                for curr_dens = 1:size(threshed_conmats_pos,4)                                                                                               % Loop on densities
                    for curr_sub = 1:out.num_subs                                                                                                        % Loop on participants
                        if length(thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev}) < out.max_club_size_thr_pos                                           % If this max is less than the current threshold
                            out.max_club_size_thr_pos = length(thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev});                                         % Set new threshold
                        end
                    end
                end
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                out.max_club_size_thr_neg = 10000;                                                                                                    % Set starting value as way higher than it could be
                for rep_lev = 1:out.num_rep_levs                                                                                                       % Loop on repeated levels
                    for curr_dens = 1:size(threshed_conmats_neg,4)                                                                                % Loop on densities
                        for curr_sub = 1:out.num_subs                                                                                                    % Loop on participants
                            if length(thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev}) < out.max_club_size_thr_neg                 % If this max is less than the current threshold
                                out.max_club_size_thr_neg = length(thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev});               % Set new threshold
                            end
                        end
                    end
                end
            end
        end
    end
    
    %%%% Calculate area under the curve for each measure, for each
    %%%% participant (ignoring NaNs)
    fprintf('Calculating AUC for threshmat properties ...\n')
    if use_parfor
        progressbar('Progress For Calculating AUC for Thresholded Matrices')                                         % Initialize progress bar at zero
    end
    
    for rep_lev = out.num_rep_levs:-1:1                                                                                                                                                                 % Loop on repeated levels
        for curr_sub = 1:out.num_subs                                                                                                                                                                     % Loop on participant
            if out.calc_props_thrmat.assort == 1                                                                                                                                                                 % If assortativity was calculated
                accept_vals = isfinite(thrmat_graph_meas.assort_pos(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.assort_pos(:,curr_sub,rep_lev))==0);                                                           % Determine which values are finite and real
                out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);                                                                                                         % Determine how many acceptable values there are
                if out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC(curr_sub,rep_lev) > 1                                                                                                                      % If there is more than 1 acceptable value
                    out.AUC_thrmat_graph_meas.assort_pos(curr_sub,rep_lev) = trapz(thrmat_graph_meas.assort_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC(curr_sub,rep_lev)-1); % Calculate the AUC, normalized for the number of acceptable values
                elseif out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC(curr_sub,rep_lev) == 1                                                                                                                 % If there is only one acceptable value
                    out.AUC_thrmat_graph_meas.assort_pos(curr_sub,rep_lev) = thrmat_graph_meas.assort_pos(accept_vals,curr_sub,rep_lev);                                                                          % Set the AUC as that value
                else                                                                                                                                                                                      % If no acceptable values are found
                    out.AUC_thrmat_graph_meas.assort_pos(curr_sub,rep_lev) = NaN;                                                                                                                             % Set the AUC as NaN
                end
                
                if out.calcAUC_nodiscon == 1
                    accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                    out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);                                                                                                         % Determine how many acceptable values there are
                    if out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1                                                                                                                      % If there is more than 1 acceptable value
                        out.AUC_thrmat_graph_meas.assort_pos_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.assort_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC_nodiscon(curr_sub,rep_lev)-1); % Calculate the AUC, normalized for the number of acceptable values
                    elseif out.AUC_thrmat_graph_meas.assort_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1                                                                                                                 % If there is only one acceptable value
                        out.AUC_thrmat_graph_meas.assort_pos_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.assort_pos(accept_vals,curr_sub,rep_lev);                                                                          % Set the AUC as that value
                    else                                                                                                                                                                                      % If no acceptable values are found
                        out.AUC_thrmat_graph_meas.assort_pos_nodiscon(curr_sub,rep_lev) = NaN;                                                                                                                             % Set the AUC as NaN
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    accept_vals = isfinite(thrmat_graph_meas.assort_neg(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.assort_neg(:,curr_sub,rep_lev))==0);                                 % Determine which values are finite and real
                    out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);                                                                                          % Determine how many acceptable values there are
                    if out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC(curr_sub,rep_lev) > 1                                                                                                       % If there is more than 1 acceptable value
                        out.AUC_thrmat_graph_meas.assort_neg(curr_sub,rep_lev) = trapz(thrmat_graph_meas.assort_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC(curr_sub,rep_lev)-1); % Calculate the AUC, normalized for the number of acceptable values
                    elseif out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC(curr_sub,rep_lev) == 1                                                                                                  % If there is only one acceptable value
                        out.AUC_thrmat_graph_meas.assort_neg(curr_sub,rep_lev) = thrmat_graph_meas.assort_neg(accept_vals,curr_sub,rep_lev);                                                % Set the AUC as that value
                    else                                                                                                                                                                                  % If no acceptable values are found
                        out.AUC_thrmat_graph_meas.assort_neg(curr_sub,rep_lev) = NaN;                                                                                                              % Set the AUC as NaN
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);                                                                                                         % Determine how many acceptable values there are
                        if out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1                                                                                                                      % If there is more than 1 acceptable value
                            out.AUC_thrmat_graph_meas.assort_neg_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.assort_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC_nodiscon(curr_sub,rep_lev)-1); % Calculate the AUC, normalized for the number of acceptable values
                        elseif out.AUC_thrmat_graph_meas.assort_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1                                                                                                                 % If there is only one acceptable value
                            out.AUC_thrmat_graph_meas.assort_neg_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.assort_neg(accept_vals,curr_sub,rep_lev);                                                                          % Set the AUC as that value
                        else                                                                                                                                                                                      % If no acceptable values are found
                            out.AUC_thrmat_graph_meas.assort_neg_nodiscon(curr_sub,rep_lev) = NaN;                                                                                                                             % Set the AUC as NaN
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.cpl == 1
                accept_vals = isfinite(thrmat_graph_meas.cpl_pos(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.cpl_pos(:,curr_sub,rep_lev))==0);
                out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                if out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC(curr_sub,rep_lev) > 1
                    out.AUC_thrmat_graph_meas.cpl_pos(curr_sub,rep_lev) = trapz(thrmat_graph_meas.cpl_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC(curr_sub,rep_lev)-1);
                elseif out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC(curr_sub,rep_lev) == 1
                    out.AUC_thrmat_graph_meas.cpl_pos(curr_sub,rep_lev) = thrmat_graph_meas.cpl_pos(accept_vals,curr_sub,rep_lev);
                else
                    out.AUC_thrmat_graph_meas.cpl_pos(curr_sub,rep_lev) = NaN;
                end
                
                if out.calcAUC_nodiscon == 1
                    accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                    out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.cpl_pos_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.cpl_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.cpl_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.cpl_pos_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.cpl_pos(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.cpl_pos_nodiscon(curr_sub,rep_lev) = NaN;
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    accept_vals = isfinite(thrmat_graph_meas.cpl_neg(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.cpl_neg(:,curr_sub,rep_lev))==0);
                    out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.cpl_neg(curr_sub,rep_lev) = trapz(thrmat_graph_meas.cpl_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.cpl_neg(curr_sub,rep_lev) = thrmat_graph_meas.cpl_neg(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.cpl_neg(curr_sub,rep_lev) = NaN;
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.cpl_neg_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.cpl_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.cpl_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.cpl_neg_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.cpl_neg(accept_vals,curr_sub,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.cpl_neg_nodiscon(curr_sub,rep_lev) = NaN;
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.clust_coef == 1 || out.calc_props_thrmat.deg == 1 || out.calc_props_thrmat.eigvec_cent == 1 || out.calc_props_thrmat.kcore_cent == 1 || out.calc_props_thrmat.loc_eff == 1 || out.calc_props_thrmat.node_bet_cent == 1 || out.calc_props_thrmat.pagerank_cent == 1 || out.calc_props_thrmat.part_coef == 1 || out.calc_props_thrmat.sub_cent == 1 || out.calc_props_thrmat.mod_deg_z == 1
                for curr_ROI = 1:out.nROI
                    if out.calc_props_thrmat.clust_coef == 1
                        accept_vals = isfinite(thrmat_graph_meas.clust_coef_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.clust_coef_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.clust_coef_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.clust_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.clust_coef_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.clust_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.clust_coef_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.clust_coef_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.clust_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.clust_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.clust_coef_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.clust_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.clust_coef_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.clust_coef_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.clust_coef_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.clust_coef_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.clust_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.clust_coef_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.clust_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.clust_coef_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.clust_coef_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.clust_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.clust_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.clust_coef_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.clust_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.clust_coef_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.deg == 1
                        accept_vals = isfinite(thrmat_graph_meas.deg_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.deg_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.deg_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.deg_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.deg_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.deg_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.deg_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.deg_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.deg_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.deg_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.deg_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.deg_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.deg_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.deg_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.deg_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.deg_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.deg_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.deg_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.deg_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.deg_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.deg_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.deg_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.deg_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.deg_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.deg_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.deg_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.eigvec_cent == 1
                        accept_vals = isfinite(thrmat_graph_meas.eigvec_cent_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.eigvec_cent_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.eigvec_cent_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.eigvec_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.eigvec_cent_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.eigvec_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.eigvec_cent_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.eigvec_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.eigvec_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.eigvec_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.eigvec_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.eigvec_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.eigvec_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.eigvec_cent_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.eigvec_cent_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.eigvec_cent_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.eigvec_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.eigvec_cent_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.eigvec_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.eigvec_cent_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.eigvec_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.eigvec_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.eigvec_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.eigvec_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.eigvec_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.eigvec_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.kcore_cent == 1
                        accept_vals = isfinite(thrmat_graph_meas.kcore_cent_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.kcore_cent_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.kcore_cent_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.kcore_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.kcore_cent_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.kcore_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.kcore_cent_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.kcore_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.kcore_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.kcore_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.kcore_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.kcore_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.kcore_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.kcore_cent_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.kcore_cent_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.kcore_cent_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.kcore_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.kcore_cent_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.kcore_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.kcore_cent_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.kcore_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.kcore_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.kcore_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.kcore_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.kcore_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.kcore_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.loc_eff == 1
                        accept_vals = isfinite(thrmat_graph_meas.loc_eff_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.loc_eff_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.loc_eff_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.loc_eff_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.loc_eff_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.loc_eff_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.loc_eff_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.loc_eff_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.loc_eff_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.loc_eff_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.loc_eff_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.loc_eff_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.loc_eff_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.loc_eff_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.loc_eff_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.loc_eff_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.loc_eff_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.loc_eff_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.loc_eff_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.loc_eff_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.loc_eff_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.loc_eff_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.loc_eff_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.loc_eff_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.loc_eff_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.loc_eff_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.node_bet_cent == 1
                        accept_vals = isfinite(thrmat_graph_meas.node_bet_cent_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.node_bet_cent_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.node_bet_cent_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.node_bet_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.node_bet_cent_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.node_bet_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.node_bet_cent_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.node_bet_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.node_bet_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.node_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.node_bet_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.node_bet_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.node_bet_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.node_bet_cent_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.node_bet_cent_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.node_bet_cent_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.node_bet_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.node_bet_cent_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.node_bet_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.node_bet_cent_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.node_bet_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.node_bet_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.node_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.node_bet_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.node_bet_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.node_bet_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.pagerank_cent == 1
                        accept_vals = isfinite(thrmat_graph_meas.pagerank_cent_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.pagerank_cent_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.pagerank_cent_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.pagerank_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.pagerank_cent_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.pagerank_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.pagerank_cent_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.pagerank_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.pagerank_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.pagerank_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.pagerank_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.pagerank_cent_pos_nodiscon(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.pagerank_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.pagerank_cent_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.pagerank_cent_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.pagerank_cent_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.pagerank_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.pagerank_cent_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.pagerank_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.pagerank_cent_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.pagerank_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.pagerank_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.pagerank_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.pagerank_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.pagerank_cent_neg_nodiscon(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.pagerank_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.part_coef == 1
                        accept_vals = isfinite(thrmat_graph_meas.part_coef_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.part_coef_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.part_coef_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.part_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.part_coef_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.part_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.part_coef_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.part_coef_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.part_coef_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.part_coef_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.part_coef_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.part_coef_pos_nodiscon(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.part_coef_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.part_coef_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.part_coef_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.part_coef_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.part_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.part_coef_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.part_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.part_coef_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.part_coef_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.part_coef_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.part_coef_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.part_coef_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.part_coef_neg_nodiscon(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.part_coef_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.sub_cent == 1
                        accept_vals = isfinite(thrmat_graph_meas.subgraph_cent_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.subgraph_cent_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.subgraph_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.subgraph_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.subgraph_cent_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.subgraph_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.subgraph_cent_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.subgraph_cent_numvalsAUC_pos(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.subgraph_cent_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.subgraph_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.subgraph_cent_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.subgraph_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.subgraph_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.subgraph_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.subgraph_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.subgraph_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.subgraph_cent_numvalsAUC_pos_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.subgraph_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.subgraph_cent_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.subgraph_cent_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.subgraph_cent_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.subgraph_cent_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.subgraph_cent_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.subgraph_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.subgraph_cent_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.subgraph_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.subgraph_cent_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.subgraph_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.subgraph_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.subgraph_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.subgraph_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.subgraph_cent_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.subgraph_cent_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                    
                    if out.calc_props_thrmat.mod_deg_z == 1
                        accept_vals = isfinite(thrmat_graph_meas.mod_deg_z_pos(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.mod_deg_z_pos(:,curr_sub,curr_ROI,rep_lev))==0);
                        out.AUC_thrmat_graph_meas.mod_deg_z_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.mod_deg_z_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.mod_deg_z_pos(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.mod_deg_z_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.mod_deg_z_pos_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.mod_deg_z_numvalsAUC_pos(curr_sub,curr_ROI,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.mod_deg_z_pos(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.mod_deg_z_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.mod_deg_z_pos(curr_sub,curr_ROI,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.mod_deg_z_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.mod_deg_z_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.mod_deg_z_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.mod_deg_z_pos(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.mod_deg_z_pos_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.mod_deg_z_numvalsAUC_pos_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.mod_deg_z_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.mod_deg_z_pos(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.mod_deg_z_pos_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                        end
                        
                        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                            accept_vals = isfinite(thrmat_graph_meas.mod_deg_z_neg(:,curr_sub,curr_ROI,rep_lev)) & (imag(thrmat_graph_meas.mod_deg_z_neg(:,curr_sub,curr_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.mod_deg_z_neg(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.mod_deg_z_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC(curr_sub,curr_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.mod_deg_z_neg(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.mod_deg_z_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.mod_deg_z_neg(curr_sub,curr_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.mod_deg_z_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = trapz(thrmat_graph_meas.mod_deg_z_neg(accept_vals,curr_sub,curr_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.mod_deg_z_neg_numvalsAUC_nodiscon(curr_sub,curr_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.mod_deg_z_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = thrmat_graph_meas.mod_deg_z_neg(accept_vals,curr_sub,curr_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.mod_deg_z_neg_nodiscon(curr_sub,curr_ROI,rep_lev) = NaN;
                                end
                            end
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.dens == 1
                accept_vals = isfinite(thrmat_graph_meas.dens_pos(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.dens_pos(:,curr_sub,rep_lev))==0);
                out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                if out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC(curr_sub,rep_lev) > 1
                    out.AUC_thrmat_graph_meas.dens_pos(curr_sub,rep_lev) = trapz(thrmat_graph_meas.dens_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC(curr_sub,rep_lev)-1);
                elseif out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC(curr_sub,rep_lev) == 1
                    out.AUC_thrmat_graph_meas.dens_pos(curr_sub,rep_lev) = thrmat_graph_meas.dens_pos(accept_vals,curr_sub,rep_lev);
                else
                    out.AUC_thrmat_graph_meas.dens_pos(curr_sub,rep_lev) = NaN;
                end
                
                if out.calcAUC_nodiscon == 1
                    accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                    out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.dens_pos_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.dens_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.dens_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.dens_pos_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.dens_pos(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.dens_pos_nodiscon(curr_sub,rep_lev) = NaN;
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    accept_vals = isfinite(thrmat_graph_meas.dens_neg(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.dens_neg(:,curr_sub,rep_lev))==0);
                    out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.dens_neg(curr_sub,rep_lev) = trapz(thrmat_graph_meas.dens_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.dens_neg(curr_sub,rep_lev) = thrmat_graph_meas.dens_neg(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.dens_neg(curr_sub,rep_lev) = NaN;
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.dens_neg_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.dens_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.dens_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.dens_neg_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.dens_neg(accept_vals,curr_sub,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.dens_neg_nodiscon(curr_sub,rep_lev) = NaN;
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.edge_bet_cent == 1 || out.calc_props_thrmat.match == 1
                for curr_row_ROI = 1:out.nROI
                    for curr_col_ROI = 1:out.nROI
                        if out.calc_props_thrmat.edge_bet_cent == 1
                            accept_vals = isfinite(thrmat_graph_meas.edge_bet_cent_pos(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)) & (imag(thrmat_graph_meas.edge_bet_cent_pos(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.edge_bet_cent_pos(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.edge_bet_cent_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.edge_bet_cent_pos(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.edge_bet_cent_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.edge_bet_cent_pos(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_pos_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.edge_bet_cent_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.edge_bet_cent_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_pos_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.edge_bet_cent_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_pos_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                                end
                            end
                            
                            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                                accept_vals = isfinite(thrmat_graph_meas.edge_bet_cent_neg(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)) & (imag(thrmat_graph_meas.edge_bet_cent_neg(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))==0);
                                out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_neg(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.edge_bet_cent_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_neg(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.edge_bet_cent_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_neg(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                                end
                                
                                if out.calcAUC_nodiscon == 1
                                    accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                    out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                                    if out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                        out.AUC_thrmat_graph_meas.edge_bet_cent_neg_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.edge_bet_cent_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                                    elseif out.AUC_thrmat_graph_meas.edge_bet_cent_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                        out.AUC_thrmat_graph_meas.edge_bet_cent_neg_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.edge_bet_cent_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                                    else
                                        out.AUC_thrmat_graph_meas.edge_bet_cent_neg_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                                    end
                                end
                            end
                        end
                        
                        if out.calc_props_thrmat.match == 1
                            accept_vals = isfinite(thrmat_graph_meas.match_pos(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)) & (imag(thrmat_graph_meas.match_pos(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))==0);
                            out.AUC_thrmat_graph_meas.match_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.match_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.match_pos(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.match_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.match_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.match_pos_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.match_pos(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.match_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                            else
                                out.AUC_thrmat_graph_meas.match_pos(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                            end
                            
                            if out.calcAUC_nodiscon == 1
                                accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                                out.AUC_thrmat_graph_meas.match_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.match_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.match_pos_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.match_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.match_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.match_pos_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.match_pos_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.match_pos(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.match_pos_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                                end
                            end
                            
                            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                                accept_vals = isfinite(thrmat_graph_meas.match_neg(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)) & (imag(thrmat_graph_meas.match_neg(:,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))==0);
                                out.AUC_thrmat_graph_meas.match_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                                if out.AUC_thrmat_graph_meas.match_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                    out.AUC_thrmat_graph_meas.match_neg(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.match_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.match_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                                elseif out.AUC_thrmat_graph_meas.match_neg_numvalsAUC(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                    out.AUC_thrmat_graph_meas.match_neg(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.match_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                                else
                                    out.AUC_thrmat_graph_meas.match_neg(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                                end
                                
                                if out.calcAUC_nodiscon == 1
                                    accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                                    out.AUC_thrmat_graph_meas.match_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = sum(accept_vals);
                                    if out.AUC_thrmat_graph_meas.match_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) > 1
                                        out.AUC_thrmat_graph_meas.match_neg_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = trapz(thrmat_graph_meas.match_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev))/(out.AUC_thrmat_graph_meas.match_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev)-1);
                                    elseif out.AUC_thrmat_graph_meas.match_neg_numvalsAUC_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) == 1
                                        out.AUC_thrmat_graph_meas.match_neg_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = thrmat_graph_meas.match_neg(accept_vals,curr_sub,curr_row_ROI,curr_col_ROI,rep_lev);
                                    else
                                        out.AUC_thrmat_graph_meas.match_neg_nodiscon(curr_sub,curr_row_ROI,curr_col_ROI,rep_lev) = NaN;
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.glob_eff == 1
                accept_vals = isfinite(thrmat_graph_meas.glob_eff_pos(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.glob_eff_pos(:,curr_sub,rep_lev))==0);
                out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                if out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC(curr_sub,rep_lev) > 1
                    out.AUC_thrmat_graph_meas.glob_eff_pos(curr_sub,rep_lev) = trapz(thrmat_graph_meas.glob_eff_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC(curr_sub,rep_lev)-1);
                elseif out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC(curr_sub,rep_lev) == 1
                    out.AUC_thrmat_graph_meas.glob_eff_pos(curr_sub,rep_lev) = thrmat_graph_meas.glob_eff_pos(accept_vals,curr_sub,rep_lev);
                else
                    out.AUC_thrmat_graph_meas.glob_eff_pos(curr_sub,rep_lev) = NaN;
                end
                
                if out.calcAUC_nodiscon == 1
                    accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                    out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.glob_eff_pos_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.glob_eff_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.glob_eff_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.glob_eff_pos_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.glob_eff_pos(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.glob_eff_pos_nodiscon(curr_sub,rep_lev) = NaN;
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    accept_vals = isfinite(thrmat_graph_meas.glob_eff_neg(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.glob_eff_neg(:,curr_sub,rep_lev))==0);
                    out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.glob_eff_neg(curr_sub,rep_lev) = trapz(thrmat_graph_meas.glob_eff_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.glob_eff_neg(curr_sub,rep_lev) = thrmat_graph_meas.glob_eff_neg(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.glob_eff_neg(curr_sub,rep_lev) = NaN;
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.glob_eff_neg_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.glob_eff_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.glob_eff_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.glob_eff_neg_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.glob_eff_neg(accept_vals,curr_sub,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.glob_eff_neg_nodiscon(curr_sub,rep_lev) = NaN;
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.rich_club == 1
                curr_club_stats = zeros(size(threshed_conmats_pos,4),out.max_club_size_thr_pos);
                for curr_dens = 1:size(threshed_conmats_pos,4)
                    if length(thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev}) < out.max_club_size_thr_pos
                        curr_club_stats(curr_dens,1:length(thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev})) = thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev}(1:end);
                        curr_club_stats(curr_dens,(length(thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev})+1):end) = NaN;
                    else
                        curr_club_stats(curr_dens,:) = thrmat_graph_meas.rich_club_pos{curr_dens,curr_sub,rep_lev}(1:out.max_club_size_thr_pos);
                    end
                end
                for curr_club_size = 1:out.max_club_size_thr_pos
                    accept_vals = isfinite(curr_club_stats(:,curr_club_size)) & (imag(curr_club_stats(:,curr_club_size))==0);
                    out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC(curr_sub,curr_club_size,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC(curr_sub,curr_club_size,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.rich_club_pos(curr_sub,curr_club_size,rep_lev) = trapz(curr_club_stats(accept_vals,curr_club_size))/(out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC(curr_sub,curr_club_size,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC(curr_sub,curr_club_size,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.rich_club_pos(curr_sub,curr_club_size,rep_lev) = curr_club_stats(accept_vals,curr_club_size);
                    else
                        out.AUC_thrmat_graph_meas.rich_club_pos(curr_sub,curr_club_size,rep_lev) = NaN;
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.rich_club_pos_nodiscon(curr_sub,curr_club_size,rep_lev) = trapz(curr_club_stats(accept_vals,curr_club_size))/(out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.rich_club_pos_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.rich_club_pos_nodiscon(curr_sub,curr_club_size,rep_lev) = curr_club_stats(accept_vals,curr_club_size);
                        else
                            out.AUC_thrmat_graph_meas.rich_club_pos_nodiscon(curr_sub,curr_club_size,rep_lev) = NaN;
                        end
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    curr_club_stats = zeros(size(threshed_conmats_neg,4),out.max_club_size_thr_neg);
                    for curr_dens = 1:size(threshed_conmats_neg,4)
                        if length(thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev}) < out.max_club_size_thr_neg
                            curr_club_stats(curr_dens,1:length(thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev})) = thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev}(1:end);
                            curr_club_stats(curr_dens,(length(thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev})+1):end) = NaN;
                        else
                            curr_club_stats(curr_dens,:) = thrmat_graph_meas.rich_club_neg{curr_dens,curr_sub,rep_lev}(1:out.max_club_size_thr_neg);
                        end
                    end
                    for curr_club_size = 1:out.max_club_size_thr_neg
                        accept_vals = isfinite(curr_club_stats(:,curr_club_size)) & (imag(curr_club_stats(:,curr_club_size))==0);
                        out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC(curr_sub,curr_club_size,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC(curr_sub,curr_club_size,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.rich_club_neg(curr_sub,curr_club_size,rep_lev) = trapz(curr_club_stats(accept_vals,curr_club_size))/(out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC(curr_sub,curr_club_size,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC(curr_sub,curr_club_size,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.rich_club_neg(curr_sub,curr_club_size,rep_lev) = curr_club_stats(accept_vals,curr_club_size);
                        else
                            out.AUC_thrmat_graph_meas.rich_club_neg(curr_sub,curr_club_size,rep_lev) = NaN;
                        end
                        
                        if out.calcAUC_nodiscon == 1
                            accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                            out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev) = sum(accept_vals);
                            if out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev) > 1
                                out.AUC_thrmat_graph_meas.rich_club_neg_nodiscon(curr_sub,curr_club_size,rep_lev) = trapz(curr_club_stats(accept_vals,curr_club_size))/(out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev)-1);
                            elseif out.AUC_thrmat_graph_meas.rich_club_neg_numvalsAUC_nodiscon(curr_sub,curr_club_size,rep_lev) == 1
                                out.AUC_thrmat_graph_meas.rich_club_neg_nodiscon(curr_sub,curr_club_size,rep_lev) = curr_club_stats(accept_vals,curr_club_size);
                            else
                                out.AUC_thrmat_graph_meas.rich_club_neg_nodiscon(curr_sub,curr_club_size,rep_lev) = NaN;
                            end
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.small_world == 1
                accept_vals = isfinite(thrmat_graph_meas.small_world_pos(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.small_world_pos(:,curr_sub,rep_lev))==0);
                out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                if out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC(curr_sub,rep_lev) > 1
                    out.AUC_thrmat_graph_meas.small_world_pos(curr_sub,rep_lev) = trapz(thrmat_graph_meas.small_world_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC(curr_sub,rep_lev)-1);
                elseif out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC(curr_sub,rep_lev) == 1
                    out.AUC_thrmat_graph_meas.small_world_pos(curr_sub,rep_lev) = thrmat_graph_meas.small_world_pos(accept_vals,curr_sub,rep_lev);
                else
                    out.AUC_thrmat_graph_meas.small_world_pos(curr_sub,rep_lev) = NaN;
                end
                
                if out.calcAUC_nodiscon == 1
                    accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                    out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.small_world_pos_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.small_world_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.small_world_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.small_world_pos_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.small_world_pos(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.small_world_pos_nodiscon(curr_sub,rep_lev) = NaN;
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    accept_vals = isfinite(thrmat_graph_meas.small_world_neg(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.small_world_neg(:,curr_sub,rep_lev))==0);
                    out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.small_world_neg(curr_sub,rep_lev) = trapz(thrmat_graph_meas.small_world_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.small_world_neg(curr_sub,rep_lev) = thrmat_graph_meas.small_world_neg(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.small_world_neg(curr_sub,rep_lev) = NaN;
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.small_world_neg_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.small_world_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.small_world_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.small_world_neg_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.small_world_neg(accept_vals,curr_sub,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.small_world_neg_nodiscon(curr_sub,rep_lev) = NaN;
                        end
                    end
                end
            end
            
            if out.calc_props_thrmat.trans == 1
                accept_vals = isfinite(thrmat_graph_meas.trans_pos(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.trans_pos(:,curr_sub,rep_lev))==0);
                out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                if out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC(curr_sub,rep_lev) > 1
                    out.AUC_thrmat_graph_meas.trans_pos(curr_sub,rep_lev) = trapz(thrmat_graph_meas.trans_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC(curr_sub,rep_lev)-1);
                elseif out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC(curr_sub,rep_lev) == 1
                    out.AUC_thrmat_graph_meas.trans_pos(curr_sub,rep_lev) = thrmat_graph_meas.trans_pos(accept_vals,curr_sub,rep_lev);
                else
                    out.AUC_thrmat_graph_meas.trans_pos(curr_sub,rep_lev) = NaN;
                end
                
                if out.calcAUC_nodiscon == 1
                    accept_vals = logical(accept_vals.*out.connected_nets_pos(curr_sub,:,rep_lev)');
                    out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.trans_pos_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.trans_pos(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.trans_pos_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.trans_pos_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.trans_pos(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.trans_pos_nodiscon(curr_sub,rep_lev) = NaN;
                    end
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    accept_vals = isfinite(thrmat_graph_meas.trans_neg(:,curr_sub,rep_lev)) & (imag(thrmat_graph_meas.trans_neg(:,curr_sub,rep_lev))==0);
                    out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC(curr_sub,rep_lev) = sum(accept_vals);
                    if out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC(curr_sub,rep_lev) > 1
                        out.AUC_thrmat_graph_meas.trans_neg(curr_sub,rep_lev) = trapz(thrmat_graph_meas.trans_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC(curr_sub,rep_lev)-1);
                    elseif out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC(curr_sub,rep_lev) == 1
                        out.AUC_thrmat_graph_meas.trans_neg(curr_sub,rep_lev) = thrmat_graph_meas.trans_neg(accept_vals,curr_sub,rep_lev);
                    else
                        out.AUC_thrmat_graph_meas.trans_neg(curr_sub,rep_lev) = NaN;
                    end
                    
                    if out.calcAUC_nodiscon == 1
                        accept_vals = logical(accept_vals.*out.connected_nets_neg(curr_sub,:,rep_lev)');
                        out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) = sum(accept_vals);
                        if out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) > 1
                            out.AUC_thrmat_graph_meas.trans_neg_nodiscon(curr_sub,rep_lev) = trapz(thrmat_graph_meas.trans_neg(accept_vals,curr_sub,rep_lev))/(out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC_nodiscon(curr_sub,rep_lev)-1);
                        elseif out.AUC_thrmat_graph_meas.trans_neg_numvalsAUC_nodiscon(curr_sub,rep_lev) == 1
                            out.AUC_thrmat_graph_meas.trans_neg_nodiscon(curr_sub,rep_lev) = thrmat_graph_meas.trans_neg(accept_vals,curr_sub,rep_lev);
                        else
                            out.AUC_thrmat_graph_meas.trans_neg_nodiscon(curr_sub,rep_lev) = NaN;
                        end
                    end
                end
            end
            
            prog = (curr_sub/out.num_subs)*(1-((rep_lev-1)/out.num_rep_levs));
            if ~use_parfor
                if out.calcfullmat == 1
                    progressbar([],[],prog)                                                                                                                  % Update user
                else
                    progressbar([],prog)                                                                                                                                                      % Update progress bar
                end
            else
                progressbar(prog)
            end
        end
    end
end

if use_parfor
    try
        parpool close
    catch %#ok<CTCH>
        matlabpool close
    end
end
%%%% Save data
save(out.outname,'out');
fprintf('Done calculating properties!!\n\n')
set(handles.Start_pushbutton,'enable','on');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Create mean contrast matrices

function [full_mean_conmat,grp_mean_conmat] = create_mean_conmats(Z,varargin)

if nargin > 1
    grouping_var = varargin{1};
    contin       = varargin{2};
    if nargin > 3
        switch varargin{3};
            case '-num_grps'
                num_grps     = varargin{4};
            case '-sub_per_grp'
                subs_per_grp = varargin{4};
        end
    else
        subs_per_grp = 50;
    end
end

fish_z = atanh(Z);
full_mean_conmat = atan(mean(fish_z,3));
full_mean_conmat(1:size(full_mean_conmat,1)+1:end) = 1;

if exist('grouping_var','var')
    if contin == 0
        group_mem = grouping_var;
    else
        if exist('num_grps','var')
            subs_per_grp = round(size(Z,3)/num_grps);
        else
            num_grps     = round(size(Z,3)/subs_per_grp);
            subs_per_grp = round(size(Z,3)/num_grps);
        end
        
        [~,ind] = sort(grouping_var);
        fish_z  = fish_z(:,:,ind);
        
        for grp = 1:num_grps
            if grp ~= num_grps
                group_mem((((grp-1)*subs_per_grp)+1):(grp*subs_per_grp)) = grp;
            else
                group_mem((((grp-1)*subs_per_grp)+1):size(Z,3))          = grp;
            end
        end
    end
    grps            = unique(group_mem);
    grp_mean_conmat = zeros([size(full_mean_conmat),length(grps)]);
    for grp = 1:length(grps)
        temp_conmat = atan(mean(fish_z(:,:,logical(group_mem == grps(grp))),3));
        temp_conmat(1:size(temp_conmat,1)+1:end) = 1;
        grp_mean_conmat(:,:,grp) = temp_conmat;
    end
end


%%%% Find the minimum density for which a particular set of graphs remain
%%%% connected
function [density,thr,step] = find_min_graph_density(mean_conmat,varargin)

min_step = 0.00001;
thr      = 0.5;
step     = 0.5;

if nargin > 1
    min_step = varargin{1};
    thr      = varargin{2};
end

while step > min_step
    bin_mat = weight_conversion(threshold_absolute(mean_conmat,thr),'binarize');
    R       = reachdist(bin_mat);
    if isempty(find(R == 0,1))
        while isempty(find(R == 0,1))
            thr     = thr+step;
            bin_mat = weight_conversion(threshold_absolute(mean_conmat,thr),'binarize');
            R       = reachdist(bin_mat);
        end
    else
        while ~isempty(find(R == 0,1))
            thr     = thr-step;
            bin_mat = weight_conversion(threshold_absolute(mean_conmat,thr),'binarize');
            R       = reachdist(bin_mat);
        end
    end
    step = step/2;
    if thr < 0
        density = NaN;
        thr     = NaN;
        return;
    end
end

if ~isempty(find(R == 0,1))
    thr = thr-2*step;
end
density = density_und(weight_conversion(threshold_absolute(mean_conmat,thr),'binarize'));
