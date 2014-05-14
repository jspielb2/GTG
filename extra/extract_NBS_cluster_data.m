function [mean_edgevals,ind_edgevals,ind_labels] = extract_NBS_cluster_data(nbs,net)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 12.18.13
%
% WARNING: This is a beta version. There no known bugs, but only limited
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed,
% redistributed versions must have the same rights

if ~exist('net','var')
    net = 1;
end

tempcoords = repmat(logical(triu(ones(length(nbs.NBS.node_label))-diag(ones(size(nbs.NBS.node_label))),1)),[1,1,size(nbs.GLM.y,1)]);
conmats = zeros(length(nbs.NBS.node_label),length(nbs.NBS.node_label),size(nbs.GLM.y,1));
conmats(tempcoords) = shiftdim(nbs.GLM.y,1);

[x,y] = find(nbs.NBS.con_mat{1,net} == 1);

for edge = 1:length(x)
    ind_labels{edge} = [nbs.NBS.node_label{x(edge),1} '_' nbs.NBS.node_label{y(edge),1}];
    ind_edgevals(:,edge) = conmats(x(edge),y(edge),:);
end

conmats = conmats-repmat(mean(conmats,3),[1,1,size(conmats,3)]);
conmats = conmats./repmat(std(conmats,0,3),[1,1,size(conmats,3)]);
conmats = conmats.*repmat(full(nbs.NBS.con_mat{1,1}),[1,1,size(conmats,3)]);

mean_edgevals = squeeze(sum(sum(triu3(conmats,1),1),2));
