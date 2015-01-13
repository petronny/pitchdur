function [base1 base2]=baseline(ax,tmp,p,f)
if nargin<4
	f=1;
end

base1=0;
base2=0;

[maxleft maxright]=exact_match(tmp);
if maxright-maxleft+1<5
	return
end

tmp=tmp(maxleft:maxright);
ax=ax(maxleft:maxright);

[in_x,in_y]=find_inlier(tmp,p);

base1=min(in_y);
base2=max(in_y);

if f==1
	ay=ones(1,maxright-maxleft+1)*base1;
	plot(ax,ay,'r');
	ay=ones(1,maxright-maxleft+1)*base2;
	plot(ax,ay,'b');
end
