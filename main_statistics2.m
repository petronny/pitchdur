clear
close all;

mydir='match/';
list=dir([mydir,'*.f0_ascii']);
num=length(list);
data=[];
for i=1:1:num

	filename=[mydir,list(i).name];
	fprintf('%d:%s\n',i,filename);
	input=fopen(filename,'r');
	a=fscanf(input,'%f %f %f %f',[4 inf])';
	fclose(input);
	a=[a(:,1); zeros(100,1)];

	[breaks marks tones]=lab_format_parser(regexprep(filename,'f0_ascii','lab'));

	for j=2:length(marks)-1
		sound=char(tones(j+1));
		psound=char(tones(j));
		[initial vowel tone]=pinyin_parser(sound);
		[pinitial pvowel ptone]=pinyin_parser(psound);
		if tone=='1' || tone=='2' || tone=='3' || tone=='4'
		    if ptone=='1' || ptone=='2' || ptone=='3' || ptone=='4'

                        %h=paper_settings([8 4.5]);
                        %axis([0 100 100 400]);

			pleft=round(marks(j-1));
			pright=round(marks(j));
			tmp=a(pleft:pright);
                        gen_points(tmp);
			x=linspace(0,pright-pleft+1,pright-pleft+1);
			p=parafit(x,tmp);
			[base1,base2]=baseline(x,tmp,p);

			left=round(marks(j));
			right=round(marks(j+1));
			tmp=a(left:right);
                        gen_points([ zeros(1,pright-pleft+1) tmp']);
			x=linspace(pright-pleft+1,right-pleft+1,right-left+1);
			p=parafit(x,tmp);
			[base3,base4]=baseline(x,tmp,p);
			[diff1 diff2]=basediff(ptone,tone,base1-base3,base2-base4);
			data=[data;ptone-'0' tone-'0' base1-base3+diff1 base2-base4+diff2];

%                        if ~isdir(['statistics/' ptone tone])
%                                mkdir(['statistics/' ptone tone]);
%                        end
%                        saveas(h,['statistics/' ptone tone '/' psound sound '-' filename(9:11) '-' sprintf('%d',j-1) ],'png');
%                        close(h);
		    end
		end
	end
end

len=size(data);
len=len(1)

for i=1:4
	for j=1:4
		h=paper_settings([16 9]);
		count=0;
		d=[];
		for k=1:len
			if data(k,1)==i && data(k,2)==j
				count=count+1;
				d=[d;data(k,3)];
			end
		end
		d=sort(d);
		plot(d,'b*');
		saveas(h,['statistics/basediff-min/' i+'0' j+'0' ],'png');
	end
end

for i=1:4
	for j=1:4
		h=paper_settings([16 9]);
		count=0;
		d=[];
		for k=1:len
			if data(k,1)==i && data(k,2)==j
				count=count+1;
				d=[d;data(k,4)];
			end
		end
		d=sort(d);
		plot(d,'b*');
		saveas(h,['statistics/basediff-max/' i+'0' j+'0' ],'png');
	end
end

output=fopen('parameters/basediff-diagonal.txt','w');
for i=1:4
	for j=1:4
		h=paper_settings([16 9]);
		count=0;
		d=[];
		for k=1:len
			if data(k,1)==i && data(k,2)==j
				count=count+1;
				d=[d;data(k,3) data(k,4)];
				plot(data(k,3),data(k,4),'b*');
			end
		end
		plot([min(d(:,1)) max(d(:,1))],[min(d(:,2)) max(d(:,2))],'r');
		p=polyfit([min(d(:,1)) max(d(:,1))],[min(d(:,2)) max(d(:,2))],1);
		fprintf(output,'%f %f\n',p(1),p(2));
		saveas(h,['statistics/basediff-max-min/' i+'0' j+'0' ],'png');
	end
end
fclose(output);
