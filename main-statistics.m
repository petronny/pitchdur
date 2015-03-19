clear
close all;

mydir='match/';
f0dir='match/f0files/';
labdir=regexprep(f0dir,'f0files','lab');
list=dir([f0dir,'*.f0_ascii']);
num=length(list);
count=[0 0 0 0];
data=[];
for i=1:1:num

	fprintf('%d:%s\n',i,list(i).name);
	input=fopen([f0dir list(i).name],'r');
	a=fscanf(input,'%f');
	fclose(input);

	[breaks marks tones]=lab_format_parser([labdir regexprep(list(i).name,'f0_ascii','lab')]);

	for j=1:length(marks)-1
		sound=char(tones(j+1));
		[initial vowel tone]=pinyin_parser(sound);
		if tone=='1' || tone=='2' || tone=='3' || tone=='4' 
			left=round(marks(j));
			right=round(marks(j+1));

                        h=paper_settings([8 4.5]);
                        axis([0 35 100 400]);
                        gen_points(a(left:right));

			tmp=a(left:right);
			x=linspace(0,right-left+1,right-left+1);
			[p r1 r2 l r]=parafit(x,tmp);
			if l~=r
				err=tmp(l:r)-polyval(p,linspace(0,r-l+1,r-l+1))';
				rmse=sqrt(sum(err.^2));

				ax=-p(2)/2/p(1);
				ax=ax/(r-l);
				if ax<0
					ax=0;
				end
				if ax >1
					ax=1;
				end

			else
				rmse=0;
				ax=-1;
			end
			data=[data;tone-'0' p(1) r1 r2 rmse ax];
			xlabel([sound ' ' sprintf('a=%f r1=%f r2=%f',p(1),r1,r2)]);

                        if ~isdir(['statistics/' tone '/' initial])
                                mkdir(['statistics/' tone '/' initial]);
                        end
                        if ~isdir(['statistics/' tone '/' vowel])
                                mkdir(['statistics/' tone '/' vowel]);
                        end
                        saveas(h,['statistics/' tone '/' initial '/' sound '-' list(i).name(3:5) '-' sprintf('%d',j) ],'png');
                        saveas(h,['statistics/' tone '/' vowel '/' sound '-' list(i).name(3:5) '-' sprintf('%d',j) ],'png');
                        close(h);

			count(tone-'0')=count(tone-'0')+1;
		end
	end

end
count

len=size(data);
len=len(1);
for k=1:4
        h=paper_settings([16 9]);
        for j=1:len
                if data(j,1)==k
                        plot(abs(data(j,3)),abs(data(j,4)),'*');
                end
        end
        saveas(h,['statistics/r1r2/' k+'0' '-r1r2' ],'png');
end

for k=1:4
        h=paper_settings([16 9]);
        for j=1:len
                if data(j,1)==k
                        plot(abs(data(j,3)),abs(data(j,2)),'*');
                end
        end
        axis([0 1 0 4]);
        saveas(h,['statistics/r1a/' k+'0' '-r1a' ],'png');
end
for k=1:4
        h=paper_settings([16 9]);
        for j=1:len
                if data(j,1)==k
                        plot(abs(data(j,2)),abs(data(j,5)),'*');
                end
        end
        axis([0 3 0 450]);
        saveas(h,['statistics/armse/' k+'0' '-armse' ],'png');
end
for k=1:4
        h=paper_settings([16 9]);
        for j=1:len
                if data(j,1)==k
                        plot(abs(data(j,3)),abs(data(j,5)),'*');
                end
        end
        axis([0 1 0 450]);
        saveas(h,['statistics/r1rmse/' k+'0' '-r1rmse' ],'png');
end
for k=1:4
	h=paper_settings([16 9]);
	for j=1:len
		if data(j,1)==k
			count=count+1;
			plot(abs(data(j,3)),abs(data(j,6)),'*');
		end
	end
	axis([0 1 0 1]);
	saveas(h,['statistics/r1ax/' k+'0' '-r1ax' ],'png');
end
