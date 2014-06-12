function [E_pos,E_neg] = efficiency_wei_sign(W,local)
% Edited version of Rubinov's function (05/30/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%EFFICIENCY_WEI     Global efficiency, local efficiency.
%
%   Eglob = efficiency_wei(W);
%   Eloc = efficiency_wei(W,1);
%
%   The global efficiency is the average of inverse shortest path length,
%   and is inversely related to the characteristic path length.
%
%   The local efficiency is the global efficiency computed on the
%   neighborhood of the node, and is related to the clustering coefficient.
%
%   Inputs:     W,              weighted undirected or directed connection matrix
%                               (all weights in W must be between 0 and 1)
%               local,          optional argument
%                                   local=0 computes global efficiency (default)
%                                   local=1 computes local efficiency
%
%   Output:     Eglob,          global efficiency (scalar)
%               Eloc,           local efficiency (vector)
%
%   Notes:
%       The  efficiency is computed using an auxiliary connection-length
%   matrix L, defined as L_ij = 1/W_ij for all nonzero L_ij; This has an
%   intuitive interpretation, as higher connection weights intuitively
%   correspond to shorter lengths.
%       The weighted local efficiency broadly parallels the weighted
%   clustering coefficient of Onnela et al. (2005) and distinguishes the
%   influence of different paths based on connection weights of the
%   corresponding neighbors to the node in question. In other words, a path
%   between two neighbors with strong connections to the node in question
%   contributes more to the local efficiency than a path between two weakly
%   connected neighbors. Note that this weighted variant of the local
%   efficiency is hence not a strict generalization of the binary variant.
%
%   Algorithm:  Dijkstra's algorithm
%
%   References: Latora and Marchiori (2001) Phys Rev Lett 87:198701.
%               Onnela et al. (2005) Phys Rev E 71:065103
%               Fagiolo (2007) Phys Rev E 76:026107.
%               Rubinov M, Sporns O (2010) NeuroImage 52:1059-69
%
%
%   Mika Rubinov, U Cambridge, 2011-2012

%Modification history
% 2011: Original (based on efficiency.m and distance_wei.m)
% 2013: Local efficiency generalized to directed networks

n = length(W);                                    %number of nodes
W_pos = threshold_absolute(W,0);
W_pos(1:n+1:end) = 0;
W_neg = threshold_absolute(W*-1,0);
W_neg(1:n+1:end) = 0;

L_pos = W_pos;
A_pos = W_pos ~= 0;
ind_pos = L_pos ~= 0;
L_pos(ind_pos) = 1./L_pos(ind_pos);                             %connection-length matrix

L_neg = W_neg;
A_neg = W_neg ~= 0;
ind_neg = L_neg ~= 0;
L_neg(ind_neg) = 1./L_neg(ind_neg);                             %connection-length matrix

if exist('local','var') && local                %local efficiency
    E_pos = zeros(n,1);
    E_neg = zeros(n,1);
    for u = 1:n
        V_pos = find(A_pos(u,:) | A_pos(:,u).');                %neighbors
        V_neg = find(A_neg(u,:) | A_neg(:,u).');                %neighbors
        sw_pos = W_pos(u,V_pos).^(1/3)+W_pos(V_pos,u).^(1/3).';       %symmetrized weights vector
        sw_neg = W_neg(u,V_neg).^(1/3)+W_neg(V_neg,u).^(1/3).';       %symmetrized weights vector
        e_pos = distance_inv_wei(L_pos(V_pos,V_pos));             %inverse distance matrix
        e_neg = distance_inv_wei(L_neg(V_neg,V_neg));             %inverse distance matrix
        se_pos = e_pos.^(1/3)+e_pos.'.^(1/3);                 %symmetrized inverse distance matrix
        se_neg = e_neg.^(1/3)+e_neg.'.^(1/3);                 %symmetrized inverse distance matrix
        numer_pos = (sum(sum((sw_pos.'*sw_pos).*se_pos)))/2;      %numerator
        numer_neg = (sum(sum((sw_neg.'*sw_neg).*se_neg)))/2;      %numerator
        if numer_pos ~= 0
            sa_pos = A_pos(u,V_pos)+A_pos(V_pos,u).';                 %symmetrized adjacency vector
            denom_pos = sum(sa_pos).^2-sum(sa_pos.^2);      %denominator
            E_pos(u) = numer_pos/denom_pos;                   %local efficiency
        end
        if numer_neg ~= 0
            sa_neg = A_neg(u,V_neg)+A_neg(V_neg,u).';                 %symmetrized adjacency vector
            denom_neg = sum(sa_neg).^2-sum(sa_neg.^2);      %denominator
            E_neg(u) = numer_neg/denom_neg;                   %local efficiency
        end
    end
else
    e_pos = distance_inv_wei(L_pos);
    e_neg = distance_inv_wei(L_neg);
    E_pos = sum(e_pos(:))./(n^2-n);                       %global efficiency
    E_neg = sum(e_neg(:))./(n^2-n);                       %global efficiency
end


function D = distance_inv_wei(W_)

n_ = length(W_);
D = inf(n_);                                      %distance matrix
D(1:n_+1:end) = 0;

for u = 1:n_
    S = true(1,n_);                               %distance permanence (true is temporary)
    W1_ = W_;
    V = u;
    while 1
        S(V) = 0;                                 %distance u->V is now permanent
        W1_(:,V) = 0;                             %no in-edges as already shortest
        for v = V
            T = find(W1_(v,:));                   %neighbours of shortest nodes
            D(u,T) = min([D(u,T);D(u,v)+W1_(v,T)]);%smallest of old/new path lengths
        end
        
        minD = min(D(u,S));
        if isempty(minD) || isinf(minD),          %isempty: all nodes reached;
            break,                              %isinf: some nodes cannot be reached
        end;
        
        V = find(D(u,:) == minD);
    end
end

D = 1./D;                                         %invert distance
D(1:n_+1:end) = 0;
