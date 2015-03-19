input=fopen('origin/2000Script(minimal)_checked_sp_sy.txt','r');
while ~feof(input)
	text=fgets(input);
	fprintf('%s',text);
end
close(input);
