function [p r]=linearfit(a)
len=length(a);

x=linspace(0,len-1,len);
y=a;
xin=x;
yin=y;
out=[];
pout=[1];
count=0;
while ~(length(out)==0&&length(pout)==0)&&(length(out)~=length(pout) || max(pout-out)~=0) && count<40
	count=count+1;
	pout=out;
	out=find_outlier(y-polyval(polyfit(xin,yin,1),x));
	nout=[];
	for j=1:length(out)
		if abs(out(j)-length(x)/2)>=length(x)/4
			nout=[nout out(j)];
		end
	end
	out=nout;
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
r=r(1,2);
