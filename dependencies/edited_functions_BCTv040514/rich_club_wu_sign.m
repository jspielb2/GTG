function   [Rw_pos,Rw_neg] = rich_club_wu_sign(CIJ,varargin)
% Edited version of van den Heuvel's function (05/30/14 - Spielberg)
%       Now computed for positive and negative weights separately
%
%
% [Rw] = rich_club_wu(CIJ,varargin) % rich club curve for weighted graph
%
%
% inputs:
%               CIJ:       weighted connection matrix
%
%               optional:
%               k-level: max level of RC(k).
%               When k-level is not given, k-level will be set to max of degree of CIJ
%                
% output:
%               rich:         rich-club curve
%
% adopted from Opsahl et al. Phys Rev Lett, 2008, 101(16)
%  
% Martijn van den Heuvel, University Medical Center Utrecht, 2011
%
% For details see 'Rich club organization of the human connectome', Martijn van den Heuvel
% and Olaf Sporns, J Neuroscience 2011 31(44)
%
% =========================================================================




NofNodes = size(CIJ,2); %number of nodes
CIJ_pos = threshold_absolute(CIJ,0);
CIJ_pos(1:NofNodes+1:end) = 0;
CIJ_neg = threshold_absolute(CIJ*-1,0);
CIJ_neg(1:NofNodes+1:end) = 0;

NodeDegree_pos = sum((CIJ_pos ~= 0)); %define degree of each node
NodeDegree_neg = sum((CIJ_neg ~= 0)); %define degree of each node


%define to which level rc should be computed
if size(varargin,2) == 1
    klevel_pos = varargin{1};
    klevel_neg = klevel_pos;
elseif isempty(varargin)
   klevel_pos = max(NodeDegree_pos);
   klevel_neg = max(NodeDegree_neg);
else
    error('number of inputs incorrect. Should be [CIJ], or [CIJ, klevel]')
end


%wrank contains the ranked weights of the network, with strongest connections on top

wrank_pos = sort(CIJ_pos(:), 'descend');
wrank_neg = sort(CIJ_neg(:), 'descend');
    
%loop over all possible k-levels 
for kk = 1:klevel_pos
    SmallNodes_pos = find(NodeDegree_pos < kk);
    
    if isempty(SmallNodes_pos);
        Rw_pos(kk) = NaN;
        continue
    end
    
    %remove small nodes with NodeDegree<kk
    CutoutCIJ_pos = CIJ_pos;
    CutoutCIJ_pos(SmallNodes_pos,:) = [];
    CutoutCIJ_pos(:,SmallNodes_pos) = [];

    %total weight of connections in subset E>r
    Wr_pos = sum(CutoutCIJ_pos(:));

    %total number of connections in subset E>r
    Er_pos = length(find(CutoutCIJ_pos ~= 0));

    %E>r number of connections with max weight in network
    wrank_r_pos = wrank_pos(1:1:Er_pos);

    %weighted rich-club coefficient
    Rw_pos(kk) = Wr_pos/sum(wrank_r_pos);
end

%loop over all possible k-levels 
for kk = 1:klevel_neg
    SmallNodes_neg = find(NodeDegree_neg < kk);
    
    if isempty(SmallNodes_neg);
        Rw_neg(kk) = NaN;
        continue
    end
    
    %remove small nodes with NodeDegree<kk
    CutoutCIJ_neg = CIJ_neg;
    CutoutCIJ_neg(SmallNodes_neg,:) = [];
    CutoutCIJ_neg(:,SmallNodes_neg) = [];

    %total weight of connections in subset E>r
    Wr_neg = sum(CutoutCIJ_neg(:));

    %total number of connections in subset E>r
    Er_neg = length(find(CutoutCIJ_neg ~= 0));

    %E>r number of connections with max weight in network
    wrank_r_neg = wrank_neg(1:1:Er_neg);

    %weighted rich-club coefficient
    Rw_neg(kk) = Wr_neg/sum(wrank_r_neg);
end
