input=fopen('weka/parameters.txt','r');
parameters = fscanf(input,'%f',[7 inf]);
fclose(input);
input=fopen('weka/tones.txt','r');
tones = textscan(input,'%s','Delimiter','\n');
tones = tones{1};
fclose(input);
len=size(parameters);
len=len(2);
for i=1:len
	fprintf('%d %s\n',i,char(tones(i)));
	h=paper_settings([16 9]);

	time=parameters(7,i);
	x=linspace(1,time,time);
	p=[parameters(1:3,i)];
	y=polyval(p,x);
	plot(x,y,'b');
	p=[parameters(4:6,i)];
	y=polyval(p,x);
	plot(x,y,'r');

	subfix='weka';
	saveas(h,['figure/' subfix '/' sprintf('%04d', i) '-' char(tones(i)) ],'png');
	close(h);
end
