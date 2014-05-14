function [r] = corrn(X1,X2)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 02.04.14
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

if (~isa(X1,'double'))
    X1 = double(X1);
end

if (~isa(X2,'double'))
    X2 = double(X2);
end

X1 = X1 - mean(X1(:));
X2 = X2 - mean(X2(:));
X11prod = X1.*X1;
X22prod = X2.*X2;
X12prod = X1.*X2;
r = sum(X12prod(:))/sqrt(sum(X11prod(:))*sum(X22prod(:)));
