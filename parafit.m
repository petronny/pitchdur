function [para r1 r2 maxleft maxright]=parafit(ax,tmp,f)
if nargin<3
	f=1;
end

para=[0 0 0];
r1=0;
r2=0;

[maxleft maxright]=exact_match(tmp);
if maxright-maxleft+1<5
	return
end

tmp=tmp(maxleft:maxright);
ax=ax(maxleft:maxright);

[p r1]=linearfit(gen_derivative(tmp,0));
para=[p(1)/2 0 0];
[p r2]=linearfit(tmp'-polyval(para,ax-ax(1)));
para=[para(1) p];

if f==1
	ay=polyval(para,ax-ax(1));
	plot(ax,ay,'r');
end
