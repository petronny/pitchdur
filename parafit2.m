function [para maxleft maxright]=parafit2(ax,tmp,f)
if nargin<3
	f=1;
end

para=[0];

len=0;
maxlen=0;
maxleft=0;
maxright=0;
for i=1:length(ax)
	if tmp(i)~=0 && len==0
		left=i;
		len=1;
	end
	if tmp(i)==0 && len~=0
		if maxlen<len
			maxlen=len;
			maxleft=left;
			maxright=i-1;
			len=0;
		end
	end
	if i==length(ax) && len~=0
		if maxlen<len
			maxlen=len;
			maxleft=left;
			maxright=i;
			len=0;
		end
	end
	if tmp(i)~=0 && len~=0
		len=len+1;
	end
end

if maxlen<5
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
while (length(out)~=length(pout) || max(pout-out)~=0) && count <20;
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
