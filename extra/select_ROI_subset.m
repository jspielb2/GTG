function [outdata, outnames, outcoords, outmodlabs] = select_ROI_subset(indata, innames, varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 12.31.13
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if nargin > 2
    incoords = varargin{1};
end
if nargin > 3
    inmodlabs = varargin{2};
end

nROI = length(innames);
[selection] = listdlg('PromptString','Select ROIs:','SelectionMode','multiple','ListString',char(innames),'initialvalue',1:nROI);

outdata = indata(selection,selection,:);
outnames = {innames{selection}};

if size(outnames,1) < size(outnames,2)
    outnames = outnames';
end

if exist('incoords','var')
    outcoords = incoords(selection,:);
end

if exist('inmodlabs','var')
    outmodlabs = inmodlabs(selection,:);
end
