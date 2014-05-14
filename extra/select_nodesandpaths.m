function [outdata, outnames, outcoords] = select_nodesandpaths(indata, innames, incoords, calcregmat, varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 11.25.13
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if calcregmat == 1
    desmat = varargin{1};
    contrastmat = varargin{2};
end

nEdges = input('How many edges in final network?  ');

nROI = length(innames);

[selection] = listdlg('PromptString','Select ALL nodes in final network:','SelectionMode','multiple','ListString',char(innames),'initialvalue',1:nROI);

tempdata = indata(selection,selection,:);
outnames = {innames{selection}};
outcoords = incoords(selection,:);

if size(outnames,1) < size(outnames,2)
    outnames = outnames';
end

if calcregmat == 0
    outdata = zeros(tempdata);
    outdata(eye(length(outnames)),:) = -1;
    for q = 1:nEdges
        [selection] = listdlg('PromptString',['Select nodes for edge ' num2str(q) ':'],'SelectionMode','multiple','ListString',char(outnames));
        outdata(selection(1),selection(2),:) = tempdata(selection(1),selection(2),:);
        outdata(selection(2),selection(1),:) = tempdata(selection(2),selection(1),:);
    end
elseif calcregmat == 1
    if desmat(:,1) ~= ones(size(desmat,1),1)
        desmat = [ones(size(desmat,1),1); desmat];
    end
    if size(contrastmat,2) == (size(desmat,2) - 1)
        contrastmat = [ones(size(contrastmat,1),1); contrastmat];
    end
    
    outdata = zeros(length(outnames),length(outnames),size(contrastmat,3));
    outdata(eye(length(outnames)),:) = -1;
    
    for q = 1:nEdges
        [selection] = listdlg('PromptString',['Select nodes for edge ' num2str(q) ':'],'SelectionMode','multiple','ListString',char(outnames));
        stats = regstats(tempdata(selection(1),selection(2),:),desmat(:,2:end),'linear',{'tstat'});
        zvals = sign(stats.tstat.beta).*abs(icdf('norm',(1 - stats.tstat.pval),0,1));
        zvals(isinf(zvals)) = sign(stats.tstat.beta(isinf(zvals)))*10;
        zvals(isnan(zvals)) = 0;
        outdata(selection(1),selection(2),:) = contrast*zvals;
        outdata(selection(2),selection(1),:) = contrast*zvals;
    end
end