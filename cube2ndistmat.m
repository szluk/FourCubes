function [D vert]= cube2ndistmat(n)
% Create distance matrix for {2^n}-cube
% INPUT:
% n    - dimension
% OUTPUT:
% D    - distance matrix
% vert - array of vertices
%
% (c) Szymon £ukaszyk
% email: szymon@patent.pl
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% History
% v1:0 31.07.2020

d3n  = 3^n;

% create array of vertices coordinates
% 3^n rows, n columns
vert = zeros(d3n, n);

% recursion level
lvl = 0;

% central vertex
cvrt = floor(d3n/2)+1;

% central vertex address
cvrtad =zeros(1,n);

% walk recursively through vertices starting from the central one to get their addresses
[vert] = do2vert(vert, cvrt, n, 0, lvl, cvrtad);

% calculate Hamming distances between vertices
D = size(vert,2)*pdist(vert, 'hamming');

% convert vector to distance matrix
D = squareform(D);

return
