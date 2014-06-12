function [T_pos,T_neg] = transitivity_wu_sign(W)
% Edited version of Rubinov's function (05/30/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%TRANSITIVITY_WU    Transitivity
%
%   T = transitivity_wu(W);
%
%   Transitivity is the ratio of 'triangles to triplets' in the network.
%   (A classical version of the clustering coefficient).
%
%   Input:      W       weighted undirected connection matrix
%
%   Output:     T       transitivity scalar
%
%   Reference: Rubinov M, Sporns O (2010) NeuroImage 52:1059-69
%              based on Onnela et al. (2005) Phys Rev E 71:065103
%
%
%   Mika Rubinov, UNSW, 2010

n = length(W);                                    %number of nodes
W_pos = threshold_absolute(W,0);
W_pos(1:n+1:end) = 0;
W_neg = threshold_absolute(W*-1,0);
W_neg(1:n+1:end) = 0;

K_pos = sum(W_pos ~= 0,2);
cyc3_pos = diag((W_pos.^(1/3))^3);
T_pos = sum(cyc3_pos)./sum((K_pos.*(K_pos-1)));       %transitivity

K_neg = sum(W_neg ~= 0,2);
cyc3_neg = diag((W_neg.^(1/3))^3);
T_neg = sum(cyc3_neg)./sum((K_neg.*(K_neg-1)));       %transitivity
