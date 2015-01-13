function base=baseline(ax,tmp,p,f)
if nargin<4
	f=1;
end

base=0;

[maxleft maxright]=exact_match(tmp);
if maxright-maxleft+1<5
	return
end

tmp=tmp(maxleft:maxright);
ax=ax(maxleft:maxright);

[in_x,in_y]=find_inlier(tmp,p);

base=max(in_y);

if f==1
	ay=ones(1,maxright-maxleft+1)*base;
	plot(ax,ay,'r');
end
