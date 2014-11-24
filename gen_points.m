function gen_curve(a)
len=length(a);
for i=1:len
	if a(i)~=0 
		plot(i,a(i),'b*');
	end
end
