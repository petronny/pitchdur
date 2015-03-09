clear
close all;

method='linear';
f0dir='match/f0files/';
labdir=regexprep(f0dir,'f0files','lab');
list=dir([f0dir,'*.f0_ascii']);
num=length(list);
data=[];
for i=1:1:num

	fprintf('%d:%s\n',i,list(i).name);
	input=fopen([f0dir list(i).name],'r');
	a=fscanf(input,'%f');
	fclose(input);

	[breaks marks tones]=lab_format_parser([labdir regexprep(list(i).name,'f0_ascii','lab')]);

	for j=1:length(breaks)-1
		left=round(breaks(j));
		right=min(round(breaks(j+1)),length(a));
		while a(left)==0 && left<right;
			left=left+1;
		end
		while a(right)==0 && left<right;
			right=right-1;
		end
		tmp=a(left:right);
		[b f]=lowpass(tmp,(breaks(j+1)-breaks(j))/100,left);
		if f==1
			p=globalfit(b,left,right,method);
			if max(p)>1e3
				b
				[p right-left+1 j]
			end
			data=[data;p right-left+1];
		end
	end

%	output=fopen(['match/f0files-modified/' list(i).name],'w');
%	fprintf(output,'%f\n',rebuild);
%	fclose(output);

end
len=size(data);
len=len(1)
h=paper_settings([16 9]);
for i=1:len
	plot(data(i,1),data(i,2),'*');
end
saveas(h,['statistics/global/' method '/a-b'],'png');
close(h);
h=paper_settings([16 9]);
for i=1:len
	plot(data(i,3),data(i,1),'*');
end
saveas(h,['statistics/global/' method '/l-a'],'png');
close(h);
h=paper_settings([16 9]);
for i=1:len
	plot(data(i,3),data(i,2),'*');
end
saveas(h,['statistics/global/' method '/l-b'],'png');
close(h);
