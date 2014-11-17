clear
mydir='match/';
list=dir([mydir,'*.f0_ascii']);
num=length(list);
top=400;
bottom=-40;
%for i=1:num
for i=1:1
	filename=[mydir,list(i).name];
	disp(filename);
	input=fopen(filename,'r');
	a=fscanf(input,'%f %f %f %f',[4 inf])';
	a=a(:,1);
	for j=1:len
		if a(j)~=0 
			plot(j,a(j),'b*');
		end
	end

	filename2=regexprep(filename,'f0_ascii','lab');
	input2=fopen(filename2,'r');
	text=fgets(input2);
	text=fgets(input2);
	text=fgets(input2);
	while ~feof(input2)
		text=fgets(input2);
		mark=sscanf(text,'%f',[1 1])*100;
		plot([mark mark],[bottom top],'--k');
	end
	plot([0 len],[0 0],'--k');
	axis([0 300 bottom top]);

	filename3=regexprep(filename,'.f0_ascii','_1');
	filename3=regexprep(filename3,'match/','figure/');
	saveas(h,filename3,'png');
end
