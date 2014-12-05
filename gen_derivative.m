function b=gen_derivative(a,f)
if nargin<2
	f=1;
end
len=length(a);
b=zeros(1,len-1);
for j=1:len-1
	if a(j)~=0 && a(j+1)~=0
		b(j)=a(j+1)-a(j);
		if f==1
			plot(j,a(j+1)-a(j),'r*');
		end
	else
		b(j)=0;
	end
end
