function [b f]=lowpass(a,t,start)

x=linspace(1,length(a),length(a));

x0=x;
x0(a==0)=[];
y0=a;
y0(a==0)=[];

if length(x0)>5
	Fs=100;
	d = fdesign.lowpass('fp,fst,ap,ast',1e-12,1/t,1e-12,6,Fs);
	Hd = design(d,'butter');

	y0=y0-max(a);
	y=spline(x0,y0,x);
	b = filter(Hd,y)+max(a);
	f =1;
else
	b=0;
	f=0;
end
