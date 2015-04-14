function [b f]=lowpass(a,start)

x0=linspace(1,length(a),length(a));
x0(a==0)=[];
y0=a;
y0(a==0)=[];

if length(x0)>5
	Fs=100;
	d = fdesign.lowpass('fp,fst,ap,ast',1e-12,0.5,1e-12,3,Fs);
	Hd = design(d,'butter');

	ptime=10;
	x0=[0 x0+ptime];
	base=mean(y0);
	y0=[0;y0-base];
	x=linspace(1,length(a)+ptime,length(a)+ptime);
	y=spline(x0,y0,x);
	b = filter(Hd,y);
	%b = y;
	%b = b(1:length(b)-ptime);
	b = b(ptime+1:length(b))+base;
	f =1;
else
	b=0;
	f=0;
end
