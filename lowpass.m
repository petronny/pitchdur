function b=lowpass(a,t,start)

x=linspace(1,length(a),length(a));

x0=x;
x0(a==0)=[];
y0=a;
y0(a==0)=[];

if length(x0)>2
	y0=y0-max(y0);
	%y=spline(x0,y0,x);
	Fs=100;
	d = fdesign.lowpass('fp,fst,ap,ast',0.01,1/t/2,0.1,60,Fs);
	%designmethods(d);
	Hd = design(d,'butter');
	ECG = filter(Hd,a-a(1));
	%b=ECG*(max(aa)-min(aa))*6+(max(aa)+min(aa))/2;
	b=ECG;
else
	b=a;
end
