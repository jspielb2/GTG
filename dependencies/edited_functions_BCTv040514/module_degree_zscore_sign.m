function [Z_pos,Z_neg] = module_degree_zscore_sign(W,Ci)
% Edited version of Rubinov's function (05/28/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%MODULE_DEGREE_ZSCORE       Within-module degree z-score
%
%   Z=module_degree_zscore(W,Ci,flag);
%
%   The within-module degree z-score is a within-module version of degree
%   centrality.
%
%   Inputs:     W,      binary/weighted, directed/undirected connection matrix
%               Ci,     community affiliation vector
%               flag,   0, undirected graph (default)
%                       1, directed graph: out-degree
%                       2, directed graph: in-degree
%                       3, directed graph: out-degree and in-degree
%
%   Output:     Z,      within-module degree z-score.
%
%   Reference: Guimera R, Amaral L. Nature (2005) 433:895-900.
%
%
%   Mika Rubinov, UNSW, 2008-2010

n = length(W);                        %number of vertices
Z_pos = zeros(n,1);
Z_neg = zeros(n,1);

for i = 1:max(Ci)
    [Koi_pos,Koi_neg] = strengths_und_sign(W(Ci == i,Ci == i));
    Z_pos(Ci == i) = (Koi_pos'-mean(Koi_pos))./std(Koi_pos);
    Z_neg(Ci == i) = (Koi_neg'-mean(Koi_neg))./std(Koi_neg);
end

Z_pos(isnan(Z_pos)) = 0;
Z_neg(isnan(Z_neg)) = 0;