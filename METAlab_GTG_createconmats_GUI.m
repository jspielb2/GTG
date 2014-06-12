function varargout = METAlab_GTG_createconmats_GUI(varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: Beta 0.30 (06.10.14)
% 
% 
% History:
% 04.23.14 - Beta 0.24 - 1) conversion into GUI, 2) addition of calpability
%                        for creating connectivity matrices by condition 
%                        for task fMRI
% 05.07.14 - Beta 0.25 - 1) bug fixes, 2) addition of within-block
%                        detrending for functional data
% 06.10.14 - Beta 0.30 - 1) small bug fixes, 2) handles now used to pass 
%                        information between functions (rather than via 
%                        out, which was made global), allowing users to 
%                        launch processes from the same gui with less 
%                        chance of info from the previous process 
%                        interfering
%
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @METAlab_GTG_createconmats_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @METAlab_GTG_createconmats_GUI_OutputFcn, ...
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

function METAlab_GTG_createconmats_GUI_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.output = hObject;
guidata(hObject, handles);

function varargout = METAlab_GTG_createconmats_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Infile_edit_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
temp         = get(hObject,'String');
handles.out  = evalin('base',temp);
guidata(hObject,handles);

function Infile_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Infile_edit_ButtonDownFcn(hObject, eventdata, handles)
set(hObject,'Enable','On');
uicontrol(handles.Infile_edit);




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

function FuncYN_popupmenu_Callback(hObject, eventdata, handles)
contents                 = cellstr(get(hObject,'String'));
handles.out.div_by_block = contents{get(hObject,'Value')};

if strcmp(handles.out.div_by_block,'Yes')
    set(handles.DivBlockTR_edit,'enable','on');
    set(handles.Detr_popupmenu,'enable','on');
    set(handles.FuncDes_edit,'enable','on');
    set(handles.FuncDes_pushbutton,'enable','on');
else
    set(handles.DivBlockTR_edit,'enable','off');
    set(handles.Detr_popupmenu,'enable','off');
    set(handles.FuncDes_edit,'enable','off');
    set(handles.FuncDes_pushbutton,'enable','off');
end
guidata(hObject,handles);

function FuncYN_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DivBlockTR_edit_Callback(hObject, eventdata, handles)
temp           = get(hObject,'String');
handles.out.TR = evalin('base',temp);
guidata(hObject,handles);

function DivBlockTR_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Detr_popupmenu_Callback(hObject, eventdata, handles)
temp                   = get(hObject,'String');
handles.out.block_detr = evalin('base',temp);
guidata(hObject,handles);

function Detr_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FuncDes_edit_Callback(hObject, eventdata, handles)
temp                       = get(hObject,'String');
handles.out.block_info     = evalin('base',temp);
handles.out.num_conditions = length(handles.out.block_info);
guidata(hObject,handles);

function FuncDes_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FuncDes_pushbutton_Callback(hObject, eventdata, handles)
handles.out.num_conditions = str2double(inputdlg('Enter the number of conditions','Conditions',2));
for cond = 1:handles.out.num_conditions
    temp = inputdlg(['Enter the onset times (in seconds, separated by commas) of condition #',num2str(cond)],'Onsets',2);
    handles.out.block_info{cond,1}(1,:) = str2num(temp{:}); %#ok<*ST2NM>
    temp = inputdlg(['Enter the block durations (in seconds, separated by commas) of condition #',num2str(cond)],'Durations',2);
    handles.out.block_info{cond,1}(2,:) = str2num(temp{:});
end
guidata(hObject,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ConnectType_popupmenu_Callback(hObject, eventdata, handles)
contents                 = cellstr(get(hObject,'String'));
handles.out.connect_type = contents{get(hObject,'Value')};
guidata(hObject,handles);

function ConnectType_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MinTP_edit_Callback(hObject, eventdata, handles)
handles.out.min_TP = str2double(get(hObject,'String'));
guidata(hObject,handles);

function MinTP_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Start_pushbutton_Callback(hObject, eventdata, handles)
out = handles.out;

% Check whether inputs have been specified
if ~exist('out','var')
    msgbox('Enter output from previous stage (structure with timeseries)','Error','error')
    return
elseif ~isfield(out,'ts') %#ok<*NODEF>
    error('No timeseries found in input structure')
elseif ~isfield(out,'subs')
    error('Participant IDs not found in input structure')
end
if ~isfield(out,'outname')
    msgbox('Enter an output name','Error','error')
    return
end
if ~isfield(out,'div_by_block')
    out.div_by_block = 'No';
elseif strcmp(out.div_by_block,'Yes') && ~isfield(out,'block_info')
    msgbox('Specify block timing info','Error','error')
    return
end
if ~isfield(out,'TR')
    out.TR = 2;
end
if ~isfield(out,'connect_type')
    msgbox('Specify a type of connectivity to calculate','Error','error')
    return
end
if ~isfield(out,'min_TP')
    out.min_TP = 50;
else
    if out.min_TP < 2
        out.min_TP = 2;
    end
end
if ~isfield(out,'nROI')
    out.nROI = length(out.ROI_labels);
end

toolboxes = ver;
use_parfor = any(strcmpi({toolboxes.Name},'Parallel Computing Toolbox'));
if use_parfor
    num_par_workers = str2double(inputdlg(sprintf('The Parallel Computing Toolbox was found on your system.\n\nEnter the number of workers you want to use (enter 1 to not use the PCT).\n\nNote: this must be <= the number of cores'),'PCT Workers',2));
    if num_par_workers > 12
        num_par_workers = 12;
    end
    if num_par_workers > feature('numCores')
        num_par_workers = feature('numCores');
    end
    if num_par_workers > 1
        try
            parpool('open',num_par_workers);
        catch
            matlabpool('open',num_par_workers); %#ok<*DPOOL>
        end
    else
        use_parfor = false;
    end
end
nROI       = out.nROI;
min_TP     = out.min_TP;
ROI_labels = out.ROI_labels;
progressbar('Progress Deconvolving')
if strcmp(out.div_by_block,'Yes')
    dt = out.TR/16;
    NT = out.TR/dt;
    hrf = spm_hrf(dt);
    out.ts_orig = out.ts;
    out.ts = cell(length(out.subs),out.num_conditions);
    nTP = size(out.ts_orig{1},2);
    for currsub = 1:length(out.subs)
        currsub_ts = out.ts_orig{currsub};
        if size(currsub_ts,2) > 1
            decon_ts = zeros(nROI,round(nTP.*NT));
            if use_parfor
                parfor var = 1:nROI
                    P      = {};
                    var_ts = currsub_ts(var,:)';
                    xb     = spm_dctmtx(nTP*NT+128,nTP);
                    P{1}.X = zeros(nTP,nTP);
                    for i = 1:nTP
                        Hx          = conv(xb(:,i),hrf);
                        P{1}.X(:,i) = Hx((1:NT:nTP*NT)+128);
                    end
                    xb              = xb(129:end,:);
                    P{1}.C          = speye(nTP,nTP)/4;
                    P{2}.X          = sparse(nTP,1);
                    P{2}.C          = speye(nTP,nTP)*nTP/trace(P{1}.X'*P{1}.X);
                    C               = spm_PEB(var_ts,P);
                    decon_ts(var,:) = xb*C{2}.E(1:nTP);
                end
            else
                for var = 1:nROI
                    P      = {};
                    var_ts = currsub_ts(var,:)';
                    xb     = spm_dctmtx(nTP*NT+128,nTP);
                    P{1}.X = zeros(nTP,nTP);
                    for i = 1:nTP
                        Hx          = conv(xb(:,i),hrf);
                        P{1}.X(:,i) = Hx((1:NT:nTP*NT)+128);
                    end
                    xb              = xb(129:end,:);
                    P{1}.C          = speye(nTP,nTP)/4;
                    P{2}.X          = sparse(nTP,1);
                    P{2}.C          = speye(nTP,nTP)*nTP/trace(P{1}.X'*P{1}.X);
                    C               = spm_PEB(var_ts,P);
                    decon_ts(var,:) = xb*C{2}.E(1:nTP);
                end
            end
        end
        for cond = 1:out.num_conditions
            block_on  = round(out.block_info{cond}(1,:)*NT)+1;
            block_off = round(((out.block_info{cond}(1,:)+out.block_info{cond}(2,:))-1)*NT)+1;
            for block = 1:length(block_on)
                if ~strcmp(out.block_detr,'Polynomial Detrending Order') && ~strcmp(out.block_detr,'No detrending')
                    decon_ts(:,block_on(block):block_off(block)) = spm_detrend(decon_ts(:,block_on(block):block_off(block)),str2double(out.block_detr));
                end
                out.ts{currsub,cond} = [out.ts{currsub,cond},decon_ts(:,block_on(block):block_off(block))];
            end
        end
        
        prog = currsub/length(out.subs);
        progressbar(prog)
    end
end
outmats = zeros(out.nROI,out.nROI,size(out.ts,2));
switch out.connect_type
    case 'Pearson Correlation'
        mat_outname = [out.outname '_fullcorr.mat'];
        logfile_outname = [out.outname '_fullcorr_logfile.txt'];
    case 'Partial Correlation'
        mat_outname = [out.outname '_partialcorr.mat'];
        logfile_outname = [out.outname '_partialcorr_logfile.txt'];
    case 'Mutual Information'
        mat_outname = [out.outname '_mutualinfo.mat'];
        logfile_outname = [out.outname '_mutualinfo_logfile.txt'];
    case 'Robust Correlation'
        mat_outname = [out.outname '_robustcorr.mat'];
        logfile_outname = [out.outname '_robustcorr_logfile.txt'];
end
logfile_fid = fopen(logfile_outname,'w');
out.num_rep_levs = size(out.ts,1);
progressbar('Progress Calculating Connectivity Matrices')

switch out.connect_type
    case 'Pearson Correlation'
        calc_cells  = logical(triu(ones(out.nROI),1));
        for currsub = 1:length(out.subs)
            if iscell(out.subs)
                sub = out.subs{currsub};
            else
                sub = num2str(out.subs(currsub));
            end
            for rep_lev = 1:out.num_rep_levs
                currsub_ts = squeeze(out.ts{rep_lev,currsub});
                if size(currsub_ts,2) > 1
                    for rowvar = 1:out.nROI
                        rowts = currsub_ts(rowvar,:)';
                        if use_parfor
                            parfor colvar = 1:nROI
                                if calc_cells(rowvar,colvar) == 1
                                    colts = currsub_ts(colvar,:)';
                                    usevols = logical((~isnan(rowts)).*(~isnan(colts)));
                                    if sum(usevols) >= min_TP
                                        outmats(rowvar,colvar,currsub,rep_lev) = corr(rowts(usevols),colts(usevols));
                                    else
                                        outmats(rowvar,colvar,currsub,rep_lev) = NaN;
                                        fprintf(logfile_fid,'Less than %i usable timepoints for computing the correlation between %s and %s for %s\n',min_TP,ROI_labels{rowvar},ROI_labels{colvar},sub); %#ok<*PFBNS>
                                    end
                                end
                            end
                        else
                            for colvar = 1:out.nROI
                                if calc_cells(rowvar,colvar) == 1
                                    colts = currsub_ts(colvar,:)';
                                    usevols = logical((~isnan(rowts)).*(~isnan(colts)));
                                    if sum(usevols) >= out.min_TP
                                        outmats(rowvar,colvar,currsub,rep_lev) = corr(rowts(usevols),colts(usevols));
                                    else
                                        outmats(rowvar,colvar,currsub,rep_lev) = NaN;
                                        fprintf(logfile_fid,'Less than %i usable timepoints for computing the correlation between %s and %s for %s\n',out.min_TP,out.ROI_labels{rowvar},out.ROI_labels{colvar},sub);
                                    end
                                end
                            end
                        end
                    end
                    outmats(:,:,currsub,rep_lev) = outmats(:,:,currsub,rep_lev)+outmats(:,:,currsub,rep_lev)';
                else
                    outmats(:,:,currsub,rep_lev) = NaN;
                end
                prog = currsub/length(out.subs);
                progressbar(prog)
            end
        end
    case 2 % 'Partial Correlation'
        out.out.connect_type = 'Partial Correlation';
        if out.min_TP <= out.nROI
            out.min_TP = out.nROI+1;
            disp('Minimum number of usable timepoints needed for Partial Correlation is at least #ROIs + 1 and has been reset to that value');
        end
        if use_parfor
            subs = out.subs;
            num_rep_levs = out.num_rep_levs;
            ts = out.ts;
            parfor currsub = 1:length(subs)
                if iscell(subs) 
                    sub = subs{currsub};
                else
                    sub = num2str(subs(currsub));
                end
                for rep_lev = 1:num_rep_levs
                    if size(ts{currsub},2) > 1
                        currts  = squeeze(ts{rep_lev,currsub});
                        usevols = sum(isnan(currts),1) == 0;
                        if sum(usevols) >= min_TP
                            outmats(:,:,currsub,rep_lev) = partialcorr(currts(:,usevols)');
                        else
                            outmats(:,:,currsub,rep_lev) = NaN;
                            fprintf(logfile_fid,'Less than is usable timepoints for computing the partial correlations for %s\n',min_TP,sub);
                        end
                    else
                        outmats(:,:,currsub,rep_lev) = NaN;
                    end
                end
            end
        else
            for currsub = 1:length(out.subs)
                if iscell(out.subs)
                    sub = out.subs{currsub};
                else
                    sub = num2str(out.subs(currsub));
                end
                for rep_lev = 1:out.num_rep_levs
                    if size(out.ts{currsub},2) > 1
                        currts  = squeeze(out.ts{rep_lev,currsub});
                        usevols = sum(isnan(currts),1) == 0;
                        if sum(usevols) >= out.min_TP
                            outmats(:,:,currsub,rep_lev) = partialcorr(currts(:,usevols)');
                        else
                            outmats(:,:,currsub,rep_lev) = NaN;
                            fprintf(logfile_fid,'Less than is usable timepoints for computing the partial correlations for %s\n',out.min_TP,sub);
                        end
                    else
                        outmats(:,:,currsub,rep_lev) = NaN;
                    end
                end
                prog = currsub/length(out.subs);
                progressbar(prog)
            end
        end
    case 3 % 'Mutual Information'
        out.connect_type = 'Mutual Information';
        calc_cells = logical(triu(ones(out.nROI),1));
        for currsub = 1:length(out.subs)
            if iscell(out.subs)
                sub = out.subs{currsub};
            else
                sub = num2str(out.subs(currsub));
            end
            for rep_lev = 1:out.num_rep_levs
                currsub_ts = squeeze(out.ts{rep_lev,currsub});
                if size(currsub_ts,2) > 1
                    for rowvar = 1:out.nROI
                        rowts = currsub_ts(rowvar,:)';
                        if use_parfor
                            parfor colvar = 1:nROI
                                if calc_cells(rowvar,colvar) == 1
                                    colts = currsub_ts(colvar,:)';
                                    usevols = logical((~isnan(rowts)).*(~isnan(colts)));
                                    if sum(usevols) >= min_TP
                                        outmats(rowvar,colvar,currsub,rep_lev) = mutualinf(rowts(usevols),colts(usevols));
                                    else
                                        outmats(rowvar,colvar,currsub,rep_lev) = NaN;
                                        fprintf(logfile_fid,'Less than %i usable timepoints for computing the mutual information between %s and %s for %s\n',min_TP,ROI_labels{rowvar},ROI_labels{colvar},sub);
                                    end
                                end
                            end
                        else
                            for colvar = 1:out.nROI
                                if calc_cells(rowvar,colvar) == 1
                                    colts = currsub_ts(colvar,:)';
                                    usevols = logical((~isnan(rowts)).*(~isnan(colts)));
                                    if sum(usevols) >= out.min_TP
                                        outmats(rowvar,colvar,currsub,rep_lev) = mutualinf(rowts(usevols),colts(usevols));
                                    else
                                        outmats(rowvar,colvar,currsub,rep_lev) = NaN;
                                        fprintf(logfile_fid,'Less than %i usable timepoints for computing the mutual information between %s and %s for %s\n',out.min_TP,out.ROI_labels{rowvar},out.ROI_labels{colvar},sub);
                                    end
                                end
                            end
                        end
                    end
                    outmats(:,:,currsub,rep_lev) = outmats(:,:,currsub,rep_lev)+outmats(:,:,currsub,rep_lev)';
                else
                    outmats(:,:,currsub,rep_lev) = NaN;
                end
            end
            prog = currsub/length(out.subs);
            progressbar(prog)
        end
    case 4 % 'Robust Correlation'
        out.connect_type = 'Robust Correlation';
        calc_cells  = logical(triu(ones(out.nROI),1));
        for currsub = 1:length(out.subs)
            if iscell(out.subs)
                sub = out.subs{currsub};
            else
                sub = num2str(out.subs(currsub));
            end
            for rep_lev = 1:out.num_rep_levs
                currsub_ts = squeeze(out.ts{rep_lev,currsub});
                if size(currsub_ts,2) > 1
                    for rowvar = 1:out.nROI
                        rowts = currsub_ts(rowvar,:)';
                        if use_parfor
                            parfor colvar = 1:nROI
                                if calc_cells(rowvar,colvar) == 1
                                    colts = currsub_ts(colvar,:)';
                                    usevols = logical((~isnan(rowts)).*(~isnan(colts)));
                                    if sum(usevols) >= min_TP
                                        outmats(rowvar,colvar,currsub,rep_lev) = bendcorr(rowts(usevols),colts(usevols),0);
                                    else
                                        outmats(rowvar,colvar,currsub,rep_lev) = NaN;
                                        fprintf(logfile_fid,'Less than %i usable timepoints for computing the robust correlation between %s and %s for %s\n',min_TP,ROI_labels{rowvar},ROI_labels{colvar},sub);
                                    end
                                end
                            end
                        else
                            for colvar = 1:out.nROI
                                if calc_cells(rowvar,colvar) == 1
                                    colts = currsub_ts(colvar,:)';
                                    usevols = logical((~isnan(rowts)).*(~isnan(colts)));
                                    if sum(usevols) >= out.min_TP
                                        outmats(rowvar,colvar,currsub,rep_lev) = bendcorr(rowts(usevols),colts(usevols),0);
                                    else
                                        outmats(rowvar,colvar,currsub,rep_lev) = NaN;
                                        fprintf(logfile_fid,'Less than %i usable timepoints for computing the robust correlation between %s and %s for %s\n',out.min_TP,out.ROI_labels{rowvar},out.ROI_labels{colvar},sub);
                                    end
                                end
                            end
                        end
                    end
                    outmats(:,:,currsub,rep_lev) = outmats(:,:,currsub,rep_lev)+outmats(:,:,currsub,rep_lev)';
                else
                    outmats(:,:,currsub,rep_lev) = NaN;
                end
            end
            prog = currsub/length(out.subs);
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
out.nonan = sum(squeeze(sum(isnan(sum(outmats,4)),1)),1)' == 0;
out.allnan = sum(squeeze(sum(isnan(sum(outmats,4)),1)),1)' == out.nROI^2;
out.conmats = outmats;
save(mat_outname,'out');
