function p=globalfit(b,left,right)
%p=polyfit(linspace(0,right-left,right-left+1),b,3);
%y22=polyval(p,linspace(0,right-left+1,right-left+1));
%plot(linspace(left,right,right-left+1),y22,'k--');

p=polyfit(linspace(0,right-left,right-left+1),b,1);
y22=polyval(p,linspace(0,right-left+1,right-left+1));
plot(linspace(left,right,right-left+1),y22,'k');

p=polyfit(linspace(0,right-left,right-left+1),exp(b/min(b)*log(20)),1);
y22=polyval(p,linspace(0,right-left+1,right-left+1));
plot(linspace(left,right,right-left+1),log(y22)/log(20)*min(b),'r-.');
