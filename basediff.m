function [diff1 diff2]=basediff(ptone,tone,base1,base2)
diff1=0;
diff2=0;
%a=[0 80 120 100; -100 10 65 -30; -120 -10 0 -50;-50 20 50 30];
if tone=='1' || tone=='2' || tone=='3' || tone=='4'
	if ptone=='1' || ptone=='2' || ptone=='3' || ptone=='4'
%		diff=a(ptone-'0',tone-'0');
		input=fopen('parameters/basediff-diagonal.txt','r');
		p=fscanf(input,'%f %f',[2 inf]);
		fclose(input);
		p=p';
		A=p((ptone-'1')*4+(tone-'0'),1);
		B=-1;
		C=p((ptone-'1')*4+(tone-'0'),2);
		t=-(A*base1+B*base2+C)/(A^2+B^2);
		diff1=A*t;
		diff2=B*t;
	end
end
