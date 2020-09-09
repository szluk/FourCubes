function [A vert]= ncubeadjmat(n, cod, kind)
% Adjacency matrix of n-cube, {n}-cube, and [n]-cube
% INPUT:
% n    - dimension
% cod  - vertices encoding type; can be 'b' (binary), 'g' (Gray) or 'r' (random)
% kind - cube kind; can be 'n' (n-cube), '{n}' ({n}-cube), '[n]' ([n]-cube, both diagonals), '[no]' ([n]-cube, odd diagonals), '[ne]' ([n]-cube, even diagonals)
% OUTPUT:
% A    - adjacency matrix
% vert - array of vertices
%
% (c) Szymon £ukaszyk
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% email: szymon@patent.pl
% History
% v1:0 01.08.2020
% 

[A vert] = ncubedistmat(n, cod);

switch kind
  case 'n' % only 0 and 1 Hamming distances allowed
    for i=1:size(A, 1) %rows
      for j=1:size(A, 2) %cols
        if( A(i,j) > 1 ) 
          A(i,j) = 0;
        end
      end
    end   
  case '{n}' % all Hamming distances allowed
    for i=1:size(A, 1) %rows
      for j=1:size(A, 2) %cols
        if( A(i,j) > 1 ) 
          A(i,j) = 1;
        end
      end
    end   
  case {'[n]', '[no]', '[ne]'} % only 0, 1 and 2 Hamming distances allowed
    for i=1:size(A, 1) %rows
      for j=1:size(A, 2) %cols
        if( A(i,j) > 2 ) 
          A(i,j) = 0;
        end
        if (A(i,j) == 2)
          switch kind        
            case '[ne]'     % 2, 4, 6, 8,... vertices in Gray encoding         
              if ~(rem(i,2))
                A(i,j) = 1;
              else
                A(i,j) = 0;
              end
            case '[no]'      % 1, 3, 5, 7,... vertices in Gray encoding
              if (rem(i,2))
                A(i,j) = 1;
              else
                A(i,j) = 0;
              end
            case '[n]' % both 2-face diagonals allowed
              A(i,j) = 1;
            otherwise
              error('I should not be here.');     
          end
        end
      end
    end  
  otherwise
    error('Wrong kind parameter; can be ''n'' (n-cube), ''{n}'' ({n}-cube), ''[n]'' ([n]-cube, both), ''[no]'' ([n]-cube, odd), ''[ne]'' ([n]-cube, even)');
end
