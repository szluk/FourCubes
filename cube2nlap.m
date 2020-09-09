function [C2nL vert] = cube2nlap(n, cod)
% Create cotan Laplacian matrix for [2^n]-cube 
% INPUT:
% n    - dimension
% cod  - vertices encoding type; can be 'b' (binary) or 'g' (Gray)
% OUTPUT:
% C2nL - [2^n]-cube cotan Laplacian
% vert - array of vertices
%
% (c) Szymon £ukaszyk
% email: szymon@patent.pl
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% History
% v1:0 03.07.2020 (binary and Gray encoding)
%% It's surely not optimal

if (cod ~= 'b') && (cod ~= 'g')
  error('Wrong encoding type') 
end

d3n  = 3^n; % size of the Laplacian

% create cotan Laplacian template
C2nL = zeros(d3n, d3n);

% fill in upper triangular part
% works OK
if cod == 'b'
  for k=0:n-1    
    seq_n   = 2*(3^k);  % number of -1's in sequence
    brk_n   = 3^k;      % number of 0's (breaks) before next sequence starts
    seq_idx = 1;        % sequence index
    brk_idx = 0;        % break index
    for r=1:d3n
      cc = 3^k+r;
      if (seq_idx <= seq_n)  && (~brk_idx)
        if cc<= d3n %final check
          C2nL(r,cc)=-1;
        end
        seq_idx = seq_idx+1;
        brk_idx = 0;      
      else %reset seq_idx & increment brk_idx 
        seq_idx = 1;
        brk_idx = brk_idx+1;            
      end
      if brk_idx == brk_n
        brk_idx = 0;
      end
    end
  end
  %for d=0:2^n-1
  %  g = de2bi(d, n, 'left-msb');
  %  vert(d+1,:) = g;
  %end

% works ok
elseif cod == 'g'
  % 2nd diagonal
  for r=1:d3n-1
     C2nL(r, r+1) = -1; 
  end
  
  % upper exchange matrices
  for k=1:n-1
    J = -rot90(eye(3^k));
    for r=1:3^k:d3n-3^k
      %disp(sprintf('k: %d, r: %d, c: %d', k, r, r+3))
      C2nL(r:r+3^k-1, r+3^k:r+3^k+3^k-1) = J;
    end
  end
end

% for both encodings
% fill in lower triangular part
C2nL = C2nL + C2nL';

% fill in diagonal entries
for r=1:d3n
  cnt(r) = 0;
  for c=1:d3n
    if C2nL(r,c) == -1;
      cnt(r) = cnt(r)+1;
    end
  end
end

for r=1:d3n
  for c=1:d3n
    if r==c
      C2nL(r,c) = cnt(r);
    end
  end
end

% create array of vertices coordinates
% 3^n rows, n columns
vert = zeros(d3n, n);
%vert = ones(d3n, n);

stamp =-1*ones(1,n);

% recursion level
lvl = 0;

% central vertex
c = floor(d3n/2)+1;

% go recursive through vertices starting from the central one to get their addresses
[vert] = do2vert(vert, c, n, 0, lvl, stamp);

for i=1:size(vert, 1)
  for k=1:size(vert, 2)
    if vert(i, k) == -1  
      vert(i, k) = 0;  
    end
  end
end

return
