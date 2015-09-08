x=linspace(-0.1,0.1,10);

papersize=[4 3];
h=figure('PaperSize',papersize,'PaperPosition',[0 0 papersize],'NextPlot','add','visible','off');
figure(h);
hold on;

input=fopen('p-statements.txt','r');
data=fscanf(input,'%f',[3 inf]);
fclose(input);
y=data(1,:)/10;
y1=hist(y,x)/length(y);

len1=size(data);
len1=len1(2);
for i=1:len1
	t=data(3,i)*10;
	a=data(1,i)/10;
	b=data(2,i);
	c=b/t;
	plot(t,c,'bo');
end

input=fopen('p-questions.txt','r');
data=fscanf(input,'%f',[4 inf]);
fclose(input);

len=size(data);
len=len(2);
for i=1:len
	t=data(3,i)*10;
	a=data(1,i);
	b=data(2,i);
	c=b/t;
	plot(t,c,'r+');
end

axis([0 6000 0 0.6]);
set(gca,'FontSize',15);
%legend('xxx','yyy','Location','SouthEast');
ylabel('b/T(Hz/ms)');
xlabel('T(ms)');
saveas(h,'stat-ct2','png');
close(h);


%for i=1:7

	%papersize=[16 9];
	%h=figure('PaperSize',papersize,'PaperPosition',[0 0 papersize],'NextPlot','add','visible','off');
	%figure(h);
	%hold on;

	%data2=data(:,data(4,:)==i);
	%y=data2(1,:);
	%y2=hist(y,x)/length(y);
	%yy=[y1;y2]';
	%bar(x,yy);

	%saveas(h,['stat-type' i+'0'],'png');
	%close(h);
%end

