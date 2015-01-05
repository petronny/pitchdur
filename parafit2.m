function [para maxleft maxright]=parafit2(ax,tmp,f)
if nargin<3
	f=1;
end

para=[0];

[maxleft maxright]=exact_match(tmp);
if maxright-maxleft+1<5
	return
end

tmp=tmp(maxleft:maxright);
ax=ax(maxleft:maxright);

x=ax-ax(1);
y=tmp';
xin=x;
yin=y;
out=[];
pout=[1];
count=0;
while ~(length(out)==0&&length(pout)==0)&&(length(out)~=length(pout) || max(pout-out)~=0) && count<40;
	count=count+1;
	pout=out;
	out=find_outlier(y-polyval(polyfit(xin,yin,2),x));
	xin=[];
	yin=[];
	for j=1:length(out)
	end
	for j=1:length(x)
		if ~any(out==j)
			xin=[xin x(j)];
			yin=[yin y(j)];
		end
	end
end

para=polyfit(xin,yin,2);

if f==1
	ay=polyval(para,xin);
	plot(xin+ax(1),ay,'r');
end
