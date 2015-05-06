function [para r1 r2 maxleft maxright]=parafit(ax,tmp,f)
if nargin<3
	f=0;
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
if p(1)>0
	para=[p(1)/2 0 0];
else
	r1=0;
end
[p r2]=linearfit(tmp'-polyval(para,ax-ax(1)));
para=[para(1) p];

if (para(2)>0 && para(1) >0) || para(1)< 0.2
	para=[0 0 0];
	r1=0;
	[p r2]=linearfit(tmp'-polyval(para,ax-ax(1)));
	para=[para(1) p];
end

th=0.2;
if para(1) > 0
	axis=-para(2)/2/para(1)/(maxright-maxleft);
	if (axis<th || axis >1-th)
		para=[0 0 0];
		r1=0;
		[p r2]=linearfit(tmp'-polyval(para,ax-ax(1)));
		para=[para(1) p];
	end
end

if f==1
	ay=polyval(para,ax-ax(1));
	if r1>0
		plot(ax,ay,'r');
		r1=1;
	else
		plot(ax,ay,'g');
	end
end
