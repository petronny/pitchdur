input1=fopen('weka/parameters-except1.txt','r');
input2=fopen('weka/parameters-only1.txt','r');
attribute=6;
parameters1 = fscanf(input1,'%f',[2*attribute+1 inf]);
parameters2 = fscanf(input2,'%f',[2*attribute+1 inf]);
fclose(input1);
fclose(input2);

f0dir='match/f0files/';
labdir=regexprep(f0dir,'f0files','lab');
list=dir([labdir,'*.lab']);
num=length(list);
num=22;

count1=0;
count2=0;

for i=1:1:num
	fprintf('%d:%s\n',i,list(i).name);

	h=paper_settings([32 9]);

	input=fopen([f0dir regexprep(list(i).name,'lab','f0_ascii')],'r');
	a=fscanf(input,'%f');
	fclose(input);
	rebuild=zeros(length(a),1);
	[breaks marks tones]=lab_format_parser([labdir list(i).name]);
	break_count=0;
	for j=1:length(marks)-1
		sound=char(tones(j));
		if strcmp(sound,'#') || j == 1
			break_count=break_count+1;
			break_left=round(breaks(break_count));
			break_right=min(round(breaks(break_count+1)),length(a));
			while a(break_left)==0 && break_left<break_right;
				break_left=break_left+1;
			end
			while a(break_right)==0 && break_left<break_right;
				break_right=break_right-1;
			end
			tmp=a(break_left:break_right);
			gen_points(a);
			[b f]=lowpass(tmp,(breaks(break_count+1)-breaks(break_count))/100,break_left);
			globalp=globalfit(b,break_left,break_right);

			break_count=break_count+1;
		end

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
			left=round(marks(j-1));
			right=min(round(marks(j)),length(a));

			%right=left+time;

			[maxl maxr]=exact_match(a(left:right));

			left=left+maxl;
			right=left+time;

			xx=linspace(left,right,right-left+1);
			x=linspace(1,time+1,time+1);
			global_y=polyval(globalp,x);
			y=polyval(p1,x);
			plot(xx,y+global_y,'b');
			y=polyval(p2,x);

			qmin=min(y);
			qmax=max(y);
			%tmin=max([qmin pmin]);
			%tmax=min([qmax pmax]);
			%[tmin tmax]=my2sort(tmin,tmax);
			y=my_scale(y,qmin,qmax,pmin,pmax);

			if strcmp(sound(length(sound)),'1')==0
				plot(xx,y+global_y,'r');
				rebuild(xx)=y+global_y;
				plot(xx,ones(1,right-left+1)*pmin+global_y,'r');
				plot(xx,ones(1,right-left+1)*pmax+global_y,'r');
			else
				plot(xx,y+global_y,'g');
				rebuild(xx)=y+global_y;
				plot(xx,ones(1,right-left+1)*pmin+global_y,'g');
				plot(xx,ones(1,right-left+1)*pmax+global_y,'g');
			end
		end
	end

	output=fopen(['match/f0files-modified/' list(i).name],'w');
	fprintf(output,'%f\n',rebuild);
	fclose(output);

	subfix='weka';
	saveas(h,['figure/',subfix,'/' list(i).name(3:5)],'png');
end
