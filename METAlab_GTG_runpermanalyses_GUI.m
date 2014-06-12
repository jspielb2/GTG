function varargout = METAlab_GTG_runpermanalyses_GUI(varargin)

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
% 03.17.14 - Beta 0.21 - small bugfixes
% 03.24.14 - Beta 0.22 - lots of small bugfixes
% 04.08.14 - Beta 0.23 - 1) lots of small bugfixes, including a bug that gave
%                        incorrect betas when doing repeated measures, 2)
%                        addition of F-tests across multiple predictors
%                        (particularly useful for categorical predictors),
%                        3) addition of calpability for more than 2 within-
%                        participant levels (although, only one within
%                        factor is allowed for now)
% 04.23.14 - Beta 0.24 - small bugfixes
% 05.07.14 - Beta 0.25 - 1) addition of output file for significant
%                        effects, 2) addition of k-coreness centrality
%                        testing
% 06.10.14 - Beta 0.30 - 1) small bugfixes, 2) all properties previously
%                        tested for all weights simultaneously are now
%                        tested for weights of each sign separately, 3)
%                        clustering coefficient, local efficiency, matching
%                        index, rich club networks, & transitivity added to
%                        full network testing, 4) participant coefficient &
%                        within-module z added to thresholded network
%                        testing, 5) handles now used to pass information
%                        between functions (rather than via out, which was
%                        made global), allowing users to launch processes
%                        from the same gui with less chance of info from
%                        the previous process interfering
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
    'gui_OpeningFcn', @METAlab_GTG_runpermanalyses_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @METAlab_GTG_runpermanalyses_GUI_OutputFcn, ...
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

function METAlab_GTG_runpermanalyses_GUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.output = hObject;
guidata(hObject, handles);

function varargout = METAlab_GTG_runpermanalyses_GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Indata_edit_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
temp         = get(hObject,'String');
handles.out  = evalin('base',temp);
set(handles.Fullprop_listbox,'String',[{'None'};handles.out.properties_calcd_fullmat]);
set(handles.Thrprop_listbox,'String',[{'None'};handles.out.properties_calcd_thrmat]);
if handles.out.num_rep_levs == 1
    set(handles.GLMtype_popupmenu,'enable','on');
end
set(handles.Samedesmat_popupmenu,'enable','on');
set(handles.Nodeselect_pushbutton,'enable','on');
set(handles.Edgeselect_pushbutton,'enable','on');
guidata(hObject,handles);

function Indata_edit_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Indata_edit_ButtonDownFcn(hObject, eventdata, handles)
set(hObject,'Enable','On');
uicontrol(handles.Indata_edit);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Alpha_edit_Callback(hObject, eventdata, handles)
handles.out.alpha = str2double(get(hObject,'String'));
set(handles.Start_pushbutton,'enable','on');
guidata(hObject,handles);

function Alpha_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




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

function Numperms_edit_Callback(hObject, eventdata, handles)
handles.out.num_perms = str2double(get(hObject,'String'));
guidata(hObject,handles);

function Numperms_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function GLMtype_popupmenu_Callback(hObject, eventdata, handles)
contents                 = cellstr(get(hObject,'String'));
handles.out.HLA_reg_type = contents{get(hObject,'Value')};
guidata(hObject,handles);

function GLMtype_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Samedesmat_popupmenu_Callback(hObject, eventdata, handles)
contents                = cellstr(get(hObject,'String'));
handles.out.same_desmat = contents{get(hObject,'Value')};
if strcmp(handles.out.same_desmat,'Yes')
    if isempty(handles.out.denscalc_varmat)
        handles.out.denscalc_varmat = ones(handles.out.num_subs,1);
    end
    handles.out.desmat   = [handles.out.denscalc_varmat,handles.out.denscalc_covarmat];
    handles.out.IV_names = [handles.out.denscalc_var_names,handles.out.denscalc_covar_names];
    if rank([handles.out.desmat,ones(size(handles.out.desmat,1),1)]) == (size(handles.out.desmat,2)+1) % If an intercept can be added without making the design matrix rank deficient
        handles.out.desmat   = [handles.out.desmat,ones(size(handles.out.desmat,1),1)];
        handles.out.IV_names = [handles.out.IV_names,{'intercept'}];
    end
    set(handles.SelectIVs_pushbutton,'enable','off');
    set(handles.Contrats_F_popupmenu,'enable','on');
    set(handles.Numcontrasts_edit,'enable','on');
    set(handles.Contrasts_uitable,'Data',[]);
    set(handles.Contrasts_uitable,'ColumnName',[]);
elseif strcmp(handles.out.same_desmat,'No')
    handles.out.desmat   = [];
    handles.out.IV_names = [];
    set(handles.Contrasts_uitable,'Data',[]);
    set(handles.Contrasts_uitable,'ColumnName',[]);
    set(handles.SelectIVs_pushbutton,'enable','on');
else
    set(handles.SelectIVs_pushbutton,'enable','off');
    set(handles.Contrats_F_popupmenu,'enable','off');
    set(handles.Numcontrasts_edit,'enable','off');
end
guidata(hObject,handles);

function Samedesmat_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SelectIVs_pushbutton_Callback(hObject, eventdata, handles)
wksp_vars          = evalin('base','who');
handles.out.desmat = [];                                                                                                      % Set empty design matrix to start
var_selection      = listdlg('PromptString',{'Select predictors:',''},'SelectionMode','multiple','ListString',char(wksp_vars)); % Ask the user to select their IVs
for var = 1:length(var_selection)                                                                                              % For each IV selected
    handles.out.IV_names{1,var} =  wksp_vars{var_selection(var)};
    handles.out.desmat          = [handles.out.desmat,evalin('base',wksp_vars{var_selection(var)})];                                                      % Get IV from workspace and add to design matrix
end
if rank([handles.out.desmat,ones(size(handles.out.desmat,1),1)]) == (size(handles.out.desmat,2)+1) % If an intercept can be added without making the design matrix rank deficient
    handles.out.desmat   = [handles.out.desmat,ones(size(handles.out.desmat,1),1)];
    handles.out.IV_names = [handles.out.IV_names,{'intercept'}];
end
set(handles.Contrats_F_popupmenu,'enable','on');
set(handles.Numcontrasts_edit,'enable','on');
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Contrats_F_popupmenu_Callback(hObject, eventdata, handles)
contents                  = cellstr(get(hObject,'String'));
handles.out.Contrast_or_F = contents{get(hObject,'Value')};
guidata(hObject,handles);

function Contrats_F_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Numcontrasts_edit_Callback(hObject, eventdata, handles)
handles.out.num_contrasts = str2double(get(hObject,'String'));
def_contrasts             = zeros(handles.out.num_contrasts,size(handles.out.desmat,2));
set(handles.Contrasts_uitable,'Data',[]);
set(handles.Contrasts_uitable,'ColumnName',[]);
set(handles.Contrasts_uitable,'Data',def_contrasts);
set(handles.Contrasts_uitable,'Columneditable',true(1,size(handles.out.desmat,2)));
set(handles.Contrasts_uitable,'ColumnName',handles.out.IV_names);
set(handles.Contrasts_uitable,'enable','on');
guidata(hObject,handles);

function Numcontrasts_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Contrasts_uitable_CellEditCallback(hObject, eventdata, handles)
handles.out.contrasts = get(hObject,'Data');
guidata(hObject,handles);

function Contrasts_uitable_CreateFcn(hObject, eventdata, handles)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Testallnodes_checkbox_Callback(hObject, eventdata, handles)
handles.out.test_all_nodes = get(hObject,'Value');

if handles.out.test_all_nodes == 1
    handles.out.node_mask = ones(handles.out.nROI,1);
    set(handles.Nodemask_edit,'enable','off');
    set(handles.Nodeselect_pushbutton,'enable','off');
elseif handles.out.test_all_nodes == 0
    set(handles.Nodemask_edit,'enable','on');
    set(handles.Nodeselect_pushbutton,'enable','on');
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Nodemask_edit_Callback(hObject, eventdata, handles)
temp                  = get(hObject,'String');
handles.out.node_mask = evalin('base',temp);
handles.out.test_all_nodes = 0;
guidata(hObject,handles);

function Nodemask_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Nodeselect_pushbutton_Callback(hObject, eventdata, handles)
[selection]                      = listdlg('PromptString',{'Select ALL nodes to test:',''},'SelectionMode','multiple','ListString',char(handles.out.ROI_labels),'initialvalue',1);
handles.out.node_mask            = zeros(handles.out.nROI,1);
handles.out.node_mask(selection) = 1;
handles.out.test_all_nodes       = 0;
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Testalledges_checkbox_Callback(hObject, eventdata, handles)
handles.out.test_all_edges = get(hObject,'Value');

if handles.out.test_all_edges == 1
    handles.out.edge_mask = triu(ones(handles.out.nROI,handles.out.nROI),1);
    set(handles.Edgemask_edit,'enable','off');
    set(handles.Edgeselect_pushbutton,'enable','off');
elseif handles.out.test_all_nodes == 0
    set(handles.Edgemask_edit,'enable','on');
    set(handles.Edgeselect_pushbutton,'enable','on');
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Edgemask_edit_Callback(hObject, eventdata, handles)
temp                  = get(hObject,'String');
handles.out.edge_mask = evalin('base',temp);
guidata(hObject,handles);

function Edgemask_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Edgeselect_pushbutton_Callback(hObject, eventdata, handles)
num_edges        = str2double(cell2mat(inputdlg(sprintf('Enter the TOTAL number of edges to test:\n'),'Total edges',2)));
[node_selection] = listdlg('PromptString',{'Select ALL nodes that are linked by your edges of interest:',''},'SelectionMode','multiple','ListString',char(handles.out.ROI_labels),'initialvalue',1);
nodenames = {handles.out.ROI_labels{node_selection}}; %#ok<CCAT1>
if size(nodenames,1) < size(nodenames,2)
    nodenames = nodenames';
end

handles.out.edge_mask = zeros(handles.out.nROI,handles.out.nROI);
for curr_edge = 1:num_edges
    [edge_selection] = listdlg('PromptString',{['Select nodes for edge ' num2str(curr_edge) ':'],''},'SelectionMode','multiple','ListString',char(nodenames));
    handles.out.edge_mask(node_selection(edge_selection(1)),node_selection(edge_selection(2)),:) = 1;
end
handles.out.test_all_edges = 0;
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Fullprop_listbox_Callback(hObject, eventdata, handles)
contents                              = cellstr(get(hObject,'String'));
handles.out.properties_tested_fullmat = contents(get(hObject,'Value'));
guidata(hObject,handles);

function Fullprop_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Thrprop_listbox_Callback(hObject, eventdata, handles)
contents                             = cellstr(get(hObject,'String'));
handles.out.properties_tested_thrmat = contents(get(hObject,'Value'));
guidata(hObject,handles);

function Thrprop_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_pushbutton_Callback(hObject, eventdata, handles)
out = handles.out;

% Remove potentially conflicting fields
if isfield(out,'full')
    out = rmfield(out,'full');
end
if isfield(out,'thrAUC')
    out = rmfield(out,'thrAUC');
end
if isfield(out,'sig_find')
    out = rmfield(out,'sig_find');
end

% Check whether inputs have been specified
if ~exist('out','var')
    msgbox('Enter output from previous stage (structure with graph properties)','Error','error')
    return
end
if ~isfield(out,'alpha')
    out.alpha = 0.05;
end
if ~isfield(out,'outname')
    msgbox('Enter an output name','Error','error')
    return
end
if ~isfield(out,'num_perms')
    out.num_perms = 5000;
end
if ~isfield(out,'HLA_reg_type')
    out.HLA_reg_type = 'OLS';
end
if ~isfield(out,'same_desmat')
    msgbox('Indicate whether you want to use the design matrix from the previous stage','Error','error')
    return
end
if ~isfield(out,'Contrast_or_F')
    out.Contrast_or_F = 'Contrasts';
end
if ~isfield(out,'num_contrasts')
    msgbox('Enter the number of contrasts desired','Error','error')
    return
end
if ~isfield(out,'contrasts')
    msgbox('Enter the contrast weights','Error','error')
    return
end
if any(sum(abs(out.contrasts),2) == 0)
    msgbox('At least 1 contrast has no non-zero weights','Error','error')
    return
end
if ~isfield(out,'properties_tested_fullmat') && ~isfield(out,'properties_tested_thrmat')
    msgbox('Select at least one property to test','Error','error')
    return
elseif ~isfield(out,'properties_tested_thrmat') && all(strcmp(out.properties_tested_fullmat,'None') == 1)
    msgbox('Select at least one property to test','Error','error')
    return
elseif ~isfield(out,'properties_tested_fullmat') && all(strcmp(out.properties_tested_thrmat,'None') == 1)
    msgbox('Select at least one property to test','Error','error')
    return
elseif (isfield(out,'properties_tested_fullmat') && all(strcmp(out.properties_tested_fullmat,'None') == 1)) && (isfield(out,'properties_tested_thrmat') && all(strcmp(out.properties_tested_thrmat,'None') == 1))
    msgbox('Select at least one property to test','Error','error')
    return
elseif ~isfield(out,'properties_tested_fullmat')
    out.properties_tested_fullmat = {};
elseif ~isfield(out,'properties_tested_thrmat')
    out.properties_tested_thrmat  = {};
end

% Set intial values to 0 (no testing)
out.test_props_fullmat.assort        = 0;
out.test_props_fullmat.cpl           = 0;
out.test_props_fullmat.clust_coef    = 0;
out.test_props_fullmat.div_coef      = 0;
out.test_props_fullmat.edge_bet_cent = 0;
out.test_props_fullmat.eigvec_cent   = 0;
out.test_props_fullmat.glob_eff      = 0;
out.test_props_fullmat.loc_eff       = 0;
out.test_props_fullmat.match         = 0;
out.test_props_fullmat.node_bet_cent = 0;
out.test_props_fullmat.rich_club     = 0;
out.test_props_fullmat.strength      = 0;
out.test_props_fullmat.pagerank_cent = 0;
out.test_props_fullmat.part_coef     = 0;
out.test_props_fullmat.trans         = 0;
out.test_props_fullmat.mod_deg_z     = 0;

out.test_props_thrmat.assort        = 0;
out.test_props_thrmat.cpl           = 0;
out.test_props_thrmat.clust_coef    = 0;
out.test_props_thrmat.deg           = 0;
out.test_props_thrmat.dens          = 0;
out.test_props_thrmat.edge_bet_cent = 0;
out.test_props_thrmat.eigvec_cent   = 0;
out.test_props_thrmat.glob_eff      = 0;
out.test_props_thrmat.kcore_cent    = 0;
out.test_props_thrmat.loc_eff       = 0;
out.test_props_thrmat.match         = 0;
out.test_props_thrmat.node_bet_cent = 0;
out.test_props_thrmat.pagerank_cent = 0;
out.test_props_thrmat.part_coef     = 0;
out.test_props_thrmat.rich_club     = 0;
out.test_props_thrmat.small_world   = 0;
out.test_props_thrmat.sub_cent      = 0;
out.test_props_thrmat.trans         = 0;
out.test_props_thrmat.mod_deg_z     = 0;

% Determine which properties the user selected for fully connected matrices
if ismember('Assortativity',out.properties_tested_fullmat)
    out.test_props_fullmat.assort        = 1;
end
if ismember('Characteristic Path Length',out.properties_tested_fullmat)
    out.test_props_fullmat.cpl           = 1;
end
if ismember('Clustering Coefficient',out.properties_tested_fullmat)
    out.test_props_fullmat.clust_coef    = 1;
end
if ismember('Diversity Coefficient',out.properties_tested_fullmat)
    out.test_props_fullmat.div_coef      = 1;
end
if ismember('Edge Betweeness Centrality',out.properties_tested_fullmat)
    out.test_props_fullmat.edge_bet_cent = 1;
end
if ismember('Eigenvector Centrality',out.properties_tested_fullmat)
    out.test_props_fullmat.eigvec_cent   = 1;
end
if ismember('Global Efficiency',out.properties_tested_fullmat)
    out.test_props_fullmat.glob_eff      = 1;
end
if ismember('Local Efficiency',out.properties_tested_fullmat)
    out.test_props_fullmat.loc_eff       = 1;
end
if ismember('Matching Index',out.properties_tested_fullmat)
    out.test_props_fullmat.match         = 1;
end
if ismember('Node Betweeness Centrality',out.properties_tested_fullmat)
    out.test_props_fullmat.node_bet_cent = 1;
end
if ismember('Node Strength',out.properties_tested_fullmat)
    out.test_props_fullmat.strength      = 1;
end
if ismember('PageRank Centrality',out.properties_tested_fullmat)
    out.test_props_fullmat.pagerank_cent = 1;
end
if ismember('Participation Coefficient',out.properties_tested_fullmat)
    out.test_props_fullmat.part_coef     = 1;
end
if ismember('Rich Club Networks',out.properties_tested_fullmat)
    out.test_props_fullmat.rich_club     = 1;
end
if ismember('Transitivity',out.properties_tested_fullmat)
    out.test_props_fullmat.trans         = 1;
end
if ismember('Within-Module Degree Z-Score',out.properties_tested_fullmat)
    out.test_props_fullmat.mod_deg_z     = 1;
end

% Determine which properties the user selected for thresholded matrices
if ismember('Assortativity',out.properties_tested_thrmat)
    out.test_props_thrmat.assort        = 1;
end
if ismember('Characteristic Path Length',out.properties_tested_thrmat)
    out.test_props_thrmat.cpl           = 1;
end
if ismember('Clustering Coefficient',out.properties_tested_thrmat)
    out.test_props_thrmat.clust_coef    = 1;
end
if ismember('Degree',out.properties_tested_thrmat)
    out.test_props_thrmat.deg           = 1;
end
if ismember('Density',out.properties_tested_thrmat)
    out.test_props_thrmat.dens          = 1;
end
if ismember('Edge Betweeness Centrality',out.properties_tested_thrmat)
    out.test_props_thrmat.edge_bet_cent = 1;
end
if ismember('Eigenvector Centrality',out.properties_tested_thrmat)
    out.test_props_thrmat.eigvec_cent   = 1;
end
if ismember('Global Efficiency',out.properties_tested_thrmat)
    out.test_props_thrmat.glob_eff      = 1;
end
if ismember('K-Coreness Centrality',out.properties_tested_thrmat)
    out.test_props_thrmat.kcore_cent    = 1;
end
if ismember('Local Efficiency',out.properties_tested_thrmat)
    out.test_props_thrmat.loc_eff       = 1;
end
if ismember('Matching Index',out.properties_tested_thrmat)
    out.test_props_thrmat.match         = 1;
end
if ismember('Node Betweeness Centrality',out.properties_tested_thrmat)
    out.test_props_thrmat.node_bet_cent = 1;
end
if ismember('PageRank Centrality',out.properties_tested_thrmat)
    out.test_props_thrmat.pagerank_cent = 1;
end
if ismember('Participation Coefficient',out.properties_tested_thrmat)
    out.test_props_thrmat.part_coef     = 1;
end
if ismember('Rich Club Networks',out.properties_tested_thrmat)
    out.test_props_thrmat.rich_club     = 1;
end
if ismember('Small Worldness',out.properties_tested_thrmat)
    out.test_props_thrmat.small_world   = 1;
end
if ismember('Subgraph Centrality',out.properties_tested_thrmat)
    out.test_props_thrmat.sub_cent      = 1;
end
if ismember('Transitivity',out.properties_tested_thrmat)
    out.test_props_thrmat.trans         = 1;
end
if ismember('Within-Module Degree Z-Score',out.properties_tested_thrmat)
    out.test_props_thrmat.mod_deg_z     = 1;
end

if out.test_props_fullmat.clust_coef         == 1 || ...
        out.test_props_fullmat.div_coef      == 1 || ...
        out.test_props_fullmat.eigvec_cent   == 1 || ...
        out.test_props_fullmat.loc_eff       == 1 || ...
        out.test_props_fullmat.node_bet_cent == 1 || ...
        out.test_props_fullmat.strength      == 1 || ...
        out.test_props_fullmat.pagerank_cent == 1 || ...
        out.test_props_fullmat.part_coef     == 1 || ...
        out.test_props_fullmat.mod_deg_z     == 1 || ...
        out.test_props_thrmat.clust_coef     == 1 || ...
        out.test_props_thrmat.deg            == 1 || ...
        out.test_props_thrmat.eigvec_cent    == 1 || ...
        out.test_props_thrmat.kcore_cent     == 1 || ...
        out.test_props_thrmat.loc_eff        == 1 || ...
        out.test_props_thrmat.node_bet_cent  == 1 || ...
        out.test_props_thrmat.pagerank_cent  == 1 || ...
        out.test_props_thrmat.part_coef      == 1 || ...
        out.test_props_thrmat.sub_cent       == 1 || ...
        out.test_props_thrmat.mod_deg_z      == 1
    
    if ~isfield(out,'test_all_nodes') && ~isfield(out,'node_mask')
        msgbox('Indicate whether to test all nodes','Error','error')
        return
    elseif out.test_all_nodes == 0 && ~isfield(out,'node_mask')
        msgbox('Select which nodes to test','Error','error')
        return
    elseif out.test_all_nodes == 0 && sum(out.node_mask(:)) == 0
        msgbox('Select at least one node to test','Error','error')
        return
    end
end
if out.test_props_fullmat.edge_bet_cent     == 1 || ...
        out.test_props_fullmat.match        == 1 || ...
        out.test_props_thrmat.edge_bet_cent == 1 || ...
        out.test_props_thrmat.match         == 1
    
    if ~isfield(out,'test_all_edges') && ~isfield(out,'edge_mask')
        msgbox('Indicate whether to test all edges','Error','error')
        return
    elseif out.test_all_edges == 0 && ~isfield(out,'edge_mask')
        msgbox('Select which edges to test','Error','error')
        return
    elseif out.test_all_edges == 0 && sum(out.edge_mask(:)) == 0
        msgbox('Select at least one edge to test','Error','error')
        return
    end
end

set(handles.Start_pushbutton,'enable','off');

if size(out.desmat,2) == 1 && unique(out.desmat) == 1
    perms        = ones(out.num_subs,out.num_perms,2);
    perms(:,:,2) = -1;
    for curr_perm = out.num_perms:-1:1
        for curr_sub = out.num_subs:-1:1
            perms(curr_sub,curr_perm,:) = perms(curr_sub,curr_perm,randperm(2));
        end
    end
    perms = perms(:,:,1);
else
    perms = zeros(out.num_subs,out.num_perms);
    for curr_perm = out.num_perms:-1:1
        perms(:,curr_perm) = randperm(out.num_subs);
    end
end

if out.num_rep_levs > 1
    within_perms = zeros(out.num_subs,out.num_rep_levs,out.num_perms);
    orig_ord = zeros(out.num_subs,out.num_rep_levs);
    for lev = 1:out.num_rep_levs
        orig_ord(:,lev) = ((((lev*out.num_subs)-out.num_subs)+1):(lev*out.num_subs))';
    end
    for curr_perm = out.num_perms:-1:1
        for curr_sub = out.num_subs:-1:1
            within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
        end
    end
    out.HLA_reg_type = 'OLS';
else
    within_perms = [];
end

if out.test_props_fullmat.rich_club == 1 || out.test_props_thrmat.rich_club == 1
    out.rich_club_min_n = str2double(cell2mat(inputdlg(sprintf('Rich clubs often cannot be calculated for a subset of participants.\nThis data is automatically excluded in analyses, leaving only a\nsubset of participants available for analysis.\n\nEnter the minimum number of participants you will allow:\n'),'Min n for rich club',2)));
end

toolboxes  = ver;
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

out.outname = [out.outname '_permoutput'];
sigeffects_fid = fopen([out.outname,'_sig_analyses.txt'],'w');

desmat_vars = 'Design matrix = [';
for var = 1:length(out.IV_names)
    desmat_vars = [desmat_vars,' ',out.IV_names{1,var}]; %#ok<AGROW>
end
desmat_vars = [desmat_vars,']'];
fprintf(sigeffects_fid,'%s\n\n',desmat_vars);

for con = 1:size(out.contrasts,1)
    fprintf(sigeffects_fid,'Contrast %s:  [%s]\n',num2str(con),num2str(out.contrasts(con,:)));
end
fprintf(sigeffects_fid,'\n\n');

NaNout = ones(out.num_rep_levs,1).*NaN;
for con = 1:size(out.contrasts,1)
    fprintf('Running permutation analyses for contrast/F-test %s ...\n',num2str(con))
    curr_con = out.contrasts(con,:)';
    progressbar(['Progress For Contrast/F-Test ' num2str(con)])                                         % Initialize progress bars at zero
    
    tot_props_to_calc = out.test_props_fullmat.assort+ ...
        out.test_props_fullmat.cpl+ ...
        out.test_props_fullmat.clust_coef+ ...
        out.test_props_fullmat.div_coef+ ...
        out.test_props_fullmat.edge_bet_cent+ ...
        out.test_props_fullmat.eigvec_cent+ ...
        out.test_props_fullmat.glob_eff+ ...
        out.test_props_fullmat.loc_eff+ ...
        out.test_props_fullmat.match+ ...
        out.test_props_fullmat.node_bet_cent+ ...
        out.test_props_fullmat.rich_club+ ...
        out.test_props_fullmat.strength+ ...
        out.test_props_fullmat.pagerank_cent+ ...
        out.test_props_fullmat.part_coef+ ...
        out.test_props_fullmat.trans+ ...
        out.test_props_fullmat.mod_deg_z+ ...
        out.test_props_thrmat.assort+ ...
        out.test_props_thrmat.cpl+ ...
        out.test_props_thrmat.clust_coef+ ...
        out.test_props_thrmat.deg+ ...
        out.test_props_thrmat.dens+ ...
        out.test_props_thrmat.edge_bet_cent+ ...
        out.test_props_thrmat.eigvec_cent+ ...
        out.test_props_thrmat.glob_eff+ ...
        out.test_props_thrmat.kcore_cent+ ...
        out.test_props_thrmat.loc_eff+ ...
        out.test_props_thrmat.match+ ...
        out.test_props_thrmat.node_bet_cent+ ...
        out.test_props_thrmat.pagerank_cent+ ...
        out.test_props_thrmat.part_coef+ ...
        out.test_props_thrmat.rich_club+ ...
        out.test_props_thrmat.small_world+ ...
        out.test_props_thrmat.sub_cent+ ...
        out.test_props_thrmat.trans+ ...
        out.test_props_thrmat.mod_deg_z;
    curr_props_calcd = 0;
    
    %%%% Less efficient, but more parsable, code for creating contrast
    %%%% predictor
    % Q = inv(out.desmat'*out.desmat);
    % F1 = inv(curr_con'*Q*curr_con);
    % currpred_desmat = out.desmat*Q*curr_con*F1;
    % Pc = curr_con*inv(curr_con'*Q*curr_con)*curr_con'*Q;
    % orth_con = null(curr_con');
    % c3 = orth_con-Pc*orth_con;
    % F3 = inv(c3'*Q*c3);
    % currcovars_desmat = out.desmat*Q*c3*F3;
    
    %%%% Create contrast predictor (and orthogonal predictors for rest of
    %%%% design matrix)
    if size(out.desmat,2) == 1 && unique(out.desmat) == 1
        currcovars_desmat = [];
        curr_full_desmat  = out.desmat;
    else
        if strcmp(out.Contrast_or_F,'Contrasts')
            currpred_desmat   = out.desmat/(out.desmat'*out.desmat)*curr_con/(curr_con'/(out.desmat'*out.desmat)*curr_con);
            Pc                = curr_con/(curr_con'/(out.desmat'*out.desmat)*curr_con)*curr_con'/(out.desmat'*out.desmat);
            orth_con          = null(curr_con');
            c3                = orth_con-Pc*orth_con;
            currcovars_desmat = out.desmat/(out.desmat'*out.desmat)*c3/(c3'/(out.desmat'*out.desmat)*c3);
            curr_full_desmat  = [currpred_desmat,currcovars_desmat];
        else
            currpred_desmat   = out.desmat(:,logical(curr_con));
            currcovars_desmat = out.desmat(:,~logical(curr_con));
            curr_full_desmat  = [currpred_desmat,currcovars_desmat];
        end
    end
    
    %%%% Methods for calculating p-values
    % Method 1
    % 1. Calc p for neg t-value or 1-p for pos t-value
    % 2. Double that value
    % This method may be problematic if the distribution is extremely
    % skewed
    %
    % Method 2
    % 1. Calc p for both pos and neg values of t
    % 2. Subtract p val for neg t-value from p val for pos t-value
    % 3. Subtract that value from 1
    %
    % To get an accurate 1-tailed p-value, halve the p from method 1
    
    %%%% Run permutation analyses
    
    if out.test_props_fullmat.assort == 1
        [out.full.assort_pos.beta(con,:), ...
            out.full.assort_pos.test_stat(con,:), ...
            out.full.assort_pos.crit_val(con,:), ...
            out.full.assort_pos.p_1tail(con,:), ...
            out.full.assort_pos.p_2tail(con,:), ...
            out.full.assort_pos.hadNaN(con,:), ...
            out.full.assort_pos.hadimag(con,:), ...
            out.full.assort_pos.hadInf(con,:)] = ...
            GTG_GLM(out.fullmat_graph_meas.assort_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        if out.use_abs_val == 0
            [out.full.assort_neg.beta(con,:), ...
                out.full.assort_neg.test_stat(con,:), ...
                out.full.assort_neg.crit_val(con,:), ...
                out.full.assort_neg.p_1tail(con,:), ...
                out.full.assort_neg.p_2tail(con,:), ...
                out.full.assort_neg.hadNaN(con,:), ...
                out.full.assort_neg.hadimag(con,:), ...
                out.full.assort_neg.hadInf(con,:)] = ...
                GTG_GLM(out.fullmat_graph_meas.assort_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.assort == 1
        [out.thrAUC.assort_pos.beta(con,:), ...
            out.thrAUC.assort_pos.test_stat(con,:), ...
            out.thrAUC.assort_pos.crit_val(con,:), ...
            out.thrAUC.assort_pos.p_1tail(con,:), ...
            out.thrAUC.assort_pos.p_2tail(con,:), ...
            out.thrAUC.assort_pos.hadNaN(con,:), ...
            out.thrAUC.assort_pos.hadimag(con,:), ...
            out.thrAUC.assort_pos.hadInf(con,:)] = ...
            GTG_GLM(out.AUC_thrmat_graph_meas.assort_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            [out.thrAUC.assort_neg.beta(con,:), ...
                out.thrAUC.assort_neg.test_stat(con,:), ...
                out.thrAUC.assort_neg.crit_val(con,:), ...
                out.thrAUC.assort_neg.p_1tail(con,:), ...
                out.thrAUC.assort_neg.p_2tail(con,:), ...
                out.thrAUC.assort_neg.hadNaN(con,:), ...
                out.thrAUC.assort_neg.hadimag(con,:), ...
                out.thrAUC.assort_neg.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.assort_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        if out.calcAUC_nodiscon == 1
            [out.thrAUC.assort_pos_nodiscon.beta(con,:), ...
                out.thrAUC.assort_pos_nodiscon.test_stat(con,:), ...
                out.thrAUC.assort_pos_nodiscon.crit_val(con,:), ...
                out.thrAUC.assort_pos_nodiscon.p_1tail(con,:), ...
                out.thrAUC.assort_pos_nodiscon.p_2tail(con,:), ...
                out.thrAUC.assort_pos_nodiscon.hadNaN(con,:), ...
                out.thrAUC.assort_pos_nodiscon.hadimag(con,:), ...
                out.thrAUC.assort_pos_nodiscon.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.assort_pos_nodiscon, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                [out.thrAUC.assort_neg_nodiscon.beta(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.test_stat(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.crit_val(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.p_1tail(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.p_2tail(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.hadNaN(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.hadimag(con,:), ...
                    out.thrAUC.assort_neg_nodiscon.hadInf(con,:)] = ...
                    GTG_GLM(out.AUC_thrmat_graph_meas.assort_neg_nodiscon, ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.cpl == 1
        [out.full.cpl_pos.beta(con,:), ...
            out.full.cpl_pos.test_stat(con,:), ...
            out.full.cpl_pos.crit_val(con,:), ...
            out.full.cpl_pos.p_1tail(con,:), ...
            out.full.cpl_pos.p_2tail(con,:), ...
            out.full.cpl_pos.hadNaN(con,:), ...
            out.full.cpl_pos.hadimag(con,:), ...
            out.full.cpl_pos.hadInf(con,:)] = ...
            GTG_GLM(out.fullmat_graph_meas.cpl_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0
            [out.full.cpl_neg.beta(con,:), ...
                out.full.cpl_neg.test_stat(con,:), ...
                out.full.cpl_neg.crit_val(con,:), ...
                out.full.cpl_neg.p_1tail(con,:), ...
                out.full.cpl_neg.p_2tail(con,:), ...
                out.full.cpl_neg.hadNaN(con,:), ...
                out.full.cpl_neg.hadimag(con,:), ...
                out.full.cpl_neg.hadInf(con,:)] = ...
                GTG_GLM(out.fullmat_graph_meas.cpl_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.cpl == 1
        [out.thrAUC.cpl_pos.beta(con,:), ...
            out.thrAUC.cpl_pos.test_stat(con,:), ...
            out.thrAUC.cpl_pos.crit_val(con,:), ...
            out.thrAUC.cpl_pos.p_1tail(con,:), ...
            out.thrAUC.cpl_pos.p_2tail(con,:), ...
            out.thrAUC.cpl_pos.hadNaN(con,:), ...
            out.thrAUC.cpl_pos.hadimag(con,:), ...
            out.thrAUC.cpl_pos.hadInf(con,:)] = ...
            GTG_GLM(out.AUC_thrmat_graph_meas.cpl_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            [out.thrAUC.cpl_neg.beta(con,:), ...
                out.thrAUC.cpl_neg.test_stat(con,:), ...
                out.thrAUC.cpl_neg.crit_val(con,:), ...
                out.thrAUC.cpl_neg.p_1tail(con,:), ...
                out.thrAUC.cpl_neg.p_2tail(con,:), ...
                out.thrAUC.cpl_neg.hadNaN(con,:), ...
                out.thrAUC.cpl_neg.hadimag(con,:), ...
                out.thrAUC.cpl_neg.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.cpl_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        if out.calcAUC_nodiscon == 1
            [out.thrAUC.cpl_pos_nodiscon.beta(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.test_stat(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.crit_val(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.p_1tail(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.p_2tail(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.hadNaN(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.hadimag(con,:), ...
                out.thrAUC.cpl_pos_nodiscon.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.cpl_pos_nodiscon, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                [out.thrAUC.cpl_neg_nodiscon.beta(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.test_stat(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.crit_val(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.p_1tail(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.p_2tail(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.hadNaN(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.hadimag(con,:), ...
                    out.thrAUC.cpl_neg_nodiscon.hadInf(con,:)] = ...
                    GTG_GLM(out.AUC_thrmat_graph_meas.cpl_neg_nodiscon, ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.clust_coef == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.full.clust_coef_pos.beta(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.test_stat(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.crit_val(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.hadimag(con,curr_ROI,:), ...
                    out.full.clust_coef_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.clust_coef_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                
                if out.use_abs_val == 0
                    [out.full.clust_coef_neg.beta(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.test_stat(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.crit_val(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.hadimag(con,curr_ROI,:), ...
                        out.full.clust_coef_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.clust_coef_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                end
            else
                out.full.clust_coef_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.clust_coef_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.clust_coef_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.clust_coef_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.clust_coef_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.clust_coef_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.clust_coef_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.clust_coef_pos.p_2tail(con,curr_ROI,:)   = NaNout;
                
                if out.use_abs_val == 0
                    out.full.clust_coef_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.clust_coef_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.clust_coef_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.clust_coef_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.clust_coef_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.clust_coef_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.clust_coef_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.clust_coef_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.clust_coef == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.clust_coef_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.clust_coef_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.clust_coef_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.clust_coef_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.clust_coef_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.clust_coef_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.clust_coef_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.clust_coef_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.clust_coef_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.clust_coef_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.clust_coef_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.clust_coef_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.clust_coef_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.clust_coef_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.clust_coef_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.clust_coef_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.clust_coef_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.clust_coef_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.clust_coef_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.clust_coef_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.clust_coef_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.clust_coef_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.clust_coef_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.clust_coef_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.clust_coef_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.clust_coef_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.clust_coef_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.clust_coef_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.clust_coef_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.clust_coef_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.clust_coef_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.clust_coef_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.clust_coef_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.clust_coef_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.clust_coef_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.clust_coef_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.clust_coef_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.clust_coef_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.clust_coef_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.clust_coef_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.clust_coef_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.clust_coef_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.clust_coef_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.deg == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.deg_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.deg_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.deg_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.deg_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.deg_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.deg_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.deg_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.deg_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.deg_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.deg_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.deg_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.deg_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.deg_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.deg_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.deg_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.deg_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.deg_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.deg_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.deg_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.deg_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.deg_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.deg_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.deg_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.deg_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.deg_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.deg_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.deg_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.deg_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.deg_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.deg_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.deg_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.deg_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.deg_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.deg_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.deg_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.deg_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.deg_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.deg_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.deg_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.deg_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.deg_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.deg_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.deg_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.deg_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.dens == 1
        [out.thrAUC.dens_pos.beta(con,:), ...
            out.thrAUC.dens_pos.test_stat(con,:), ...
            out.thrAUC.dens_pos.crit_val(con,:), ...
            out.thrAUC.dens_pos.p_1tail(con,:), ...
            out.thrAUC.dens_pos.p_2tail(con,:), ...
            out.thrAUC.dens_pos.hadNaN(con,:), ...
            out.thrAUC.dens_pos.hadimag(con,:), ...
            out.thrAUC.dens_pos.hadInf(con,:)] = ...
            GTG_GLM(out.AUC_thrmat_graph_meas.dens_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            [out.thrAUC.dens_neg.beta(con,:), ...
                out.thrAUC.dens_neg.test_stat(con,:), ...
                out.thrAUC.dens_neg.crit_val(con,:), ...
                out.thrAUC.dens_neg.p_1tail(con,:), ...
                out.thrAUC.dens_neg.p_2tail(con,:), ...
                out.thrAUC.dens_neg.hadNaN(con,:), ...
                out.thrAUC.dens_neg.hadimag(con,:), ...
                out.thrAUC.dens_neg.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.dens_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        if out.calcAUC_nodiscon == 1
            [out.thrAUC.dens_pos_nodiscon.beta(con,:), ...
                out.thrAUC.dens_pos_nodiscon.test_stat(con,:), ...
                out.thrAUC.dens_pos_nodiscon.crit_val(con,:), ...
                out.thrAUC.dens_pos_nodiscon.p_1tail(con,:), ...
                out.thrAUC.dens_pos_nodiscon.p_2tail(con,:), ...
                out.thrAUC.dens_pos_nodiscon.hadNaN(con,:), ...
                out.thrAUC.dens_pos_nodiscon.hadimag(con,:), ...
                out.thrAUC.dens_pos_nodiscon.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.dens_pos_nodiscon, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                [out.thrAUC.dens_neg_nodiscon.beta(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.test_stat(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.crit_val(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.p_1tail(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.p_2tail(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.hadNaN(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.hadimag(con,:), ...
                    out.thrAUC.dens_neg_nodiscon.hadInf(con,:)] = ...
                    GTG_GLM(out.AUC_thrmat_graph_meas.dens_neg_nodiscon, ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.div_coef == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.full.div_coef_pos.beta(con,curr_ROI,:), ...
                    out.full.div_coef_pos.test_stat(con,curr_ROI,:), ...
                    out.full.div_coef_pos.crit_val(con,curr_ROI,:), ...
                    out.full.div_coef_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.div_coef_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.div_coef_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.div_coef_pos.hadimag(con,curr_ROI,:), ...
                    out.full.div_coef_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.div_coef_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                
                if out.use_abs_val == 0
                    [out.full.div_coef_neg.beta(con,curr_ROI,:), ...
                        out.full.div_coef_neg.test_stat(con,curr_ROI,:), ...
                        out.full.div_coef_neg.crit_val(con,curr_ROI,:), ...
                        out.full.div_coef_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.div_coef_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.div_coef_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.div_coef_neg.hadimag(con,curr_ROI,:), ...
                        out.full.div_coef_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.div_coef_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                end
            else
                out.full.div_coef_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.div_coef_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.div_coef_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.div_coef_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.div_coef_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.div_coef_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.div_coef_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.div_coef_pos.p_2tail(con,curr_ROI,:)   = NaNout;
                
                if out.use_abs_val == 0
                    out.full.div_coef_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.div_coef_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.div_coef_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.div_coef_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.div_coef_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.div_coef_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.div_coef_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.div_coef_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.edge_bet_cent == 1
        for curr_row_ROI = out.nROI:-1:1
            for curr_col_ROI = out.nROI:-1:1
                if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.edge_bet_cent_pos(:,curr_row_ROI,curr_col_ROI,:))))
                    [out.full.edge_bet_cent_pos.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.edge_bet_cent_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.edge_bet_cent_pos(:,curr_row_ROI,curr_col_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.edge_bet_cent_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.full.edge_bet_cent_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                    out.full.edge_bet_cent_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.full.edge_bet_cent_pos.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                    out.full.edge_bet_cent_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                    out.full.edge_bet_cent_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                    out.full.edge_bet_cent_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    out.full.edge_bet_cent_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0
                    if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.edge_bet_cent_neg(:,curr_row_ROI,curr_col_ROI,:))))
                        [out.full.edge_bet_cent_neg.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.edge_bet_cent_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                            GTG_GLM(squeeze(out.fullmat_graph_meas.edge_bet_cent_neg(:,curr_row_ROI,curr_col_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.full.edge_bet_cent_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.full.edge_bet_cent_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                        out.full.edge_bet_cent_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.full.edge_bet_cent_neg.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                        out.full.edge_bet_cent_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                        out.full.edge_bet_cent_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                        out.full.edge_bet_cent_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        out.full.edge_bet_cent_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.edge_bet_cent == 1
        for curr_row_ROI = out.nROI:-1:1
            for curr_col_ROI = out.nROI:-1:1
                if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.edge_bet_cent(:,curr_row_ROI,curr_col_ROI,:))))
                    [out.thrAUC.edge_bet_cent_pos.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.edge_bet_cent_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.edge_bet_cent_pos(:,curr_row_ROI,curr_col_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.edge_bet_cent_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.thrAUC.edge_bet_cent_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                    out.thrAUC.edge_bet_cent_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.thrAUC.edge_bet_cent_pos.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                    out.thrAUC.edge_bet_cent_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                    out.thrAUC.edge_bet_cent_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                    out.thrAUC.edge_bet_cent_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    out.thrAUC.edge_bet_cent_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.edge_bet_cent(:,curr_row_ROI,curr_col_ROI,:))))
                        [out.thrAUC.edge_bet_cent_neg.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.edge_bet_cent_neg(:,curr_row_ROI,curr_col_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.edge_bet_cent_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.edge_bet_cent_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                        out.thrAUC.edge_bet_cent_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.edge_bet_cent_neg.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                        out.thrAUC.edge_bet_cent_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                        out.thrAUC.edge_bet_cent_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                        out.thrAUC.edge_bet_cent_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        out.thrAUC.edge_bet_cent_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    end
                end
                
                if out.calcAUC_nodiscon == 1
                    if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.edge_bet_cent(:,curr_row_ROI,curr_col_ROI,:))))
                        [out.thrAUC.edge_bet_cent_pos_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.edge_bet_cent_pos_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.edge_bet_cent_pos_nodiscon(:,curr_row_ROI,curr_col_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.edge_bet_cent_pos_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        out.thrAUC.edge_bet_cent_pos_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    end
                    
                    if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                        if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.edge_bet_cent(:,curr_row_ROI,curr_col_ROI,:))))
                            [out.thrAUC.edge_bet_cent_neg_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.edge_bet_cent_neg_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                                GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.edge_bet_cent_neg_nodiscon(:,curr_row_ROI,curr_col_ROI,:)), ...
                                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                        else
                            out.thrAUC.edge_bet_cent_neg_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                            out.thrAUC.edge_bet_cent_neg_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        end
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.eigvec_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.eigvec_cent_pos(:,curr_ROI,:))))
                [out.full.eigvec_cent_pos.beta(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.full.eigvec_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.eigvec_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.full.eigvec_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.eigvec_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.eigvec_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.eigvec_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.eigvec_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.eigvec_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.eigvec_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.eigvec_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.eigvec_cent_neg(:,curr_ROI,:))))
                    [out.full.eigvec_cent_neg.beta(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.full.eigvec_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.eigvec_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.eigvec_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.eigvec_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.eigvec_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.eigvec_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.eigvec_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.eigvec_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.eigvec_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.eigvec_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.eigvec_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent(:,curr_ROI,:))))
                [out.thrAUC.eigvec_cent_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.eigvec_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.eigvec_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.eigvec_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.eigvec_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.eigvec_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.eigvec_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.eigvec_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.eigvec_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.eigvec_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent(:,curr_ROI,:))))
                    [out.thrAUC.eigvec_cent_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.eigvec_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.eigvec_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.eigvec_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.eigvec_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.eigvec_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.eigvec_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.eigvec_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.eigvec_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent(:,curr_ROI,:))))
                    [out.thrAUC.eigvec_cent_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.eigvec_cent_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.eigvec_cent_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.eigvec_cent_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.eigvec_cent_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.eigvec_cent_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.eigvec_cent_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.eigvec_cent_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.eigvec_cent_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.eigvec_cent_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent(:,curr_ROI,:))))
                        [out.thrAUC.eigvec_cent_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.eigvec_cent_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.eigvec_cent_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.eigvec_cent_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.eigvec_cent_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.eigvec_cent_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.eigvec_cent_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.eigvec_cent_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.eigvec_cent_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.eigvec_cent_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.eigvec_cent_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.glob_eff == 1
        [out.full.glob_eff_pos.beta(con,:), ...
            out.full.glob_eff_pos.test_stat(con,:), ...
            out.full.glob_eff_pos.crit_val(con,:), ...
            out.full.glob_eff_pos.p_1tail(con,:), ...
            out.full.glob_eff_pos.p_2tail(con,:), ...
            out.full.glob_eff_pos.hadNaN(con,:), ...
            out.full.glob_eff_pos.hadimag(con,:), ...
            out.full.glob_eff_pos.hadInf(con,:)] = ...
            GTG_GLM(out.fullmat_graph_meas.glob_eff_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0
            [out.full.glob_eff_neg.beta(con,:), ...
                out.full.glob_eff_neg.test_stat(con,:), ...
                out.full.glob_eff_neg.crit_val(con,:), ...
                out.full.glob_eff_neg.p_1tail(con,:), ...
                out.full.glob_eff_neg.p_2tail(con,:), ...
                out.full.glob_eff_neg.hadNaN(con,:), ...
                out.full.glob_eff_neg.hadimag(con,:), ...
                out.full.glob_eff_neg.hadInf(con,:)] = ...
                GTG_GLM(out.fullmat_graph_meas.glob_eff_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.glob_eff == 1
        [out.thrAUC.glob_eff_pos.beta(con,:), ...
            out.thrAUC.glob_eff_pos.test_stat(con,:), ...
            out.thrAUC.glob_eff_pos.crit_val(con,:), ...
            out.thrAUC.glob_eff_pos.p_1tail(con,:), ...
            out.thrAUC.glob_eff_pos.p_2tail(con,:), ...
            out.thrAUC.glob_eff_pos.hadNaN(con,:), ...
            out.thrAUC.glob_eff_pos.hadimag(con,:), ...
            out.thrAUC.glob_eff_pos.hadInf(con,:)] = ...
            GTG_GLM(out.AUC_thrmat_graph_meas.glob_eff_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            [out.thrAUC.glob_eff_neg.beta(con,:), ...
                out.thrAUC.glob_eff_neg.test_stat(con,:), ...
                out.thrAUC.glob_eff_neg.crit_val(con,:), ...
                out.thrAUC.glob_eff_neg.p_1tail(con,:), ...
                out.thrAUC.glob_eff_neg.p_2tail(con,:), ...
                out.thrAUC.glob_eff_neg.hadNaN(con,:), ...
                out.thrAUC.glob_eff_neg.hadimag(con,:), ...
                out.thrAUC.glob_eff_neg.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.glob_eff_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        if out.calcAUC_nodiscon == 1
            [out.thrAUC.glob_eff_pos_nodiscon.beta(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.test_stat(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.crit_val(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.p_1tail(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.p_2tail(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.hadNaN(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.hadimag(con,:), ...
                out.thrAUC.glob_eff_pos_nodiscon.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.glob_eff_pos_nodiscon, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                [out.thrAUC.glob_eff_neg_nodiscon.beta(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.test_stat(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.crit_val(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.p_1tail(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.p_2tail(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.hadNaN(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.hadimag(con,:), ...
                    out.thrAUC.glob_eff_neg_nodiscon.hadInf(con,:)] = ...
                    GTG_GLM(out.AUC_thrmat_graph_meas.glob_eff_neg_nodiscon, ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.kcore_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.kcore_cent_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.kcore_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.kcore_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.kcore_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.kcore_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.kcore_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.kcore_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.kcore_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.kcore_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.kcore_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.kcore_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.kcore_cent_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.kcore_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.kcore_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.kcore_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.kcore_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.kcore_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.kcore_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.kcore_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.kcore_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.kcore_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.kcore_cent_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.kcore_cent_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.kcore_cent_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.kcore_cent_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.kcore_cent_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.kcore_cent_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.kcore_cent_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.kcore_cent_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.kcore_cent_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.kcore_cent_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.kcore_cent_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.kcore_cent_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.kcore_cent_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.kcore_cent_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.kcore_cent_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.kcore_cent_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.kcore_cent_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.kcore_cent_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.kcore_cent_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.kcore_cent_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.kcore_cent_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.kcore_cent_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.loc_eff == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.loc_eff_pos(:,curr_ROI,:))))
                [out.full.loc_eff_pos.beta(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.test_stat(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.crit_val(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.hadimag(con,curr_ROI,:), ...
                    out.full.loc_eff_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.loc_eff_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.full.loc_eff_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.loc_eff_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.loc_eff_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.loc_eff_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.loc_eff_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.loc_eff_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.loc_eff_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.loc_eff_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.loc_eff_neg(:,curr_ROI,:))))
                    [out.full.loc_eff_neg.beta(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.test_stat(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.crit_val(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.hadimag(con,curr_ROI,:), ...
                        out.full.loc_eff_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.loc_eff_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.loc_eff_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.loc_eff_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.loc_eff_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.loc_eff_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.loc_eff_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.loc_eff_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.loc_eff_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.loc_eff_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.loc_eff == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.loc_eff_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.loc_eff_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.loc_eff_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.loc_eff_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.loc_eff_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.loc_eff_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.loc_eff_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.loc_eff_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.loc_eff_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.loc_eff_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.loc_eff_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.loc_eff_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.loc_eff_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.loc_eff_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.loc_eff_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.loc_eff_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.loc_eff_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.loc_eff_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.loc_eff_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.loc_eff_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.loc_eff_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.loc_eff_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.loc_eff_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.loc_eff_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.loc_eff_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.loc_eff_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.loc_eff_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.loc_eff_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.loc_eff_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.loc_eff_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.loc_eff_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.loc_eff_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.loc_eff_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.loc_eff_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.loc_eff_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.loc_eff_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.loc_eff_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.loc_eff_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.loc_eff_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.loc_eff_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.loc_eff_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.loc_eff_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.loc_eff_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.match == 1
        for curr_row_ROI = out.nROI:-1:1
            for curr_col_ROI = out.nROI:-1:1
                if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.match_pos(:,curr_row_ROI,curr_col_ROI,:))))
                    [out.full.match_pos.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.full.match_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.match_pos(:,curr_row_ROI,curr_col_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.match_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.full.match_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                    out.full.match_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.full.match_pos.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                    out.full.match_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                    out.full.match_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                    out.full.match_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    out.full.match_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0
                    if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.match_neg(:,curr_row_ROI,curr_col_ROI,:))))
                        [out.full.match_neg.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.full.match_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                            GTG_GLM(squeeze(out.fullmat_graph_meas.match_neg(:,curr_row_ROI,curr_col_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.full.match_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.full.match_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                        out.full.match_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.full.match_neg.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                        out.full.match_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                        out.full.match_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                        out.full.match_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        out.full.match_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    
    if out.test_props_thrmat.match == 1
        for curr_row_ROI = out.nROI:-1:1
            for curr_col_ROI = out.nROI:-1:1
                if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1
                    [out.thrAUC.match_pos.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                        out.thrAUC.match_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.match_pos(:,curr_row_ROI,curr_col_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.match_pos.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.thrAUC.match_pos.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                    out.thrAUC.match_pos.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                    out.thrAUC.match_pos.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                    out.thrAUC.match_pos.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                    out.thrAUC.match_pos.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                    out.thrAUC.match_pos.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    out.thrAUC.match_pos.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1
                        [out.thrAUC.match_neg.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.match_neg(:,curr_row_ROI,curr_col_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.match_neg.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.match_neg.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                        out.thrAUC.match_neg.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.match_neg.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                        out.thrAUC.match_neg.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                        out.thrAUC.match_neg.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                        out.thrAUC.match_neg.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        out.thrAUC.match_neg.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    end
                end
                
                if out.calcAUC_nodiscon == 1
                    if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1
                        [out.thrAUC.match_pos_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                            out.thrAUC.match_pos_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.match_pos_nodiscon(:,curr_row_ROI,curr_col_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.match_pos_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.match_pos_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                        out.thrAUC.match_pos_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                        out.thrAUC.match_pos_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                        out.thrAUC.match_pos_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                        out.thrAUC.match_pos_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                        out.thrAUC.match_pos_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        out.thrAUC.match_pos_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                    end
                    
                    if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                        if out.edge_mask(curr_row_ROI,curr_col_ROI) == 1
                            [out.thrAUC.match_neg_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:), ...
                                out.thrAUC.match_neg_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)] = ...
                                GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.match_neg_nodiscon(:,curr_row_ROI,curr_col_ROI,:)), ...
                                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                        else
                            out.thrAUC.match_neg_nodiscon.hadNaN(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                            out.thrAUC.match_neg_nodiscon.hadimag(con,curr_row_ROI,curr_col_ROI,:)   = NaN;
                            out.thrAUC.match_neg_nodiscon.hadInf(con,curr_row_ROI,curr_col_ROI,:)    = NaN;
                            out.thrAUC.match_neg_nodiscon.beta(con,curr_row_ROI,curr_col_ROI,:)      = NaNout;
                            out.thrAUC.match_neg_nodiscon.test_stat(con,curr_row_ROI,curr_col_ROI,:) = NaNout;
                            out.thrAUC.match_neg_nodiscon.crit_val(con,curr_row_ROI,curr_col_ROI,:)  = NaNout;
                            out.thrAUC.match_neg_nodiscon.p_1tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                            out.thrAUC.match_neg_nodiscon.p_2tail(con,curr_row_ROI,curr_col_ROI,:)   = NaNout;
                        end
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.node_bet_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.node_bet_cent_pos(:,curr_ROI,:))))
                [out.full.node_bet_cent_pos.beta(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.full.node_bet_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.node_bet_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.full.node_bet_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.node_bet_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.node_bet_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.node_bet_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.node_bet_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.node_bet_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.node_bet_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.node_bet_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.node_bet_cent_neg(:,curr_ROI,:))))
                    [out.full.node_bet_cent_neg.beta(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.full.node_bet_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.node_bet_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.node_bet_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.node_bet_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.node_bet_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.node_bet_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.node_bet_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.node_bet_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.node_bet_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.node_bet_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.node_bet_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.node_bet_cent_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.node_bet_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.node_bet_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.node_bet_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.node_bet_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.node_bet_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.node_bet_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.node_bet_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.node_bet_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.node_bet_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.node_bet_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.node_bet_cent_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.node_bet_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.node_bet_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.node_bet_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.node_bet_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.node_bet_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.node_bet_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.node_bet_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.node_bet_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.node_bet_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.node_bet_cent_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.node_bet_cent_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.node_bet_cent_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.node_bet_cent_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.node_bet_cent_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.node_bet_cent_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.node_bet_cent_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.node_bet_cent_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.node_bet_cent_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.node_bet_cent_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.node_bet_cent_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.node_bet_cent_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.node_bet_cent_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.node_bet_cent_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.node_bet_cent_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.node_bet_cent_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.node_bet_cent_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.node_bet_cent_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.node_bet_cent_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.node_bet_cent_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.node_bet_cent_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.node_bet_cent_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.strength == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.full.strength_pos.beta(con,curr_ROI,:), ...
                    out.full.strength_pos.test_stat(con,curr_ROI,:), ...
                    out.full.strength_pos.crit_val(con,curr_ROI,:), ...
                    out.full.strength_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.strength_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.strength_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.strength_pos.hadimag(con,curr_ROI,:), ...
                    out.full.strength_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.strength_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                
                if out.use_abs_val == 0
                    [out.full.strength_neg.beta(con,curr_ROI,:), ...
                        out.full.strength_neg.test_stat(con,curr_ROI,:), ...
                        out.full.strength_neg.crit_val(con,curr_ROI,:), ...
                        out.full.strength_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.strength_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.strength_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.strength_neg.hadimag(con,curr_ROI,:), ...
                        out.full.strength_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.strength_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                end
            else
                out.full.strength_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.strength_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.strength_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.strength_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.strength_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.strength_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.strength_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.strength_pos.p_2tail(con,curr_ROI,:)   = NaNout;
                
                if out.use_abs_val == 0
                    out.full.strength_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.strength_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.strength_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.strength_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.strength_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.strength_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.strength_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.strength_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        [out.full.strength_totpos.beta(con,:), ...
            out.full.strength_totpos.test_stat(con,:), ...
            out.full.strength_totpos.crit_val(con,:), ...
            out.full.strength_totpos.p_1tail(con,:), ...
            out.full.strength_totpos.p_2tail(con,:), ...
            out.full.strength_totpos.hadNaN(con,:), ...
            out.full.strength_totpos.hadimag(con,:), ...
            out.full.strength_totpos.hadInf(con,:)] = ...
            GTG_GLM(out.fullmat_graph_meas.strength_totpos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0
            [out.full.strength_totneg.beta(con,:), ...
                out.full.strength_totneg.test_stat(con,:), ...
                out.full.strength_totneg.crit_val(con,:), ...
                out.full.strength_totneg.p_1tail(con,:), ...
                out.full.strength_totneg.p_2tail(con,:), ...
                out.full.strength_totneg.hadNaN(con,:), ...
                out.full.strength_totneg.hadimag(con,:), ...
                out.full.strength_totneg.hadInf(con,:)] = ...
                GTG_GLM(out.fullmat_graph_meas.strength_totneg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.pagerank_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.pagerank_cent_pos(:,curr_ROI,:))))
                [out.full.pagerank_cent_pos.beta(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.full.pagerank_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.pagerank_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.full.pagerank_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.pagerank_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.pagerank_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.pagerank_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.pagerank_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.pagerank_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.pagerank_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.pagerank_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.pagerank_cent_neg(:,curr_ROI,:))))
                    [out.full.pagerank_cent_neg.beta(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.full.pagerank_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.pagerank_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.pagerank_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.pagerank_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.pagerank_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.pagerank_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.pagerank_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.pagerank_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.pagerank_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.pagerank_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.pagerank_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.pagerank_cent(:,curr_ROI,:))))
                [out.thrAUC.pagerank_cent_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.pagerank_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.pagerank_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.pagerank_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.pagerank_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.pagerank_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.pagerank_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.pagerank_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.pagerank_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.pagerank_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.pagerank_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.pagerank_cent(:,curr_ROI,:))))
                    [out.thrAUC.pagerank_cent_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.pagerank_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.pagerank_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.pagerank_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.pagerank_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.pagerank_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.pagerank_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.pagerank_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.pagerank_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.pagerank_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.pagerank_cent(:,curr_ROI,:))))
                    [out.thrAUC.pagerank_cent_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.pagerank_cent_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.pagerank_cent_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.pagerank_cent_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.pagerank_cent_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.pagerank_cent_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.pagerank_cent_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.pagerank_cent_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.pagerank_cent_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.pagerank_cent_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.pagerank_cent_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.fullmat_graph_meas.pagerank_cent(:,curr_ROI,:))))
                        [out.thrAUC.pagerank_cent_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.pagerank_cent_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.pagerank_cent_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.pagerank_cent_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.pagerank_cent_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.pagerank_cent_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.pagerank_cent_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.pagerank_cent_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.pagerank_cent_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.pagerank_cent_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.pagerank_cent_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.part_coef == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.full.part_coef_pos.beta(con,curr_ROI,:), ...
                    out.full.part_coef_pos.test_stat(con,curr_ROI,:), ...
                    out.full.part_coef_pos.crit_val(con,curr_ROI,:), ...
                    out.full.part_coef_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.part_coef_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.part_coef_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.part_coef_pos.hadimag(con,curr_ROI,:), ...
                    out.full.part_coef_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.part_coef_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                
                if out.use_abs_val == 0
                    [out.full.part_coef_neg.beta(con,curr_ROI,:), ...
                        out.full.part_coef_neg.test_stat(con,curr_ROI,:), ...
                        out.full.part_coef_neg.crit_val(con,curr_ROI,:), ...
                        out.full.part_coef_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.part_coef_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.part_coef_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.part_coef_neg.hadimag(con,curr_ROI,:), ...
                        out.full.part_coef_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.part_coef_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                end
            else
                out.full.part_coef_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.part_coef_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.part_coef_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.part_coef_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.part_coef_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.part_coef_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.part_coef_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.part_coef_pos.p_2tail(con,curr_ROI,:)   = NaNout;
                
                if out.use_abs_val == 0
                    out.full.part_coef_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.part_coef_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.part_coef_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.part_coef_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.part_coef_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.part_coef_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.part_coef_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.part_coef_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    
    if out.test_props_thrmat.part_coef == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.part_coef_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.part_coef_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.part_coef_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.part_coef_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.part_coef_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.part_coef_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.part_coef_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.part_coef_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.part_coef_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.part_coef_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.part_coef_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.part_coef_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.part_coef_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.part_coef_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.part_coef_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.part_coef_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.part_coef_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.part_coef_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.part_coef_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.part_coef_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.part_coef_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.part_coef_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.part_coef_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.part_coef_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.part_coef_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.part_coef_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.part_coef_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.part_coef_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.part_coef_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.part_coef_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.part_coef_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.part_coef_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.part_coef_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.part_coef_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.part_coef_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.part_coef_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.part_coef_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.part_coef_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.part_coef_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.part_coef_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.part_coef_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.part_coef_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.part_coef_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.rich_club == 1
        for curr_size = out.max_club_size_full_pos:-1:1
            tempdata = squeeze(out.fullmat_graph_meas.rich_club_pos(:,curr_size,:));
            if any(isnan(tempdata(:)))
                out.full.rich_club_pos.hadNaN(con,curr_size) = 1;
            else
                out.full.rich_club_pos.hadNaN(con,curr_size) = 0;
            end
            notnan                                       = ~sum(isnan(tempdata),2);
            out.full.rich_club_pos.num_subs(curr_size) = sum(notnan);
            
            if out.full.rich_club_pos.num_subs(curr_size) < out.rich_club_min_n
                out.full.rich_club_pos.hadimag(con,curr_size,:)   = NaN;
                out.full.rich_club_pos.hadInf(con,curr_size,:)    = NaN;
                out.full.rich_club_pos.beta(con,curr_size,:)      = NaNout;
                out.full.rich_club_pos.test_stat(con,curr_size,:) = NaNout;
                out.full.rich_club_pos.crit_val(con,curr_size,:)  = NaNout;
                out.full.rich_club_pos.p_1tail(con,curr_size,:)   = NaNout;
                out.full.rich_club_pos.p_2tail(con,curr_size,:)   = NaNout;
            else
                temp_perms = perms(logical(perms <= out.full.rich_club_pos.num_subs(curr_size)));
                temp_perms = reshape(temp_perms,out.full.rich_club_pos.num_subs(curr_size),(length(temp_perms)/out.full.rich_club_pos.num_subs(curr_size)));
                
                if out.num_rep_levs > 1
                    temp_within_perms = zeros(out.full.rich_club_pos.num_subs(curr_size),out.num_rep_levs,out.num_perms);
                    orig_ord          = [1:out.full.rich_club_pos.num_subs(curr_size);(out.full.rich_club_pos.num_subs(curr_size)+1):(out.full.rich_club_pos.num_subs(curr_size)*2)]';
                    for curr_perm = out.num_perms:-1:1
                        for curr_sub = out.full.rich_club_pos.num_subs(curr_size):-1:1
                            temp_within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
                        end
                    end
                else
                    temp_within_perms = [];
                end
                
                [out.full.rich_club_pos.beta(con,curr_size,:), ...
                    out.full.rich_club_pos.test_stat(con,curr_size,:), ...
                    out.full.rich_club_pos.crit_val(con,curr_size,:), ...
                    out.full.rich_club_pos.p_1tail(con,curr_size,:), ...
                    out.full.rich_club_pos.p_2tail(con,curr_size,:), ...
                    ~, ...
                    out.full.rich_club_pos.hadimag(con,curr_size,:), ...
                    out.full.rich_club_pos.hadInf(con,curr_size,:)] = ...
                    GTG_GLM(tempdata(notnan,:), ...
                    curr_full_desmat(notnan,:),currcovars_desmat(notnan,:),temp_perms,out.HLA_reg_type,use_parfor,temp_within_perms,out.alpha);
            end
        end
        if out.use_abs_val == 0
            for curr_size = out.max_club_size_full_neg:-1:1
                tempdata = squeeze(out.fullmat_graph_meas.rich_club_neg(:,curr_size,:));
                if any(isnan(tempdata(:)))
                    out.full.rich_club_neg.hadNaN(con,curr_size) = 1;
                else
                    out.full.rich_club_neg.hadNaN(con,curr_size) = 0;
                end
                notnan = ~sum(isnan(tempdata),2);
                out.full.rich_club_neg.num_subs(curr_size) = sum(notnan);
                
                if out.full.rich_club_neg.num_subs(curr_size) < out.rich_club_min_n
                    out.full.rich_club_neg.hadimag(con,curr_size,:)   = NaN;
                    out.full.rich_club_neg.hadInf(con,curr_size,:)    = NaN;
                    out.full.rich_club_neg.beta(con,curr_size,:)      = NaNout;
                    out.full.rich_club_neg.test_stat(con,curr_size,:) = NaNout;
                    out.full.rich_club_neg.crit_val(con,curr_size,:)  = NaNout;
                    out.full.rich_club_neg.p_1tail(con,curr_size,:)   = NaNout;
                    out.full.rich_club_neg.p_2tail(con,curr_size,:)   = NaNout;
                else
                    temp_perms = perms(logical(perms <= out.full.rich_club_neg.num_subs(curr_size)));
                    temp_perms = reshape(temp_perms,out.full.rich_club_neg.num_subs(curr_size),(length(temp_perms)/out.full.rich_club_neg.num_subs(curr_size)));
                    
                    if out.num_rep_levs > 1
                        temp_within_perms = zeros(out.full.rich_club_neg.num_subs(curr_size),out.num_rep_levs,out.num_perms);
                        orig_ord          = [1:out.full.rich_club_neg.num_subs(curr_size);(out.full.rich_club_neg.num_subs(curr_size)+1):(out.full.rich_club_neg.num_subs(curr_size)*2)]';
                        for curr_perm = out.num_perms:-1:1
                            for curr_sub = out.full.rich_club_neg.num_subs(curr_size):-1:1
                                temp_within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
                            end
                        end
                    else
                        temp_within_perms = [];
                    end
                    
                    [out.full.rich_club_neg.beta(con,curr_size,:), ...
                        out.full.rich_club_neg.test_stat(con,curr_size,:), ...
                        out.full.rich_club_neg.crit_val(con,curr_size,:), ...
                        out.full.rich_club_neg.p_1tail(con,curr_size,:), ...
                        out.full.rich_club_neg.p_2tail(con,curr_size,:), ...
                        ~, ...
                        out.full.rich_club_neg.hadimag(con,curr_size,:), ...
                        out.full.rich_club_neg.hadInf(con,curr_size,:)] = ...
                        GTG_GLM(tempdata(notnan,:), ...
                        curr_full_desmat(notnan,:),currcovars_desmat(notnan,:),temp_perms,out.HLA_reg_type,use_parfor,temp_within_perms,out.alpha);
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    if out.test_props_thrmat.rich_club == 1
        for curr_size = out.max_club_size_thr_pos:-1:1
            tempdata = squeeze(out.AUC_thrmat_graph_meas.rich_club_pos(:,curr_size,:));
            if any(isnan(tempdata(:)))
                out.thrAUC.rich_club_pos.hadNaN(con,curr_size) = 1;
            else
                out.thrAUC.rich_club_pos.hadNaN(con,curr_size) = 0;
            end
            notnan                                       = ~sum(isnan(tempdata),2);
            out.thrAUC.rich_club_pos.num_subs(curr_size) = sum(notnan);
            
            if out.thrAUC.rich_club_pos.num_subs(curr_size) < out.rich_club_min_n
                out.thrAUC.rich_club_pos.hadimag(con,curr_size,:)   = NaN;
                out.thrAUC.rich_club_pos.hadInf(con,curr_size,:)    = NaN;
                out.thrAUC.rich_club_pos.beta(con,curr_size,:)      = NaNout;
                out.thrAUC.rich_club_pos.test_stat(con,curr_size,:) = NaNout;
                out.thrAUC.rich_club_pos.crit_val(con,curr_size,:)  = NaNout;
                out.thrAUC.rich_club_pos.p_1tail(con,curr_size,:)   = NaNout;
                out.thrAUC.rich_club_pos.p_2tail(con,curr_size,:)   = NaNout;
            else
                temp_perms = perms(logical(perms <= out.thrAUC.rich_club_pos.num_subs(curr_size)));
                temp_perms = reshape(temp_perms,out.thrAUC.rich_club_pos.num_subs(curr_size),(length(temp_perms)/out.thrAUC.rich_club_pos.num_subs(curr_size)));
                
                if out.num_rep_levs > 1
                    temp_within_perms = zeros(out.thrAUC.rich_club_pos.num_subs(curr_size),out.num_rep_levs,out.num_perms);
                    orig_ord          = [1:out.thrAUC.rich_club_pos.num_subs(curr_size);(out.thrAUC.rich_club_pos.num_subs(curr_size)+1):(out.thrAUC.rich_club_pos.num_subs(curr_size)*2)]';
                    for curr_perm = out.num_perms:-1:1
                        for curr_sub = out.thrAUC.rich_club_pos.num_subs(curr_size):-1:1
                            temp_within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
                        end
                    end
                else
                    temp_within_perms = [];
                end
                
                [out.thrAUC.rich_club_pos.beta(con,curr_size,:), ...
                    out.thrAUC.rich_club_pos.test_stat(con,curr_size,:), ...
                    out.thrAUC.rich_club_pos.crit_val(con,curr_size,:), ...
                    out.thrAUC.rich_club_pos.p_1tail(con,curr_size,:), ...
                    out.thrAUC.rich_club_pos.p_2tail(con,curr_size,:), ...
                    ~, ...
                    out.thrAUC.rich_club_pos.hadimag(con,curr_size,:), ...
                    out.thrAUC.rich_club_pos.hadInf(con,curr_size,:)] = ...
                    GTG_GLM(tempdata(notnan,:), ...
                    curr_full_desmat(notnan,:),currcovars_desmat(notnan,:),temp_perms,out.HLA_reg_type,use_parfor,temp_within_perms,out.alpha);
            end
        end
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            for curr_size = out.max_club_size_thr_neg:-1:1
                tempdata = squeeze(out.AUC_thrmat_graph_meas.rich_club_neg(:,curr_size,:));
                if any(isnan(tempdata(:)))
                    out.thrAUC.rich_club_neg.hadNaN(con,curr_size) = 1;
                else
                    out.thrAUC.rich_club_neg.hadNaN(con,curr_size) = 0;
                end
                notnan = ~sum(isnan(tempdata),2);
                out.thrAUC.rich_club_neg.num_subs(curr_size) = sum(notnan);
                
                if out.thrAUC.rich_club_neg.num_subs(curr_size) < out.rich_club_min_n
                    out.thrAUC.rich_club_neg.hadimag(con,curr_size,:)   = NaN;
                    out.thrAUC.rich_club_neg.hadInf(con,curr_size,:)    = NaN;
                    out.thrAUC.rich_club_neg.beta(con,curr_size,:)      = NaNout;
                    out.thrAUC.rich_club_neg.test_stat(con,curr_size,:) = NaNout;
                    out.thrAUC.rich_club_neg.crit_val(con,curr_size,:)  = NaNout;
                    out.thrAUC.rich_club_neg.p_1tail(con,curr_size,:)   = NaNout;
                    out.thrAUC.rich_club_neg.p_2tail(con,curr_size,:)   = NaNout;
                else
                    temp_perms = perms(logical(perms <= out.thrAUC.rich_club_neg.num_subs(curr_size)));
                    temp_perms = reshape(temp_perms,out.thrAUC.rich_club_neg.num_subs(curr_size),(length(temp_perms)/out.thrAUC.rich_club_neg.num_subs(curr_size)));
                    
                    if out.num_rep_levs > 1
                        temp_within_perms = zeros(out.thrAUC.rich_club_neg.num_subs(curr_size),out.num_rep_levs,out.num_perms);
                        orig_ord          = [1:out.thrAUC.rich_club_neg.num_subs(curr_size);(out.thrAUC.rich_club_neg.num_subs(curr_size)+1):(out.thrAUC.rich_club_neg.num_subs(curr_size)*2)]';
                        for curr_perm = out.num_perms:-1:1
                            for curr_sub = out.thrAUC.rich_club_neg.num_subs(curr_size):-1:1
                                temp_within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
                            end
                        end
                    else
                        temp_within_perms = [];
                    end
                    
                    [out.thrAUC.rich_club_neg.beta(con,curr_size,:), ...
                        out.thrAUC.rich_club_neg.test_stat(con,curr_size,:), ...
                        out.thrAUC.rich_club_neg.crit_val(con,curr_size,:), ...
                        out.thrAUC.rich_club_neg.p_1tail(con,curr_size,:), ...
                        out.thrAUC.rich_club_neg.p_2tail(con,curr_size,:), ...
                        ~, ...
                        out.thrAUC.rich_club_neg.hadimag(con,curr_size,:), ...
                        out.thrAUC.rich_club_neg.hadInf(con,curr_size,:)] = ...
                        GTG_GLM(tempdata(notnan,:), ...
                        curr_full_desmat(notnan,:),currcovars_desmat(notnan,:),temp_perms,out.HLA_reg_type,use_parfor,temp_within_perms,out.alpha);
                end
            end
        end
        if out.calcAUC_nodiscon == 1
            for curr_size = out.max_club_size_thr_pos:-1:1
                tempdata = squeeze(out.AUC_thrmat_graph_meas.rich_club_pos_nodiscon(:,curr_size,:));
                if any(isnan(tempdata(:)))
                    out.thrAUC.rich_club_pos_nodiscon.hadNaN(con,curr_size) = 1;
                else
                    out.thrAUC.rich_club_pos_nodiscon.hadNaN(con,curr_size) = 0;
                end
                notnan                                                = ~sum(isnan(tempdata),2);
                out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size) = sum(notnan);
                
                if out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size) < out.rich_club_min_n
                    out.thrAUC.rich_club_pos_nodiscon.hadimag(con,curr_size,:)   = NaN;
                    out.thrAUC.rich_club_pos_nodiscon.hadInf(con,curr_size,:)    = NaN;
                    out.thrAUC.rich_club_pos_nodiscon.beta(con,curr_size,:)      = NaNout;
                    out.thrAUC.rich_club_pos_nodiscon.test_stat(con,curr_size,:) = NaNout;
                    out.thrAUC.rich_club_pos_nodiscon.crit_val(con,curr_size,:)  = NaNout;
                    out.thrAUC.rich_club_pos_nodiscon.p_1tail(con,curr_size,:)   = NaNout;
                    out.thrAUC.rich_club_pos_nodiscon.p_2tail(con,curr_size,:)   = NaNout;
                else
                    temp_perms = perms(logical(perms <= out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size)));
                    temp_perms = reshape(temp_perms,out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size),(length(temp_perms)/out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size)));
                    
                    if out.num_rep_levs > 1
                        temp_within_perms = zeros(out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size),out.num_rep_levs,out.num_perms);
                        orig_ord = [1:out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size);(out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size)+1):(out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size)*2)]';
                        for curr_perm = out.num_perms:-1:1
                            for curr_sub = out.thrAUC.rich_club_pos_nodiscon.num_subs(curr_size):-1:1
                                temp_within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
                            end
                        end
                    else
                        temp_within_perms = [];
                    end
                    
                    [out.thrAUC.rich_club_pos_nodiscon.beta(con,curr_size,:), ...
                        out.thrAUC.rich_club_pos_nodiscon.test_stat(con,curr_size,:), ...
                        out.thrAUC.rich_club_pos_nodiscon.crit_val(con,curr_size,:), ...
                        out.thrAUC.rich_club_pos_nodiscon.p_1tail(con,curr_size,:), ...
                        out.thrAUC.rich_club_pos_nodiscon.p_2tail(con,curr_size,:), ...
                        ~, ...
                        out.thrAUC.rich_club_pos_nodiscon.hadimag(con,curr_size,:), ...
                        out.thrAUC.rich_club_pos_nodiscon.hadInf(con,curr_size,:)] = ...
                        GTG_GLM(tempdata(notnan,:), ...
                        curr_full_desmat(notnan,:),currcovars_desmat(notnan,:),temp_perms,out.HLA_reg_type,use_parfor,temp_within_perms,out.alpha);
                end
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                for curr_size = out.max_club_size_thr_neg:-1:1
                    tempdata = squeeze(out.AUC_thrmat_graph_meas.rich_club_neg_nodiscon(:,curr_size,:));
                    if any(isnan(tempdata(:)))
                        out.thrAUC.rich_club_neg_nodiscon.hadNaN(con,curr_size) = 1;
                    else
                        out.thrAUC.rich_club_neg_nodiscon.hadNaN(con,curr_size) = 0;
                    end
                    notnan                                                = ~sum(isnan(tempdata),2);
                    out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size) = sum(notnan);
                    
                    if out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size) < out.rich_club_min_n
                        out.thrAUC.rich_club_neg_nodiscon.hadimag(con,curr_size,:)   = NaN;
                        out.thrAUC.rich_club_neg_nodiscon.hadInf(con,curr_size,:)    = NaN;
                        out.thrAUC.rich_club_neg_nodiscon.beta(con,curr_size,:)      = NaNout;
                        out.thrAUC.rich_club_neg_nodiscon.test_stat(con,curr_size,:) = NaNout;
                        out.thrAUC.rich_club_neg_nodiscon.crit_val(con,curr_size,:)  = NaNout;
                        out.thrAUC.rich_club_neg_nodiscon.p_1tail(con,curr_size,:)   = NaNout;
                        out.thrAUC.rich_club_neg_nodiscon.p_2tail(con,curr_size,:)   = NaNout;
                    else
                        temp_perms = perms(logical(perms <= out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size)));
                        temp_perms = reshape(temp_perms,out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size),(length(temp_perms)/out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size)));
                        
                        if out.num_rep_levs > 1
                            temp_within_perms = zeros(out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size),out.num_rep_levs,out.num_perms);
                            orig_ord          = [1:out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size);(out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size)+1):(out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size)*2)]';
                            for curr_perm = out.num_perms:-1:1
                                for curr_sub = out.thrAUC.rich_club_neg_nodiscon.num_subs(curr_size):-1:1
                                    temp_within_perms(curr_sub,:,curr_perm) = orig_ord(curr_sub,randperm(out.num_rep_levs));
                                end
                            end
                        else
                            temp_within_perms = [];
                        end
                        
                        [out.thrAUC.rich_club_neg_nodiscon.beta(con,curr_size,:), ...
                            out.thrAUC.rich_club_neg_nodiscon.test_stat(con,curr_size,:), ...
                            out.thrAUC.rich_club_neg_nodiscon.crit_val(con,curr_size,:), ...
                            out.thrAUC.rich_club_neg_nodiscon.p_1tail(con,curr_size,:), ...
                            out.thrAUC.rich_club_neg_nodiscon.p_2tail(con,curr_size,:), ...
                            ~, ...
                            out.thrAUC.rich_club_neg_nodiscon.hadimag(con,curr_size,:), ...
                            out.thrAUC.rich_club_neg_nodiscon.hadInf(con,curr_size,:)] = ...
                            GTG_GLM(tempdata(notnan,:), ...
                            curr_full_desmat(notnan,:),currcovars_desmat(notnan,:),temp_perms,out.HLA_reg_type,use_parfor,temp_within_perms,out.alpha);
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.small_world == 1
        [out.thrAUC.small_world_pos.beta(con,:), ...
            out.thrAUC.small_world_pos.test_stat(con,:), ...
            out.thrAUC.small_world_pos.crit_val(con,:), ...
            out.thrAUC.small_world_pos.p_1tail(con,:), ...
            out.thrAUC.small_world_pos.p_2tail(con,:), ...
            out.thrAUC.small_world_pos.hadNaN(con,:), ...
            out.thrAUC.small_world_pos.hadimag(con,:), ...
            out.thrAUC.small_world_pos.hadInf(con,:)] = ...
            GTG_GLM(out.AUC_thrmat_graph_meas.small_world_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            [out.thrAUC.small_world_neg.beta(con,:), ...
                out.thrAUC.small_world_neg.test_stat(con,:), ...
                out.thrAUC.small_world_neg.crit_val(con,:), ...
                out.thrAUC.small_world_neg.p_1tail(con,:), ...
                out.thrAUC.small_world_neg.p_2tail(con,:), ...
                out.thrAUC.small_world_neg.hadNaN(con,:), ...
                out.thrAUC.small_world_neg.hadimag(con,:), ...
                out.thrAUC.small_world_neg.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.small_world_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        if out.calcAUC_nodiscon == 1
            [out.thrAUC.small_world_pos_nodiscon.beta(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.test_stat(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.crit_val(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.p_1tail(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.p_2tail(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.hadNaN(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.hadimag(con,:), ...
                out.thrAUC.small_world_pos_nodiscon.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.small_world_pos_nodiscon, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                [out.thrAUC.small_world_neg_nodiscon.beta(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.test_stat(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.crit_val(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.p_1tail(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.p_2tail(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.hadNaN(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.hadimag(con,:), ...
                    out.thrAUC.small_world_neg_nodiscon.hadInf(con,:)] = ...
                    GTG_GLM(out.AUC_thrmat_graph_meas.small_world_neg_nodiscon, ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.sub_cent == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.thrAUC.subgraph_cent_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.subgraph_cent_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.subgraph_cent_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.subgraph_cent_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.subgraph_cent_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.subgraph_cent_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.subgraph_cent_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.subgraph_cent_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.subgraph_cent_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.subgraph_cent_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.subgraph_cent_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.subgraph_cent_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.subgraph_cent_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.subgraph_cent_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.subgraph_cent_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.subgraph_cent_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.subgraph_cent_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.subgraph_cent_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.subgraph_cent_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.subgraph_cent_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.subgraph_cent_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1
                    [out.thrAUC.subgraph_cent_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.subgraph_cent_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.subgraph_cent_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.subgraph_cent_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.subgraph_cent_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.subgraph_cent_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.subgraph_cent_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.subgraph_cent_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.subgraph_cent_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.subgraph_cent_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.subgraph_cent_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1
                        [out.thrAUC.subgraph_cent_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.subgraph_cent_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.subgraph_cent_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.subgraph_cent_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.subgraph_cent_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.subgraph_cent_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.subgraph_cent_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.subgraph_cent_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.subgraph_cent_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.subgraph_cent_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.subgraph_cent_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.trans == 1
        [out.full.trans_pos.beta(con,:), ...
            out.full.trans_pos.test_stat(con,:), ...
            out.full.trans_pos.crit_val(con,:), ...
            out.full.trans_pos.p_1tail(con,:), ...
            out.full.trans_pos.p_2tail(con,:), ...
            out.full.trans_pos.hadNaN(con,:), ...
            out.full.trans_pos.hadimag(con,:), ...
            out.full.trans_pos.hadInf(con,:)] = ...
            GTG_GLM(out.fullmat_graph_meas.trans_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0
            [out.full.trans_neg.beta(con,:), ...
                out.full.trans_neg.test_stat(con,:), ...
                out.full.trans_neg.crit_val(con,:), ...
                out.full.trans_neg.p_1tail(con,:), ...
                out.full.trans_neg.p_2tail(con,:), ...
                out.full.trans_neg.hadNaN(con,:), ...
                out.full.trans_neg.hadimag(con,:), ...
                out.full.trans_neg.hadInf(con,:)] = ...
                GTG_GLM(out.fullmat_graph_meas.trans_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.trans == 1
        [out.thrAUC.trans_pos.beta(con,:), ...
            out.thrAUC.trans_pos.test_stat(con,:), ...
            out.thrAUC.trans_pos.crit_val(con,:), ...
            out.thrAUC.trans_pos.p_1tail(con,:), ...
            out.thrAUC.trans_pos.p_2tail(con,:), ...
            out.thrAUC.trans_pos.hadNaN(con,:), ...
            out.thrAUC.trans_pos.hadimag(con,:), ...
            out.thrAUC.trans_pos.hadInf(con,:)] = ...
            GTG_GLM(out.AUC_thrmat_graph_meas.trans_pos, ...
            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        
        if out.use_abs_val == 0 && out.neg_mindens_nan == 0
            [out.thrAUC.trans_neg.beta(con,:), ...
                out.thrAUC.trans_neg.test_stat(con,:), ...
                out.thrAUC.trans_neg.crit_val(con,:), ...
                out.thrAUC.trans_neg.p_1tail(con,:), ...
                out.thrAUC.trans_neg.p_2tail(con,:), ...
                out.thrAUC.trans_neg.hadNaN(con,:), ...
                out.thrAUC.trans_neg.hadimag(con,:), ...
                out.thrAUC.trans_neg.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.trans_neg, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
        end
        
        if out.calcAUC_nodiscon == 1
            [out.thrAUC.trans_pos_nodiscon.beta(con,:), ...
                out.thrAUC.trans_pos_nodiscon.test_stat(con,:), ...
                out.thrAUC.trans_pos_nodiscon.crit_val(con,:), ...
                out.thrAUC.trans_pos_nodiscon.p_1tail(con,:), ...
                out.thrAUC.trans_pos_nodiscon.p_2tail(con,:), ...
                out.thrAUC.trans_pos_nodiscon.hadNaN(con,:), ...
                out.thrAUC.trans_pos_nodiscon.hadimag(con,:), ...
                out.thrAUC.trans_pos_nodiscon.hadInf(con,:)] = ...
                GTG_GLM(out.AUC_thrmat_graph_meas.trans_pos_nodiscon, ...
                curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                [out.thrAUC.trans_neg_nodiscon.beta(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.test_stat(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.crit_val(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.p_1tail(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.p_2tail(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.hadNaN(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.hadimag(con,:), ...
                    out.thrAUC.trans_neg_nodiscon.hadInf(con,:)] = ...
                    GTG_GLM(out.AUC_thrmat_graph_meas.trans_neg_nodiscon, ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_fullmat.mod_deg_z == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1
                [out.full.mod_deg_z_pos.beta(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.test_stat(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.crit_val(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.p_1tail(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.p_2tail(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.hadNaN(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.hadimag(con,curr_ROI,:), ...
                    out.full.mod_deg_z_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.fullmat_graph_meas.mod_deg_z_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.full.mod_deg_z_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.full.mod_deg_z_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.full.mod_deg_z_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.full.mod_deg_z_pos.beta(con,curr_ROI,:)      = NaNout;
                out.full.mod_deg_z_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.full.mod_deg_z_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.full.mod_deg_z_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.full.mod_deg_z_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0
                if out.node_mask(curr_ROI) == 1
                    [out.full.mod_deg_z_neg.beta(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.test_stat(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.crit_val(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.p_1tail(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.p_2tail(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.hadNaN(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.hadimag(con,curr_ROI,:), ...
                        out.full.mod_deg_z_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.fullmat_graph_meas.mod_deg_z_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.full.mod_deg_z_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.full.mod_deg_z_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.full.mod_deg_z_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.full.mod_deg_z_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.full.mod_deg_z_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.full.mod_deg_z_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.full.mod_deg_z_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.full.mod_deg_z_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    if out.test_props_thrmat.mod_deg_z == 1
        for curr_ROI = out.nROI:-1:1
            if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_pos(:,curr_ROI,:))))
                [out.thrAUC.mod_deg_z_pos.beta(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.test_stat(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.crit_val(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.p_1tail(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.p_2tail(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.hadNaN(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.hadimag(con,curr_ROI,:), ...
                    out.thrAUC.mod_deg_z_pos.hadInf(con,curr_ROI,:)] = ...
                    GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_pos(:,curr_ROI,:)), ...
                    curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
            else
                out.thrAUC.mod_deg_z_pos.hadNaN(con,curr_ROI,:)    = NaN;
                out.thrAUC.mod_deg_z_pos.hadimag(con,curr_ROI,:)   = NaN;
                out.thrAUC.mod_deg_z_pos.hadInf(con,curr_ROI,:)    = NaN;
                out.thrAUC.mod_deg_z_pos.beta(con,curr_ROI,:)      = NaNout;
                out.thrAUC.mod_deg_z_pos.test_stat(con,curr_ROI,:) = NaNout;
                out.thrAUC.mod_deg_z_pos.crit_val(con,curr_ROI,:)  = NaNout;
                out.thrAUC.mod_deg_z_pos.p_1tail(con,curr_ROI,:)   = NaNout;
                out.thrAUC.mod_deg_z_pos.p_2tail(con,curr_ROI,:)   = NaNout;
            end
            
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_neg(:,curr_ROI,:))))
                    [out.thrAUC.mod_deg_z_neg.beta(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_neg.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_neg(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.mod_deg_z_neg.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.mod_deg_z_neg.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.mod_deg_z_neg.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.mod_deg_z_neg.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.mod_deg_z_neg.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.mod_deg_z_neg.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.mod_deg_z_neg.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.mod_deg_z_neg.p_2tail(con,curr_ROI,:)   = NaNout;
                end
            end
            
            if out.calcAUC_nodiscon == 1
                if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_pos(:,curr_ROI,:))))
                    [out.thrAUC.mod_deg_z_pos_nodiscon.beta(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.test_stat(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.crit_val(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.p_1tail(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.p_2tail(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.hadNaN(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.hadimag(con,curr_ROI,:), ...
                        out.thrAUC.mod_deg_z_pos_nodiscon.hadInf(con,curr_ROI,:)] = ...
                        GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_pos_nodiscon(:,curr_ROI,:)), ...
                        curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                else
                    out.thrAUC.mod_deg_z_pos_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                    out.thrAUC.mod_deg_z_pos_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                    out.thrAUC.mod_deg_z_pos_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                    out.thrAUC.mod_deg_z_pos_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                    out.thrAUC.mod_deg_z_pos_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                    out.thrAUC.mod_deg_z_pos_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                    out.thrAUC.mod_deg_z_pos_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                    out.thrAUC.mod_deg_z_pos_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                end
                
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.node_mask(curr_ROI) == 1 && any(any(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_neg(:,curr_ROI,:))))
                        [out.thrAUC.mod_deg_z_neg_nodiscon.beta(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.test_stat(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.crit_val(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.p_1tail(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.p_2tail(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.hadNaN(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.hadimag(con,curr_ROI,:), ...
                            out.thrAUC.mod_deg_z_neg_nodiscon.hadInf(con,curr_ROI,:)] = ...
                            GTG_GLM(squeeze(out.AUC_thrmat_graph_meas.mod_deg_z_neg_nodiscon(:,curr_ROI,:)), ...
                            curr_full_desmat,currcovars_desmat,out.Contrast_or_F,perms,out.HLA_reg_type,use_parfor,within_perms,out.alpha);
                    else
                        out.thrAUC.mod_deg_z_neg_nodiscon.hadNaN(con,curr_ROI,:)    = NaN;
                        out.thrAUC.mod_deg_z_neg_nodiscon.hadimag(con,curr_ROI,:)   = NaN;
                        out.thrAUC.mod_deg_z_neg_nodiscon.hadInf(con,curr_ROI,:)    = NaN;
                        out.thrAUC.mod_deg_z_neg_nodiscon.beta(con,curr_ROI,:)      = NaNout;
                        out.thrAUC.mod_deg_z_neg_nodiscon.test_stat(con,curr_ROI,:) = NaNout;
                        out.thrAUC.mod_deg_z_neg_nodiscon.crit_val(con,curr_ROI,:)  = NaNout;
                        out.thrAUC.mod_deg_z_neg_nodiscon.p_1tail(con,curr_ROI,:)   = NaNout;
                        out.thrAUC.mod_deg_z_neg_nodiscon.p_2tail(con,curr_ROI,:)   = NaNout;
                    end
                end
            end
        end
        
        curr_props_calcd = curr_props_calcd+1;
        prog             = curr_props_calcd/tot_props_to_calc;
        progressbar(prog)
    end
    
    
    fprintf('Done running permutation analyses for contrast %s!\n\n',num2str(con))
    fprintf('Locating significant findings for contrast %s ...\n\n',num2str(con))
    
    if out.num_rep_levs > 2
        lev_vals = out.num_rep_levs+1;
    else
        lev_vals = out.num_rep_levs;
    end
    for lev = 1:lev_vals
        if lev_vals > 1
            fprintf(sigeffects_fid,'Significant findings for Contrast #%s, repeated level #%s\n\n',num2str(con),num2str(lev));
        else
            fprintf(sigeffects_fid,'Significant findings for Contrast #%s\n\n',num2str(con));
        end
        
        % Assortativity
        if out.test_props_fullmat.assort == 1
            if out.full.assort_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.assort_pos.beta(con,lev)) && out.full.assort_pos.beta(con,lev) ~= 0
                out.sig_find(con).assort_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).assort_pos_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).assort_pos_full{2,lev} = [out.sig_find(con).assort_pos_full{2,lev};num2cell([out.full.assort_pos.beta(con,lev);out.full.assort_pos.test_stat(con,lev);out.full.assort_pos.crit_val(con,lev);out.full.assort_pos.p_2tail(con,lev);out.full.assort_pos.hadNaN(con);out.full.assort_pos.hadimag(con);out.full.assort_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Assortativity (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.assort_pos.beta(con,lev),out.full.assort_pos.test_stat(con,lev),out.full.assort_pos.crit_val(con,lev),out.full.assort_pos.p_2tail(con,lev),out.full.assort_pos.hadNaN(con),out.full.assort_pos.hadimag(con),out.full.assort_pos.hadInf(con));
            end
            if out.use_abs_val == 0
                if out.full.assort_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.assort_neg.beta(con,lev)) && out.full.assort_neg.beta(con,lev) ~= 0
                    out.sig_find(con).assort_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).assort_neg_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).assort_neg_full{2,lev} = [out.sig_find(con).assort_neg_full{2,lev};num2cell([out.full.assort_neg.beta(con,lev);out.full.assort_neg.test_stat(con,lev);out.full.assort_neg.crit_val(con,lev);out.full.assort_neg.p_2tail(con,lev);out.full.assort_neg.hadNaN(con);out.full.assort_neg.hadimag(con);out.full.assort_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Assortativity (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.assort_neg.beta(con,lev),out.full.assort_neg.test_stat(con,lev),out.full.assort_neg.crit_val(con,lev),out.full.assort_neg.p_2tail(con,lev),out.full.assort_neg.hadNaN(con),out.full.assort_neg.hadimag(con),out.full.assort_neg.hadInf(con));
                end
            end
        end
        if out.test_props_thrmat.assort == 1
            if out.thrAUC.assort_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.assort_pos.beta(con,lev)) && out.thrAUC.assort_pos.beta(con,lev) ~= 0
                out.sig_find(con).assort_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).assort_pos_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).assort_pos_thr{2,lev} = [out.sig_find(con).assort_pos_thr{2,lev};num2cell([out.thrAUC.assort_pos.beta(con,lev);out.thrAUC.assort_pos.test_stat(con,lev);out.thrAUC.assort_pos.crit_val(con,lev);out.thrAUC.assort_pos.p_2tail(con,lev);out.thrAUC.assort_pos.hadNaN(con);out.thrAUC.assort_pos.hadimag(con);out.thrAUC.assort_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Assortativity (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.assort_pos.beta(con,lev),out.thrAUC.assort_pos.test_stat(con,lev),out.thrAUC.assort_pos.crit_val(con,lev),out.thrAUC.assort_pos.p_2tail(con,lev),out.thrAUC.assort_pos.hadNaN(con),out.thrAUC.assort_pos.hadimag(con),out.thrAUC.assort_pos.hadInf(con));
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.thrAUC.assort_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.assort_neg.beta(con,lev)) && out.thrAUC.assort_neg.beta(con,lev) ~= 0
                    out.sig_find(con).assort_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).assort_neg_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).assort_neg_thr{2,lev} = [out.sig_find(con).assort_neg_thr{2,lev};num2cell([out.thrAUC.assort_neg.beta(con,lev);out.thrAUC.assort_neg.test_stat(con,lev);out.thrAUC.assort_neg.crit_val(con,lev);out.thrAUC.assort_neg.p_2tail(con,lev);out.thrAUC.assort_neg.hadNaN(con);out.thrAUC.assort_neg.hadimag(con);out.thrAUC.assort_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Assortativity (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.assort_neg.beta(con,lev),out.thrAUC.assort_neg.test_stat(con,lev),out.thrAUC.assort_neg.crit_val(con,lev),out.thrAUC.assort_neg.p_2tail(con,lev),out.thrAUC.assort_neg.hadNaN(con),out.thrAUC.assort_neg.hadimag(con),out.thrAUC.assort_neg.hadInf(con));
                end
            end
            if out.calcAUC_nodiscon == 1
                if out.thrAUC.assort_pos_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.assort_pos_nodiscon.beta(con,lev)) && out.thrAUC.assort_pos_nodiscon.beta(con,lev) ~= 0
                    out.sig_find(con).assort_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).assort_pos_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).assort_pos_nodiscon_thr{2,lev} = [out.sig_find(con).assort_pos_nodiscon_thr{2,lev};num2cell([out.thrAUC.assort_pos_nodiscon.beta(con,lev);out.thrAUC.assort_pos_nodiscon.test_stat(con,lev);out.thrAUC.assort_pos_nodiscon.crit_val(con,lev);out.thrAUC.assort_pos_nodiscon.p_2tail(con,lev);out.thrAUC.assort_pos_nodiscon.hadNaN(con);out.thrAUC.assort_pos_nodiscon.hadimag(con);out.thrAUC.assort_pos_nodiscon.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Assortativity (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.assort_pos_nodiscon.beta(con,lev),out.thrAUC.assort_pos_nodiscon.test_stat(con,lev),out.thrAUC.assort_pos_nodiscon.crit_val(con,lev),out.thrAUC.assort_pos_nodiscon.p_2tail(con,lev),out.thrAUC.assort_pos_nodiscon.hadNaN(con),out.thrAUC.assort_pos_nodiscon.hadimag(con),out.thrAUC.assort_pos_nodiscon.hadInf(con));
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.thrAUC.assort_neg_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.assort_neg_nodiscon.beta(con,lev)) && out.thrAUC.assort_neg_nodiscon.beta(con,lev) ~= 0
                        out.sig_find(con).assort_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).assort_neg_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).assort_neg_nodiscon_thr{2,lev} = [out.sig_find(con).assort_neg_nodiscon_thr{2,lev};num2cell([out.thrAUC.assort_neg_nodiscon.beta(con,lev);out.thrAUC.assort_neg_nodiscon.test_stat(con,lev);out.thrAUC.assort_neg_nodiscon.crit_val(con,lev);out.thrAUC.assort_neg_nodiscon.p_2tail(con,lev);out.thrAUC.assort_neg_nodiscon.hadNaN(con);out.thrAUC.assort_neg_nodiscon.hadimag(con);out.thrAUC.assort_neg_nodiscon.hadInf(con)]')];
                        
                        fprintf(sigeffects_fid,'Assortativity (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.assort_neg_nodiscon.beta(con,lev),out.thrAUC.assort_neg_nodiscon.test_stat(con,lev),out.thrAUC.assort_neg_nodiscon.crit_val(con,lev),out.thrAUC.assort_neg_nodiscon.p_2tail(con,lev),out.thrAUC.assort_neg_nodiscon.hadNaN(con),out.thrAUC.assort_neg_nodiscon.hadimag(con),out.thrAUC.assort_neg_nodiscon.hadInf(con));
                    end
                end
            end
        end
        
        % Characteristic Path Length
        if out.test_props_fullmat.cpl == 1
            if out.full.cpl_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.cpl_pos.beta(con,lev)) && out.full.cpl_pos.beta(con,lev) ~= 0
                out.sig_find(con).cpl_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).cpl_pos_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).cpl_pos_full{2,lev} = [out.sig_find(con).cpl_pos_full{2,lev};num2cell([out.full.cpl_pos.beta(con,lev);out.full.cpl_pos.test_stat(con,lev);out.full.cpl_pos.crit_val(con,lev);out.full.cpl_pos.p_2tail(con,lev);out.full.cpl_pos.hadNaN(con);out.full.cpl_pos.hadimag(con);out.full.cpl_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Characteristic Path Length (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.cpl_pos.beta(con,lev),out.full.cpl_pos.test_stat(con,lev),out.full.cpl_pos.crit_val(con,lev),out.full.cpl_pos.p_2tail(con,lev),out.full.cpl_pos.hadNaN(con),out.full.cpl_pos.hadimag(con),out.full.cpl_pos.hadInf(con));
            end
            if out.use_abs_val == 0
                if out.full.cpl_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.cpl_neg.beta(con,lev)) && out.full.cpl_neg.beta(con,lev) ~= 0
                    out.sig_find(con).cpl_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).cpl_neg_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).cpl_neg_full{2,lev} = [out.sig_find(con).cpl_neg_full{2,lev};num2cell([out.full.cpl_neg.beta(con,lev);out.full.cpl_neg.test_stat(con,lev);out.full.cpl_neg.crit_val(con,lev);out.full.cpl_neg.p_2tail(con,lev);out.full.cpl_neg.hadNaN(con);out.full.cpl_neg.hadimag(con);out.full.cpl_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Characteristic Path Length (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.cpl_neg.beta(con,lev),out.full.cpl_neg.test_stat(con,lev),out.full.cpl_neg.crit_val(con,lev),out.full.cpl_neg.p_2tail(con,lev),out.full.cpl_neg.hadNaN(con),out.full.cpl_neg.hadimag(con),out.full.cpl_neg.hadInf(con));
                end
            end
        end
        if out.test_props_thrmat.cpl == 1
            if out.thrAUC.cpl_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.cpl_pos.beta(con,lev)) && out.thrAUC.cpl_pos.beta(con,lev) ~= 0
                out.sig_find(con).cpl_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).cpl_pos_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).cpl_pos_thr{2,lev} = [out.sig_find(con).cpl_pos_thr{2,lev};num2cell([out.thrAUC.cpl_pos.beta(con,lev);out.thrAUC.cpl_pos.test_stat(con,lev);out.thrAUC.cpl_pos.crit_val(con,lev);out.thrAUC.cpl_pos.p_2tail(con,lev);out.thrAUC.cpl_pos.hadNaN(con);out.thrAUC.cpl_pos.hadimag(con);out.thrAUC.cpl_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Characteristic Path Length (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.cpl_pos.beta(con,lev),out.thrAUC.cpl_pos.test_stat(con,lev),out.thrAUC.cpl_pos.crit_val(con,lev),out.thrAUC.cpl_pos.p_2tail(con,lev),out.thrAUC.cpl_pos.hadNaN(con),out.thrAUC.cpl_pos.hadimag(con),out.thrAUC.cpl_pos.hadInf(con));
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.thrAUC.cpl_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.cpl_neg.beta(con,lev)) && out.thrAUC.cpl_neg.beta(con,lev) ~= 0
                    out.sig_find(con).cpl_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).cpl_neg_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).cpl_neg_thr{2,lev} = [out.sig_find(con).cpl_neg_thr{2,lev};num2cell([out.thrAUC.cpl_neg.beta(con,lev);out.thrAUC.cpl_neg.test_stat(con,lev);out.thrAUC.cpl_neg.crit_val(con,lev);out.thrAUC.cpl_neg.p_2tail(con,lev);out.thrAUC.cpl_neg.hadNaN(con);out.thrAUC.cpl_neg.hadimag(con);out.thrAUC.cpl_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Characteristic Path Length (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.cpl_neg.beta(con,lev),out.thrAUC.cpl_neg.test_stat(con,lev),out.thrAUC.cpl_neg.crit_val(con,lev),out.thrAUC.cpl_neg.p_2tail(con,lev),out.thrAUC.cpl_neg.hadNaN(con),out.thrAUC.cpl_neg.hadimag(con),out.thrAUC.cpl_neg.hadInf(con));
                end
            end
            if out.calcAUC_nodiscon == 1
                if out.thrAUC.cpl_pos_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.cpl_pos_nodiscon.beta(con,lev)) && out.thrAUC.cpl_pos_nodiscon.beta(con,lev) ~= 0
                    out.sig_find(con).cpl_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).cpl_pos_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).cpl_pos_nodiscon_thr{2,lev} = [out.sig_find(con).cpl_pos_nodiscon_thr{2,lev};num2cell([out.thrAUC.cpl_pos_nodiscon.beta(con,lev);out.thrAUC.cpl_pos_nodiscon.test_stat(con,lev);out.thrAUC.cpl_pos_nodiscon.crit_val(con,lev);out.thrAUC.cpl_pos_nodiscon.p_2tail(con,lev);out.thrAUC.cpl_pos_nodiscon.hadNaN(con);out.thrAUC.cpl_pos_nodiscon.hadimag(con);out.thrAUC.cpl_pos_nodiscon.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Characteristic Path Length (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.cpl_pos_nodiscon.beta(con,lev),out.thrAUC.cpl_pos_nodiscon.test_stat(con,lev),out.thrAUC.cpl_pos_nodiscon.crit_val(con,lev),out.thrAUC.cpl_pos_nodiscon.p_2tail(con,lev),out.thrAUC.cpl_pos_nodiscon.hadNaN(con),out.thrAUC.cpl_pos_nodiscon.hadimag(con),out.thrAUC.cpl_pos_nodiscon.hadInf(con));
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.thrAUC.cpl_neg_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.cpl_neg_nodiscon.beta(con,lev)) && out.thrAUC.cpl_neg_nodiscon.beta(con,lev) ~= 0
                        out.sig_find(con).cpl_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).cpl_neg_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).cpl_neg_nodiscon_thr{2,lev} = [out.sig_find(con).cpl_neg_nodiscon_thr{2,lev};num2cell([out.thrAUC.cpl_neg_nodiscon.beta(con,lev);out.thrAUC.cpl_neg_nodiscon.test_stat(con,lev);out.thrAUC.cpl_neg_nodiscon.crit_val(con,lev);out.thrAUC.cpl_neg_nodiscon.p_2tail(con,lev);out.thrAUC.cpl_neg_nodiscon.hadNaN(con);out.thrAUC.cpl_neg_nodiscon.hadimag(con);out.thrAUC.cpl_neg_nodiscon.hadInf(con)]')];
                        
                        fprintf(sigeffects_fid,'Characteristic Path Length (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.cpl_neg_nodiscon.beta(con,lev),out.thrAUC.cpl_neg_nodiscon.test_stat(con,lev),out.thrAUC.cpl_neg_nodiscon.crit_val(con,lev),out.thrAUC.cpl_neg_nodiscon.p_2tail(con,lev),out.thrAUC.cpl_neg_nodiscon.hadNaN(con),out.thrAUC.cpl_neg_nodiscon.hadimag(con),out.thrAUC.cpl_neg_nodiscon.hadInf(con));
                    end
                end
            end
        end
        
        % Clustering Coefficient
        if out.test_props_fullmat.clust_coef == 1
            ind = logical(out.full.clust_coef_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.clust_coef_pos.beta(con,:,lev)) & out.full.clust_coef_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).clust_coef_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).clust_coef_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).clust_coef_pos_full{2,lev} = [out.sig_find(con).clust_coef_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.clust_coef_pos.beta(con,ind,lev);out.full.clust_coef_pos.test_stat(con,ind,lev);out.full.clust_coef_pos.crit_val(con,ind,lev);out.full.clust_coef_pos.p_2tail(con,ind,lev);out.full.clust_coef_pos.hadNaN(con,ind);out.full.clust_coef_pos.hadimag(con,ind);out.full.clust_coef_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Clustering Coefficient (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.clust_coef_pos.beta(con,f_ind(ind_val),lev),out.full.clust_coef_pos.test_stat(con,f_ind(ind_val),lev),out.full.clust_coef_pos.crit_val(con,f_ind(ind_val),lev),out.full.clust_coef_pos.p_2tail(con,f_ind(ind_val),lev),out.full.clust_coef_pos.hadNaN(con,f_ind(ind_val)),out.full.clust_coef_pos.hadimag(con,f_ind(ind_val)),out.full.clust_coef_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.clust_coef_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.clust_coef_neg.beta(con,:,lev)) & out.full.clust_coef_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).clust_coef_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).clust_coef_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).clust_coef_neg_full{2,lev} = [out.sig_find(con).clust_coef_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.clust_coef_neg.beta(con,ind,lev);out.full.clust_coef_neg.test_stat(con,ind,lev);out.full.clust_coef_neg.crit_val(con,ind,lev);out.full.clust_coef_neg.p_2tail(con,ind,lev);out.full.clust_coef_neg.hadNaN(con,ind);out.full.clust_coef_neg.hadimag(con,ind);out.full.clust_coef_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Clustering Coefficient (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.clust_coef_neg.beta(con,f_ind(ind_val),lev),out.full.clust_coef_neg.test_stat(con,f_ind(ind_val),lev),out.full.clust_coef_neg.crit_val(con,f_ind(ind_val),lev),out.full.clust_coef_neg.p_2tail(con,f_ind(ind_val),lev),out.full.clust_coef_neg.hadNaN(con,f_ind(ind_val)),out.full.clust_coef_neg.hadimag(con,f_ind(ind_val)),out.full.clust_coef_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.clust_coef == 1
            ind = logical(out.thrAUC.clust_coef_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.clust_coef_pos.beta(con,:,lev)) & out.thrAUC.clust_coef_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).clust_coef_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).clust_coef_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).clust_coef_pos_thr{2,lev} = [out.sig_find(con).clust_coef_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.clust_coef_pos.beta(con,ind,lev);out.thrAUC.clust_coef_pos.test_stat(con,ind,lev);out.thrAUC.clust_coef_pos.crit_val(con,ind,lev);out.thrAUC.clust_coef_pos.p_2tail(con,ind,lev);out.thrAUC.clust_coef_pos.hadNaN(con,ind);out.thrAUC.clust_coef_pos.hadimag(con,ind);out.thrAUC.clust_coef_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Clustering Coefficient (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.clust_coef_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.clust_coef_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.clust_coef_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.clust_coef_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.clust_coef_neg.beta(con,:,lev)) & out.thrAUC.clust_coef_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).clust_coef_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).clust_coef_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).clust_coef_neg_thr{2,lev} = [out.sig_find(con).clust_coef_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.clust_coef_neg.beta(con,ind,lev);out.thrAUC.clust_coef_neg.test_stat(con,ind,lev);out.thrAUC.clust_coef_neg.crit_val(con,ind,lev);out.thrAUC.clust_coef_neg.p_2tail(con,ind,lev);out.thrAUC.clust_coef_neg.hadNaN(con,ind);out.thrAUC.clust_coef_neg.hadimag(con,ind);out.thrAUC.clust_coef_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Clustering Coefficient (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.clust_coef_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.clust_coef_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.clust_coef_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.clust_coef_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.clust_coef_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.clust_coef_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).clust_coef_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).clust_coef_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).clust_coef_pos_nodiscon_thr{2,lev} = [out.sig_find(con).clust_coef_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.clust_coef_pos_nodiscon.beta(con,ind,lev);out.thrAUC.clust_coef_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.clust_coef_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.clust_coef_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.clust_coef_pos_nodiscon.hadNaN(con,ind);out.thrAUC.clust_coef_pos_nodiscon.hadimag(con,ind);out.thrAUC.clust_coef_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Clustering Coefficient (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.clust_coef_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.clust_coef_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.clust_coef_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.clust_coef_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.clust_coef_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.clust_coef_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).clust_coef_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).clust_coef_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).clust_coef_neg_nodiscon_thr{2,lev} = [out.sig_find(con).clust_coef_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.clust_coef_neg_nodiscon.beta(con,ind,lev);out.thrAUC.clust_coef_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.clust_coef_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.clust_coef_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.clust_coef_neg_nodiscon.hadNaN(con,ind);out.thrAUC.clust_coef_neg_nodiscon.hadimag(con,ind);out.thrAUC.clust_coef_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Clustering Coefficient (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.clust_coef_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.clust_coef_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.clust_coef_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.clust_coef_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Degree
        if out.test_props_thrmat.deg == 1
            ind = logical(out.thrAUC.deg_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.deg_pos.beta(con,:,lev)) & out.thrAUC.deg_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).deg_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).deg_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).deg_pos_thr{2,lev} = [out.sig_find(con).deg_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.deg_pos.beta(con,ind,lev);out.thrAUC.deg_pos.test_stat(con,ind,lev);out.thrAUC.deg_pos.crit_val(con,ind,lev);out.thrAUC.deg_pos.p_2tail(con,ind,lev);out.thrAUC.deg_pos.hadNaN(con,ind);out.thrAUC.deg_pos.hadimag(con,ind);out.thrAUC.deg_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Degree (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.deg_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.deg_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.deg_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.deg_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.deg_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.deg_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.deg_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.deg_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.deg_neg.beta(con,:,lev)) & out.thrAUC.deg_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).deg_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).deg_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).deg_neg_thr{2,lev} = [out.sig_find(con).deg_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.deg_neg.beta(con,ind,lev);out.thrAUC.deg_neg.test_stat(con,ind,lev);out.thrAUC.deg_neg.crit_val(con,ind,lev);out.thrAUC.deg_neg.p_2tail(con,ind,lev);out.thrAUC.deg_neg.hadNaN(con,ind);out.thrAUC.deg_neg.hadimag(con,ind);out.thrAUC.deg_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Degree (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.deg_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.deg_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.deg_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.deg_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.deg_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.deg_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.deg_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.deg_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.deg_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.deg_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).deg_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).deg_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).deg_pos_nodiscon_thr{2,lev} = [out.sig_find(con).deg_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.deg_pos_nodiscon.beta(con,ind,lev);out.thrAUC.deg_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.deg_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.deg_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.deg_pos_nodiscon.hadNaN(con,ind);out.thrAUC.deg_pos_nodiscon.hadimag(con,ind);out.thrAUC.deg_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Degree (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.deg_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.deg_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.deg_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.deg_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.deg_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.deg_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.deg_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.deg_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.deg_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.deg_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).deg_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).deg_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).deg_neg_nodiscon_thr{2,lev} = [out.sig_find(con).deg_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.deg_neg_nodiscon.beta(con,ind,lev);out.thrAUC.deg_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.deg_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.deg_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.deg_neg_nodiscon.hadNaN(con,ind);out.thrAUC.deg_neg_nodiscon.hadimag(con,ind);out.thrAUC.deg_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Degree (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.deg_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.deg_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.deg_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.deg_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.deg_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.deg_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.deg_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Density
        if out.test_props_thrmat.dens == 1
            if out.thrAUC.dens_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.dens_pos.beta(con,lev)) && out.thrAUC.dens_pos.beta(con,lev) ~= 0
                out.sig_find(con).dens_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).dens_pos_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).dens_pos_thr{2,lev} = [out.sig_find(con).dens_pos_thr{2,lev};num2cell([out.thrAUC.dens_pos.beta(con,lev);out.thrAUC.dens_pos.test_stat(con,lev);out.thrAUC.dens_pos.crit_val(con,lev);out.thrAUC.dens_pos.p_2tail(con,lev);out.thrAUC.dens_pos.hadNaN(con);out.thrAUC.dens_pos.hadimag(con);out.thrAUC.dens_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Density (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.dens_pos.beta(con,lev),out.thrAUC.dens_pos.test_stat(con,lev),out.thrAUC.dens_pos.crit_val(con,lev),out.thrAUC.dens_pos.p_2tail(con,lev),out.thrAUC.dens_pos.hadNaN(con),out.thrAUC.dens_pos.hadimag(con),out.thrAUC.dens_pos.hadInf(con));
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.thrAUC.dens_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.dens_neg.beta(con,lev)) && out.thrAUC.dens_neg.beta(con,lev) ~= 0
                    out.sig_find(con).dens_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).dens_neg_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).dens_neg_thr{2,lev} = [out.sig_find(con).dens_neg_thr{2,lev};num2cell([out.thrAUC.dens_neg.beta(con,lev);out.thrAUC.dens_neg.test_stat(con,lev);out.thrAUC.dens_neg.crit_val(con,lev);out.thrAUC.dens_neg.p_2tail(con,lev);out.thrAUC.dens_neg.hadNaN(con);out.thrAUC.dens_neg.hadimag(con);out.thrAUC.dens_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Density (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.dens_neg.beta(con,lev),out.thrAUC.dens_neg.test_stat(con,lev),out.thrAUC.dens_neg.crit_val(con,lev),out.thrAUC.dens_neg.p_2tail(con,lev),out.thrAUC.dens_neg.hadNaN(con),out.thrAUC.dens_neg.hadimag(con),out.thrAUC.dens_neg.hadInf(con));
                end
            end
            if out.calcAUC_nodiscon == 1
                if out.thrAUC.dens_pos_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.dens_pos_nodiscon.beta(con,lev)) && out.thrAUC.dens_pos_nodiscon.beta(con,lev) ~= 0
                    out.sig_find(con).dens_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).dens_pos_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).dens_pos_nodiscon_thr{2,lev} = [out.sig_find(con).dens_pos_nodiscon_thr{2,lev};num2cell([out.thrAUC.dens_pos_nodiscon.beta(con,lev);out.thrAUC.dens_pos_nodiscon.test_stat(con,lev);out.thrAUC.dens_pos_nodiscon.crit_val(con,lev);out.thrAUC.dens_pos_nodiscon.p_2tail(con,lev);out.thrAUC.dens_pos_nodiscon.hadNaN(con);out.thrAUC.dens_pos_nodiscon.hadimag(con);out.thrAUC.dens_pos_nodiscon.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Density (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.dens_pos_nodiscon.beta(con,lev),out.thrAUC.dens_pos_nodiscon.test_stat(con,lev),out.thrAUC.dens_pos_nodiscon.crit_val(con,lev),out.thrAUC.dens_pos_nodiscon.p_2tail(con,lev),out.thrAUC.dens_pos_nodiscon.hadNaN(con),out.thrAUC.dens_pos_nodiscon.hadimag(con),out.thrAUC.dens_pos_nodiscon.hadInf(con));
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.thrAUC.dens_neg_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.dens_neg_nodiscon.beta(con,lev)) && out.thrAUC.dens_neg_nodiscon.beta(con,lev) ~= 0
                        out.sig_find(con).dens_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).dens_neg_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).dens_neg_nodiscon_thr{2,lev} = [out.sig_find(con).dens_neg_nodiscon_thr{2,lev};num2cell([out.thrAUC.dens_neg_nodiscon.beta(con,lev);out.thrAUC.dens_neg_nodiscon.test_stat(con,lev);out.thrAUC.dens_neg_nodiscon.crit_val(con,lev);out.thrAUC.dens_neg_nodiscon.p_2tail(con,lev);out.thrAUC.dens_neg_nodiscon.hadNaN(con);out.thrAUC.dens_neg_nodiscon.hadimag(con);out.thrAUC.dens_neg_nodiscon.hadInf(con)]')];
                        
                        fprintf(sigeffects_fid,'Density (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.dens_neg_nodiscon.beta(con,lev),out.thrAUC.dens_neg_nodiscon.test_stat(con,lev),out.thrAUC.dens_neg_nodiscon.crit_val(con,lev),out.thrAUC.dens_neg_nodiscon.p_2tail(con,lev),out.thrAUC.dens_neg_nodiscon.hadNaN(con),out.thrAUC.dens_neg_nodiscon.hadimag(con),out.thrAUC.dens_neg_nodiscon.hadInf(con));
                    end
                end
            end
        end
        
        % Diversity Coefficient
        if out.test_props_fullmat.div_coef == 1
            ind = logical(out.full.div_coef_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.div_coef_pos.beta(con,:,lev)) & out.full.div_coef_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).div_coef_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).div_coef_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).div_coef_pos_full{2,lev} = [out.sig_find(con).div_coef_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.div_coef_pos.beta(con,ind,lev);out.full.div_coef_pos.test_stat(con,ind,lev);out.full.div_coef_pos.crit_val(con,ind,lev);out.full.div_coef_pos.p_2tail(con,ind,lev);out.full.div_coef_pos.hadNaN(con,ind);out.full.div_coef_pos.hadimag(con,ind);out.full.div_coef_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Diversity Coefficient (full matrices, negative weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.div_coef_neg.beta(con,f_ind(ind_val),lev),out.full.div_coef_neg.test_stat(con,f_ind(ind_val),lev),out.full.div_coef_neg.crit_val(con,f_ind(ind_val),lev),out.full.div_coef_neg.p_2tail(con,f_ind(ind_val),lev),out.full.div_coef_neg.hadNaN(con,f_ind(ind_val)),out.full.div_coef_neg.hadimag(con,f_ind(ind_val)),out.full.div_coef_neg.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.div_coef_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.div_coef_neg.beta(con,:,lev)) & out.full.div_coef_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).div_coef_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).div_coef_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).div_coef_neg_full{2,lev} = [out.sig_find(con).div_coef_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.div_coef_neg.beta(con,ind,lev);out.full.div_coef_neg.test_stat(con,ind,lev);out.full.div_coef_neg.crit_val(con,ind,lev);out.full.div_coef_neg.p_2tail(con,ind,lev);out.full.div_coef_neg.hadNaN(con,ind);out.full.div_coef_neg.hadimag(con,ind);out.full.div_coef_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Diversity Coefficient (full matrices, positive weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.div_coef_pos.beta(con,f_ind(ind_val),lev),out.full.div_coef_pos.test_stat(con,f_ind(ind_val),lev),out.full.div_coef_pos.crit_val(con,f_ind(ind_val),lev),out.full.div_coef_pos.p_2tail(con,f_ind(ind_val),lev),out.full.div_coef_pos.hadNaN(con,f_ind(ind_val)),out.full.div_coef_pos.hadimag(con,f_ind(ind_val)),out.full.div_coef_pos.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        
        % Edge Betweenes Centrality
        if out.test_props_fullmat.edge_bet_cent == 1
            ind                          = logical((squeeze(out.full.edge_bet_cent_pos.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.full.edge_bet_cent_pos.beta(con,:,:,lev))) & squeeze(out.full.edge_bet_cent_pos.beta(con,:,:,lev) ~= 0));
            ind(logical(eye(size(ind)))) = 0;
            [xind,yind]                  = find(ind == 1);
            if any(any(ind))
                out.sig_find(con).edge_bet_cent_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).edge_bet_cent_pos_full{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                tempbeta                                  = squeeze(out.full.edge_bet_cent_pos.beta(con,:,:,lev));
                tempteststat                              = squeeze(out.full.edge_bet_cent_pos.test_stat(con,:,:,lev));
                tempcritval                               = squeeze(out.full.edge_bet_cent_pos.crit_val(con,:,:,lev));
                tempp                                     = squeeze(out.full.edge_bet_cent_pos.p_2tail(con,:,:,lev));
                out.sig_find(con).edge_bet_cent_pos_full{2,lev} = [out.sig_find(con).edge_bet_cent_pos_full{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.full.edge_bet_cent_pos.hadNaN(con,ind)',out.full.edge_bet_cent_pos.hadimag(con,ind)',out.full.edge_bet_cent_pos.hadInf(con,ind)'])]];
                
                fprintf(sigeffects_fid,'Edge Betweeness Centrality (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                for ind_val = 1:length(xind)
                    fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.full.edge_bet_cent_pos.hadNaN(con,xind(ind_val),yind(ind_val)),out.full.edge_bet_cent_pos.hadimag(con,xind(ind_val),yind(ind_val)),out.full.edge_bet_cent_pos.hadInf(con,xind(ind_val),yind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind                          = logical((squeeze(out.full.edge_bet_cent_neg.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.full.edge_bet_cent_neg.beta(con,:,:,lev))) & squeeze(out.full.edge_bet_cent_neg.beta(con,:,:,lev) ~= 0));
                ind(logical(eye(size(ind)))) = 0;
                [xind,yind]                  = find(ind == 1);
                if any(any(ind))
                    out.sig_find(con).edge_bet_cent_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).edge_bet_cent_neg_full{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    tempbeta                                  = squeeze(out.full.edge_bet_cent_neg.beta(con,:,:,lev));
                    tempteststat                              = squeeze(out.full.edge_bet_cent_neg.test_stat(con,:,:,lev));
                    tempcritval                               = squeeze(out.full.edge_bet_cent_neg.crit_val(con,:,:,lev));
                    tempp                                     = squeeze(out.full.edge_bet_cent_neg.p_2tail(con,:,:,lev));
                    out.sig_find(con).edge_bet_cent_neg_full{2,lev} = [out.sig_find(con).edge_bet_cent_neg_full{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.full.edge_bet_cent_neg.hadNaN(con,ind)',out.full.edge_bet_cent_neg.hadimag(con,ind)',out.full.edge_bet_cent_neg.hadInf(con,ind)'])]];
                    
                    fprintf(sigeffects_fid,'Edge Betweeness Centrality (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    for ind_val = 1:length(xind)
                        fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.full.edge_bet_cent_neg.hadNaN(con,xind(ind_val),yind(ind_val)),out.full.edge_bet_cent_neg.hadimag(con,xind(ind_val),yind(ind_val)),out.full.edge_bet_cent_neg.hadInf(con,xind(ind_val),yind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.edge_bet_cent == 1
            ind                          = logical((squeeze(out.thrAUC.edge_bet_cent_pos.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.edge_bet_cent_pos.beta(con,:,:,lev))) & squeeze(out.thrAUC.edge_bet_cent_pos.beta(con,:,:,lev) ~= 0));
            ind(logical(eye(size(ind)))) = 0;
            [xind,yind]                  = find(ind == 1);
            if any(any(ind))
                out.sig_find(con).edge_bet_cent_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).edge_bet_cent_pos_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                tempbeta                                     = squeeze(out.thrAUC.edge_bet_cent_pos.beta(con,:,:,lev));
                tempteststat                                 = squeeze(out.thrAUC.edge_bet_cent_pos.test_stat(con,:,:,lev));
                tempcritval                                  = squeeze(out.thrAUC.edge_bet_cent_pos.crit_val(con,:,:,lev));
                tempp                                        = squeeze(out.thrAUC.edge_bet_cent_pos.p_2tail(con,:,:,lev));
                out.sig_find(con).edge_bet_cent_pos_thr{2,lev} = [out.sig_find(con).edge_bet_cent_pos_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.edge_bet_cent_pos.hadNaN(con,ind)',out.thrAUC.edge_bet_cent_pos.hadimag(con,ind)',out.thrAUC.edge_bet_cent_pos.hadInf(con,ind)'])]];
                
                fprintf(sigeffects_fid,'Edge Betweeness Centrality (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                for ind_val = 1:length(xind)
                    fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_pos.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_pos.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_pos.hadInf(con,xind(ind_val),yind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind                          = logical((squeeze(out.thrAUC.edge_bet_cent_neg.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.edge_bet_cent_neg.beta(con,:,:,lev))) & squeeze(out.thrAUC.edge_bet_cent_neg.beta(con,:,:,lev) ~= 0));
                ind(logical(eye(size(ind)))) = 0;
                [xind,yind]                  = find(ind == 1);
                if any(any(ind))
                    out.sig_find(con).edge_bet_cent_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).edge_bet_cent_neg_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    tempbeta                                     = squeeze(out.thrAUC.edge_bet_cent_neg.beta(con,:,:,lev));
                    tempteststat                                 = squeeze(out.thrAUC.edge_bet_cent_neg.test_stat(con,:,:,lev));
                    tempcritval                                  = squeeze(out.thrAUC.edge_bet_cent_neg.crit_val(con,:,:,lev));
                    tempp                                        = squeeze(out.thrAUC.edge_bet_cent_neg.p_2tail(con,:,:,lev));
                    out.sig_find(con).edge_bet_cent_neg_thr{2,lev} = [out.sig_find(con).edge_bet_cent_neg_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.edge_bet_cent_neg.hadNaN(con,ind)',out.thrAUC.edge_bet_cent_neg.hadimag(con,ind)',out.thrAUC.edge_bet_cent_neg.hadInf(con,ind)'])]];
                    
                    fprintf(sigeffects_fid,'Edge Betweeness Centrality (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    for ind_val = 1:length(xind)
                        fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_neg.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_neg.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_neg.hadInf(con,xind(ind_val),yind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind                          = logical((squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.beta(con,:,:,lev))) & squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.beta(con,:,:,lev) ~= 0));
                ind(logical(eye(size(ind)))) = 0;
                [xind,yind]                  = find(ind == 1);
                if any(any(ind))
                    out.sig_find(con).edge_bet_cent_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).edge_bet_cent_pos_nodiscon_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    tempbeta                                              = squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.beta(con,:,:,lev));
                    tempteststat                                          = squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.test_stat(con,:,:,lev));
                    tempcritval                                           = squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.crit_val(con,:,:,lev));
                    tempp                                                 = squeeze(out.thrAUC.edge_bet_cent_pos_nodiscon.p_2tail(con,:,:,lev));
                    out.sig_find(con).edge_bet_cent_pos_nodiscon_thr{2,lev} = [out.sig_find(con).edge_bet_cent_pos_nodiscon_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.edge_bet_cent_pos_nodiscon.hadNaN(con,ind)',out.thrAUC.edge_bet_cent_pos_nodiscon.hadimag(con,ind)',out.thrAUC.edge_bet_cent_pos_nodiscon.hadInf(con,ind)'])]];
                    
                    fprintf(sigeffects_fid,'Edge Betweeness Centrality (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    for ind_val = 1:length(xind)
                        fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_pos_nodiscon.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_pos_nodiscon.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_pos_nodiscon.hadInf(con,xind(ind_val),yind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind                          = logical((squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.beta(con,:,:,lev))) & squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.beta(con,:,:,lev) ~= 0));
                    ind(logical(eye(size(ind)))) = 0;
                    [xind,yind]                  = find(ind == 1);
                    if any(any(ind))
                        out.sig_find(con).edge_bet_cent_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).edge_bet_cent_neg_nodiscon_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        tempbeta                                              = squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.beta(con,:,:,lev));
                        tempteststat                                          = squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.test_stat(con,:,:,lev));
                        tempcritval                                           = squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.crit_val(con,:,:,lev));
                        tempp                                                 = squeeze(out.thrAUC.edge_bet_cent_neg_nodiscon.p_2tail(con,:,:,lev));
                        out.sig_find(con).edge_bet_cent_neg_nodiscon_thr{2,lev} = [out.sig_find(con).edge_bet_cent_neg_nodiscon_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.edge_bet_cent_neg_nodiscon.hadNaN(con,ind)',out.thrAUC.edge_bet_cent_neg_nodiscon.hadimag(con,ind)',out.thrAUC.edge_bet_cent_neg_nodiscon.hadInf(con,ind)'])]];
                        
                        fprintf(sigeffects_fid,'Edge Betweeness Centrality (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        for ind_val = 1:length(xind)
                            fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_neg_nodiscon.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_neg_nodiscon.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.edge_bet_cent_neg_nodiscon.hadInf(con,xind(ind_val),yind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Eigenvector Centrality
        if out.test_props_fullmat.eigvec_cent == 1
            ind = logical(out.full.eigvec_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.eigvec_cent_pos.beta(con,:,lev)) & out.full.eigvec_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).eigvec_cent_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).eigvec_cent_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).eigvec_cent_pos_full{2,lev} = [out.sig_find(con).eigvec_cent_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.eigvec_cent_pos.beta(con,ind,lev);out.full.eigvec_cent_pos.test_stat(con,ind,lev);out.full.eigvec_cent_pos.crit_val(con,ind,lev);out.full.eigvec_cent_pos.p_2tail(con,ind,lev);out.full.eigvec_cent_pos.hadNaN(con,ind);out.full.eigvec_cent_pos.hadimag(con,ind);out.full.eigvec_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Eigenvector Centrality (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.eigvec_cent_pos.beta(con,f_ind(ind_val),lev),out.full.eigvec_cent_pos.test_stat(con,f_ind(ind_val),lev),out.full.eigvec_cent_pos.crit_val(con,f_ind(ind_val),lev),out.full.eigvec_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.full.eigvec_cent_pos.hadNaN(con,f_ind(ind_val)),out.full.eigvec_cent_pos.hadimag(con,f_ind(ind_val)),out.full.eigvec_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.eigvec_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.eigvec_cent_neg.beta(con,:,lev)) & out.full.eigvec_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).eigvec_cent_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).eigvec_cent_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).eigvec_cent_neg_full{2,lev} = [out.sig_find(con).eigvec_cent_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.eigvec_cent_neg.beta(con,ind,lev);out.full.eigvec_cent_neg.test_stat(con,ind,lev);out.full.eigvec_cent_neg.crit_val(con,ind,lev);out.full.eigvec_cent_neg.p_2tail(con,ind,lev);out.full.eigvec_cent_neg.hadNaN(con,ind);out.full.eigvec_cent_neg.hadimag(con,ind);out.full.eigvec_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Eigenvector Centrality (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.eigvec_cent_neg.beta(con,f_ind(ind_val),lev),out.full.eigvec_cent_neg.test_stat(con,f_ind(ind_val),lev),out.full.eigvec_cent_neg.crit_val(con,f_ind(ind_val),lev),out.full.eigvec_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.full.eigvec_cent_neg.hadNaN(con,f_ind(ind_val)),out.full.eigvec_cent_neg.hadimag(con,f_ind(ind_val)),out.full.eigvec_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.eigvec_cent == 1
            ind = logical(out.thrAUC.eigvec_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.eigvec_cent_pos.beta(con,:,lev)) & out.thrAUC.eigvec_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).eigvec_cent_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).eigvec_cent_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).eigvec_cent_pos_thr{2,lev} = [out.sig_find(con).eigvec_cent_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.eigvec_cent_pos.beta(con,ind,lev);out.thrAUC.eigvec_cent_pos.test_stat(con,ind,lev);out.thrAUC.eigvec_cent_pos.crit_val(con,ind,lev);out.thrAUC.eigvec_cent_pos.p_2tail(con,ind,lev);out.thrAUC.eigvec_cent_pos.hadNaN(con,ind);out.thrAUC.eigvec_cent_pos.hadimag(con,ind);out.thrAUC.eigvec_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Eigenvector Centrality (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.eigvec_cent_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.eigvec_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.eigvec_cent_neg.beta(con,:,lev)) & out.thrAUC.eigvec_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).eigvec_cent_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).eigvec_cent_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).eigvec_cent_neg_thr{2,lev} = [out.sig_find(con).eigvec_cent_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.eigvec_cent_neg.beta(con,ind,lev);out.thrAUC.eigvec_cent_neg.test_stat(con,ind,lev);out.thrAUC.eigvec_cent_neg.crit_val(con,ind,lev);out.thrAUC.eigvec_cent_neg.p_2tail(con,ind,lev);out.thrAUC.eigvec_cent_neg.hadNaN(con,ind);out.thrAUC.eigvec_cent_neg.hadimag(con,ind);out.thrAUC.eigvec_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Eigenvector Centrality (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.eigvec_cent_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.eigvec_cent_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.eigvec_cent_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.eigvec_cent_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).eigvec_cent_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).eigvec_cent_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).eigvec_cent_pos_nodiscon_thr{2,lev} = [out.sig_find(con).eigvec_cent_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.eigvec_cent_pos_nodiscon.beta(con,ind,lev);out.thrAUC.eigvec_cent_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.eigvec_cent_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.eigvec_cent_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.eigvec_cent_pos_nodiscon.hadNaN(con,ind);out.thrAUC.eigvec_cent_pos_nodiscon.hadimag(con,ind);out.thrAUC.eigvec_cent_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Eigenvector Centrality (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.eigvec_cent_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.eigvec_cent_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.eigvec_cent_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.eigvec_cent_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).eigvec_cent_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).eigvec_cent_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).eigvec_cent_neg_nodiscon_thr{2,lev} = [out.sig_find(con).eigvec_cent_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.eigvec_cent_neg_nodiscon.beta(con,ind,lev);out.thrAUC.eigvec_cent_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.eigvec_cent_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.eigvec_cent_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.eigvec_cent_neg_nodiscon.hadNaN(con,ind);out.thrAUC.eigvec_cent_neg_nodiscon.hadimag(con,ind);out.thrAUC.eigvec_cent_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Eigenvector Centrality (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.eigvec_cent_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.eigvec_cent_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.eigvec_cent_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Global Efficiency
        if out.test_props_fullmat.glob_eff == 1
            if out.full.glob_eff_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.glob_eff_pos.beta(con,lev)) && out.full.glob_eff_pos.beta(con,lev) ~= 0
                out.sig_find(con).glob_eff_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).glob_eff_pos_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).glob_eff_pos_full{2,lev} = [out.sig_find(con).glob_eff_pos_full{2,lev};num2cell([out.full.glob_eff_pos.beta(con,lev);out.full.glob_eff_pos.test_stat(con,lev);out.full.glob_eff_pos.crit_val(con,lev);out.full.glob_eff_pos.p_2tail(con,lev);out.full.glob_eff_pos.hadNaN(con);out.full.glob_eff_pos.hadimag(con);out.full.glob_eff_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Global Efficiency (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.glob_eff_pos.beta(con,lev),out.full.glob_eff_pos.test_stat(con,lev),out.full.glob_eff_pos.crit_val(con,lev),out.full.glob_eff_pos.p_2tail(con,lev),out.full.glob_eff_pos.hadNaN(con),out.full.glob_eff_pos.hadimag(con),out.full.glob_eff_pos.hadInf(con));
            end
            if out.use_abs_val == 0
                if out.full.glob_eff_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.glob_eff_neg.beta(con,lev)) && out.full.glob_eff_neg.beta(con,lev) ~= 0
                    out.sig_find(con).glob_eff_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).glob_eff_neg_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).glob_eff_neg_full{2,lev} = [out.sig_find(con).glob_eff_neg_full{2,lev};num2cell([out.full.glob_eff_neg.beta(con,lev);out.full.glob_eff_neg.test_stat(con,lev);out.full.glob_eff_neg.crit_val(con,lev);out.full.glob_eff_neg.p_2tail(con,lev);out.full.glob_eff_neg.hadNaN(con);out.full.glob_eff_neg.hadimag(con);out.full.glob_eff_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Global Efficiency (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.glob_eff_neg.beta(con,lev),out.full.glob_eff_neg.test_stat(con,lev),out.full.glob_eff_neg.crit_val(con,lev),out.full.glob_eff_neg.p_2tail(con,lev),out.full.glob_eff_neg.hadNaN(con),out.full.glob_eff_neg.hadimag(con),out.full.glob_eff_neg.hadInf(con));
                end
            end
        end
        if out.test_props_thrmat.glob_eff == 1
            if out.thrAUC.glob_eff_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.glob_eff_pos.beta(con,lev)) && out.thrAUC.glob_eff_pos.beta(con,lev) ~= 0
                out.sig_find(con).glob_eff_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).glob_eff_pos_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).glob_eff_pos_thr{2,lev} = [out.sig_find(con).glob_eff_pos_thr{2,lev};num2cell([out.thrAUC.glob_eff_pos.beta(con,lev);out.thrAUC.glob_eff_pos.test_stat(con,lev);out.thrAUC.glob_eff_pos.crit_val(con,lev);out.thrAUC.glob_eff_pos.p_2tail(con,lev);out.thrAUC.glob_eff_pos.hadNaN(con);out.thrAUC.glob_eff_pos.hadimag(con);out.thrAUC.glob_eff_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Global Efficiency (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.glob_eff_pos.beta(con,lev),out.thrAUC.glob_eff_pos.test_stat(con,lev),out.thrAUC.glob_eff_pos.crit_val(con,lev),out.thrAUC.glob_eff_pos.p_2tail(con,lev),out.thrAUC.glob_eff_pos.hadNaN(con),out.thrAUC.glob_eff_pos.hadimag(con),out.thrAUC.glob_eff_pos.hadInf(con));
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.thrAUC.glob_eff_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.glob_eff_neg.beta(con,lev)) && out.thrAUC.glob_eff_neg.beta(con,lev) ~= 0
                    out.sig_find(con).glob_eff_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).glob_eff_neg_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).glob_eff_neg_thr{2,lev} = [out.sig_find(con).glob_eff_neg_thr{2,lev};num2cell([out.thrAUC.glob_eff_neg.beta(con,lev);out.thrAUC.glob_eff_neg.test_stat(con,lev);out.thrAUC.glob_eff_neg.crit_val(con,lev);out.thrAUC.glob_eff_neg.p_2tail(con,lev);out.thrAUC.glob_eff_neg.hadNaN(con);out.thrAUC.glob_eff_neg.hadimag(con);out.thrAUC.glob_eff_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Global Efficiency (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.glob_eff_neg.beta(con,lev),out.thrAUC.glob_eff_neg.test_stat(con,lev),out.thrAUC.glob_eff_neg.crit_val(con,lev),out.thrAUC.glob_eff_neg.p_2tail(con,lev),out.thrAUC.glob_eff_neg.hadNaN(con),out.thrAUC.glob_eff_neg.hadimag(con),out.thrAUC.glob_eff_neg.hadInf(con));
                end
            end
            if out.calcAUC_nodiscon == 1
                if out.thrAUC.glob_eff_pos_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.glob_eff_pos_nodiscon.beta(con,lev)) && out.thrAUC.glob_eff_pos_nodiscon.beta(con,lev) ~= 0
                    out.sig_find(con).glob_eff_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).glob_eff_pos_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).glob_eff_pos_nodiscon_thr{2,lev} = [out.sig_find(con).glob_eff_pos_nodiscon_thr{2,lev};num2cell([out.thrAUC.glob_eff_pos_nodiscon.beta(con,lev);out.thrAUC.glob_eff_pos_nodiscon.test_stat(con,lev);out.thrAUC.glob_eff_pos_nodiscon.crit_val(con,lev);out.thrAUC.glob_eff_pos_nodiscon.p_2tail(con,lev);out.thrAUC.glob_eff_pos_nodiscon.hadNaN(con);out.thrAUC.glob_eff_pos_nodiscon.hadimag(con);out.thrAUC.glob_eff_pos_nodiscon.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Global Efficiency (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.glob_eff_pos_nodiscon.beta(con,lev),out.thrAUC.glob_eff_pos_nodiscon.test_stat(con,lev),out.thrAUC.glob_eff_pos_nodiscon.crit_val(con,lev),out.thrAUC.glob_eff_pos_nodiscon.p_2tail(con,lev),out.thrAUC.glob_eff_pos_nodiscon.hadNaN(con),out.thrAUC.glob_eff_pos_nodiscon.hadimag(con),out.thrAUC.glob_eff_pos_nodiscon.hadInf(con));
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.thrAUC.glob_eff_neg_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.glob_eff_neg_nodiscon.beta(con,lev)) && out.thrAUC.glob_eff_neg_nodiscon.beta(con,lev) ~= 0
                        out.sig_find(con).glob_eff_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).glob_eff_neg_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).glob_eff_neg_nodiscon_thr{2,lev} = [out.sig_find(con).glob_eff_neg_nodiscon_thr{2,lev};num2cell([out.thrAUC.glob_eff_neg_nodiscon.beta(con,lev);out.thrAUC.glob_eff_neg_nodiscon.test_stat(con,lev);out.thrAUC.glob_eff_neg_nodiscon.crit_val(con,lev);out.thrAUC.glob_eff_neg_nodiscon.p_2tail(con,lev);out.thrAUC.glob_eff_neg_nodiscon.hadNaN(con);out.thrAUC.glob_eff_neg_nodiscon.hadimag(con);out.thrAUC.glob_eff_neg_nodiscon.hadInf(con)]')];
                        
                        fprintf(sigeffects_fid,'Global Efficiency (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.glob_eff_neg_nodiscon.beta(con,lev),out.thrAUC.glob_eff_neg_nodiscon.test_stat(con,lev),out.thrAUC.glob_eff_neg_nodiscon.crit_val(con,lev),out.thrAUC.glob_eff_neg_nodiscon.p_2tail(con,lev),out.thrAUC.glob_eff_neg_nodiscon.hadNaN(con),out.thrAUC.glob_eff_neg_nodiscon.hadimag(con),out.thrAUC.glob_eff_neg_nodiscon.hadInf(con));
                    end
                end
            end
        end
        
        % K-Coreness Centrality
        if out.test_props_thrmat.kcore_cent == 1
            ind = logical(out.thrAUC.kcore_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.kcore_cent_pos.beta(con,:,lev)) & out.thrAUC.kcore_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).kcore_cent_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).kcore_cent_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).kcore_cent_pos_thr{2,lev} = [out.sig_find(con).kcore_cent_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.kcore_cent_pos.beta(con,ind,lev);out.thrAUC.kcore_cent_pos.test_stat(con,ind,lev);out.thrAUC.kcore_cent_pos.crit_val(con,ind,lev);out.thrAUC.kcore_cent_pos.p_2tail(con,ind,lev);out.thrAUC.kcore_cent_pos.hadNaN(con,ind);out.thrAUC.kcore_cent_pos.hadimag(con,ind);out.thrAUC.kcore_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'K-Coreness Centrality (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.kcore_cent_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.kcore_cent_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.kcore_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.kcore_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.kcore_cent_neg.beta(con,:,lev)) & out.thrAUC.kcore_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).kcore_cent_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).kcore_cent_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).kcore_cent_neg_thr{2,lev} = [out.sig_find(con).kcore_cent_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.kcore_cent_neg.beta(con,ind,lev);out.thrAUC.kcore_cent_neg.test_stat(con,ind,lev);out.thrAUC.kcore_cent_neg.crit_val(con,ind,lev);out.thrAUC.kcore_cent_neg.p_2tail(con,ind,lev);out.thrAUC.kcore_cent_neg.hadNaN(con,ind);out.thrAUC.kcore_cent_neg.hadimag(con,ind);out.thrAUC.kcore_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'K-Coreness Centrality (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.kcore_cent_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.kcore_cent_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.kcore_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.kcore_cent_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.kcore_cent_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.kcore_cent_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).kcore_cent_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).kcore_cent_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).kcore_cent_pos_nodiscon_thr{2,lev} = [out.sig_find(con).kcore_cent_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.kcore_cent_pos_nodiscon.beta(con,ind,lev);out.thrAUC.kcore_cent_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.kcore_cent_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.kcore_cent_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.kcore_cent_pos_nodiscon.hadNaN(con,ind);out.thrAUC.kcore_cent_pos_nodiscon.hadimag(con,ind);out.thrAUC.kcore_cent_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'K-Coreness Centrality (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.kcore_cent_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.kcore_cent_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.kcore_cent_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.kcore_cent_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.kcore_cent_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.kcore_cent_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).kcore_cent_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).kcore_cent_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).kcore_cent_neg_nodiscon_thr{2,lev} = [out.sig_find(con).kcore_cent_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.kcore_cent_neg_nodiscon.beta(con,ind,lev);out.thrAUC.kcore_cent_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.kcore_cent_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.kcore_cent_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.kcore_cent_neg_nodiscon.hadNaN(con,ind);out.thrAUC.kcore_cent_neg_nodiscon.hadimag(con,ind);out.thrAUC.kcore_cent_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'K-Coreness Centrality (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.kcore_cent_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.kcore_cent_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.kcore_cent_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.kcore_cent_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Local Efficiency
        if out.test_props_fullmat.loc_eff == 1
            ind = logical(out.full.loc_eff_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.loc_eff_pos.beta(con,:,lev)) & out.full.loc_eff_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).loc_eff_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).loc_eff_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).loc_eff_pos_full{2,lev} = [out.sig_find(con).loc_eff_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.loc_eff_pos.beta(con,ind,lev);out.full.loc_eff_pos.test_stat(con,ind,lev);out.full.loc_eff_pos.crit_val(con,ind,lev);out.full.loc_eff_pos.p_2tail(con,ind,lev);out.full.loc_eff_pos.hadNaN(con,ind);out.full.loc_eff_pos.hadimag(con,ind);out.full.loc_eff_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Local Efficiency (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.loc_eff_pos.beta(con,f_ind(ind_val),lev),out.full.loc_eff_pos.test_stat(con,f_ind(ind_val),lev),out.full.loc_eff_pos.crit_val(con,f_ind(ind_val),lev),out.full.loc_eff_pos.p_2tail(con,f_ind(ind_val),lev),out.full.loc_eff_pos.hadNaN(con,f_ind(ind_val)),out.full.loc_eff_pos.hadimag(con,f_ind(ind_val)),out.full.loc_eff_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.loc_eff_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.loc_eff_neg.beta(con,:,lev)) & out.full.loc_eff_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).loc_eff_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).loc_eff_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).loc_eff_neg_full{2,lev} = [out.sig_find(con).loc_eff_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.loc_eff_neg.beta(con,ind,lev);out.full.loc_eff_neg.test_stat(con,ind,lev);out.full.loc_eff_neg.crit_val(con,ind,lev);out.full.loc_eff_neg.p_2tail(con,ind,lev);out.full.loc_eff_neg.hadNaN(con,ind);out.full.loc_eff_neg.hadimag(con,ind);out.full.loc_eff_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Local Efficiency (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.loc_eff_neg.beta(con,f_ind(ind_val),lev),out.full.loc_eff_neg.test_stat(con,f_ind(ind_val),lev),out.full.loc_eff_neg.crit_val(con,f_ind(ind_val),lev),out.full.loc_eff_neg.p_2tail(con,f_ind(ind_val),lev),out.full.loc_eff_neg.hadNaN(con,f_ind(ind_val)),out.full.loc_eff_neg.hadimag(con,f_ind(ind_val)),out.full.loc_eff_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.loc_eff == 1
            ind = logical(out.thrAUC.loc_eff_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.loc_eff_pos.beta(con,:,lev)) & out.thrAUC.loc_eff_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).loc_eff_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).loc_eff_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).loc_eff_pos_thr{2,lev} = [out.sig_find(con).loc_eff_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.loc_eff_pos.beta(con,ind,lev);out.thrAUC.loc_eff_pos.test_stat(con,ind,lev);out.thrAUC.loc_eff_pos.crit_val(con,ind,lev);out.thrAUC.loc_eff_pos.p_2tail(con,ind,lev);out.thrAUC.loc_eff_pos.hadNaN(con,ind);out.thrAUC.loc_eff_pos.hadimag(con,ind);out.thrAUC.loc_eff_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Local Efficiency (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.loc_eff_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.loc_eff_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.loc_eff_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.loc_eff_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.loc_eff_neg.beta(con,:,lev)) & out.thrAUC.loc_eff_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).loc_eff_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).loc_eff_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).loc_eff_neg_thr{2,lev} = [out.sig_find(con).loc_eff_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.loc_eff_neg.beta(con,ind,lev);out.thrAUC.loc_eff_neg.test_stat(con,ind,lev);out.thrAUC.loc_eff_neg.crit_val(con,ind,lev);out.thrAUC.loc_eff_neg.p_2tail(con,ind,lev);out.thrAUC.loc_eff_neg.hadNaN(con,ind);out.thrAUC.loc_eff_neg.hadimag(con,ind);out.thrAUC.loc_eff_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Local Efficiency (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.loc_eff_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.loc_eff_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.loc_eff_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.loc_eff_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.loc_eff_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.loc_eff_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).loc_eff_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).loc_eff_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).loc_eff_pos_nodiscon_thr{2,lev} = [out.sig_find(con).loc_eff_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.loc_eff_pos_nodiscon.beta(con,ind,lev);out.thrAUC.loc_eff_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.loc_eff_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.loc_eff_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.loc_eff_pos_nodiscon.hadNaN(con,ind);out.thrAUC.loc_eff_pos_nodiscon.hadimag(con,ind);out.thrAUC.loc_eff_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Local Efficiency (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.loc_eff_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.loc_eff_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.loc_eff_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.loc_eff_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.loc_eff_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.loc_eff_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).loc_eff_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).loc_eff_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).loc_eff_neg_nodiscon_thr{2,lev} = [out.sig_find(con).loc_eff_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.loc_eff_neg_nodiscon.beta(con,ind,lev);out.thrAUC.loc_eff_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.loc_eff_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.loc_eff_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.loc_eff_neg_nodiscon.hadNaN(con,ind);out.thrAUC.loc_eff_neg_nodiscon.hadimag(con,ind);out.thrAUC.loc_eff_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Local Efficiency (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.loc_eff_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.loc_eff_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.loc_eff_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.loc_eff_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Matching Index
        if out.test_props_fullmat.match == 1
            ind                          = logical((squeeze(out.full.match_pos.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.full.match_pos.beta(con,:,:,lev))) & squeeze(out.full.match_pos.beta(con,:,:,lev) ~= 0));
            ind(logical(eye(size(ind)))) = 0;
            [xind,yind]                  = find(ind == 1);
            if any(any(ind))
                out.sig_find(con).match_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).match_pos_full{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                tempbeta                                  = squeeze(out.full.match_pos.beta(con,:,:,lev));
                tempteststat                              = squeeze(out.full.match_pos.test_stat(con,:,:,lev));
                tempcritval                               = squeeze(out.full.match_pos.crit_val(con,:,:,lev));
                tempp                                     = squeeze(out.full.match_pos.p_2tail(con,:,:,lev));
                out.sig_find(con).match_pos_full{2,lev} = [out.sig_find(con).match_pos_full{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.full.match_pos.hadNaN(con,ind)',out.full.match_pos.hadimag(con,ind)',out.full.match_pos.hadInf(con,ind)'])]];
                
                fprintf(sigeffects_fid,'Matching Index (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                for ind_val = 1:length(xind)
                    fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.full.match_pos.hadNaN(con,xind(ind_val),yind(ind_val)),out.full.match_pos.hadimag(con,xind(ind_val),yind(ind_val)),out.full.match_pos.hadInf(con,xind(ind_val),yind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind                          = logical((squeeze(out.full.match_neg.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.full.match_neg.beta(con,:,:,lev))) & squeeze(out.full.match_neg.beta(con,:,:,lev) ~= 0));
                ind(logical(eye(size(ind)))) = 0;
                [xind,yind]                  = find(ind == 1);
                if any(any(ind))
                    out.sig_find(con).match_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).match_neg_full{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    tempbeta                                  = squeeze(out.full.match_neg.beta(con,:,:,lev));
                    tempteststat                              = squeeze(out.full.match_neg.test_stat(con,:,:,lev));
                    tempcritval                               = squeeze(out.full.match_neg.crit_val(con,:,:,lev));
                    tempp                                     = squeeze(out.full.match_neg.p_2tail(con,:,:,lev));
                    out.sig_find(con).match_neg_full{2,lev} = [out.sig_find(con).match_neg_full{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.full.match_neg.hadNaN(con,ind)',out.full.match_neg.hadimag(con,ind)',out.full.match_neg.hadInf(con,ind)'])]];
                    
                    fprintf(sigeffects_fid,'Matching Index (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    for ind_val = 1:length(xind)
                        fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.full.match_neg.hadNaN(con,xind(ind_val),yind(ind_val)),out.full.match_neg.hadimag(con,xind(ind_val),yind(ind_val)),out.full.match_neg.hadInf(con,xind(ind_val),yind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.match == 1
            ind                          = logical((squeeze(out.thrAUC.match_pos.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.match_pos.beta(con,:,:,lev))) & squeeze(out.thrAUC.match_pos.beta(con,:,:,lev) ~= 0));
            ind(logical(eye(size(ind)))) = 0;
            [xind,yind]                  = find(ind == 1);
            if any(any(ind))
                out.sig_find(con).match_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).match_pos_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                tempbeta                               = squeeze(out.thrAUC.match_pos.beta(con,:,:,lev));
                tempteststat                           = squeeze(out.thrAUC.match_pos.test_stat(con,:,:,lev));
                tempcritval                            = squeeze(out.thrAUC.match_pos.crit_val(con,:,:,lev));
                tempp                                  = squeeze(out.thrAUC.match_pos.p_2tail(con,:,:,lev));
                out.sig_find(con).match_pos_thr{2,lev} = [out.sig_find(con).match_pos_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.match_pos.hadNaN(con,ind)',out.thrAUC.match_pos.hadimag(con,ind)',out.thrAUC.match_pos.hadInf(con,ind)'])]];
                
                fprintf(sigeffects_fid,'Matching Index (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                for ind_val = 1:length(xind)
                    fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.match_pos.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_pos.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_pos.hadInf(con,xind(ind_val),yind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind                          = logical((squeeze(out.thrAUC.match_neg.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.match_neg.beta(con,:,:,lev))) & squeeze(out.thrAUC.match_neg.beta(con,:,:,lev) ~= 0));
                ind(logical(eye(size(ind)))) = 0;
                [xind,yind]                  = find(ind == 1);
                if any(any(ind))
                    out.sig_find(con).match_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).match_neg_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    tempbeta                               = squeeze(out.thrAUC.match_neg.beta(con,:,:,lev));
                    tempteststat                           = squeeze(out.thrAUC.match_neg.test_stat(con,:,:,lev));
                    tempcritval                            = squeeze(out.thrAUC.match_neg.crit_val(con,:,:,lev));
                    tempp                                  = squeeze(out.thrAUC.match_neg.p_2tail(con,:,:,lev));
                    out.sig_find(con).match_neg_thr{2,lev} = [out.sig_find(con).match_neg_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.match_neg.hadNaN(con,ind)',out.thrAUC.match_neg.hadimag(con,ind)',out.thrAUC.match_neg.hadInf(con,ind)'])]];
                    
                    fprintf(sigeffects_fid,'Matching Index (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    for ind_val = 1:length(xind)
                        fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.match_neg.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_neg.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_neg.hadInf(con,xind(ind_val),yind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind                          = logical((squeeze(out.thrAUC.match_pos_nodiscon.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.match_pos_nodiscon.beta(con,:,:,lev))) & squeeze(out.thrAUC.match_pos_nodiscon.beta(con,:,:,lev) ~= 0));
                ind(logical(eye(size(ind)))) = 0;
                [xind,yind]                  = find(ind == 1);
                if any(any(ind))
                    out.sig_find(con).match_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).match_pos_nodiscon_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    tempbeta                                        = squeeze(out.thrAUC.match_pos_nodiscon.beta(con,:,:,lev));
                    tempteststat                                    = squeeze(out.thrAUC.match_pos_nodiscon.test_stat(con,:,:,lev));
                    tempcritval                                     = squeeze(out.thrAUC.match_pos_nodiscon.crit_val(con,:,:,lev));
                    tempp                                           = squeeze(out.thrAUC.match_pos_nodiscon.p_2tail(con,:,:,lev));
                    out.sig_find(con).match_pos_nodiscon_thr{2,lev} = [out.sig_find(con).match_pos_nodiscon_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.match_pos_nodiscon.hadNaN(con,ind)',out.thrAUC.match_pos_nodiscon.hadimag(con,ind)',out.thrAUC.match_pos_nodiscon.hadInf(con,ind)'])]];
                    
                    fprintf(sigeffects_fid,'Matching Index (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    for ind_val = 1:length(xind)
                        fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.match_pos_nodiscon.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_pos_nodiscon.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_pos_nodiscon.hadInf(con,xind(ind_val),yind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind                          = logical((squeeze(out.thrAUC.match_neg_nodiscon.p_2tail(con,:,:,lev)) <= out.alpha) & ~isnan(squeeze(out.thrAUC.match_neg_nodiscon.beta(con,:,:,lev))) & squeeze(out.thrAUC.match_neg_nodiscon.beta(con,:,:,lev) ~= 0));
                    ind(logical(eye(size(ind)))) = 0;
                    [xind,yind]                  = find(ind == 1);
                    if any(any(ind))
                        out.sig_find(con).match_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).match_neg_nodiscon_thr{2,lev} = {'node_1','node_2','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        tempbeta                                        = squeeze(out.thrAUC.match_neg_nodiscon.beta(con,:,:,lev));
                        tempteststat                                    = squeeze(out.thrAUC.match_neg_nodiscon.test_stat(con,:,:,lev));
                        tempcritval                                     = squeeze(out.thrAUC.match_neg_nodiscon.crit_val(con,:,:,lev));
                        tempp                                           = squeeze(out.thrAUC.match_neg_nodiscon.p_2tail(con,:,:,lev));
                        out.sig_find(con).match_neg_nodiscon_thr{2,lev} = [out.sig_find(con).match_neg_nodiscon_thr{2,lev};[out.ROI_labels(xind),out.ROI_labels(yind),num2cell([tempbeta(ind),tempteststat(ind),tempcritval(ind),tempp(ind),out.thrAUC.match_neg_nodiscon.hadNaN(con,ind)',out.thrAUC.match_neg_nodiscon.hadimag(con,ind)',out.thrAUC.match_neg_nodiscon.hadInf(con,ind)'])]];
                        
                        fprintf(sigeffects_fid,'Matching Index (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode_1\ttnode_2\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        for ind_val = 1:length(xind)
                            fprintf(sigeffects_fid,'\t%s\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels(xind(ind_val)),out.ROI_labels(yind(ind_val)),tempbeta(xind(ind_val),yind(ind_val)),tempteststat(xind(ind_val),yind(ind_val)),tempcritval(xind(ind_val),yind(ind_val)),tempp(xind(ind_val),yind(ind_val)),out.thrAUC.match_neg_nodiscon.hadNaN(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_neg_nodiscon.hadimag(con,xind(ind_val),yind(ind_val)),out.thrAUC.match_neg_nodiscon.hadInf(con,xind(ind_val),yind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Node Betweeness Centrality
        if out.test_props_fullmat.node_bet_cent == 1
            ind = logical(out.full.node_bet_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.node_bet_cent_pos.beta(con,:,lev)) & out.full.node_bet_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).node_bet_cent_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).node_bet_cent_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).node_bet_cent_pos_full{2,lev} = [out.sig_find(con).node_bet_cent_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.node_bet_cent_pos.beta(con,ind,lev);out.full.node_bet_cent_pos.test_stat(con,ind,lev);out.full.node_bet_cent_pos.crit_val(con,ind,lev);out.full.node_bet_cent_pos.p_2tail(con,ind,lev);out.full.node_bet_cent_pos.hadNaN(con,ind);out.full.node_bet_cent_pos.hadimag(con,ind);out.full.node_bet_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Node Betweeness Centrality (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.node_bet_cent_pos.beta(con,f_ind(ind_val),lev),out.full.node_bet_cent_pos.test_stat(con,f_ind(ind_val),lev),out.full.node_bet_cent_pos.crit_val(con,f_ind(ind_val),lev),out.full.node_bet_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.full.node_bet_cent_pos.hadNaN(con,f_ind(ind_val)),out.full.node_bet_cent_pos.hadimag(con,f_ind(ind_val)),out.full.node_bet_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.node_bet_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.node_bet_cent_neg.beta(con,:,lev)) & out.full.node_bet_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).node_bet_cent_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).node_bet_cent_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).node_bet_cent_neg_full{2,lev} = [out.sig_find(con).node_bet_cent_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.node_bet_cent_neg.beta(con,ind,lev);out.full.node_bet_cent_neg.test_stat(con,ind,lev);out.full.node_bet_cent_neg.crit_val(con,ind,lev);out.full.node_bet_cent_neg.p_2tail(con,ind,lev);out.full.node_bet_cent_neg.hadNaN(con,ind);out.full.node_bet_cent_neg.hadimag(con,ind);out.full.node_bet_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Node Betweeness Centrality (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.node_bet_cent_neg.beta(con,f_ind(ind_val),lev),out.full.node_bet_cent_neg.test_stat(con,f_ind(ind_val),lev),out.full.node_bet_cent_neg.crit_val(con,f_ind(ind_val),lev),out.full.node_bet_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.full.node_bet_cent_neg.hadNaN(con,f_ind(ind_val)),out.full.node_bet_cent_neg.hadimag(con,f_ind(ind_val)),out.full.node_bet_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.node_bet_cent == 1
            ind = logical(out.thrAUC.node_bet_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.node_bet_cent_pos.beta(con,:,lev)) & out.thrAUC.node_bet_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).node_bet_cent_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).node_bet_cent_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).node_bet_cent_pos_thr{2,lev} = [out.sig_find(con).node_bet_cent_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.node_bet_cent_pos.beta(con,ind,lev);out.thrAUC.node_bet_cent_pos.test_stat(con,ind,lev);out.thrAUC.node_bet_cent_pos.crit_val(con,ind,lev);out.thrAUC.node_bet_cent_pos.p_2tail(con,ind,lev);out.thrAUC.node_bet_cent_pos.hadNaN(con,ind);out.thrAUC.node_bet_cent_pos.hadimag(con,ind);out.thrAUC.node_bet_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Node Betweeness Centrality (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.node_bet_cent_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.node_bet_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.node_bet_cent_neg.beta(con,:,lev)) & out.thrAUC.node_bet_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).node_bet_cent_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).node_bet_cent_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).node_bet_cent_neg_thr{2,lev} = [out.sig_find(con).node_bet_cent_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.node_bet_cent_neg.beta(con,ind,lev);out.thrAUC.node_bet_cent_neg.test_stat(con,ind,lev);out.thrAUC.node_bet_cent_neg.crit_val(con,ind,lev);out.thrAUC.node_bet_cent_neg.p_2tail(con,ind,lev);out.thrAUC.node_bet_cent_neg.hadNaN(con,ind);out.thrAUC.node_bet_cent_neg.hadimag(con,ind);out.thrAUC.node_bet_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Node Betweeness Centrality (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.node_bet_cent_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.node_bet_cent_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.node_bet_cent_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.node_bet_cent_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).node_bet_cent_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).node_bet_cent_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).node_bet_cent_pos_nodiscon_thr{2,lev} = [out.sig_find(con).node_bet_cent_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.node_bet_cent_pos_nodiscon.beta(con,ind,lev);out.thrAUC.node_bet_cent_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.node_bet_cent_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.node_bet_cent_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.node_bet_cent_pos_nodiscon.hadNaN(con,ind);out.thrAUC.node_bet_cent_pos_nodiscon.hadimag(con,ind);out.thrAUC.node_bet_cent_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Node Betweeness Centrality (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.node_bet_cent_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.node_bet_cent_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.node_bet_cent_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.node_bet_cent_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).node_bet_cent_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).node_bet_cent_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).node_bet_cent_neg_nodiscon_thr{2,lev} = [out.sig_find(con).node_bet_cent_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.node_bet_cent_neg_nodiscon.beta(con,ind,lev);out.thrAUC.node_bet_cent_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.node_bet_cent_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.node_bet_cent_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.node_bet_cent_neg_nodiscon.hadNaN(con,ind);out.thrAUC.node_bet_cent_neg_nodiscon.hadimag(con,ind);out.thrAUC.node_bet_cent_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Node Betweeness Centrality (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.node_bet_cent_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.node_bet_cent_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.node_bet_cent_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Pagerank Centrality
        if out.test_props_fullmat.pagerank_cent == 1
            ind = logical(out.full.pagerank_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.pagerank_cent_pos.beta(con,:,lev)) & out.full.pagerank_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).pagerank_cent_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).pagerank_cent_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).pagerank_cent_pos_full{2,lev} = [out.sig_find(con).pagerank_cent_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.pagerank_cent_pos.beta(con,ind,lev);out.full.pagerank_cent_pos.test_stat(con,ind,lev);out.full.pagerank_cent_pos.crit_val(con,ind,lev);out.full.pagerank_cent_pos.p_2tail(con,ind,lev);out.full.pagerank_cent_pos.hadNaN(con,ind);out.full.pagerank_cent_pos.hadimag(con,ind);out.full.pagerank_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Pagerank Centrality (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.pagerank_cent_pos.beta(con,f_ind(ind_val),lev),out.full.pagerank_cent_pos.test_stat(con,f_ind(ind_val),lev),out.full.pagerank_cent_pos.crit_val(con,f_ind(ind_val),lev),out.full.pagerank_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.full.pagerank_cent_pos.hadNaN(con,f_ind(ind_val)),out.full.pagerank_cent_pos.hadimag(con,f_ind(ind_val)),out.full.pagerank_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.pagerank_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.pagerank_cent_neg.beta(con,:,lev)) & out.full.pagerank_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).pagerank_cent_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).pagerank_cent_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).pagerank_cent_neg_full{2,lev} = [out.sig_find(con).pagerank_cent_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.pagerank_cent_neg.beta(con,ind,lev);out.full.pagerank_cent_neg.test_stat(con,ind,lev);out.full.pagerank_cent_neg.crit_val(con,ind,lev);out.full.pagerank_cent_neg.p_2tail(con,ind,lev);out.full.pagerank_cent_neg.hadNaN(con,ind);out.full.pagerank_cent_neg.hadimag(con,ind);out.full.pagerank_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Pagerank Centrality (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.pagerank_cent_neg.beta(con,f_ind(ind_val),lev),out.full.pagerank_cent_neg.test_stat(con,f_ind(ind_val),lev),out.full.pagerank_cent_neg.crit_val(con,f_ind(ind_val),lev),out.full.pagerank_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.full.pagerank_cent_neg.hadNaN(con,f_ind(ind_val)),out.full.pagerank_cent_neg.hadimag(con,f_ind(ind_val)),out.full.pagerank_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.pagerank_cent == 1
            ind = logical(out.thrAUC.pagerank_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.pagerank_cent_pos.beta(con,:,lev)) & out.thrAUC.pagerank_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).pagerank_cent_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).pagerank_cent_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).pagerank_cent_pos_thr{2,lev} = [out.sig_find(con).pagerank_cent_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.pagerank_cent_pos.beta(con,ind,lev);out.thrAUC.pagerank_cent_pos.test_stat(con,ind,lev);out.thrAUC.pagerank_cent_pos.crit_val(con,ind,lev);out.thrAUC.pagerank_cent_pos.p_2tail(con,ind,lev);out.thrAUC.pagerank_cent_pos.hadNaN(con,ind);out.thrAUC.pagerank_cent_pos.hadimag(con,ind);out.thrAUC.pagerank_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Pagerank Centrality (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.pagerank_cent_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.pagerank_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.pagerank_cent_neg.beta(con,:,lev)) & out.thrAUC.pagerank_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).pagerank_cent_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).pagerank_cent_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).pagerank_cent_neg_thr{2,lev} = [out.sig_find(con).pagerank_cent_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.pagerank_cent_neg.beta(con,ind,lev);out.thrAUC.pagerank_cent_neg.test_stat(con,ind,lev);out.thrAUC.pagerank_cent_neg.crit_val(con,ind,lev);out.thrAUC.pagerank_cent_neg.p_2tail(con,ind,lev);out.thrAUC.pagerank_cent_neg.hadNaN(con,ind);out.thrAUC.pagerank_cent_neg.hadimag(con,ind);out.thrAUC.pagerank_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Pagerank Centrality (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.pagerank_cent_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.pagerank_cent_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.pagerank_cent_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.pagerank_cent_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).pagerank_cent_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).pagerank_cent_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).pagerank_cent_pos_nodiscon_thr{2,lev} = [out.sig_find(con).pagerank_cent_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.pagerank_cent_pos_nodiscon.beta(con,ind,lev);out.thrAUC.pagerank_cent_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.pagerank_cent_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.pagerank_cent_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.pagerank_cent_pos_nodiscon.hadNaN(con,ind);out.thrAUC.pagerank_cent_pos_nodiscon.hadimag(con,ind);out.thrAUC.pagerank_cent_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Pagerank Centrality (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.pagerank_cent_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.pagerank_cent_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.pagerank_cent_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.pagerank_cent_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).pagerank_cent_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).pagerank_cent_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).pagerank_cent_neg_nodiscon_thr{2,lev} = [out.sig_find(con).pagerank_cent_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.pagerank_cent_neg_nodiscon.beta(con,ind,lev);out.thrAUC.pagerank_cent_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.pagerank_cent_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.pagerank_cent_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.pagerank_cent_neg_nodiscon.hadNaN(con,ind);out.thrAUC.pagerank_cent_neg_nodiscon.hadimag(con,ind);out.thrAUC.pagerank_cent_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Pagerank Centrality (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.pagerank_cent_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.pagerank_cent_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.pagerank_cent_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Participation Coefficient
        if out.test_props_fullmat.part_coef == 1
            ind = logical(out.full.part_coef_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.part_coef_pos.beta(con,:,lev)) & out.full.part_coef_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).part_coef_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).part_coef_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).part_coef_pos_full{2,lev} = [out.sig_find(con).part_coef_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.part_coef_pos.beta(con,ind,lev);out.full.part_coef_pos.test_stat(con,ind,lev);out.full.part_coef_pos.crit_val(con,ind,lev);out.full.part_coef_pos.p_2tail(con,ind,lev);out.full.part_coef_pos.hadNaN(con,ind);out.full.part_coef_pos.hadimag(con,ind);out.full.part_coef_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Participation Coefficient (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.part_coef_pos.beta(con,f_ind(ind_val),lev),out.full.part_coef_pos.test_stat(con,f_ind(ind_val),lev),out.full.part_coef_pos.crit_val(con,f_ind(ind_val),lev),out.full.part_coef_pos.p_2tail(con,f_ind(ind_val),lev),out.full.part_coef_pos.hadNaN(con,f_ind(ind_val)),out.full.part_coef_pos.hadimag(con,f_ind(ind_val)),out.full.part_coef_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.part_coef_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.part_coef_neg.beta(con,:,lev)) & out.full.part_coef_neg.beta(con,:,lev) ~= 0);
                if any(any(ind))
                    out.sig_find(con).part_coef_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).part_coef_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).part_coef_neg_full{2,lev} = [out.sig_find(con).part_coef_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.part_coef_neg.beta(con,ind,lev);out.full.part_coef_neg.test_stat(con,ind,lev);out.full.part_coef_neg.crit_val(con,ind,lev);out.full.part_coef_neg.p_2tail(con,ind,lev);out.full.part_coef_neg.hadNaN(con,ind);out.full.part_coef_neg.hadimag(con,ind);out.full.part_coef_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Participation Coefficient (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.part_coef_neg.beta(con,f_ind(ind_val),lev),out.full.part_coef_neg.test_stat(con,f_ind(ind_val),lev),out.full.part_coef_neg.crit_val(con,f_ind(ind_val),lev),out.full.part_coef_neg.p_2tail(con,f_ind(ind_val),lev),out.full.part_coef_neg.hadNaN(con,f_ind(ind_val)),out.full.part_coef_neg.hadimag(con,f_ind(ind_val)),out.full.part_coef_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.part_coef == 1
            ind = logical(out.thrAUC.part_coef_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.part_coef_pos.beta(con,:,lev)) & out.thrAUC.part_coef_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).part_coef_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).part_coef_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).part_coef_pos_thr{2,lev} = [out.sig_find(con).part_coef_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.part_coef_pos.beta(con,ind,lev);out.thrAUC.part_coef_pos.test_stat(con,ind,lev);out.thrAUC.part_coef_pos.crit_val(con,ind,lev);out.thrAUC.part_coef_pos.p_2tail(con,ind,lev);out.thrAUC.part_coef_pos.hadNaN(con,ind);out.thrAUC.part_coef_pos.hadimag(con,ind);out.thrAUC.part_coef_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Participation Coefficient (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.part_coef_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.part_coef_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.part_coef_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.part_coef_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.part_coef_neg.beta(con,:,lev)) & out.thrAUC.part_coef_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).part_coef_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).part_coef_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).part_coef_neg_thr{2,lev} = [out.sig_find(con).part_coef_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.part_coef_neg.beta(con,ind,lev);out.thrAUC.part_coef_neg.test_stat(con,ind,lev);out.thrAUC.part_coef_neg.crit_val(con,ind,lev);out.thrAUC.part_coef_neg.p_2tail(con,ind,lev);out.thrAUC.part_coef_neg.hadNaN(con,ind);out.thrAUC.part_coef_neg.hadimag(con,ind);out.thrAUC.part_coef_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Participation Coefficient (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.part_coef_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.part_coef_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.part_coef_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.part_coef_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.part_coef_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.part_coef_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).part_coef_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).part_coef_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).part_coef_pos_nodiscon_thr{2,lev} = [out.sig_find(con).part_coef_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.part_coef_pos_nodiscon.beta(con,ind,lev);out.thrAUC.part_coef_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.part_coef_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.part_coef_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.part_coef_pos_nodiscon.hadNaN(con,ind);out.thrAUC.part_coef_pos_nodiscon.hadimag(con,ind);out.thrAUC.part_coef_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Participation Coefficient (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.part_coef_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.part_coef_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.part_coef_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.part_coef_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.part_coef_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.part_coef_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.part_coef_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).part_coef_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).part_coef_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).part_coef_neg_nodiscon_thr{2,lev} = [out.sig_find(con).part_coef_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.part_coef_neg_nodiscon.beta(con,ind,lev);out.thrAUC.part_coef_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.part_coef_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.part_coef_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.part_coef_neg_nodiscon.hadNaN(con,ind);out.thrAUC.part_coef_neg_nodiscon.hadimag(con,ind);out.thrAUC.part_coef_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Participation Coefficient (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.part_coef_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.part_coef_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.part_coef_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.part_coef_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Rich Club Networks
        if out.test_props_fullmat.rich_club == 1
            ind = find(out.full.rich_club_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.rich_club_pos.beta(con,:,lev)) & out.full.rich_club_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).rich_club_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).rich_club_pos_full{2,lev} = {'node size','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).rich_club_pos_full{2,lev} = [out.sig_find(con).rich_club_pos_full{2,lev};num2cell([ind;out.full.rich_club_pos.beta(con,ind,lev);out.full.rich_club_pos.test_stat(con,ind,lev);out.full.rich_club_pos.crit_val(con,ind,lev);out.full.rich_club_pos.p_2tail(con,ind,lev);out.full.rich_club_pos.hadNaN(con,ind);out.full.rich_club_pos.hadimag(con,ind);out.full.rich_club_pos.hadInf(con,ind)]')];
                
                fprintf(sigeffects_fid,'Rich Club Networks (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode size\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%u\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',ind,out.full.rich_club_pos.beta(con,f_ind(ind_val),lev),out.full.rich_club_pos.test_stat(con,f_ind(ind_val),lev),out.full.rich_club_pos.crit_val(con,f_ind(ind_val),lev),out.full.rich_club_pos.p_2tail(con,f_ind(ind_val),lev),out.full.rich_club_pos.hadNaN(con,f_ind(ind_val)),out.full.rich_club_pos.hadimag(con,f_ind(ind_val)),out.full.rich_club_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = find(out.full.rich_club_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.rich_club_neg.beta(con,:,lev)) & out.full.rich_club_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).rich_club_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).rich_club_neg_full{2,lev} = {'node size','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).rich_club_neg_full{2,lev} = [out.sig_find(con).rich_club_neg_full{2,lev};num2cell([ind;out.full.rich_club_neg.beta(con,ind,lev);out.full.rich_club_neg.test_stat(con,ind,lev);out.full.rich_club_neg.crit_val(con,ind,lev);out.full.rich_club_neg.p_2tail(con,ind,lev);out.full.rich_club_neg.hadNaN(con,ind);out.full.rich_club_neg.hadimag(con,ind);out.full.rich_club_neg.hadInf(con,ind)]')];
                    
                    fprintf(sigeffects_fid,'Rich Club Networks (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode size\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%u\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',ind,out.full.rich_club_neg.beta(con,f_ind(ind_val),lev),out.full.rich_club_neg.test_stat(con,f_ind(ind_val),lev),out.full.rich_club_neg.crit_val(con,f_ind(ind_val),lev),out.full.rich_club_neg.p_2tail(con,f_ind(ind_val),lev),out.full.rich_club_neg.hadNaN(con,f_ind(ind_val)),out.full.rich_club_neg.hadimag(con,f_ind(ind_val)),out.full.rich_club_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.rich_club == 1
            ind = find(out.thrAUC.rich_club_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.rich_club_pos.beta(con,:,lev)) & out.thrAUC.rich_club_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).rich_club_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).rich_club_pos_thr{2,lev} = {'node size','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).rich_club_pos_thr{2,lev} = [out.sig_find(con).rich_club_pos_thr{2,lev};num2cell([ind;out.thrAUC.rich_club_pos.beta(con,ind,lev);out.thrAUC.rich_club_pos.test_stat(con,ind,lev);out.thrAUC.rich_club_pos.crit_val(con,ind,lev);out.thrAUC.rich_club_pos.p_2tail(con,ind,lev);out.thrAUC.rich_club_pos.hadNaN(con,ind);out.thrAUC.rich_club_pos.hadimag(con,ind);out.thrAUC.rich_club_pos.hadInf(con,ind)]')];
                
                fprintf(sigeffects_fid,'Rich Club Networks (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode size\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%u\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',ind,out.thrAUC.rich_club_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.rich_club_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.rich_club_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = find(out.thrAUC.rich_club_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.rich_club_neg.beta(con,:,lev)) & out.thrAUC.rich_club_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).rich_club_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).rich_club_neg_thr{2,lev} = {'node size','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).rich_club_neg_thr{2,lev} = [out.sig_find(con).rich_club_neg_thr{2,lev};num2cell([ind;out.thrAUC.rich_club_neg.beta(con,ind,lev);out.thrAUC.rich_club_neg.test_stat(con,ind,lev);out.thrAUC.rich_club_neg.crit_val(con,ind,lev);out.thrAUC.rich_club_neg.p_2tail(con,ind,lev);out.thrAUC.rich_club_neg.hadNaN(con,ind);out.thrAUC.rich_club_neg.hadimag(con,ind);out.thrAUC.rich_club_neg.hadInf(con,ind)]')];
                    
                    fprintf(sigeffects_fid,'Rich Club Networks (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode size\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%u\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',ind,out.thrAUC.rich_club_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.rich_club_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.rich_club_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = find(out.thrAUC.rich_club_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.rich_club_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.rich_club_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).rich_club_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).rich_club_pos_nodiscon_thr{2,lev} = {'node size','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).rich_club_pos_nodiscon_thr{2,lev} = [out.sig_find(con).rich_club_pos_nodiscon_thr{2,lev};num2cell([ind;out.thrAUC.rich_club_pos_nodiscon.beta(con,ind,lev);out.thrAUC.rich_club_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.rich_club_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.rich_club_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.rich_club_pos_nodiscon.hadNaN(con,ind);out.thrAUC.rich_club_pos_nodiscon.hadimag(con,ind);out.thrAUC.rich_club_pos_nodiscon.hadInf(con,ind)]')];
                    
                    fprintf(sigeffects_fid,'Rich Club Networks (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode size\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%u\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',ind,out.thrAUC.rich_club_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.rich_club_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.rich_club_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.rich_club_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = find(out.thrAUC.rich_club_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.rich_club_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.rich_club_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).rich_club_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).rich_club_neg_nodiscon_thr{2,lev} = {'node size','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).rich_club_neg_nodiscon_thr{2,lev} = [out.sig_find(con).rich_club_neg_nodiscon_thr{2,lev};num2cell([ind;out.thrAUC.rich_club_neg_nodiscon.beta(con,ind,lev);out.thrAUC.rich_club_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.rich_club_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.rich_club_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.rich_club_neg_nodiscon.hadNaN(con,ind);out.thrAUC.rich_club_neg_nodiscon.hadimag(con,ind);out.thrAUC.rich_club_neg_nodiscon.hadInf(con,ind)]')];
                        
                        fprintf(sigeffects_fid,'Rich Club Networks (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode size\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%u\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',ind,out.thrAUC.rich_club_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.rich_club_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.rich_club_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.rich_club_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Node Strength
        if out.test_props_fullmat.strength == 1
            ind = logical(out.full.strength_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.strength_pos.beta(con,:,lev)) & out.full.strength_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).strength_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).strength_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).strength_pos_full{2,lev} = [out.sig_find(con).strength_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.strength_pos.beta(con,ind,lev);out.full.strength_pos.test_stat(con,ind,lev);out.full.strength_pos.crit_val(con,ind,lev);out.full.strength_pos.p_2tail(con,ind,lev);out.full.strength_pos.hadNaN(con,ind);out.full.strength_pos.hadimag(con,ind);out.full.strength_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Strength (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.strength_pos.beta(con,f_ind(ind_val),lev),out.full.strength_pos.test_stat(con,f_ind(ind_val),lev),out.full.strength_pos.crit_val(con,f_ind(ind_val),lev),out.full.strength_pos.p_2tail(con,f_ind(ind_val),lev),out.full.strength_pos.hadNaN(con,f_ind(ind_val)),out.full.strength_pos.hadimag(con,f_ind(ind_val)),out.full.strength_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.full.strength_totpos.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.strength_totpos.beta(con,lev)) && out.full.strength_totpos.beta(con,lev) ~= 0
                out.sig_find(con).strength_totpos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).strength_totpos_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).strength_totpos_full{2,lev} = [out.sig_find(con).strength_totpos_full{2,lev};num2cell([out.full.strength_totpos.beta(con,lev);out.full.strength_totpos.test_stat(con,lev);out.full.strength_totpos.crit_val(con,lev);out.full.strength_totpos.p_2tail(con,lev);out.full.strength_totpos.hadNaN(con);out.full.strength_totpos.hadimag(con);out.full.strength_totpos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Total Strength (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.strength_totpos.beta(con,lev),out.full.strength_totpos.test_stat(con,lev),out.full.strength_totpos.crit_val(con,lev),out.full.strength_totpos.p_2tail(con,lev),out.full.strength_totpos.hadNaN(con),out.full.strength_totpos.hadimag(con),out.full.strength_totpos.hadInf(con));
            end
            if out.use_abs_val == 0
                ind = logical(out.full.strength_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.strength_neg.beta(con,:,lev)) & out.full.strength_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).strength_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).strength_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).strength_neg_full{2,lev} = [out.sig_find(con).strength_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.strength_neg.beta(con,ind,lev);out.full.strength_neg.test_stat(con,ind,lev);out.full.strength_neg.crit_val(con,ind,lev);out.full.strength_neg.p_2tail(con,ind,lev);out.full.strength_neg.hadNaN(con,ind);out.full.strength_neg.hadimag(con,ind);out.full.strength_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Strength (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.strength_neg.beta(con,f_ind(ind_val),lev),out.full.strength_neg.test_stat(con,f_ind(ind_val),lev),out.full.strength_neg.crit_val(con,f_ind(ind_val),lev),out.full.strength_neg.p_2tail(con,f_ind(ind_val),lev),out.full.strength_neg.hadNaN(con,f_ind(ind_val)),out.full.strength_neg.hadimag(con,f_ind(ind_val)),out.full.strength_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.full.strength_totneg.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.strength_totneg.beta(con,lev)) && out.full.strength_totneg.beta(con,lev) ~= 0
                    out.sig_find(con).strength_totneg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).strength_totneg_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).strength_totneg_full{2,lev} = [out.sig_find(con).strength_totneg_full{2,lev};num2cell([out.full.strength_totneg.beta(con,lev);out.full.strength_totneg.test_stat(con,lev);out.full.strength_totneg.crit_val(con,lev);out.full.strength_totneg.p_2tail(con,lev);out.full.strength_totneg.hadNaN(con);out.full.strength_totneg.hadimag(con);out.full.strength_totneg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Total Strength (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.strength_totneg.beta(con,lev),out.full.strength_totneg.test_stat(con,lev),out.full.strength_totneg.crit_val(con,lev),out.full.strength_totneg.p_2tail(con,lev),out.full.strength_totneg.hadNaN(con),out.full.strength_totneg.hadimag(con),out.full.strength_totneg.hadInf(con));
                end
            end
        end
        
        % Small Worldness
        if out.test_props_thrmat.small_world == 1
            if out.thrAUC.small_world_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.small_world_pos.beta(con,lev)) && out.thrAUC.small_world_pos.beta(con,lev) ~= 0
                out.sig_find(con).small_world_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).small_world_pos_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).small_world_pos_thr{2,lev} = [out.sig_find(con).small_world_pos_thr{2,lev};num2cell([out.thrAUC.small_world_pos.beta(con,lev);out.thrAUC.small_world_pos.test_stat(con,lev);out.thrAUC.small_world_pos.crit_val(con,lev);out.thrAUC.small_world_pos.p_2tail(con,lev);out.thrAUC.small_world_pos.hadNaN(con);out.thrAUC.small_world_pos.hadimag(con);out.thrAUC.small_world_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Small Worldness (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.small_world_pos.beta(con,lev),out.thrAUC.small_world_pos.test_stat(con,lev),out.thrAUC.small_world_pos.crit_val(con,lev),out.thrAUC.small_world_pos.p_2tail(con,lev),out.thrAUC.small_world_pos.hadNaN(con),out.thrAUC.small_world_pos.hadimag(con),out.thrAUC.small_world_pos.hadInf(con));
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.thrAUC.small_world_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.small_world_neg.beta(con,lev)) && out.thrAUC.small_world_neg.beta(con,lev) ~= 0
                    out.sig_find(con).small_world_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).small_world_neg_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).small_world_neg_thr{2,lev} = [out.sig_find(con).small_world_neg_thr{2,lev};num2cell([out.thrAUC.small_world_neg.beta(con,lev);out.thrAUC.small_world_neg.test_stat(con,lev);out.thrAUC.small_world_neg.crit_val(con,lev);out.thrAUC.small_world_neg.p_2tail(con,lev);out.thrAUC.small_world_neg.hadNaN(con);out.thrAUC.small_world_neg.hadimag(con);out.thrAUC.small_world_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Small Worldness (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.small_world_neg.beta(con,lev),out.thrAUC.small_world_neg.test_stat(con,lev),out.thrAUC.small_world_neg.crit_val(con,lev),out.thrAUC.small_world_neg.p_2tail(con,lev),out.thrAUC.small_world_neg.hadNaN(con),out.thrAUC.small_world_neg.hadimag(con),out.thrAUC.small_world_neg.hadInf(con));
                end
            end
            if out.calcAUC_nodiscon == 1
                if out.thrAUC.small_world_pos_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.small_world_pos_nodiscon.beta(con,lev)) && out.thrAUC.small_world_pos_nodiscon.beta(con,lev) ~= 0
                    out.sig_find(con).small_world_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).small_world_pos_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).small_world_pos_nodiscon_thr{2,lev} = [out.sig_find(con).small_world_pos_nodiscon_thr{2,lev};num2cell([out.thrAUC.small_world_pos_nodiscon.beta(con,lev);out.thrAUC.small_world_pos_nodiscon.test_stat(con,lev);out.thrAUC.small_world_pos_nodiscon.crit_val(con,lev);out.thrAUC.small_world_pos_nodiscon.p_2tail(con,lev);out.thrAUC.small_world_pos_nodiscon.hadNaN(con);out.thrAUC.small_world_pos_nodiscon.hadimag(con);out.thrAUC.small_world_pos_nodiscon.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Small Worldness (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.small_world_pos_nodiscon.beta(con,lev),out.thrAUC.small_world_pos_nodiscon.test_stat(con,lev),out.thrAUC.small_world_pos_nodiscon.crit_val(con,lev),out.thrAUC.small_world_pos_nodiscon.p_2tail(con,lev),out.thrAUC.small_world_pos_nodiscon.hadNaN(con),out.thrAUC.small_world_pos_nodiscon.hadimag(con),out.thrAUC.small_world_pos_nodiscon.hadInf(con));
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.thrAUC.small_world_neg_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.small_world_neg_nodiscon.beta(con,lev)) && out.thrAUC.small_world_neg_nodiscon.beta(con,lev) ~= 0
                        out.sig_find(con).small_world_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).small_world_neg_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).small_world_neg_nodiscon_thr{2,lev} = [out.sig_find(con).small_world_neg_nodiscon_thr{2,lev};num2cell([out.thrAUC.small_world_neg_nodiscon.beta(con,lev);out.thrAUC.small_world_neg_nodiscon.test_stat(con,lev);out.thrAUC.small_world_neg_nodiscon.crit_val(con,lev);out.thrAUC.small_world_neg_nodiscon.p_2tail(con,lev);out.thrAUC.small_world_neg_nodiscon.hadNaN(con);out.thrAUC.small_world_neg_nodiscon.hadimag(con);out.thrAUC.small_world_neg_nodiscon.hadInf(con)]')];
                        
                        fprintf(sigeffects_fid,'Small Worldness (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.small_world_neg_nodiscon.beta(con,lev),out.thrAUC.small_world_neg_nodiscon.test_stat(con,lev),out.thrAUC.small_world_neg_nodiscon.crit_val(con,lev),out.thrAUC.small_world_neg_nodiscon.p_2tail(con,lev),out.thrAUC.small_world_neg_nodiscon.hadNaN(con),out.thrAUC.small_world_neg_nodiscon.hadimag(con),out.thrAUC.small_world_neg_nodiscon.hadInf(con));
                    end
                end
            end
        end
        
        % Subgraph Centrality
        if out.test_props_thrmat.sub_cent == 1
            ind = logical(out.thrAUC.subgraph_cent_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.subgraph_cent_pos.beta(con,:,lev)) & out.thrAUC.subgraph_cent_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).subgraph_cent_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).subgraph_cent_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).subgraph_cent_pos_thr{2,lev} = [out.sig_find(con).subgraph_cent_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.subgraph_cent_pos.beta(con,ind,lev);out.thrAUC.subgraph_cent_pos.test_stat(con,ind,lev);out.thrAUC.subgraph_cent_pos.crit_val(con,ind,lev);out.thrAUC.subgraph_cent_pos.p_2tail(con,ind,lev);out.thrAUC.subgraph_cent_pos.hadNaN(con,ind);out.thrAUC.subgraph_cent_pos.hadimag(con,ind);out.thrAUC.subgraph_cent_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Subgraph Centrality (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.subgraph_cent_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.subgraph_cent_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.subgraph_cent_neg.beta(con,:,lev)) & out.thrAUC.subgraph_cent_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).subgraph_cent_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).subgraph_cent_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).subgraph_cent_neg_thr{2,lev} = [out.sig_find(con).subgraph_cent_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.subgraph_cent_neg.beta(con,ind,lev);out.thrAUC.subgraph_cent_neg.test_stat(con,ind,lev);out.thrAUC.subgraph_cent_neg.crit_val(con,ind,lev);out.thrAUC.subgraph_cent_neg.p_2tail(con,ind,lev);out.thrAUC.subgraph_cent_neg.hadNaN(con,ind);out.thrAUC.subgraph_cent_neg.hadimag(con,ind);out.thrAUC.subgraph_cent_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Subgraph Centrality (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.subgraph_cent_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.subgraph_cent_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.subgraph_cent_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.subgraph_cent_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).subgraph_cent_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).subgraph_cent_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).subgraph_cent_pos_nodiscon_thr{2,lev} = [out.sig_find(con).subgraph_cent_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.subgraph_cent_pos_nodiscon.beta(con,ind,lev);out.thrAUC.subgraph_cent_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.subgraph_cent_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.subgraph_cent_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.subgraph_cent_pos_nodiscon.hadNaN(con,ind);out.thrAUC.subgraph_cent_pos_nodiscon.hadimag(con,ind);out.thrAUC.subgraph_cent_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Subgraph Centrality (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.subgraph_cent_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.subgraph_cent_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.subgraph_cent_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.subgraph_cent_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).subgraph_cent_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).subgraph_cent_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).subgraph_cent_neg_nodiscon_thr{2,lev} = [out.sig_find(con).subgraph_cent_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.subgraph_cent_neg_nodiscon.beta(con,ind,lev);out.thrAUC.subgraph_cent_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.subgraph_cent_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.subgraph_cent_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.subgraph_cent_neg_nodiscon.hadNaN(con,ind);out.thrAUC.subgraph_cent_neg_nodiscon.hadimag(con,ind);out.thrAUC.subgraph_cent_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Subgraph Centrality (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.subgraph_cent_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.subgraph_cent_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.subgraph_cent_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
        
        % Transitivity
        if out.test_props_fullmat.trans == 1
            if out.full.trans_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.trans_pos.beta(con,lev)) && out.full.trans_pos.beta(con,lev) ~= 0
                out.sig_find(con).trans_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).trans_pos_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).trans_pos_full{2,lev} = [out.sig_find(con).trans_pos_full{2,lev};num2cell([out.full.trans_pos.beta(con,lev);out.full.trans_pos.test_stat(con,lev);out.full.trans_pos.crit_val(con,lev);out.full.trans_pos.p_2tail(con,lev);out.full.trans_pos.hadNaN(con);out.full.trans_pos.hadimag(con);out.full.trans_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Transitivity (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.trans_pos.beta(con,lev),out.full.trans_pos.test_stat(con,lev),out.full.trans_pos.crit_val(con,lev),out.full.trans_pos.p_2tail(con,lev),out.full.trans_pos.hadNaN(con),out.full.trans_pos.hadimag(con),out.full.trans_pos.hadInf(con));
            end
            if out.use_abs_val == 0
                if out.full.trans_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.full.trans_neg.beta(con,lev)) && out.full.trans_neg.beta(con,lev) ~= 0
                    out.sig_find(con).trans_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).trans_neg_full{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).trans_neg_full{2,lev} = [out.sig_find(con).trans_neg_full{2,lev};num2cell([out.full.trans_neg.beta(con,lev);out.full.trans_neg.test_stat(con,lev);out.full.trans_neg.crit_val(con,lev);out.full.trans_neg.p_2tail(con,lev);out.full.trans_neg.hadNaN(con);out.full.trans_neg.hadimag(con);out.full.trans_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Transitivity (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.full.trans_neg.beta(con,lev),out.full.trans_neg.test_stat(con,lev),out.full.trans_neg.crit_val(con,lev),out.full.trans_neg.p_2tail(con,lev),out.full.trans_neg.hadNaN(con),out.full.trans_neg.hadimag(con),out.full.trans_neg.hadInf(con));
                end
            end
        end
        if out.test_props_thrmat.trans == 1
            if out.thrAUC.trans_pos.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.trans_pos.beta(con,lev)) && out.thrAUC.trans_pos.beta(con,lev) ~= 0
                out.sig_find(con).trans_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).trans_pos_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).trans_pos_thr{2,lev} = [out.sig_find(con).trans_pos_thr{2,lev};num2cell([out.thrAUC.trans_pos.beta(con,lev);out.thrAUC.trans_pos.test_stat(con,lev);out.thrAUC.trans_pos.crit_val(con,lev);out.thrAUC.trans_pos.p_2tail(con,lev);out.thrAUC.trans_pos.hadNaN(con);out.thrAUC.trans_pos.hadimag(con);out.thrAUC.trans_pos.hadInf(con)]')];
                
                fprintf(sigeffects_fid,'Transitivity (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.trans_pos.beta(con,lev),out.thrAUC.trans_pos.test_stat(con,lev),out.thrAUC.trans_pos.crit_val(con,lev),out.thrAUC.trans_pos.p_2tail(con,lev),out.thrAUC.trans_pos.hadNaN(con),out.thrAUC.trans_pos.hadimag(con),out.thrAUC.trans_pos.hadInf(con));
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                if out.thrAUC.trans_neg.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.trans_neg.beta(con,lev)) && out.thrAUC.trans_neg.beta(con,lev) ~= 0
                    out.sig_find(con).trans_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).trans_neg_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).trans_neg_thr{2,lev} = [out.sig_find(con).trans_neg_thr{2,lev};num2cell([out.thrAUC.trans_neg.beta(con,lev);out.thrAUC.trans_neg.test_stat(con,lev);out.thrAUC.trans_neg.crit_val(con,lev);out.thrAUC.trans_neg.p_2tail(con,lev);out.thrAUC.trans_neg.hadNaN(con);out.thrAUC.trans_neg.hadimag(con);out.thrAUC.trans_neg.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Transitivity (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.trans_neg.beta(con,lev),out.thrAUC.trans_neg.test_stat(con,lev),out.thrAUC.trans_neg.crit_val(con,lev),out.thrAUC.trans_neg.p_2tail(con,lev),out.thrAUC.trans_neg.hadNaN(con),out.thrAUC.trans_neg.hadimag(con),out.thrAUC.trans_neg.hadInf(con));
                end
            end
            if out.calcAUC_nodiscon == 1
                if out.thrAUC.trans_pos_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.trans_pos_nodiscon.beta(con,lev)) && out.thrAUC.trans_pos_nodiscon.beta(con,lev) ~= 0
                    out.sig_find(con).trans_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).trans_pos_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).trans_pos_nodiscon_thr{2,lev} = [out.sig_find(con).trans_pos_nodiscon_thr{2,lev};num2cell([out.thrAUC.trans_pos_nodiscon.beta(con,lev);out.thrAUC.trans_pos_nodiscon.test_stat(con,lev);out.thrAUC.trans_pos_nodiscon.crit_val(con,lev);out.thrAUC.trans_pos_nodiscon.p_2tail(con,lev);out.thrAUC.trans_pos_nodiscon.hadNaN(con);out.thrAUC.trans_pos_nodiscon.hadimag(con);out.thrAUC.trans_pos_nodiscon.hadInf(con)]')];
                    
                    fprintf(sigeffects_fid,'Transitivity (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.trans_pos_nodiscon.beta(con,lev),out.thrAUC.trans_pos_nodiscon.test_stat(con,lev),out.thrAUC.trans_pos_nodiscon.crit_val(con,lev),out.thrAUC.trans_pos_nodiscon.p_2tail(con,lev),out.thrAUC.trans_pos_nodiscon.hadNaN(con),out.thrAUC.trans_pos_nodiscon.hadimag(con),out.thrAUC.trans_pos_nodiscon.hadInf(con));
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    if out.thrAUC.trans_neg_nodiscon.p_2tail(con,lev) <= out.alpha && ~isnan(out.thrAUC.trans_neg_nodiscon.beta(con,lev)) && out.thrAUC.trans_neg_nodiscon.beta(con,lev) ~= 0
                        out.sig_find(con).trans_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).trans_neg_nodiscon_thr{2,lev} = {'beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).trans_neg_nodiscon_thr{2,lev} = [out.sig_find(con).trans_neg_nodiscon_thr{2,lev};num2cell([out.thrAUC.trans_neg_nodiscon.beta(con,lev);out.thrAUC.trans_neg_nodiscon.test_stat(con,lev);out.thrAUC.trans_neg_nodiscon.crit_val(con,lev);out.thrAUC.trans_neg_nodiscon.p_2tail(con,lev);out.thrAUC.trans_neg_nodiscon.hadNaN(con);out.thrAUC.trans_neg_nodiscon.hadimag(con);out.thrAUC.trans_neg_nodiscon.hadInf(con)]')];
                        
                        fprintf(sigeffects_fid,'Transitivity (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        fprintf(sigeffects_fid,'\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n\n',out.thrAUC.trans_neg_nodiscon.beta(con,lev),out.thrAUC.trans_neg_nodiscon.test_stat(con,lev),out.thrAUC.trans_neg_nodiscon.crit_val(con,lev),out.thrAUC.trans_neg_nodiscon.p_2tail(con,lev),out.thrAUC.trans_neg_nodiscon.hadNaN(con),out.thrAUC.trans_neg_nodiscon.hadimag(con),out.thrAUC.trans_neg_nodiscon.hadInf(con));
                    end
                end
            end
        end
        
        % Within Module Degree Z-Score
        if out.test_props_fullmat.mod_deg_z == 1
            ind = logical(out.full.mod_deg_z_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.mod_deg_z_pos.beta(con,:,lev)) & out.full.mod_deg_z_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).mod_deg_z_pos_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).mod_deg_z_pos_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).mod_deg_z_pos_full{2,lev} = [out.sig_find(con).mod_deg_z_pos_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.mod_deg_z_pos.beta(con,ind,lev);out.full.mod_deg_z_pos.test_stat(con,ind,lev);out.full.mod_deg_z_pos.crit_val(con,ind,lev);out.full.mod_deg_z_pos.p_2tail(con,ind,lev);out.full.mod_deg_z_pos.hadNaN(con,ind);out.full.mod_deg_z_pos.hadimag(con,ind);out.full.mod_deg_z_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Within-Module Degree Z-Score (full matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.mod_deg_z_pos.beta(con,f_ind(ind_val),lev),out.full.mod_deg_z_pos.test_stat(con,f_ind(ind_val),lev),out.full.mod_deg_z_pos.crit_val(con,f_ind(ind_val),lev),out.full.mod_deg_z_pos.p_2tail(con,f_ind(ind_val),lev),out.full.mod_deg_z_pos.hadNaN(con,f_ind(ind_val)),out.full.mod_deg_z_pos.hadimag(con,f_ind(ind_val)),out.full.mod_deg_z_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0
                ind = logical(out.full.mod_deg_z_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.full.mod_deg_z_neg.beta(con,:,lev)) & out.full.mod_deg_z_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).mod_deg_z_neg_full{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).mod_deg_z_neg_full{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).mod_deg_z_neg_full{2,lev} = [out.sig_find(con).mod_deg_z_neg_full{2,lev};[out.ROI_labels(ind),num2cell([out.full.mod_deg_z_neg.beta(con,ind,lev);out.full.mod_deg_z_neg.test_stat(con,ind,lev);out.full.mod_deg_z_neg.crit_val(con,ind,lev);out.full.mod_deg_z_neg.p_2tail(con,ind,lev);out.full.mod_deg_z_neg.hadNaN(con,ind);out.full.mod_deg_z_neg.hadimag(con,ind);out.full.mod_deg_z_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Within-Module Degree Z-Score (full matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.full.mod_deg_z_neg.beta(con,f_ind(ind_val),lev),out.full.mod_deg_z_neg.test_stat(con,f_ind(ind_val),lev),out.full.mod_deg_z_neg.crit_val(con,f_ind(ind_val),lev),out.full.mod_deg_z_neg.p_2tail(con,f_ind(ind_val),lev),out.full.mod_deg_z_neg.hadNaN(con,f_ind(ind_val)),out.full.mod_deg_z_neg.hadimag(con,f_ind(ind_val)),out.full.mod_deg_z_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
        end
        if out.test_props_thrmat.mod_deg_z == 1
            ind = logical(out.thrAUC.mod_deg_z_pos.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.mod_deg_z_pos.beta(con,:,lev)) & out.thrAUC.mod_deg_z_pos.beta(con,:,lev) ~= 0);
            if any(ind)
                out.sig_find(con).mod_deg_z_pos_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                out.sig_find(con).mod_deg_z_pos_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                out.sig_find(con).mod_deg_z_pos_thr{2,lev} = [out.sig_find(con).mod_deg_z_pos_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.mod_deg_z_pos.beta(con,ind,lev);out.thrAUC.mod_deg_z_pos.test_stat(con,ind,lev);out.thrAUC.mod_deg_z_pos.crit_val(con,ind,lev);out.thrAUC.mod_deg_z_pos.p_2tail(con,ind,lev);out.thrAUC.mod_deg_z_pos.hadNaN(con,ind);out.thrAUC.mod_deg_z_pos.hadimag(con,ind);out.thrAUC.mod_deg_z_pos.hadInf(con,ind)]')]];
                
                fprintf(sigeffects_fid,'Within-Module Degree Z-Score (thresholded matrices, positive weights):\n');
                fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                f_ind = find(ind);
                for ind_val = 1:length(f_ind)
                    fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.mod_deg_z_pos.beta(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos.test_stat(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos.crit_val(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos.hadNaN(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_pos.hadimag(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_pos.hadInf(con,f_ind(ind_val)));
                end
                fprintf(sigeffects_fid,'\n');
            end
            if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                ind = logical(out.thrAUC.mod_deg_z_neg.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.mod_deg_z_neg.beta(con,:,lev)) & out.thrAUC.mod_deg_z_neg.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).mod_deg_z_neg_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).mod_deg_z_neg_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).mod_deg_z_neg_thr{2,lev} = [out.sig_find(con).mod_deg_z_neg_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.mod_deg_z_neg.beta(con,ind,lev);out.thrAUC.mod_deg_z_neg.test_stat(con,ind,lev);out.thrAUC.mod_deg_z_neg.crit_val(con,ind,lev);out.thrAUC.mod_deg_z_neg.p_2tail(con,ind,lev);out.thrAUC.mod_deg_z_neg.hadNaN(con,ind);out.thrAUC.mod_deg_z_neg.hadimag(con,ind);out.thrAUC.mod_deg_z_neg.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Within-Module Degree Z-Score (thresholded matrices, negative weights):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.mod_deg_z_neg.beta(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg.test_stat(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg.crit_val(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg.hadNaN(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_neg.hadimag(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_neg.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
            end
            if out.calcAUC_nodiscon == 1
                ind = logical(out.thrAUC.mod_deg_z_pos_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.mod_deg_z_pos_nodiscon.beta(con,:,lev)) & out.thrAUC.mod_deg_z_pos_nodiscon.beta(con,:,lev) ~= 0);
                if any(ind)
                    out.sig_find(con).mod_deg_z_pos_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                    out.sig_find(con).mod_deg_z_pos_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                    out.sig_find(con).mod_deg_z_pos_nodiscon_thr{2,lev} = [out.sig_find(con).mod_deg_z_pos_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.mod_deg_z_pos_nodiscon.beta(con,ind,lev);out.thrAUC.mod_deg_z_pos_nodiscon.test_stat(con,ind,lev);out.thrAUC.mod_deg_z_pos_nodiscon.crit_val(con,ind,lev);out.thrAUC.mod_deg_z_pos_nodiscon.p_2tail(con,ind,lev);out.thrAUC.mod_deg_z_pos_nodiscon.hadNaN(con,ind);out.thrAUC.mod_deg_z_pos_nodiscon.hadimag(con,ind);out.thrAUC.mod_deg_z_pos_nodiscon.hadInf(con,ind)]')]];
                    
                    fprintf(sigeffects_fid,'Within-Module Degree Z-Score (thresholded matrices, positive weights, excluding disconnected matrices in AUC):\n');
                    fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                    f_ind = find(ind);
                    for ind_val = 1:length(f_ind)
                        fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.mod_deg_z_pos_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_pos_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_pos_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_pos_nodiscon.hadInf(con,f_ind(ind_val)));
                    end
                    fprintf(sigeffects_fid,'\n');
                end
                if out.use_abs_val == 0 && out.neg_mindens_nan == 0
                    ind = logical(out.thrAUC.mod_deg_z_neg_nodiscon.p_2tail(con,:,lev) <= out.alpha & ~isnan(out.thrAUC.mod_deg_z_neg_nodiscon.beta(con,:,lev)) & out.thrAUC.mod_deg_z_neg_nodiscon.beta(con,:,lev) ~= 0);
                    if any(ind)
                        out.sig_find(con).mod_deg_z_neg_nodiscon_thr{1,lev} = ['Contrast/F-test #',num2str(con)];
                        out.sig_find(con).mod_deg_z_neg_nodiscon_thr{2,lev} = {'node','beta','stat','crit_val','p','had NaN','had imag','had Inf'};
                        out.sig_find(con).mod_deg_z_neg_nodiscon_thr{2,lev} = [out.sig_find(con).mod_deg_z_neg_nodiscon_thr{2,lev};[out.ROI_labels(ind),num2cell([out.thrAUC.mod_deg_z_neg_nodiscon.beta(con,ind,lev);out.thrAUC.mod_deg_z_neg_nodiscon.test_stat(con,ind,lev);out.thrAUC.mod_deg_z_neg_nodiscon.crit_val(con,ind,lev);out.thrAUC.mod_deg_z_neg_nodiscon.p_2tail(con,ind,lev);out.thrAUC.mod_deg_z_neg_nodiscon.hadNaN(con,ind);out.thrAUC.mod_deg_z_neg_nodiscon.hadimag(con,ind);out.thrAUC.mod_deg_z_neg_nodiscon.hadInf(con,ind)]')]];
                        
                        fprintf(sigeffects_fid,'Within-Module Degree Z-Score (thresholded matrices, negative weights, excluding disconnected matrices in AUC):\n');
                        fprintf(sigeffects_fid,'\tnode\tbeta\tstat\tcrit_val\tp\thad NaN\thad imag\thad Inf\n');
                        f_ind = find(ind);
                        for ind_val = 1:length(f_ind)
                            fprintf(sigeffects_fid,'\t%s\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%u\t%u\t%u\n',out.ROI_labels{f_ind(ind_val)},out.thrAUC.mod_deg_z_neg_nodiscon.beta(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg_nodiscon.test_stat(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg_nodiscon.crit_val(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg_nodiscon.p_2tail(con,f_ind(ind_val),lev),out.thrAUC.mod_deg_z_neg_nodiscon.hadNaN(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_neg_nodiscon.hadimag(con,f_ind(ind_val)),out.thrAUC.mod_deg_z_neg_nodiscon.hadInf(con,f_ind(ind_val)));
                        end
                        fprintf(sigeffects_fid,'\n');
                    end
                end
            end
        end
    end
end

if use_parfor
    try
        parpool close
    catch %#ok<*CTCH>
        matlabpool close
    end
end

fclose(sigeffects_fid);
save(out.outname,'out')
fprintf('Done running permutation analyses!!!\n\n')
set(handles.Start_pushbutton,'enable','on');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Calculate GLM & significance based on permutations
function [beta,test_stat,crit_val,p_1tail,p_2tail,hadNaN,hadimag,hadInf] = GTG_GLM(DV,full_desmat,covars_desmat,Contrast_or_F,perms,reg_type,use_parfor,within_perms,alpha)

if size(DV,2) > size(DV,1)
    DV = DV';
end
if any(isnan(DV(:)))
    hadNaN = 1;
else
    hadNaN = 0;
end
if any(imag(DV(:))~=0)
    hadimag = 1;
else
    hadimag = 0;
end
if any(isinf(DV(:)))
    hadInf                           = 1;
    DV(isinf(DV) & (sign(DV) == 1))  = max(DV(~isinf(DV)));
    DV(isinf(DV) & (sign(DV) == -1)) = min(DV(~isinf(DV)));
else
    hadInf = 0;
end

if strcmp(Contrast_or_F,'Contrasts')
    if size(DV,2) == 1
        if strcmp(reg_type,'OLS')
            temp      = regstats(DV,full_desmat,eye(size(full_desmat,2)),{'tstat'});
            beta      = temp.tstat.beta(1);
            test_stat = temp.tstat.t(1);
            permdis   = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'OLS',use_parfor);
        else
            [rob_b,rob_stats] = robustfit_iterincrease(full_desmat,DV,'bisquare',4.685,'off');
            beta              = rob_b(1);
            test_stat         = rob_stats.t(1);
            permdis           = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'Robust',use_parfor);
        end
        if sign(test_stat) == 1
            crit_val = permdis(round((1-alpha)*length(permdis)));
            p_1tail  = sum(permdis >= test_stat)/length(permdis);
            p_2tail  = sum(permdis <= -test_stat)/length(permdis)+p_1tail;
        else
            crit_val = permdis(round(alpha*length(permdis)));
            p_1tail  = sum(permdis <= test_stat)/length(permdis);
            p_2tail  = sum(permdis >= -test_stat)/length(permdis)+p_1tail;
        end
    else
        K = eye(size(full_desmat,2));
        % Set M matrices, which specify what to do with the multiple DVs
        switch size(DV,2)
            case 2                             % 2 levels
                M(:,1) = [1;1]./norm([1;1]);   % Orthonormal M Matrix for b/t effects
                M(:,2) = [-1;1]./norm([-1;1]); % Orthonormal M Matrix for w/in linear effects
            case 3                                 % 3 levels
                M(:,1) = [1;1;1]./norm([1;1;1]);   % Orthonormal M Matrix for b/t effects
                M(:,2) = [-1;0;1]./norm([-1;0;1]); % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [1;-2;1]./norm([1;-2;1]); % Orthonormal M Matrix for w/in quadratic effects
            case 4                                       % 4 levels
                M(:,1) = [1;1;1;1]./norm([1;1;1;1]);     % Orthonormal M Matrix for b/t effects
                M(:,2) = [-3;-1;1;3]./norm([-3;-1;1;3]); % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [1;-1;-1;1]./norm([1;-1;-1;1]); % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-1;3;-3;1]./norm([-1;3;-3;1]); % Orthonormal M Matrix for w/in cubic effects
            case 5                                             % 5 levels
                M(:,1) = [1;1;1;1;1]./norm([1;1;1;1;1]);       % Orthonormal M Matrix for b/t effects
                M(:,2) = [-2;-1;0;1;2]./norm([-2;-1;0;1;2]);   % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [2;-1;-2;-1;2]./norm([2;-1;-2;-1;2]); % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-1;2;0;-2;1]./norm([-1;2;0;-2;1]);   % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [1;-4;6;-4;1]./norm([1;-4;6;-4;1]);   % Orthonormal M Matrix for w/in quartic effects
            case 6                                                     % 6 levels
                M(:,1) = [1;1;1;1;1;1]./norm([1;1;1;1;1;1]);           % Orthonormal M Matrix for b/t effects
                M(:,2) = [-5;-3;-1;1;3;5]./norm([-5;-3;-1;1;3;5]);     % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [5;-1;-4;-4;-1;5]./norm([5;-1;-4;-4;-1;5]);   % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-5;7;4;-4;-7;5]./norm([-5;7;4;-4;-7;5]);     % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [1;-3;2;2;-3;1]./norm([1;-3;2;2;-3;1]);       % Orthonormal M Matrix for w/in quartic effects
                M(:,6) = [-1;5;-10;10;-5;1]./norm([-1;5;-10;10;-5;1]); % Orthonormal M Matrix for w/in quintic effects
            case 7                                                           % 7 levels
                M(:,1) = [1;1;1;1;1;1;1]./norm([1;1;1;1;1;1;1]);             % Orthonormal M Matrix for b/t effects
                M(:,2) = [-3;-2;-1;0;1;2;3]./norm([-3;-2;-1;0;1;2;3]);       % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [5;0;-3;-4;-3;0;5]./norm([5;0;-3;-4;-3;0;5]);       % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-1;1;1;0;-1;-1;1]./norm([-1;1;1;0;-1;-1;1]);       % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [3;-7;1;6;1;-7;3]./norm([3;-7;1;6;1;-7;3]);         % Orthonormal M Matrix for w/in quartic effects
                M(:,6) = [-1;4;-5;0;5;-4;1]./norm([-1;4;-5;0;5;-4;1]);       % Orthonormal M Matrix for w/in quintic effects
                M(:,7) = [1;-6;15;-20;15;-6;1]./norm([1;-6;15;-20;15;-6;1]); % Orthonormal M Matrix for w/in sextic effects
            case 8
                M(:,1) = [1;1;1;1;1;1;1;1]./norm([1;1;1;1;1;1;1]);               % Orthonormal M Matrix for b/t effects
                M(:,2) = [-7;-5;-3;-1;1;3;5;7]./norm([-7;-5;-3;-1;1;3;5;7]);     % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [7;1;-3;-5;-5;-3;1;7]./norm([7;1;-3;-5;-5;-3;1;7]);     % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-7;5;7;3;-3;-7;-5;7]./norm([-7;5;7;3;-3;-7;-5;7]);     % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [7;-13;-3;9;9;-3;-13;7]./norm([7;-13;-3;9;9;-3;-13;7]); % Orthonormal M Matrix for w/in quartic effects
                M(:,6) = [-150;492;-364;-321;321;364;-492;150]./norm([-150;492;-364;-321;321;364;-492;150]);       % Orthonormal M Matrix for w/in quintic effects
                M(:,7) = [31;-154;277;-154;-154;277;-154;31]./norm([31;-154;277;-154;-154;277;-154;31]); % Orthonormal M Matrix for w/in sextic effects
                M(:,8) = [-17;119;-358;597;-597;358;-119;17]./norm([-17;119;-358;597;-597;358;-119;17]); % Orthonormal M Matrix for w/in septic effects
        end
        
        dof_error = size(full_desmat,1)-size(full_desmat,2)-1;                         % Degrees of freedom for the error
        
        % Estimate beta matrix
        B = (full_desmat'*full_desmat)\full_desmat'*DV;
        beta = M*B(1,:)';
        test_stat = zeros(size(M,2),1);
        crit_val  = zeros(size(M,2),1);
        p_1tail   = zeros(size(M,2),1);
        p_2tail   = zeros(size(M,2),1);
        
        for con = 1:size(M,2)
            H              = M(:,con)'*(K(1,:)*B)'/(K(1,:)/(full_desmat'*full_desmat)*K(1,:)')*(K(1,:)*B)*M(:,con); % Estimate hypothesis matrix
            E              = M(:,con)'*(DV'*DV-B'*(full_desmat'*full_desmat)*B)*M(:,con); % Estimate error matrix
            test_stat(con) = H/(E/dof_error);                                         % Calculate F
            permdis        = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'~',use_parfor,within_perms,M(:,con));
            
            if sign(test_stat(con)) == 1
                crit_val(con) = permdis(round((1-alpha)*length(permdis)));
                p_1tail(con)  = sum(permdis >= test_stat(con))/length(permdis);
                p_2tail(con)  = sum(permdis <= -test_stat(con))/length(permdis)+p_1tail(con);
            else
                crit_val(con) = permdis(round(alpha*length(permdis)));
                p_1tail(con)  = sum(permdis <= test_stat(con))/length(permdis);
                p_2tail(con)  = sum(permdis >= -test_stat(con))/length(permdis)+p_1tail(con);
            end
        end
        if size(M,2) > 2
            beta                   = [beta;sum(abs(beta(2:end)))];
            H                      = M(:,2:end)'*(K(1,:)*B)'/(K(1,:)/(full_desmat'*full_desmat)*K(1,:)')*(K(1,:)*B)*M(:,2:end); % Estimate hypothesis matrix
            E                      = M(:,2:end)'*(DV'*DV-B'*(full_desmat'*full_desmat)*B)*M(:,2:end); % Estimate error matrix
            test_stat(size(M,2)+1) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
            permdis                = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'~',use_parfor,within_perms,M(:,2:end));
            
            if sign(test_stat(size(M,2)+1)) == 1
                crit_val(size(M,2)+1) = permdis(round((1-alpha)*length(permdis)));
                p_1tail(size(M,2)+1)  = sum(permdis >= test_stat(size(M,2)+1))/length(permdis);
                p_2tail(size(M,2)+1)  = sum(permdis <= -test_stat(size(M,2)+1))/length(permdis)+p_1tail(size(M,2)+1);
            else
                crit_val(size(M,2)+1) = permdis(round(alpha*length(permdis)));
                p_1tail(size(M,2)+1)  = sum(permdis <= test_stat(size(M,2)+1))/length(permdis);
                p_2tail(size(M,2)+1)  = sum(permdis >= -test_stat(size(M,2)+1))/length(permdis)+p_1tail(size(M,2)+1);
            end
        end
    end
else
    num_preds_in_F = size(full_desmat,2)-size(covars_desmat,2);
    if size(DV,2) == 1
        if isempty(covars_desmat)
            if strcmp(reg_type,'OLS')
                temp           = regstats(DV,full_desmat,eye(size(full_desmat,2)),{'beta','fstat'});
                beta           = sum(abs(temp.beta(1:num_preds_in_F)));
                test_stat      = temp.fstat(1);
                permdis        = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'OLS',use_parfor);
            else
                [rob_b,rob_stats] = robustfit_iterincrease(full_desmat,DV,'bisquare',4.685,'off');
                beta              = sum(abs(rob_b(1:num_preds_in_F)));
                Rsq               = 1-(corr(DV,rob_stats.resid))^2;
                test_stat         = ((Rsq)*(size(full_desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                permdis           = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'Robust',use_parfor);
            end
        else
            if strcmp(reg_type,'OLS')
                temp           = regstats(DV,full_desmat,eye(size(full_desmat,2)),{'beta','rsquare'});
                beta           = sum(abs(temp.beta(1:num_preds_in_F)));
                Rsq_full       = temp.rsquare(1);
                temp           = regstats(DV,covars_desmat,eye(size(covars_desmat,2)),{'rsquare'});
                Rsq_redu       = temp.rsquare(1);
                test_stat      = ((Rsq_full-Rsq_redu)*(size(full_desmat,1)-size(full_desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                permdis        = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'OLS',use_parfor);
            else
                [rob_b,rob_stats] = robustfit_iterincrease(full_desmat,DV,'bisquare',4.685,'off');
                beta              = sum(abs(rob_b(1:num_preds_in_F)));
                Rsq_full          = 1-(corr(DV,rob_stats.resid))^2;
                [~,rob_stats]     = robustfit_iterincrease(covars_desmat,DV,'bisquare',4.685,'off');
                Rsq_redu          = 1-(corr(DV,rob_stats.resid))^2;
                test_stat         = ((Rsq_full-Rsq_redu)*(size(full_desmat,1)-size(full_desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                permdis           = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'Robust',use_parfor);
            end
        end
        if sign(test_stat) == 1
            crit_val = permdis(round((1-alpha)*length(permdis)));
            p_1tail  = sum(permdis >= test_stat)/length(permdis);
            p_2tail  = sum(permdis <= -test_stat)/length(permdis)+p_1tail;
        else
            crit_val = permdis(round(alpha*length(permdis)));
            p_1tail  = sum(permdis <= test_stat)/length(permdis);
            p_2tail  = sum(permdis >= -test_stat)/length(permdis)+p_1tail;
        end
    else
        K = eye(size(full_desmat,2));
        % Set M matrices, which specify what to do with the multiple DVs
        switch size(DV,2)
            case 2                             % 2 levels
                M(:,1) = [1;1]./norm([1;1]);   % Orthonormal M Matrix for b/t effects
                M(:,2) = [-1;1]./norm([-1;1]); % Orthonormal M Matrix for w/in linear effects
            case 3                                 % 3 levels
                M(:,1) = [1;1;1]./norm([1;1;1]);   % Orthonormal M Matrix for b/t effects
                M(:,2) = [-1;0;1]./norm([-1;0;1]); % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [1;-2;1]./norm([1;-2;1]); % Orthonormal M Matrix for w/in quadratic effects
            case 4                                       % 4 levels
                M(:,1) = [1;1;1;1]./norm([1;1;1;1]);     % Orthonormal M Matrix for b/t effects
                M(:,2) = [-3;-1;1;3]./norm([-3;-1;1;3]); % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [1;-1;-1;1]./norm([1;-1;-1;1]); % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-1;3;-3;1]./norm([-1;3;-3;1]); % Orthonormal M Matrix for w/in cubic effects
            case 5                                             % 5 levels
                M(:,1) = [1;1;1;1;1]./norm([1;1;1;1;1]);       % Orthonormal M Matrix for b/t effects
                M(:,2) = [-2;-1;0;1;2]./norm([-2;-1;0;1;2]);   % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [2;-1;-2;-1;2]./norm([2;-1;-2;-1;2]); % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-1;2;0;-2;1]./norm([-1;2;0;-2;1]);   % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [1;-4;6;-4;1]./norm([1;-4;6;-4;1]);   % Orthonormal M Matrix for w/in quartic effects
            case 6                                                     % 6 levels
                M(:,1) = [1;1;1;1;1;1]./norm([1;1;1;1;1;1]);           % Orthonormal M Matrix for b/t effects
                M(:,2) = [-5;-3;-1;1;3;5]./norm([-5;-3;-1;1;3;5]);     % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [5;-1;-4;-4;-1;5]./norm([5;-1;-4;-4;-1;5]);   % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-5;7;4;-4;-7;5]./norm([-5;7;4;-4;-7;5]);     % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [1;-3;2;2;-3;1]./norm([1;-3;2;2;-3;1]);       % Orthonormal M Matrix for w/in quartic effects
                M(:,6) = [-1;5;-10;10;-5;1]./norm([-1;5;-10;10;-5;1]); % Orthonormal M Matrix for w/in quintic effects
            case 7                                                           % 7 levels
                M(:,1) = [1;1;1;1;1;1;1]./norm([1;1;1;1;1;1;1]);             % Orthonormal M Matrix for b/t effects
                M(:,2) = [-3;-2;-1;0;1;2;3]./norm([-3;-2;-1;0;1;2;3]);       % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [5;0;-3;-4;-3;0;5]./norm([5;0;-3;-4;-3;0;5]);       % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-1;1;1;0;-1;-1;1]./norm([-1;1;1;0;-1;-1;1]);       % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [3;-7;1;6;1;-7;3]./norm([3;-7;1;6;1;-7;3]);         % Orthonormal M Matrix for w/in quartic effects
                M(:,6) = [-1;4;-5;0;5;-4;1]./norm([-1;4;-5;0;5;-4;1]);       % Orthonormal M Matrix for w/in quintic effects
                M(:,7) = [1;-6;15;-20;15;-6;1]./norm([1;-6;15;-20;15;-6;1]); % Orthonormal M Matrix for w/in sextic effects
            case 8
                M(:,1) = [1;1;1;1;1;1;1;1]./norm([1;1;1;1;1;1;1]);                                           % Orthonormal M Matrix for b/t effects
                M(:,2) = [-7;-5;-3;-1;1;3;5;7]./norm([-7;-5;-3;-1;1;3;5;7]);                                 % Orthonormal M Matrix for w/in linear effects
                M(:,3) = [7;1;-3;-5;-5;-3;1;7]./norm([7;1;-3;-5;-5;-3;1;7]);                                 % Orthonormal M Matrix for w/in quadratic effects
                M(:,4) = [-7;5;7;3;-3;-7;-5;7]./norm([-7;5;7;3;-3;-7;-5;7]);                                 % Orthonormal M Matrix for w/in cubic effects
                M(:,5) = [7;-13;-3;9;9;-3;-13;7]./norm([7;-13;-3;9;9;-3;-13;7]);                             % Orthonormal M Matrix for w/in quartic effects
                M(:,6) = [-150;492;-364;-321;321;364;-492;150]./norm([-150;492;-364;-321;321;364;-492;150]); % Orthonormal M Matrix for w/in quintic effects
                M(:,7) = [31;-154;277;-154;-154;277;-154;31]./norm([31;-154;277;-154;-154;277;-154;31]);     % Orthonormal M Matrix for w/in sextic effects
                M(:,8) = [-17;119;-358;597;-597;358;-119;17]./norm([-17;119;-358;597;-597;358;-119;17]);     % Orthonormal M Matrix for w/in septic effects
        end
        if isempty(covars_desmat)
            % Estimate beta matrix
            B    = (full_desmat'*full_desmat)\full_desmat'*DV;
            beta = M*B';
            beta = sum(abs(beta(:,1:num_preds_in_F)));
            
            test_stat = zeros(size(M,2),1);
            crit_val  = zeros(size(M,2),1);
            p_1tail   = zeros(size(M,2),1);
            p_2tail   = zeros(size(M,2),1);
            
            for con = 1:size(M,2)
                Rsq            = 1-(corr(DV*M(:,con),(DV*M(:,con)-full_desmat*B*M(:,con))))^2;
                test_stat(con) = ((Rsq)*(size(full_desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                permdis        = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'~',use_parfor,within_perms,M(:,con));
                
                if sign(test_stat(con)) == 1
                    crit_val(con) = permdis(round((1-alpha)*length(permdis)));
                    p_1tail(con)  = sum(permdis >= test_stat(con))/length(permdis);
                    p_2tail(con)  = sum(permdis <= -test_stat(con))/length(permdis)+p_1tail(con);
                else
                    crit_val(con) = permdis(round(alpha*length(permdis)));
                    p_1tail(con)  = sum(permdis <= test_stat(con))/length(permdis);
                    p_2tail(con)  = sum(permdis >= -test_stat(con))/length(permdis)+p_1tail(con);
                end
            end
            if size(M,2) > 2
                beta                   = [beta;sum(abs(beta(2:end)))];
                Rsq                    = 1-(corr2(DV*M(:,2:end),(DV*M(:,2:end)-full_desmat*B*M(:,2:end))))^2;
                test_stat(size(M,2)+1) = ((Rsq)*(size(full_desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                permdis                = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'~',use_parfor,within_perms,M(:,2:end));
                
                if sign(test_stat(size(M,2)+1)) == 1
                    crit_val(size(M,2)+1) = permdis(round((1-alpha)*length(permdis)));
                    p_1tail(size(M,2)+1)  = sum(permdis >= test_stat(size(M,2)+1))/length(permdis);
                    p_2tail(size(M,2)+1)  = sum(permdis <= -test_stat(size(M,2)+1))/length(permdis)+p_1tail(size(M,2)+1);
                else
                    crit_val(size(M,2)+1) = permdis(round(alpha*length(permdis)));
                    p_1tail(size(M,2)+1)  = sum(permdis <= test_stat(size(M,2)+1))/length(permdis);
                    p_2tail(size(M,2)+1)  = sum(permdis >= -test_stat(size(M,2)+1))/length(permdis)+p_1tail(size(M,2)+1);
                end
            end
        else
            % Estimate beta matrix
            B_full = (full_desmat'*full_desmat)\full_desmat'*DV;
            B_redu = (covars_desmat'*covars_desmat)\covars_desmat'*DV;
            beta   = M*B_full';
            beta   = sum(abs(beta(:,1:num_preds_in_F)),2);
            
            test_stat = zeros(size(M,2),1);
            crit_val  = zeros(size(M,2),1);
            p_1tail   = zeros(size(M,2),1);
            p_2tail   = zeros(size(M,2),1);
            
            for con = 1:size(M,2)
                Rsq_full       = 1-(corr(DV*M(:,con),(DV*M(:,con)-full_desmat*B_full*M(:,con))))^2;
                Rsq_redu       = 1-(corr(DV*M(:,con),(DV*M(:,con)-covars_desmat*B_redu*M(:,con))))^2;
                test_stat(con) = ((Rsq_full-Rsq_redu)*(size(full_desmat,1)-size(full_desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                permdis        = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'~',use_parfor,within_perms,M(:,con));
                
                if sign(test_stat(con)) == 1
                    crit_val(con) = permdis(round((1-alpha)*length(permdis)));
                    p_1tail(con)  = sum(permdis >= test_stat(con))/length(permdis);
                    p_2tail(con)  = sum(permdis <= -test_stat(con))/length(permdis)+p_1tail(con);
                else
                    crit_val(con) = permdis(round(alpha*length(permdis)));
                    p_1tail(con)  = sum(permdis <= test_stat(con))/length(permdis);
                    p_2tail(con)  = sum(permdis >= -test_stat(con))/length(permdis)+p_1tail(con);
                end
            end
            if size(M,2) > 2
                beta                   = [beta;sum(abs(beta(2:end)))];
                Rsq_full               = 1-(corr2(DV*M(:,2:end),(DV*M(:,2:end)-full_desmat*B_full*M(:,2:end))))^2;
                Rsq_redu               = 1-(corr2(DV*M(:,2:end),(DV*M(:,2:end)-covars_desmat*B_redu*M(:,2:end))))^2;
                test_stat(size(M,2)+1) = ((Rsq_full-Rsq_redu)*(size(full_desmat,1)-size(full_desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                permdis                = create_perm_dist(DV,full_desmat,covars_desmat,Contrast_or_F,perms,'~',use_parfor,within_perms,M(:,2:end));
                
                if sign(test_stat(size(M,2)+1)) == 1
                    crit_val(size(M,2)+1) = permdis(round((1-alpha)*length(permdis)));
                    p_1tail(size(M,2)+1)  = sum(permdis >= test_stat(size(M,2)+1))/length(permdis);
                    p_2tail(size(M,2)+1)  = sum(permdis <= -test_stat(size(M,2)+1))/length(permdis)+p_1tail(size(M,2)+1);
                else
                    crit_val(size(M,2)+1) = permdis(round(alpha*length(permdis)));
                    p_1tail(size(M,2)+1)  = sum(permdis <= test_stat(size(M,2)+1))/length(permdis);
                    p_2tail(size(M,2)+1)  = sum(permdis >= -test_stat(size(M,2)+1))/length(permdis)+p_1tail(size(M,2)+1);
                end
            end
        end
    end
end

if size(beta,1) > 1
    hadNaN(2:size(beta,1),1)  = hadNaN(1);
    hadimag(2:size(beta,1),1) = hadimag(1);
    hadInf(2:size(beta,1),1)  = hadInf(1);
end


%%%% Create a permutation distribution for a partial regression
%%%% coefficient
function [test_stats] = create_perm_dist(DV,desmat,covariates,Contrast_or_F,perms,reg_type,use_parfor,varargin)

if ~isempty(varargin)
    within_perms = varargin{1};
    M            = varargin{2};
end

num_perms  = size(perms,2);
test_stats = zeros(num_perms,1);
dof_error  = size(desmat,1)-size(desmat,2)-1;                         % Degrees of freedom for the error

if strcmp(Contrast_or_F,'Contrasts')
    if use_parfor
        if size(DV,2) == 1
            if strcmp(reg_type,'OLS')
                if isempty(covariates)
                    if unique(desmat) == 1
                        parfor perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV.*curr_perm;
                            temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'tstat'});
                            test_stats(perm) = temp.tstat.t(1);
                        end
                    else
                        parfor perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV(curr_perm); %#ok<*PFBNS>
                            temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'tstat'});
                            test_stats(perm) = temp.tstat.t(1);
                        end
                    end
                else
                    DVvals = regstats(DV,covariates,eye(size(covariates,2)),{'yhat','r'});
                    resids = DVvals.r;
                    yhat = DVvals.yhat;
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = resids(curr_perm)+yhat;
                        temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'tstat'});
                        test_stats(perm) = temp.tstat.t(1);
                    end
                end
            else
                if isempty(covariates)
                    if unique(desmat) == 1
                        parfor perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV.*curr_perm;
                            [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                            test_stats(perm) = stats.t(1);
                        end
                    else
                        parfor perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV(curr_perm);
                            [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                            test_stats(perm) = stats.t(1);
                        end
                    end
                else
                    [~,orig_stats] = robustfit_iterincrease(covariates,DV,'bisquare',4.685,'off');
                    resids = orig_stats.resid;
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = resids(curr_perm)+(DV-resids);
                        [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                        test_stats(perm) = stats.t(1);
                    end
                end
            end
        else
            K = eye(size(desmat,2));
            if isempty(covariates)
                if unique(desmat) == 1
                    parfor perm = 1:num_perms
                        permed_DV        = [];
                        curr_perm        = perms(:,perm);
                        curr_within_perm = within_perms(:,:,perm);
                        for lev = size(DV,2):-1:1
                            permed_DV(:,lev) = DV(:,lev).*curr_perm;
                        end
                        permed_DV        = permed_DV(curr_within_perm);
                        B                = (desmat'*desmat)\desmat'*permed_DV;
                        H                = M'*(K(1,:)*B)'/(K(1,:)/(desmat'*desmat)*K(1,:)')*(K(1,:)*B)*M; % Estimate hypothesis matrix
                        E                = M'*(permed_DV'*permed_DV-B'*(desmat'*desmat)*B)*M; % Estimate error matrix
                        if size(M,2) > 1
                            test_stats(perm) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
                        else
                            test_stats(perm) = H/(E/dof_error);                                         % Calculate F
                        end
                    end
                else
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        curr_within_perm = within_perms(:,:,perm);
                        permed_DV        = DV(curr_perm,:);
                        permed_DV        = permed_DV(curr_within_perm);
                        B                = (desmat'*desmat)\desmat'*permed_DV;
                        H                = M'*(K(1,:)*B)'/(K(1,:)/(desmat'*desmat)*K(1,:)')*(K(1,:)*B)*M; % Estimate hypothesis matrix
                        E                = M'*(permed_DV'*permed_DV-B'*(desmat'*desmat)*B)*M; % Estimate error matrix
                        if size(M,2) > 1
                            test_stats(perm) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
                        else
                            test_stats(perm) = H/(E/dof_error);                                         % Calculate F
                        end
                    end
                end
            else
                yhat  = covariates/(covariates'*covariates)*covariates'*DV;
                resid = DV-covariates/(covariates'*covariates)*covariates'*DV;
                parfor perm = 1:num_perms
                    curr_perm        = perms(:,perm);
                    curr_within_perm = within_perms(:,:,perm);
                    permed_resid     = resid(curr_perm,:);
                    permed_resid     = permed_resid(curr_within_perm);
                    permed_DV        = permed_resid+yhat;
                    B                = (desmat'*desmat)\desmat'*permed_DV;
                    H                = M'*(K(1,:)*B)'/(K(1,:)/(desmat'*desmat)*K(1,:)')*(K(1,:)*B)*M; % Estimate hypothesis matrix
                    E                = M'*(permed_DV'*permed_DV-B'*(desmat'*desmat)*B)*M; % Estimate error matrix
                    if size(M,2) > 1
                        test_stats(perm) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
                    else
                        test_stats(perm) = H/(E/dof_error);                                         % Calculate F
                    end
                end
            end
        end
    else
        if size(DV,2) == 1
            if strcmp(reg_type,'OLS')
                if isempty(covariates)
                    if unique(desmat) == 1
                        for perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV.*curr_perm;
                            temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'tstat'});
                            test_stats(perm) = temp.tstat.t(1);
                        end
                    else
                        for perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV(curr_perm);
                            temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'tstat'});
                            test_stats(perm) = temp.tstat.t(1);
                        end
                    end
                else
                    DVvals = regstats(DV,covariates,eye(size(covariates,2)),{'yhat','r'});
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = DVvals.r(curr_perm)+DVvals.yhat;
                        temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'tstat'});
                        test_stats(perm) = temp.tstat.t(1);
                    end
                end
            else
                if isempty(covariates)
                    if unique(desmat) == 1
                        for perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV.*curr_perm;
                            [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                            test_stats(perm) = stats.t(1);
                        end
                    else
                        for perm = 1:num_perms
                            curr_perm        = perms(:,perm);
                            permed_DV        = DV(curr_perm);
                            [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                            test_stats(perm) = stats.t(1);
                        end
                    end
                else
                    [~,orig_stats] = robustfit_iterincrease(covariates,DV,'bisquare',4.685,'off');
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = orig_stats.resid(curr_perm)+(DV-orig_stats.resid);
                        [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                        test_stats(perm) = stats.t(1);
                    end
                end
            end
        else
            K = eye(size(desmat,2));
            if isempty(covariates)
                if unique(desmat) == 1
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        curr_within_perm = within_perms(:,:,perm);
                        for lev = size(DV,2):-1:1
                            permed_DV(:,lev) = DV(:,lev).*curr_perm;
                        end
                        permed_DV        = permed_DV(curr_within_perm);
                        B                = (desmat'*desmat)\desmat'*permed_DV;
                        H                = M'*(K(1,:)*B)'/(K(1,:)/(desmat'*desmat)*K(1,:)')*(K(1,:)*B)*M; % Estimate hypothesis matrix
                        E                = M'*(permed_DV'*permed_DV-B'*(desmat'*desmat)*B)*M; % Estimate error matrix
                        if size(M,2) > 1
                            test_stats(perm) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
                        else
                            test_stats(perm) = H/(E/dof_error);                                         % Calculate F
                        end
                    end
                else
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        curr_within_perm = within_perms(:,:,perm);
                        permed_DV        = DV(curr_perm,:);
                        permed_DV        = permed_DV(curr_within_perm);
                        B                = (desmat'*desmat)\desmat'*permed_DV;
                        H                = M'*(K(1,:)*B)'/(K(1,:)/(desmat'*desmat)*K(1,:)')*(K(1,:)*B)*M; % Estimate hypothesis matrix
                        E                = M'*(permed_DV'*permed_DV-B'*(desmat'*desmat)*B)*M; % Estimate error matrix
                        if size(M,2) > 1
                            test_stats(perm) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
                        else
                            test_stats(perm) = H/(E/dof_error);                                         % Calculate F
                        end
                    end
                end
            else
                yhat  = covariates/(covariates'*covariates)*covariates'*DV;
                resid = DV-covariates/(covariates'*covariates)*covariates'*DV;
                for perm = 1:num_perms
                    curr_perm        = perms(:,perm);
                    curr_within_perm = within_perms(:,:,perm);
                    permed_resid     = resid(curr_perm,:);
                    permed_resid     = permed_resid(curr_within_perm);
                    permed_DV        = permed_resid+yhat;
                    B                = (desmat'*desmat)\desmat'*permed_DV;
                    H                = M'*(K(1,:)*B)'/(K(1,:)/(desmat'*desmat)*K(1,:)')*(K(1,:)*B)*M; % Estimate hypothesis matrix
                    E                = M'*(permed_DV'*permed_DV-B'*(desmat'*desmat)*B)*M; % Estimate error matrix
                    if size(M,2) > 1
                        test_stats(perm) = det(E)/det(H+E);                                         % Calculate Wilks' Lambda
                    else
                        test_stats(perm) = H/(E/dof_error);                                         % Calculate F
                    end
                end
            end
        end
    end
else
    num_preds_in_F = size(desmat,2)-size(covariates,2);
    if use_parfor
        if size(DV,2) == 1
            if strcmp(reg_type,'OLS')
                if isempty(covariates)
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = DV(curr_perm); %#ok<*PFBNS>
                        temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'fstat'});
                        test_stats(perm) = temp.fstat(1);
                    end
                else
                    DVvals = regstats(DV,covariates,eye(size(covariates,2)),{'yhat','r'});
                    resids = DVvals.r;
                    yhat   = DVvals.yhat;
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = resids(curr_perm)+yhat;
                        temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'rsquare'});
                        Rsq_full         = temp.rsquare(1);
                        temp             = regstats(permed_DV,covariates,eye(size(covariates,2)),{'rsquare'});
                        Rsq_redu         = temp.rsquare(1);
                        test_stats(perm) = ((Rsq_full-Rsq_redu)*(size(desmat,1)-size(desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                    end
                end
            else
                if isempty(covariates)
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = DV(curr_perm);
                        [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                        Rsq              = 1-(corr(permed_DV,stats.resid))^2;
                        test_stats(perm) = ((Rsq)*(size(desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                    end
                else
                    [~,orig_stats] = robustfit_iterincrease(covariates,DV,'bisquare',4.685,'off');
                    resids = orig_stats.resid;
                    parfor perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = resids(curr_perm)+(DV-resids);
                        [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                        Rsq_full         = 1-(corr(permed_DV,stats.resid))^2;
                        [~,stats]        = robustfit_iterincrease(covariates,permed_DV,'bisquare',4.685,'off');
                        Rsq_redu         = 1-(corr(permed_DV,stats.resid))^2;
                        test_stats(perm) = ((Rsq_full-Rsq_redu)*(size(desmat,1)-size(desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                    end
                end
            end
        else
            if isempty(covariates)
                parfor perm = 1:num_perms
                    curr_perm        = perms(:,perm);
                    curr_within_perm = within_perms(:,:,perm);
                    permed_DV        = DV(curr_perm,:);
                    permed_DV        = permed_DV(curr_within_perm);
                    B                = (desmat'*desmat)\desmat'*permed_DV;
                    Rsq              = 1-(corr(permed_DV*M,(permed_DV*M-desmat*B*M)))^2;
                    test_stats(perm) = ((Rsq)*(size(desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                end
            else
                yhat  = covariates/(covariates'*covariates)*covariates'*DV;
                resid = DV-covariates/(covariates'*covariates)*covariates'*DV;
                parfor perm = 1:num_perms
                    curr_perm        = perms(:,perm);
                    curr_within_perm = within_perms(:,:,perm);
                    permed_resid     = resid(curr_perm,:);
                    permed_resid     = permed_resid(curr_within_perm);
                    permed_DV        = permed_resid+yhat;
                    B_full           = (desmat'*desmat)\desmat'*permed_DV;
                    B_redu           = (covariates'*covariates)\covariates'*permed_DV;
                    Rsq_full         = 1-(corr(permed_DV*M,(permed_DV*M-desmat*B_full*M)))^2;
                    Rsq_redu         = 1-(corr(permed_DV*M,(permed_DV*M-covariates*B_redu*M)))^2;
                    test_stats(perm) = ((Rsq_full-Rsq_redu)*(size(desmat,1)-size(desmat,2)))/((1-Rsq_full)*num_preds_in_F);                                         % Calculate F
                end
            end
        end
    else
        if size(DV,2) == 1
            if strcmp(reg_type,'OLS')
                if isempty(covariates)
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = DV(curr_perm);
                        temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'fstat'});
                        test_stats(perm) = temp.fstat(1);
                    end
                else
                    DVvals = regstats(DV,covariates,eye(size(covariates,2)),{'yhat','r'});
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = DVvals.r(curr_perm)+DVvals.yhat;
                        temp             = regstats(permed_DV,desmat,eye(size(desmat,2)),{'rsquare'});
                        Rsq_full         = temp.rsquare(1);
                        temp             = regstats(permed_DV,covariates,eye(size(covariates,2)),{'rsquare'});
                        Rsq_redu         = temp.rsquare(1);
                        test_stats(perm) = ((Rsq_full-Rsq_redu)*(size(desmat,1)-size(desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                    end
                end
            else
                if isempty(covariates)
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = DV(curr_perm);
                        [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                        Rsq              = 1-(corr(permed_DV,stats.resid))^2;
                        test_stats(perm) = ((Rsq)*(size(desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                    end
                else
                    [~,orig_stats] = robustfit_iterincrease(covariates,DV,'bisquare',4.685,'off');
                    for perm = 1:num_perms
                        curr_perm        = perms(:,perm);
                        permed_DV        = orig_stats.resid(curr_perm)+(DV-orig_stats.resid);
                        [~,stats]        = robustfit_iterincrease(desmat,permed_DV,'bisquare',4.685,'off');
                        Rsq_full         = 1-(corr(permed_DV,stats.resid))^2;
                        [~,stats]        = robustfit_iterincrease(covariates,permed_DV,'bisquare',4.685,'off');
                        Rsq_redu         = 1-(corr(permed_DV,stats.resid))^2;
                        test_stats(perm) = ((Rsq_full-Rsq_redu)*(size(desmat,1)-size(desmat,2)))/((1-Rsq_full)*num_preds_in_F);
                    end
                end
            end
        else
            if isempty(covariates)
                for perm = 1:num_perms
                    curr_perm        = perms(:,perm);
                    curr_within_perm = within_perms(:,:,perm);
                    permed_DV        = DV(curr_perm,:);
                    permed_DV        = permed_DV(curr_within_perm);
                    B                = (desmat'*desmat)\desmat'*permed_DV;
                    Rsq              = 1-(corr2(permed_DV*M,(permed_DV*M-desmat*B*M)))^2;
                    test_stats(perm) = ((Rsq)*(size(desmat,1)-num_preds_in_F-1))/((1-Rsq)*num_preds_in_F);
                end
            else
                yhat  = covariates/(covariates'*covariates)*covariates'*DV;
                resid = DV-covariates/(covariates'*covariates)*covariates'*DV;
                for perm = 1:num_perms
                    curr_perm        = perms(:,perm);
                    curr_within_perm = within_perms(:,:,perm);
                    permed_resid     = resid(curr_perm,:);
                    permed_resid     = permed_resid(curr_within_perm);
                    permed_DV        = permed_resid+yhat;
                    B_full           = (desmat'*desmat)\desmat'*permed_DV;
                    B_redu           = (covariates'*covariates)\covariates'*permed_DV;
                    Rsq_full         = 1-(corr2(permed_DV*M,(permed_DV*M-desmat*B_full*M)))^2;
                    Rsq_redu         = 1-(corr2(permed_DV*M,(permed_DV*M-covariates*B_redu*M)))^2;
                    test_stats(perm) = ((Rsq_full-Rsq_redu)*(size(desmat,1)-size(desmat,2)))/((1-Rsq_full)*num_preds_in_F);                                         % Calculate F
                end
            end
        end
    end
end
test_stats = sort(test_stats);
