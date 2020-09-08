function [L vert] = ncubelap(n, cod, oln)
% Create cotan Laplacian matrix for [n]-cube
% INPUT:
% n    - dimension
% cod  - vertices encoding type; can be 'b' (binary), 'g' (Gray) or 'r' (random)
% oln  - optional parameter to account for negative semi-definite Laplacian 
% OUTPUT:
% L    - cotan Laplacian
% vert - array of vertices
%
% (c) Szymon £ukaszyk
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% email: szymon@patent.pl
% History
% v1:0 18.07.2020

olp = 1;
if nargin>=3 %olp
  olp = 0;
end

[L vert] = ncubedistmat(n, cod);

for i=1:size(L, 1)
  for j=1:size(L, 2)
    if( L(i,j) == 0 ) % fill diagonal with sum of 1 distances
      if( olp )
          L(i,j) = n;
      else
          L(i,j) = -n;
      end
    elseif( L(i,j) == 1 ) % leave 1 distances in place
      if( olp )
        L(i,j) = -1;              
      end
    elseif( L(i,j) ~= 1 ) % zero other distances
      L(i,j) = 0;
      %L(i,j) = -inf; % "elements that are not connected directly will need to be set to infinity or a suitable large value for the min-plus operations to work correctly. A zero in these locations will be incorrectly interpreted as an edge with no distance, cost, etc." [https://en.wikipedia.org/wiki/Distance_matrix]
    end
  end
end  

% [1]-cube has no triangulation at all and [2]-cube is the only triangulation with a boundary
% so maybe (?)
%if( n<=2)
%  L=L./2;
%end