clear
close all;

mydir='match/';
list=dir([mydir,'*.f0_ascii']);
num=length(list);
len=300;
for i=1:1%:num

	filename=[mydir,list(i).name];
	disp(filename);
	input=fopen(filename,'r');
	a=fscanf(input,'%f %f %f %f',[4 inf])';
	a=a(:,1);

	h=paper_settings([32 9]);
	parafit(a);
	gen_points(a);
	gen_grid(regexprep(filename,'f0_ascii','lab'));
	aa=a;
	aa(a==0)=[];
	axis([0 length(a) min(aa) max(aa)]);
	saveas(h,regexprep(regexprep(filename,'.f0_ascii','_0'),'match/','figure/'),'png');
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
