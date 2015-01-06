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
	a=[a(:,1); zeros(100,1)];

	[breaks marks tones]=lab_format_parser(regexprep(filename,'f0_ascii','lab'));

	for j=2:length(marks)-1
		sound=char(tones(j+1));
		psound=char(tones(j));
		[initial vowel tone]=pinyin_parser(sound);
		[pinitial pvowel ptone]=pinyin_parser(psound);
		if tone=='1' || tone=='2' || tone=='3' || tone=='4'
		    if ptone=='1' || ptone=='2' || ptone=='3' || ptone=='4'

                        h=paper_settings([8 4.5]);
                        axis([0 100 100 400]);

			pleft=round(marks(j-1));
			pright=round(marks(j));
			tmp=a(pleft:pright);
                        gen_points(tmp);
			x=linspace(0,pright-pleft+1,pright-pleft+1);
			p=parafit(x,tmp);
			base1=baseline(x,tmp,p);

			left=round(marks(j));
			right=round(marks(j+1));
			tmp=a(left:right);
                        gen_points([ zeros(1,pright-pleft+1) tmp']);
			x=linspace(pright-pleft+1,right-pleft+1,right-left+1);
			p=parafit(x,tmp);
			base2=baseline(x,tmp,p);

			data=[data;ptone-'0' tone-'0' base1-base2];

                        if ~isdir(['statistics/' ptone tone])
                                mkdir(['statistics/' ptone tone]);
                        end
                        saveas(h,['statistics/' ptone tone '/' psound sound '-' filename(9:11) '-' sprintf('%d',j-1) ],'png');
                        close(h);
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
		for k=1:len
			if data(k,1)==i && data(k,2)==j
				count=count+1;
				plot(count,data(k,3),'*');
			end
		end
		saveas(h,['statistics/basediff/' i+'0' j+'0' ],'png');
	end
end
