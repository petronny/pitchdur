function [para r1 r2 maxleft maxright]=parafit(ax,tmp,f)
if nargin<3
	f=1;
end

para=[0 0 0];

len=0;
maxlen=0;
maxleft=0;
maxright=0;
r1=0;
r2=0;

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

x=ax(1:length(ax)-1)-ax(1);
y=gen_derivative(tmp,0);
xin=x;
yin=y;
out=[];
pout=[1];
count=0;
while ~(length(out)==0&&length(pout)==0)&&(length(out)~=length(pout) || max(pout-out)~=0) && count<20;
	count=count+1;
	pout=out;
	out=find_outlier(y-polyval(polyfit(xin,yin,1),x));
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

p=polyfit(xin,yin,1);
r=corrcoef(xin,yin);
r1=r(1,2);
para=[p(1)/2 0 0];

x=ax-ax(1);
y=tmp'-polyval(para,ax-ax(1));
xin=x;
yin=y;
out=[];
pout=[1];

count=0;
while ~(length(out)==0&&length(pout)==0)&&(length(out)~=length(pout) || max(pout-out)~=0) && count <20;
	count=count+1;
	pout=out;
	out=find_outlier(y-polyval(polyfit(xin,yin,1),x));
	xin=[];
	yin=[];
	for j=1:length(x)
		if ~any(out==j)
			xin=[xin x(j)];
			yin=[yin y(j)];
		end
	end
end

p=polyfit(xin,yin,1);
r=corrcoef(xin,yin);
r2=r(1,2);
para=[para(1) p];

if f==1
	ay=polyval(para,ax-ax(1));
	plot(ax,ay,'r');
end
