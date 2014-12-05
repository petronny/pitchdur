function fit_axis(a,len)
if nargin<2
	len=length(a);
end
aa=a;
aa(a==0)=[];
axis([0 len min(aa) max(aa)]);
