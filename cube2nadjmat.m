function [A vert]= cube2nadjmat(n, cod, kind)
% Adjacency matrix of 2^n-cube, {2^n}-cube, and [2^n]-cube
% INPUT:
% n    - dimension
% cod  - vertices encoding type; can be 'b' (binary) or 'g' (Gray)
% kind - cube kind; can be '2^n' (2^n-cube), '{2^n}' ({2^n}-cube), or '[2^n]' ([2^n]-cube)
% OUTPUT:
% A    - adjacency matrix
% vert - array of vertices
%
% (c) Szymon £ukaszyk
% email: szymon@patent.pl
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% History
% v1:0 01.08.2020

% cotan Laplacian is the basic template for adjacency matrix, giving all HD1 edges
% distance matrix won't work here as distances do not correspond to edges
[A vert] = cube2nlap(n, cod);

% zero non -1 entries of cotlap matrix; turn -1's into 1's 
for i=1:size(A, 1) % rows
  for j=1:size(A, 2) % cols
    if( A(i,j) >= 1 ) 
      A(i,j) = 0;
    end
    if( A(i,j) == -1 ) 
      A(i,j) = 1;
    end
  end
end   

% 2^n-cube
if strcmp(kind, '2^n')
  % there's nothing left to do
  return
end  

% convert addresses to Cartesians
cart = zeros(3^n, n);
for i=1:size(vert, 1)
  %cart(i,:) = vert2cart(i, n, cod);
  cart(i,:) = vert2cart(i, n);  % so far only binary
end

%vert = cart;
%return

D = pdist(cart, 'euclidean');  
D = squareform(D);

%A=D;
%return

% fajny myk, dla zaokraglania
% round(lm*10^12)/10^12

% [2^n]-cube
if strcmp(kind, '[2^n]')
  for i=1:size(D, 1) % rows
    for j=1:size(D, 2) % cols  
      % #### IS THIS CONDITION OK??
      if abs( D(i,j)-sqrt(2) ) < 10^-14   % only sqrt(2) edges allowed for [2^n]-cube
        D(i,j)=1;
      else
        D(i,j)=0;      
      end
    end
  end

  % combine with adjacency matrix of 2^n-cube
  A = A+D;
  return
end  

% {2^n}-cube
if strcmp(kind, '{2^n}')
  for i=1:size(D, 1) % rows
    for j=1:size(D, 2) % cols  
      for k=2:n
        if abs( D(i,j)-sqrt(k) ) < 10^-13   % only sqrt(k) edges, for k>0 are allowed for {2^n}-cube
          D(i,j)=1;
        end  
      end
    end
  end  
  for i=1:size(D, 1) % rows
    for j=1:size(D, 2) % cols  
      if D(i,j)~=1;      
         D(i,j)=0;
      end  
    end
  end
  A = A+D;
  for i=1:size(D, 1) % rows
    for j=1:size(D, 2) % cols  
      if A(i,j)==2;      
         A(i,j)=1;
      end  
    end
  end
  
  return

else
    error('Wrong kind parameter; can be ''2^n'', ''[2^n]'', ''{2^n}''');
end
