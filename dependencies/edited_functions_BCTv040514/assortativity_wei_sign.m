function [r_pos,r_neg] = assortativity_wei_sign(CIJ)
% Edited version of Sporns et al.'s function (05/28/14 - Spielberg)
%       Now computed for positive and negative weights separately
%       (directionality calpability removed)
%
%
%ASSORTATIVITY      Assortativity coefficient
%
%   r = assortativity_wei(CIJ,flag);
%
%   The assortativity coefficient is a correlation coefficient between the
%   strengths (weighted degrees) of all nodes on two opposite ends of a link.
%   A positive assortativity coefficient indicates that nodes tend to link to
%   other nodes with the same or similar strength.
%
%   Inputs:     CIJ,    weighted directed/undirected connection matrix
%
%   Outputs:    r,      assortativity coefficient
%
%   Reference:  Newman (2002) Phys Rev Lett 89:208701
%               Foster et al. (2010) PNAS 107:10815–10820
%
%   Olaf Sporns, Indiana University, 2007/2008
%   Vassilis Tsiaras, University of Crete, 2009
%   Murray Shanahan, Imperial College London, 2012
%   Mika Rubinov, University of Cambridge, 2012

[str_pos,str_neg] = strengths_und_sign(CIJ);
[i_pos,j_pos] = find(triu(CIJ,1)>0);
[i_neg,j_neg] = find(triu(CIJ,1)<0);
K_pos = length(i_pos);
K_neg = length(i_neg);
stri_pos = str_pos(i_pos);
strj_pos = str_pos(j_pos);
stri_neg = str_neg(i_neg);
strj_neg = str_neg(j_neg);

% compute assortativity
r_pos = (sum(stri_pos.*strj_pos)/K_pos-(sum(0.5*(stri_pos+strj_pos))/K_pos)^2)/ ...
    (sum(0.5*(stri_pos.^2+strj_pos.^2))/K_pos-(sum(0.5*(stri_pos+strj_pos))/K_pos)^2);
r_neg = (sum(stri_neg.*strj_neg)/K_neg-(sum(0.5*(stri_neg+strj_neg))/K_neg)^2)/ ...
    (sum(0.5*(stri_neg.^2+strj_neg.^2))/K_neg-(sum(0.5*(stri_neg+strj_neg))/K_neg)^2);
