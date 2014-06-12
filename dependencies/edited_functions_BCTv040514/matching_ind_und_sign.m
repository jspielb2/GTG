function [M0_pos,M0_neg] = matching_ind_und_sign(CIJ)
% Edited version of Betzel's function (05/30/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
%MATCHING_IND_UND       matching index
%
%   M0 = MATCHING_IND_UND(CIJ) computes matching index for undirected
%   graph specified by adjacency matrix CIJ. Matching index is a measure of
%   similarity between two nodes' connectivity profiles (excluding their
%   mutual connection, should it exist).
%
%   Inputs:     CIJ,    undirected adjacency matrix
%
%   Outputs:    M0,     matching index matrix.
%
%   Richard Betzel, Indiana University, 2013
%
n = length(CIJ);                                    %number of nodes
CIJ_pos = threshold_absolute(CIJ,0);
CIJ_pos(1:n+1:end) = 0;
CIJ_neg = threshold_absolute(CIJ*-1,0);
CIJ_neg(1:n+1:end) = 0;

CIJ0_pos = CIJ_pos;
K_pos = sum(CIJ0_pos);
R_pos = K_pos ~= 0;
N_pos = sum(R_pos);
CIJ_pos = CIJ0_pos(R_pos,R_pos);
I_pos = ~eye(N_pos);
M_pos = zeros(N_pos,N_pos);
for i = 1:N_pos
    c1_pos = CIJ_pos(i,:);
    use_pos = bsxfun(@or,c1_pos,CIJ_pos);
    use_pos(:,i) = 0;
    use_pos = use_pos.*I_pos;
    
    ncon1_pos = bsxfun(@times,use_pos,c1_pos);
    ncon2_pos = bsxfun(@times,use_pos,CIJ_pos);
    ncon_pos = sum(ncon1_pos+ncon2_pos,2);
    
    M_pos(:,i) = 2*sum(ncon1_pos & ncon2_pos,2)./ncon_pos;
end
M_pos = M_pos.*I_pos;
M_pos(isnan(M_pos)) = 0;
M0_pos = zeros(size(CIJ0_pos));
M0_pos(R_pos,R_pos) = M_pos;

CIJ0_neg = CIJ_neg;
K_neg = sum(CIJ0_neg);
R_neg = K_neg ~= 0;
N_neg = sum(R_neg);
CIJ_neg = CIJ0_neg(R_neg,R_neg);
I_neg = ~eye(N_neg);
M_neg = zeros(N_neg,N_neg);
for i = 1:N_neg
    c1_neg = CIJ_neg(i,:);
    use_neg = bsxfun(@or,c1_neg,CIJ_neg);
    use_neg(:,i) = 0;
    use_neg = use_neg.*I_neg;
    
    ncon1_neg = bsxfun(@times,use_neg,c1_neg);
    ncon2_neg = bsxfun(@times,use_neg,CIJ_neg);
    ncon_neg = sum(ncon1_neg+ncon2_neg,2);
    
    M_neg(:,i) = 2*sum(ncon1_neg & ncon2_neg,2)./ncon_neg;
end
M_neg = M_neg.*I_neg;
M_neg(isnan(M_neg)) = 0;
M0_neg = zeros(size(CIJ0_neg));
M0_neg(R_neg,R_neg) = M_neg;

