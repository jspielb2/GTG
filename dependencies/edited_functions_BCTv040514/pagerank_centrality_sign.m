function [r_pos,r_neg] = pagerank_centrality_sign(A,d,falff)
% Edited version of Zuo & Betzel's function (05/28/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%PAGERANK_CENTRALITY       PageRank centrality
%
%   r = pagerank_centrality(A, d, falff)
%
%   The PageRank centrality is a variant of eigenvector centrality. This
%   function computes the PageRank centrality of each vertex in a graph.
%
%   Formally, PageRank is defined as the stationary distribution achieved
%   by instantiating a Markov chain on a graph. The PageRank centrality of
%   a given vertex, then, is proportional to the number of steps (or amount
%   of time) spent at that vertex as a result of such a process. 
%
%   The PageRank index gets modified by the addition of a damping factor,
%   d. In terms of a Markov chain, the damping factor specifies the
%   fraction of the time that a random walker will transition to one of its
%   current state's neighbors. The remaining fraction of the time the
%   walker is restarted at a random vertex. A common value for the damping
%   factor is d = 0.85.
%
%   Inputs:     A,      adjacency matrix
%               d,      damping factor
%           falff,      initial page rank probability (non-negative)
%
%   Outputs:    r,      vectors of page rankings
%
%   Note: The algorithm will work well for smaller matrices (number of
%   nodes around 1000 or less) 
%
%   References:
%
%   [1]. GeneRank: Using search engine technology for the analysis of
%   microarray experiments, by Julie L. Morrison, Rainer Breitling, Desmond
%   J. Higham and David R. Gilbert, BMC Bioinformatics, 6:233, 2005.
% 	[2]. Boldi P, Santini M, Vigna S (2009) PageRank: Functional
% 	dependencies. ACM Trans Inf Syst 27, 1-23.
%
%   Xi-Nian Zuo, Institute of Psychology, Chinese Academy of Sciences, 2011
%   Rick Betzel, Indiana University, 2012

N = size(A,1);
A_pos = threshold_absolute(A,0);
A_pos(1:N+1:end) = 0;
A_neg = threshold_absolute(A*-1,0);
A_neg(1:N+1:end) = 0;

if nargin < 3
    norm_falff = ones(N,1)/N;
else
    falff = abs(falff);
    norm_falff = falff/sum(falff);
end

deg_pos = sum(A_pos);
ind_pos = (deg_pos == 0);
deg_pos(ind_pos) = 1;
D1_pos = zeros(N);
D1_pos(1:(N+1):end) = 1./deg_pos;
B_pos = eye(N) - d*(A_pos*D1_pos);
b = (1-d)*norm_falff;
r_pos = B_pos\b;
r_pos = r_pos/sum(r_pos);

deg_neg = sum(A_neg);
ind_neg = (deg_neg == 0);
deg_neg(ind_neg) = 1;
D1_neg = zeros(N);
D1_neg(1:(N+1):end) = 1./deg_neg;
B_neg = eye(N) - d*(A_neg*D1_neg);
b = (1-d)*norm_falff;
r_neg = B_neg\b;
r_neg = r_neg/sum(r_neg);
