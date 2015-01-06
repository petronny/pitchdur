function [maxleft maxright]=exact_match(a)

len=0;
maxlen=0;
maxleft=0;
maxright=0;

for i=1:length(a)
	if a(i)~=0 && len==0
		left=i;
		len=1;
	end
	if a(i)==0 && len~=0
		if maxlen<len
			maxlen=len;
			maxleft=left;
			maxright=i-1;
		end
		len=0;
	end
	if i==length(a) && len~=0
		if maxlen<len
			maxlen=len;
			maxleft=left;
			maxright=i;
			len=0;
		end
	end
	if a(i)~=0 && len~=0
		len=len+1;
	end
end
