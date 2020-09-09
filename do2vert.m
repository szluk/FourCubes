function [vadin] = do2vert(vadin, v, n, ids, lvl, stamp)
% Recursion through vertices of [2^n]-cube; called from cube2nlap.m
% INPUT:
% vadin - input array of vertices addresses
% v     - starting vertex (index) to propagate from
% n     - dimension
% ids   - starting index (denominator of 3^ids) ids=0,1,...,n-1
% lvl   - recursion level
% stamp - address stamp (address of a vertex in the upper level)
% OUTPUT:
% vadin - output array of vertices addresses
%
% (c) Szymon £ukaszyk
% email: szymon@patent.pl
% licensed under a Creative Commons Attribution-ShareAlike 2.0 Generic License.
% History
% v1:0 31.07.2020

lvl = lvl+1;
for k=ids:n-1
  for s=1:2

    sgn = +1;
    if s==1
      sgn = -1;
    end

    idx = v + sgn*(3^k);   % "-" direction for -1 (s=1), "+" direction for +1 (s=2) 

    %if lvl~=n
    %  strinfo = sprintf('ids=%d, lvl=%d, n-k=%d,  sgn=%d, idx=%d', ids, lvl, n-k, sgn, idx);
    %  disp(strinfo);
    %  stamp
    %end

    if lvl==n
      vadin(idx, :) = 1;
    
    else % lvl = 1:n-1
      vadin(idx,:) = stamp;      
      vadin(idx, n-k) = 1;
    end

    if k+1 < n
      [vadin] = do2vert(vadin, idx, n, k+1, lvl, vadin(idx,:));
    end

  end
end
