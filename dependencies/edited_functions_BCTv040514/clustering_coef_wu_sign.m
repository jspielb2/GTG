function [C_pos,C_neg] = clustering_coef_wu_sign(W)
% Edited version of Rubinov's function (05/30/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%CLUSTERING_COEF_WU     Clustering coefficient
%
%   C = clustering_coef_wu(W);
%
%   The weighted clustering coefficient is the average "intensity" of 
%   triangles around a node.
%
%   Input:      W,      weighted undirected connection matrix
%
%   Output:     C,      clustering coefficient vector
%
%   Reference: Onnela et al. (2005) Phys Rev E 71:065103
%
%
%   Mika Rubinov, UNSW, 2007-2010

n = length(W);                                    %number of nodes
W_pos = threshold_absolute(W,0);
W_pos(1:n+1:end) = 0;
W_neg = threshold_absolute(W*-1,0);
W_neg(1:n+1:end) = 0;

K_pos = sum(W_pos ~= 0,2);            	
cyc3_pos = diag((W_pos.^(1/3))^3);           
K_pos(cyc3_pos == 0) = inf;             %if no 3-cycles exist, make C=0 (via K=inf)
C_pos = cyc3_pos./(K_pos.*(K_pos-1));         %clustering coefficient

K_neg = sum(W_neg ~= 0,2);            	
cyc3_neg = diag((W_neg.^(1/3))^3);           
K_neg(cyc3_neg == 0) = inf;             %if no 3-cycles exist, make C=0 (via K=inf)
C_neg = cyc3_neg./(K_neg.*(K_neg-1));         %clustering coefficient