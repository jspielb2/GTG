function  [lambda_pos,lambda_neg,efficiency_pos,efficiency_neg,ecc_pos,ecc_neg,radius_pos,radius_neg,diameter_pos,diameter_neg] = charpath_sign(L)
% Edited version of Sporns et al.'s function (05/28/14 - Spielberg)
%       Now computed for positive and negative weights separately, and user
%       inputs a length matrix rather than distance
%
%
%CHARPATH       Characteristic path length, global efficiency and related statistics
%
%   lambda = charpath(L);
%   [lambda,efficiency] = charpath(L);
%   [lambda,efficiency,ecc,radius,diameter] = charpath(L);
%
%   The characteristic path length is the average shortest path length in 
%   the network. The global efficiency is the average inverse shortest path
%   length in the network.
%
%   Input:      L,              length matrix (NOTE: different from Sporn's
%                                                    original function)
%
%   Outputs:    lambda,         characteristic path length
%               efficiency,     global efficiency
%               ecc,            eccentricity (for each vertex)
%               radius,         radius of graph
%               diameter,       diameter of graph
%
%   Notes:
%       Characteristic path length is calculated as the global mean of 
%   the distance matrix D, excludings any 'Infs' but including distances on
%   the main diagonal.
%
%
%   Olaf Sporns, Indiana University, 2002/2007/2008
% Modification, 2010 (Mika Rubinov): incorporation of global efficiency


D_pos = distance_wei(threshold_absolute(L,0));
D_neg = distance_wei(threshold_absolute((L*-1),0));

% Mean of finite entries of D(G)
lambda_pos = sum(sum(D_pos(D_pos ~= Inf)))/length(nonzeros(D_pos ~= Inf));
lambda_neg = sum(sum(D_neg(D_neg ~= Inf)))/length(nonzeros(D_neg ~= Inf));

% Eccentricity for each vertex (note: ignore 'Inf') 
ecc_pos = max(D_pos.*(D_pos ~= Inf),[],2);
ecc_neg = max(D_neg.*(D_neg ~= Inf),[],2);

% Radius of graph
radius_pos = min(ecc_pos);  % but what about zeros?
radius_neg = min(ecc_neg);  % but what about zeros?

% Diameter of graph
diameter_pos = max(ecc_pos);
diameter_neg = max(ecc_neg);


% Efficiency: mean of inverse entries of D(G)
n = size(D_pos,1);
D_pos = 1./D_pos;                           %invert distance
D_neg = 1./D_neg;                           %invert distance
D_pos(1:n+1:end) = 0;                   %set diagonal to 0
D_neg(1:n+1:end) = 0;                   %set diagonal to 0
efficiency_pos = sum(D_pos(:))/(n*(n-1));   %compute global efficiency
efficiency_neg = sum(D_neg(:))/(n*(n-1));   %compute global efficiency
