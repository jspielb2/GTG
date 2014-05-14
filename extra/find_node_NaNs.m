function [num_node_NaNs,high_NaN_nodes] = find_node_NaNs(conmats,varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 02.21.14
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if ~isempty(varargin)
    nodelabels = varargin{1};
end

num_node_NaNs = sum(squeeze(sum(isnan(conmats),1)),2);

if exist('nodelabels','var')
    high_NaN_nodes = nodelabels(num_node_NaNs > median(num_node_NaNs));
else
    high_NaN_nodes = find(num_node_NaNs > median(num_node_NaNs));
end
