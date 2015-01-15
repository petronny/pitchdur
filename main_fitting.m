clear
close all;

mydir='match/';
list=dir([mydir,'*.f0_ascii']);
num=length(list);
for i=1:1%:num

	filename=[mydir,list(i).name];
	fprintf('%d:%s\n',i,filename);
	input=fopen(filename,'r');
	a=fscanf(input,'%f %f %f %f',[4 inf])';
	fclose(input);
	a=[a(:,1); zeros(100,1)];

	h=paper_settings([32 9]);
	gen_points(a);
	[breaks marks tones]=lab_format_parser(regexprep(filename,'f0_ascii','lab'));
	gen_grid(marks);
	fit_axis(a);
	ptone='0';
	pbase1=0;
	pbase2=0;
	for j=1:length(marks)-1
		sound=char(tones(j+1));
		[initial vowel tone]=pinyin_parser(sound);
		left=round(marks(j));
		right=round(marks(j+1));
		tmp=a(left:right);
		x=linspace(left,right,right-left+1);
		[p r1 r2 maxl maxr]=parafit(x,tmp);
		if maxr-maxl+1>5
			[base1 base2]=baseline(x,tmp,p);
			[diff1 diff2]=basediff(ptone,tone,pbase1-base1,pbase2-base2);
			pbase1=base1;
			pbase2=base2;
			ax=x(maxl:maxr);
			ay=ones(1,maxr-maxl+1)*(base1+diff1);
			plot(ax,ay,'b');
			ay=ones(1,maxr-maxl+1)*(base2+diff2);
			plot(ax,ay,'b');
		end
		ptone=tone;
	end

%	for j=1:length(breaks)-1
%		left=round(breaks(j));
%		right=round(breaks(j+1));
%		tmp=a(left:right);
%		b=fourier_fit(tmp,(breaks(j+1)-breaks(j))/100*1.1);
%		if max(b)>0
%			plot(linspace(left,right,right-left+1),b);
%		end
%	end

%	subfix='fourierfit';
	subfix='parafit';
	saveas(h,regexprep(regexprep(filename,'.f0_ascii',['-' subfix]),'match/',['figure/',subfix,'/']),'png');
	close(h);

%	h=paper_settings();
%	gen_polyfit(b,1);
%	gen_grid(regexprep(filename,'f0_ascii','lab'));
%	axis([0 len -40 40]);
%	saveas(h,regexprep(regexprep(filename,'.f0_ascii','_1'),'match/','figure/'),'png');
%	close(h);

%	h=paper_settings();
%	b=gen_derivative(a,0);
%	c=gen_derivative(b);
%	gen_polyfit(c,0);
%	gen_grid(regexprep(filename,'f0_ascii','lab'));
%	axis([0 len -40 40]);
%	saveas(h,regexprep(regexprep(filename,'.f0_ascii','_2'),'match/','figure/'),'png');
%	close(h);
end
