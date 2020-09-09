function [cart]= vert2cart(m, n)
% Convert binary encoded address of a vertex 
% of 2^n cube into Cartesian coordinates
% INPUT:
% m    - vertex (index)
% n    - dimension
% OUTPUT:
% cart - Cartesian coordinates
%
% (c) Szymon £ukaszyk
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% email: szymon@patent.pl
% History
% v1:0 04.09.2020
% only binary encoding is implemented
% amd it doesn't look like a good coding now

% central vertex
cvrt = floor(3^n/2)+1;

% initialise coordinates
cart = zeros(1,n);

% m                               n=3
% k=n-1                           k=2
% m>cvrt => m=m-3^k & sgn = +1    cvrt=14
% m<cvrt => m=m+3^k & sgn = -1
% m=cvrt => break

% |cvrt-m|<=3^k => cart(i) = sgn, next k
% |cvrt-m|>3^k  => revert m, next k

% binary
% 19 [111]
% 19>14 => 19-3^2=10; |14-10|=4<=4 => +1 as (-), k=2; lim(2)=4 -> lim(3)=4
% 10<14 => 10+3^1=13; |14-13|=1<=1 => -1 as (+), k=1; lim(1)=1 -> lim(2)=1
% 13<14 => 13+3^0=14; |14-14|=0<=0 => -1 as (+), k=0; lim(0)=0 -> lim(1)=0
% [1, -1, -1]

% 2 [110]
% 2<14  => 2+9 =11;   |14-11|=3<=4 => -1 as (+)
% 11<14 => 11+3=14;   |14-14|=0<=1 => -1 as (+)
% 14=14 => break
% [-1, -1, 0]

% 9 [111]
% 9<14  => 9+9=18;    |14-18|=4<=4 => -1 as (+)
% 18>14 => 18-3=15;   |14-15|=1<=1 => +1 as (-)
% 15>14 => 15-1=14;   |14-14|=0<=0 => +1 as (-)
% [-1, 1, 1]

% 13 [001]
% 13<14 => 13+9=22;   |14-22|=8>4  => (0)
%          13+3=16;   |14-16|=2>1  => (0)
%          13+1=14;   |14-14|=0<=0 => -1 as (+)
% [0, 0, -1]

% 17 [010]
% 17>14 => 17-9=8;     |14-8|=6>4  => (0)
%          17-3=14;    |14-14|=0<=1=> +1 as (-)
% 14=14 => break
% [0, 1, 0]

% lim=[0,1,4,13,40,121,...]
lim(1) = 0;
for k=1:n-1
  lim(k+1) = lim(k)+3^(k-1);
end

i = 1; d = m;
for k=n-1:-1:0  % n=3 <=> k=2,1,0
  d_old = d;
  if d>cvrt
    d = d-3^k;     sgn = 1;
  elseif d<cvrt
    d = d+3^k;     sgn = -1;    
  else % d==cvrt
    break % we have reached the central vertex
  end
  if ( abs(cvrt-d) <= lim(k+1) )
    cart(i) = sgn;
  else
    d = d_old;
  end
  i=i+1;
end
