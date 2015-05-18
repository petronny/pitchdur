clear;
input=fopen('p-questions.txt','r');
data=fscanf(input,'%f',[3 inf]);
fclose(input);

output=fopen('a larger than zero/log.txt','w');
for i=1:1:7
	mydir=sprintf('origin/Type%d/',i);
	list=dir([mydir '*.wav']);
	data2=data(:,data(3,:)==i);
	len=size(data2);
	len=len(2);
	for j=1:len
		if data2(1,j)>0
			co=sprintf('cp Type%d/%04d.{dur,pit} a\\ larger\\ than\\ zero/Type%d',i,j,i);
			system(co);
			co=sprintf('cp figure/Type%d/%04d.png a\\ larger\\ than\\ zero/Type%d',i,j,i);
			system(co);
			fprintf(output,'%f ',data2(1:2,j));
			input=fopen(sprintf('Type%d/%04d.tone',i,j),'r');
			line=fgets(input);
			fclose(input);
			fprintf(output,'Type%d/%s ',i,list(j).name);
			fprintf(output,'%s\n',line);
		end
	end
end
