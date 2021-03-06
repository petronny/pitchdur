clear
close all;
Fs=200;
d = fdesign.lowpass('fp,fst,ap,ast',1e-12,0.5,1e-12,3,Fs);
Hd = design(d,'butter');
data=[];

input=fopen('refitting.txt','r');
half_list=fscanf(input,'%d',[2 inf])';
fclose(input);

for i=1:1:7
	mydir=sprintf('Type%d/',i);
	list=dir([mydir '*.dur']);
	num=length(list);
		count=0;
		count2=0;
	for j=1:1:num

		papersize=[16 9];
		h=figure('PaperSize',papersize,'PaperPosition',[0 0 papersize],'NextPlot','add','visible','off');
		figure(h);
		hold on;

		fprintf('%s%s\n',mydir,list(j).name);
		input1=fopen([mydir list(j).name]);
		input2=fopen([mydir regexprep(list(j).name,'dur','pit')]);
		dur=fscanf(input1,'%f');
		pit=textscan(input2,'%s','Delimiter','\n');
		fclose(input1);
		fclose(input2);
		pit=pit{1};
		left=0;
		globalx=[];
		globaly=[];
		for k=1:length(dur)
			right=dur(k)+left;
			pitch=sscanf(char(pit{k}),'%f');
			if length(pitch)>1
				tag=pitch(1);
				pitch=pitch(2:length(pitch));
				x=linspace(left,right,length(pitch)+1);
				x=x(1:length(x)-1);
				for l=1:length(pitch)
					if pitch(l)>0
						plot(x(l),pitch(l),'r*');
						globalx=[globalx x(l)];
						globaly=[globaly pitch(l)];
					end
				end
				count=count+length(pitch);
				count2=count2+dur(k);
			end
			left=right;
		end

		if ismember([i j],half_list,'rows') == 1
			globaly=globaly(length(globaly)/2:length(globaly));
			globalx=globalx(length(globalx)/2:length(globalx));
		end

		base=mean(globaly);
		ptime=10;
		x0=[0 globalx+ptime-globalx(1)];
		y0=[0 globaly-base];
		right=globalx(length(globalx));
		x=linspace(0,right+ptime-globalx(1),length(globalx)+10);
		y=spline(x0,y0,x);
		b = filter(Hd,y)+base;
		b(x<ptime)=[];
		x(x<ptime)=[];
		p=polyfit(x,b,1);

		y=polyval(p,x);
		t=(right-globalx(1))/10;
		p2=[-0.000131*t, t*0.0159+158.4314];
		y2=polyval(p2,x);

		x=x+globalx(1)-ptime;
		data=[data;p t i];

		plot(x,b,'b');
		plot(x,y,'k');
		plot(x,y2,'g');


		if ismember([i j],half_list,'rows') == 1
			saveas(h,['a>0/',mydir list(j).name(1:4)],'png');
		end
		saveas(h,['figure/',mydir list(j).name(1:4)],'png');
		close(h);
	end
end

%output=fopen('p-questions.txt','w');
%len=size(data);
%len=len(1);
%for i=1:len
	%fprintf(output,'%f %f %d %d\n',data(i,1),data(i,2),data(i,3),data(i,4));
%end
%fclose(output);
