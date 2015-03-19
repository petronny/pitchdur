input=fopen('origin/2000Script(minimal)_checked_sp_sy.txt','r');
while ~feof(input)
	text=fgets(input);
	fprintf('%s',text);
	start=1;
	while text(start)~=32
		start=start+1;
	end
	start=start+1;
	count=0;
	for i=start:length(text)
		hex=dec2hex(text(i));
		if length(hex)==4
			count=count+1;
		end
		if length(hex)==2 && strcmp(hex,'2F')
			fprintf('%d ',count);
			count=0;
		end
	end
	fprintf('\n');
end
close(input);
