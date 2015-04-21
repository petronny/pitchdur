input1=fopen('weka/parameters-except1.txt','r');
input2=fopen('weka/parameters-only1.txt','r');
attribute=6;
parameters1 = fscanf(input1,'%f',[2*attribute+1 inf]);
parameters2 = fscanf(input2,'%f',[2*attribute+1 inf]);
fclose(input1);
fclose(input2);

labdir='match/lab/';
list=dir([labdir,'*.lab']);
num=length(list);
num=22;

count1=0;
count2=0;

for i=1:1:num
	fprintf('%d:%s\n',i,list(i).name);
	h=paper_settings([32 9]);
	[breaks marks tones]=lab_format_parser([labdir list(i).name]);
	for j=1:length(marks)-1
		sound=char(tones(j+1));
		if strcmp(sound,'#')==0
			if strcmp(sound(length(sound)),'1')==0
				count1=count1+1;
				time=parameters1(2*attribute+1,count1);
				p1=[parameters1(1:3,count1)];
				p2=[parameters1(1+attribute:3+attribute,count1)];
				omin=parameters1(4,count1);
				pmin=parameters1(4+attribute,count1);
				pmax=parameters1(5+attribute,count1);
				ax=parameters1(6+attribute,count1);
			else
				count2=count2+1;
				time=parameters2(2*attribute+1,count2);
				p1=[parameters2(1:3,count2)];
				p2=[parameters2(1+attribute:3+attribute,count2)];
				omin=parameters2(4,count2);
				pmin=parameters2(4+attribute,count2);
				pmax=parameters2(5+attribute,count2);
				ax=parameters2(6+attribute,count2);
			end
			[pmin pmax]=my2sort(pmin,pmax);
			left=round(marks(j));
			right=left+time;
			xx=linspace(left,right,right-left+1);
			x=linspace(1,time+1,time+1);
			y=polyval(p1,x);
			plot(xx,y,'b');
			y=polyval(p2,x);

			qmin=min(y);
			qmax=max(y);
			%tmin=max([qmin pmin]);
			%tmax=min([qmax pmax]);
			%[tmin tmax]=my2sort(tmin,tmax);
			y=my_scale(y,qmin,qmax,pmin,pmax);

			if strcmp(sound(length(sound)),'1')==0
				plot(xx,y,'r');
				plot(xx,ones(1,right-left+1)*pmin,'r');
				plot(xx,ones(1,right-left+1)*pmax,'r');
			else
				plot(xx,y,'g');
				plot(xx,ones(1,right-left+1)*pmin,'g');
				plot(xx,ones(1,right-left+1)*pmax,'g');
			end
		end
		subfix='weka';
		saveas(h,['figure/',subfix,'/' list(i).name(3:5)],'png');
	end
end
