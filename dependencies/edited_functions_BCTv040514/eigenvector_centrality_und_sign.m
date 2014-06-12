function   [v_pos,v_neg] = eigenvector_centrality_und_sign(CIJ)
% Edited version of Zuo & Betzel's function (05/28/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%EIGENVECTOR_CENTRALITY_UND      Spectral measure of centrality
%
%   v = eigenvector_centrality_und_sign(CIJ)
%
%   Eigenector centrality is a self-referential measure of centrality:
%   nodes have high eigenvector centrality if they connect to other nodes
%   that have high eigenvector centrality. The eigenvector centrality of
%   node i is equivalent to the ith element in the eigenvector 
%   corresponding to the largest eigenvalue of the adjacency matrix.
%
%   Inputs:     CIJ,        binary/weighted undirected adjacency matrix.
%
%   Outputs:      v,        eigenvector associated with the largest
%                           eigenvalue of the adjacency matrix CIJ.
%
%   Reference: Newman, MEJ (2002). The mathematics of networks.
%
%   Xi-Nian Zuo, Chinese Academy of Sciences, 2010
%   Rick Betzel, Indiana University, 2012


n = length(CIJ);
CIJ_pos = threshold_absolute(CIJ,0);
CIJ_pos(1:n+1:end) = 0;
CIJ_neg = threshold_absolute(CIJ*-1,0);
CIJ_neg(1:n+1:end) = 0;

if n < 1000
    [V_pos,~] = eig(CIJ_pos);
    ec_pos = abs(V_pos(:,n));
else
    [V_pos,~] = eigs(sparse(CIJ_pos));
    ec_pos = abs(V_pos(:,1));
end
v_pos = reshape(ec_pos,length(ec_pos),1);

if n < 1000
    [V_neg,~] = eig(CIJ_neg);
    ec_neg = abs(V_neg(:,n));
else
    [V_neg,~] = eigs(sparse(CIJ_neg));
    ec_neg = abs(V_neg(:,1));
end
v_neg = reshape(ec_neg,length(ec_neg),1);