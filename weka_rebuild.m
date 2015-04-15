input=fopen('weka/parameters.txt','r');
attribute=6;
parameters = fscanf(input,'%f',[2*attribute+1 inf]);
fclose(input);

labdir='match/lab/';
list=dir([labdir,'*.lab']);
num=length(list);

count=0;
for i=1:1:num
	fprintf('%d:%s\n',i,list(i).name);
	h=paper_settings([32 9]);
	[breaks marks tones]=lab_format_parser([labdir list(i).name]);
	for j=1:length(marks)-1
		sound=char(tones(j+1));
		if strcmp(sound,'#')==0
			count=count+1;
			left=round(marks(j));
			%right=round(marks(j+1));
			time=parameters(2*attribute+1,count);
			right=left+time;
			xx=linspace(left,right,right-left+1);

			x=linspace(1,time+1,time+1);
			p=[parameters(1:3,count)];
			y=polyval(p,x);
			plot(xx,y,'b');
			p=[parameters(1+attribute:3+attribute,count)];
			y=polyval(p,x);
			plot(xx,y,'r');
		end
		subfix='weka';
		saveas(h,['figure/',subfix,'/' list(i).name(3:5)],'png');
	end
end

len=size(parameters);
len=len(2);
count-len
