x=linspace(-0.1,0.1,10);

papersize=[16 9];
h=figure('PaperSize',papersize,'PaperPosition',[0 0 papersize],'NextPlot','add','visible','off');
figure(h);
hold on;

input=fopen('p-statements.txt','r');
data=fscanf(input,'%f',[2 inf]);
fclose(input);
y=data(1,:)/10;
y1=hist(y,x)/length(y);

len=size(data);
len=len(2);
for i=1:len
	plot(data(1,i)/10,data(2,i),'bo');
end

input=fopen('p-questions.txt','r');
data=fscanf(input,'%f',[3 inf]);
fclose(input);

len=size(data);
len=len(2);
for i=1:len
	plot(data(1,i),data(2,i),'r+');
end

saveas(h,'stat','png');
close(h);

for i=1:7

	papersize=[16 9];
	h=figure('PaperSize',papersize,'PaperPosition',[0 0 papersize],'NextPlot','add','visible','off');
	figure(h);
	hold on;

	data2=data(:,data(3,:)==i);
	y=data2(1,:);
	y2=hist(y,x)/length(y);
	yy=[y1;y2]';
	bar(x,yy);

	saveas(h,['stat-type' i+'0'],'png');
	close(h);
end

