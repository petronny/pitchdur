clear
close all;

f0dir='match/f0files/';
labdir=regexprep(f0dir,'f0files','lab');
list=dir([f0dir,'*.f0_ascii']);
num=length(list);
for i=1:1:num

	fprintf('%d:%s\n',i,list(i).name);
	input=fopen([f0dir list(i).name],'r');
	a=fscanf(input,'%f');
	fclose(input);

	h=paper_settings([32 9]);
	gen_points(a);
	[breaks marks tones]=lab_format_parser([labdir regexprep(list(i).name,'f0_ascii','lab')]);
	%gen_grid(marks);
	%fit_axis(a);
	ptone='0';
	pbase1=0;
	pbase2=0;
	rebuild=zeros(length(a),1);

	for j=1:length(breaks)-1
		left=round(breaks(j));
		right=min(round(breaks(j+1)),length(a));
		while a(left)==0 && left<right;
			left=left+1;
		end
		while a(right)==0 && left<right;
			right=right-1;
		end
		tmp=a(left:right);
		[b f]=lowpass(tmp,(breaks(j+1)-breaks(j))/100,left);
		if f==1
			plot(linspace(left,right,right-left+1),b);

			p=polyfit(linspace(0,right-left,right-left+1),b,1);
			y22=polyval(p,linspace(0,right-left+1,right-left+1));
			plot(linspace(left,right,right-left+1),y22,'r');

			for k=left:right
				if tmp(k-left+1)~=0
					plot(k,tmp(k-left+1)-b(k-left+1),'r*');
					%rebuild(k)=tmp(k-left+1)-b(k-left+1)+max(tmp);
				end
			end
		end
	end

	for j=1:length(marks)-1
		sound=char(tones(j+1));
		[initial vowel tone]=pinyin_parser(sound);
		left=round(marks(j));
		right=min(round(marks(j+1)),length(a));
		tmp=a(left:right);
		x=linspace(left,right,right-left+1);
		[p r1 r2 maxl maxr]=parafit(x,tmp);
		if maxr-maxl+1>5
			[base1 base2]=baseline(x,tmp,p,0);
			[diff1 diff2]=basediff(ptone,tone,pbase1-base1,pbase2-base2);
			pbase1=base1;
			pbase2=base2;
			ax=x(maxl:maxr);
			ay=ones(1,maxr-maxl+1)*(base1+diff1);
			%plot(ax,ay,'b');
			ay=ones(1,maxr-maxl+1)*(base2+diff2);
			%plot(ax,ay,'b');

			for k=maxl:maxr
				rebuild(x(k))=polyval(p,k-maxl+1);
			end
		end
		ptone=tone;

	end

	output=fopen(['match/f0files-modified/' list(i).name],'w');
	fprintf(output,'%f\n',rebuild);
	fclose(output);

	subfix='parafit';
	saveas(h,['figure/',subfix,'/' list(i).name(3:5)],'png');
	close(h);

end
