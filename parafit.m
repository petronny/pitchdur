function parafit(tmp)
a=gen_derivative(tmp,0);
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
			fx=[];
			for j=1:length(x)
				if ~any(out==j)
					fx=[fx tmp(j+x(1)-1)];
				end
			end
			p=polyfit(xin,yin,1);
			x1=x(1);
			x2=x(length(x));
			para=[p(1)/2 0 0];
			gx=polyfit(xin,fx-polyval(para,xin),1);
			para(2)=gx(1);
			para(3)=polyfit(xin,fx-polyval(para,xin),0);
			xx=x(1):0.1:x(length(x));
			yy=polyval(para,xx);
			plot(xx,yy,'r');
		end
		x=[];
		y=[];
	end
	if a(i)~=0 
		x=[x i];
		y=[y a(i)];
	end
end
