input=fopen('origin/500script.txt','r');
output=fopen('origin/500_sp_sy.txt','w');
pline=0;
while ~feof(input)
	text=fgets(input);
	start=1;
	while start<=length(text) && text(start)~='.' 
		start=start+1;
	end
	start=start+2;
	count=0;
	label='';
	stop='';
	if start<=length(text)
		line=str2num(text(1:start-3));
		if line~=pline+1
			fprintf('%d ',line-1);
		end
		for i=start:length(text)
			hex=dec2hex(text(i));
			if length(hex)==4 || i==length(text)
				if length(label)~=0
					for j=1:count
						if j==count
							if length(stop)==0
								stop='=';
							end
							fprintf(output,'%s%s ',label,stop);
						else
							fprintf(output,'%s- ',label);
						end
					end
					count=0;
					label='';
					stop='';
				end
				count=count+1;
			end
			if length(hex)==2
				if text(i)=='|'
					stop='|';
				end
				if text(i)<='z' && text(i)>='a'
					label=[label text(i)];
				end
			end
		end
		fprintf(output,'\n');
		pline=line;
	end
end
fprintf('\n');
fclose(input);
fclose(output);
