function [r] = corr_cell(X1,X2)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 02.20.14
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if any(size(X1) ~= size(X2))
    error('X1 and X2 must be the same size');
end

vect_length = cumprod(size(X1));
X1 = reshape(X1,vect_length(end),1);
X2 = reshape(X2,vect_length(end),1);

for currcell = size(X1,1):-1:1
    currX1 = X1{currcell};
    currX2 = X2{currcell};
    
    if (~isa(currX1,'double'))
        currX1 = double(currX1);
    end
    
    if (~isa(currX2,'double'))
        currX2 = double(currX2);
    end
    
    notnan = logical(~isnan(currX1).*~isnan(currX2));
    currX1 = currX1(notnan);
    currX2 = currX2(notnan);
    
    if length(currX1) > 1
        currX1 = currX1 - mean(currX1(:));
        currX2 = currX2 - mean(currX2(:));
    end
    X11prod(currcell) = sum(currX1(:).*currX1(:));
    X22prod(currcell) = sum(currX2(:).*currX2(:));
    X12prod(currcell) = sum(currX1(:).*currX2(:));
end

r = sum(X12prod(:))/sqrt(sum(X11prod(:))*sum(X22prod(:)));
