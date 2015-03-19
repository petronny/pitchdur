function p=globalfit(b,left,right,method,flag)
if nargin <5
	flag=0;
end
if nargin <4
	method='linear';
end
if strcmp(method,'cubic')
	p=polyfit(linspace(0,right-left,right-left+1),b,3);
	if flag==1
		y22=polyval(p,linspace(0,right-left+1,right-left+1));
		plot(linspace(left,right,right-left+1),y22,'k--');
	end
end

if strcmp(method,'linear')
	p=polyfit(linspace(0,right-left,right-left+1),b,1);
	if flag==1
		y22=polyval(p,linspace(0,right-left+1,right-left+1));
		plot(linspace(left,right,right-left+1),y22,'k');
	end
end

if strcmp(method,'exponent')
	unit=1;
	index=exp(1);
	p=polyfit(linspace(0,right-left,right-left+1),log(b/unit)/log(index),1);
	if flag==1
		y22=polyval(p,linspace(0,right-left+1,right-left+1));
		if min(y22)<0
			fprintf('exponent ERROR!');
		end
		plot(linspace(left,right,right-left+1),exp(y22*log(index))*unit,'r-.');
	end
end

if strcmp(method,'logarithm')
	unit=max(b)/2;
	index=20;
	p=polyfit(linspace(0,right-left,right-left+1),exp(b/unit*log(index)),1);
	if flag==1
		y22=polyval(p,linspace(0,right-left+1,right-left+1));
		if min(y22)<0
			fprintf('exponent ERROR!');
		end
		plot(linspace(left,right,right-left+1),log(y22)/log(index)*unit,'r-.');
	end
end
