function [D vert]= ncubedistmat(n, cod)
% Create distance matrix for {n}-cube
% INPUT:
% n    - dimension
% cod  - vertices encoding type; can be 'b' (binary), 'g' (Gray) or 'r' (random)
% OUTPUT:
% D    - distance matrix
% vert - array of vertices
%
% (c) Szymon £ukaszyk
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% email: szymon@patent.pl
% History
% v1:0 18.07.2020

if (cod ~= 'b') && (cod ~= 'g') && (cod ~= 'r')
  error('Wrong encoding type') 
end

% create array of vertices coordinates
% 2^n rows, n columns
vert = zeros(2^n, n);
for d = 0:2^n-1
    % fill in vertex with binary code
    %g = de2bi(d, n);
    g = de2bi(d, n, 'left-msb');
    if cod == 'g'
      %convert binary code to Gray code
      g = bin2gray_n(g);
    end
    vert(d+1,:) = g;
end

if cod == 'r'
  vert = vert(randperm(size(vert, 1)), :);
end

% calculate Hamming distances between vertices
D = size(vert,2)*pdist(vert, 'hamming');

% convert vector to distance matrix
D = squareform(D);
