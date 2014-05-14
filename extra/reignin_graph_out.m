function [outmats] = reignin_graph_out(inmats,maxval)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 12.16.13
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

maxval = abs(maxval);
minval = -maxval;

zmats = rdivide(minus(inmats,repmat(mean(inmats,3),[1,1,size(inmats,3)])),repmat(std(inmats,0,3),[1,1,size(inmats,3)]));
high_outliers = logical(zmats > maxval);
low_outliers  = logical(zmats < minval);

newhighvals = times(plus((high_outliers.*maxval),repmat(mean(inmats,3),[1,1,size(inmats,3)])),repmat(std(inmats,0,3),[1,1,size(inmats,3)]));
newlowvals  = times(plus((low_outliers.*minval),repmat(mean(inmats,3),[1,1,size(inmats,3)])),repmat(std(inmats,0,3),[1,1,size(inmats,3)]));

outmats = inmats;
outmats(high_outliers) = newhighvals(high_outliers);
outmats(low_outliers)  = newlowvals(low_outliers);
