clear
close all;

input=fopen('origin/500_sp_sy.txt','r');
labels = textscan(input,'%s','Delimiter','\n');
fclose(input);
labels=labels{1};
all1={};
all2={};
f0dir='match/f0files/';
labdir=regexprep(f0dir,'f0files','lab');
list=dir([f0dir,'*.f0_ascii']);
num=length(list);

output=fopen('match/data.arff' ,'w');
fprintf(output,'@RELATION data\n');
for k=-2:2
	fprintf(output,'@ATTRIBUTE initial%d {b,c,ch,d,f,g,h,j,k,l,m,n,none,p,q,r,s,sh,t,w,x,y,z,zh}\n',k);
	fprintf(output,'@ATTRIBUTE vowel%d {a,ai,an,ang,ao,e,ei,en,eng,er,i,ia,ian,iang,iao,ie,in,ing,iong,iu,none,o,ong,ou,u,ua,uai,uan,uang,ue,ui,un,uo,v}\n',k);
end
for k=1:5
	fprintf(output,'@ATTRIBUTE tone%d {-1,1,2,3,4,5}\n',k);
end
for k=1:5
	fprintf(output,'@ATTRIBUTE label%d {sp,a,ad,an,b,c,d,f,g,i,j,k,l,m,n,nr,ns,nt,nz,p,q,r,s,t,u,v,vd,vn,y,z}\n',k);
end
for k=1:5
	fprintf(output,'@ATTRIBUTE stop%d {sp,=,-,|}\n',k);
end
fprintf(output,'@ATTRIBUTE a REAL\n');
fprintf(output,'@ATTRIBUTE b REAL\n');
fprintf(output,'@ATTRIBUTE c REAL\n');
fprintf(output,'@DATA\n');

for i=1:1:num
	fprintf('%d:%s\n',i,list(i).name);
	input=fopen([f0dir list(i).name],'r');
	a=fscanf(input,'%f');
	fclose(input);

	[breaks marks tones]=lab_format_parser([labdir regexprep(list(i).name,'f0_ascii','lab')]);

	data=[];
	for j=1:length(marks)-1
		sound=char(tones(j+1));
		if strcmp(sound,'#')==0
			left=round(marks(j));
			right=min(round(marks(j+1)),length(a));
			tmp=a(left:right);
			x=linspace(left,right,right-left+1);
			[p r1 r2 maxl maxr]=parafit(x,tmp);
			data=[data;p];
		end
	end

	stop=[];
	for j=1:length(tones)
		if strcmp(tones(j),'#')
			stop=[stop j];
		end
	end
	tones(stop)=[];

	len1=size(data);
	len1=len1(1);
	len2=length(tones);
	if len1~=len2
		fprintf('!%d:%s\n',i,list(i).name);
	end

	label=char(labels(str2num(list(i).name(3:5))));
	count=0;
	start=1;
	while start<=length(label)
		alabel=sscanf(label(start:length(label)),'%s',1);
		start=start+length(alabel)+1;
		count=count+1;
		tones{2,count}=alabel(1:length(alabel)-1);
		tones{3,count}=alabel(length(alabel));
	end

	for j=1:count
		for k=j-2:j+2
			if k<=0 || k>count
				fprintf(output,'none,none,');
			else
				sound=char(tones(1,k));
				[initial vowel tone]=pinyin_parser(sound);
				fprintf(output,'%s,%s,',initial,vowel);
			end
		end
		for k=j-2:j+2
			if k<=0 || k>count
				fprintf(output,'-1,');
			else
				sound=char(tones(1,k));
				if sound(length(sound))=='e' || sound(length(sound))=='n'
					fprintf(output,'5,');
				else
					fprintf(output,'%s,',sound(length(sound)));
				end
			end
		end
		for k=j-2:j+2
			if k<=0 || k>count
				fprintf(output,'sp,');
			else
				fprintf(output,'%s,',char(tones(2,k)));
				all1{length(all1)+1}=char(tones(2,k));
			end
		end
		for k=j-2:j+2
			if k<=0 || k>count
				fprintf(output,'sp,');
			else
				fprintf(output,'%s,',char(tones(3,k)));
			end
		end
		fprintf(output,'%f,',data(j,1:2));
		fprintf(output,'%f\n',data(j,3));
	end
end
fclose(output);
%all1=unique(all1,'first');
all2=unique(all2,'first');
%for i=1:length(all1)
        %fprintf('%s,',all1{i});
%end
%fprintf('\n');
for i=1:length(all2)
        fprintf('%s,',all2{i});
end
