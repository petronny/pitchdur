function b=fourier_fit(a,t,band)
if nargin <3
	band=t/20;
end
aa=a;
aa(a==0)=[];
if length(aa)>0
	d = fdesign.bandpass('N,F3dB1,F3dB2',8,1/(t+band),1/(t-band),100); 
	Hd = design(d,'butter');
	ECG = filter(Hd,a);
	b=ECG*(max(aa)-min(aa))*6+(max(aa)+min(aa))/2;
else
	b=a;
end
