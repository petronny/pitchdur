clear;
input=fopen('p-questions.txt','r');
data=fscanf(input,'%f',[4 inf]);
fclose(input);

a=data(1,:);
b=data(2,:);
t=data(3,:);
len=length(a)
for i=1:len
	c(i)=a(i)/t(i);
	d(i)=b(i)/t(i);
	d2(i)=b(i);
end
mean(c)
mean(d)
polyfit(a,t,1)
polyfit(t,b,1)
