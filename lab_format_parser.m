function [breaks marks tones]=lab_format_parser(filename)
input=fopen(filename,'r');
text=fgets(input);
text=fgets(input);
text=fgets(input);
breaks=[];
marks=[];
tones={};
toneshead={};
pmark=0;
while ~feof(input)
	text=fgets(input);
	if(text(length(text))==10)
		text=text(1:length(text)-1);
	end
	if(text(length(text))==13)
		text=text(1:length(text)-1);
	end
	mark=sscanf(text,'%f %d %[#1-9a-z]',[1 3]);

	mark(1)=mark(1)*100;

	tones=[tones {sprintf('%s',mark(3:length(mark)))}];

	if mark(3)=='#' && length(breaks)>0
		breaks=[breaks pmark mark(1)];
	end
	if mark(3)=='#' && length(breaks)==0 
		breaks=[breaks mark(1)];
	end
	marks=[marks mark(1)];
	pmark=mark(1);
end
