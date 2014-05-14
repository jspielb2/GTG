function [mod_grps] = determine_modularity(conmats,varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 04.09.14
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if nargin > 1
    num_mod_runs = varargin{1};
else
    num_mod_runs = 10000;
end

if size(conmats,3) > 1
    fish_z = atanh(conmats);
    full_mean_conmat = atan(mean(fish_z,3));
else
    full_mean_conmat = conmats;
end

for run              = num_mod_runs:-1:1
    [louv_ci]        = modularity_louvain_und_sign(full_mean_conmat);
    [fine_ci,Q(run)] = modularity_finetune_und_sign(full_mean_conmat,'sta',louv_ci);
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

mod_grps         = mod_grps(:,find(Q == max(Q),1,'first'));
