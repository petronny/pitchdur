function linearfit(a)
len=length(a);
x=[];
y=[];
for i=1:len
	if a(i)==0
		if length(x)>0
			xin=x;
			yin=y;
			out=[];
			pout=[1];
			while length(out)~=length(pout) || max(pout-out)~=0
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
			for j=1:length(x)
				if any(out==j)
					 plot(x(j),y(j),'o')
				end
			end
			p=polyfit(xin,yin,1);
			x1=x(1):0.1:x(length(x));
			y1=polyval(p,x1);
			plot(x1,y1,'g');
		end
		x=[];
		y=[];
	end
	if a(i)~=0 
		x=[x i];
		y=[y a(i)];
	end
end
